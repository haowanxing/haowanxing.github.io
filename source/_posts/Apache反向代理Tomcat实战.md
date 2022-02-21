---
title: Apache 反向代理 Tomcat实战
tags:
  - Apache
  - Linux
  - Proxy
id: 275
categories:
  - Linux
abbrlink: c178ca6
date: 2015-10-22 21:27:58
---

[![apache](http://www.dshui.wang/wp-content/uploads/2015/10/QQ截图20151022212703-300x157.png)](http://www.dshui.wang/wp-content/uploads/2015/10/QQ截图20151022212703.png)

近期突然有个想法，既然有多出来的服务器，空着也是空着，不如拿出来用作演示项目。带着这样的心情，我开始在自己的服务器上动起了手脚。

## 一、现有情况：

1.  我的博客地址：http://www.dshui.wang/
2.  演示用的服务器地址(Tomcat)：http://xxx.xx.xx.xx:8080/ （由于暴露IP和端口带来了攻击，现在取消了）
3.  演示所用域名：demo.dshui.wang 解析至博客所在服务器（非演示用服务器）

## 二、预期效果：

1.  访问http://demo.dshui.wang/tomcat/时，展示的页面为http://xxx.xx.xx.xx:8080/所显示的页面
2.  更近一层，http://demo.dshui.wang/tomcat/* 译为http://xxx.xx.xx.xx:8080/*  （*代表通配符<!--more-->

## 三、配置代理：

所需要配置的就只有对应域名的反向代理，我们进入apache的虚拟主机配置文件，在最下面新建规则：
<pre lang="dos">    ServerName demo.dshui.wang
    ProxyPreserveHost On
    ProxyPass  /tomcat http://xxx.xx.xx.xx:8080/
    ProxyPassReverse /tomcat http://xxx.xx.xx.xx:8080/
    ProxyPassReverseCookieDomain xxx.xx.xx.xx xxx.xb.xc.xa demo.dshui.wang
    ProxyPassReverseCookiePath / /tomcat
    ProxyPassReverseCookiePath /*/ /tomcat
</pre>
解释：
<pre lang="dos">ServserName XXXXX               我们对域名demo.dshui.wang来进行代理访问
ProxyPreserveHost On            使用进入的HTTP请求头来发送代理请求
ProxyPassReverse                调整由反向代理服务器发送的HTTP应答头中的URL
ProxyPassReverseCookieDomain    调整由反Set-Cookie报头域串代理服务器
ProxyPassReverseCookiePath      调整由反Set-Cookie标头的路径字符串的代理服务器

如果只是简单的设置了ServserName、ProxyPass和ProxyPassReverse的话，最后结果是session和Cookie的作用域无效！后面的两条我找了好久才配置好，虽然还没弄的非常的明白，嘿！

这样一来，我的展示平台就代理好了，这样的好处在于：我不用在演示平台的机器上安装一个Apache来绑定域名（解决了有些时候不允许绑定，比如需备案）或者修改Tomcat的端口为80，而且通过代理的方式，我可以轻松在演示平台上安装其他服务端口，最后通过代理不同的路径来访问不同的端口下的服务器应用。
是不是感觉就是在一个平台上访问呢？</pre>

### 相关资料：

[http://man.chinaunix.net/newsoft/ApacheMenual_CN_2.2new/mod/mod_proxy.html](http://man.chinaunix.net/newsoft/ApacheMenual_CN_2.2new/mod/mod_proxy.html)
[http://blog.csdn.net/fenglibing/article/details/6796094/](http://blog.csdn.net/fenglibing/article/details/6796094/)