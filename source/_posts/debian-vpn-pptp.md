---
title: Debian中搭建VPN(PPTP协议)实战，实现VPN上网
id: 319
categories:
  - Linux
date: 2015-11-30 13:46:34
tags:
---

首先讲一讲为什么会突然想到弄一下VPN呢？这是因为在我的学校，校园网的认证采用的是VPN(L2TP协议)，既然这样，我是不是可以通过学校的虚机来自建一个认证系统来实现上网呢？抱着这种疑问，开始做一些事情吧。

另外提一下，PPTP, L2TP/IPSec 和 OpenVPN这三种协议里，PPTP比较容易配置，所以我采用了这种方法。

## 1、所需工具和资源

说到底，还是离不开一台校内的机器，而且能够上网并拥有独立IP（看上去很难有这个），多亏有师生这层美妙的关系，对！一台虚机就这样有了。软件方面的东西直接在虚机上下载就行了。

本次实战的机器是Debian系统，软件源包使用apt-get，本地电脑Macbook（自带ssh连接端）

## 2、具体步骤

首先连接上远程计算机，通过命令行进行安装：
<!--more-->

1、安装PPTP，服务端VPN软件：# apt-get install -y pptpd

2、编辑/etc/pptpd.conf ：去掉localip 和 remoteip两行的注释，并修改相应的IP
<pre lang="bash">local 192.168.121.1    #这里设置服务器IP 相当于网关 需要避免与本地一样
remoteip 192.168.121.11-30  #这里设置客户端可分配资源 是IP段
</pre>
3、编辑/etc/ppp/options.pptpd ：
<pre lang="bash">name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
lock
nobsdcomp
novj
novjccomp
nologfd
</pre>
其中 ms-dns 可以修改成你自己想要的DNS服务器地址

4、修改文件 /etc/ppp/chap-secrets，第一列是用户名，第二列是服务器名（默认写 pptpd 即可，如果在 pptpd-options 文件中更改过的话，注意这里保持和文件中的name行一致），第三列是密码，第四列是 IP 限制（不做限制写 * 即可）如创建一个名为vpnuser，密码为123123，不限制登录IP的VPN账号：
<pre lang="bash"># Secrets for authentication using CHAP
# client        server  secret                  IP addresses
vpnuser      pptpd   123123  *
</pre>
然后我们就需要重启PPTP服务：/etc/init.d/pptpd restart

重启完毕之后，应该就可以连接上了，但是可能无法通过它来上网，我们还需要进行以下配置：

6、修改文件 /etc/sysctl.conf，去掉这一行 #net.ipv4.ip_forward=1 的#号，开启ipv4 forward，然后运行命令：
<pre lang="bash">sysctl –p
</pre>
如果这样还是不能上网，可能是防火墙的问题了，执行命令：
<pre lang="bash">iptables -t nat -A POSTROUTING -s 192.168.121.1/24 -o eth0 -j MASQUERADE
</pre>
为防止重启机器后iptables丢失，先运行
<pre lang="bash">
sudo iptables-save > /etc/iptables-rules
</pre>
然后修改 /etc/network/interfaces 文件，找到 eth0 那一节，在对 eth0 的设置最末尾加上下面这句：
<pre lang="bash">
pre-up iptables-restore < /etc/iptables-rules
</pre>
这样当网卡 eth0 被加载启动的时候就会自动载入我们预先用 iptables-save 保存下的配置。
PPTP 服务需要使用 1723(tcp) 端口和 gre 协议，因此确保防火墙设置允许这两者通行。

通过输入命令：netstat -antl 查看是否打开了协议端口，如果出现1723端口的行就说明一切正常了：
<pre lang="bash">
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:21              0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:1723            0.0.0.0:*               LISTEN     
tcp        0      0 xxx.xxx.xxx.xxx:22         xxx.xxx.xxx.xxx:51910       ESTABLISHED
tcp        0      0 xxx.xxx.xxx.xxx:22         xxx.xxx.xxx.xxx:53934     ESTABLISHED
tcp        0      0 xxx.xxx.xxx.xxx:1723       xxx.xxx.xxx.xxx:61101     ESTABLISHED
</pre>