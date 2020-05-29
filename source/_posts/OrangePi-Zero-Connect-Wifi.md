---
title: OrangePi Zero 简单连接WIFI的方法
tags:
  - OrangePi
  - Network
abbrlink: ba6472f
date: 2019-09-12 14:02:31
categories: 开发板
---

> 有幸拿到可爱的小玩意儿“OrangePi_Zero”，也烧写了多个系统去体验，其中可以直接刷写OpenWrt，然后通过web管理界面启用WIFI功能。不过我需要的不是路由器，我需要的是能够连接WIFI的小型Server。

## 首先

通过ssh等方式登录server，然后查看无线网卡的名称。这里使用`iwconfig`命令，如果无线网卡正常安装且驱动正常的话，你能够看到一个以`wlan`开头+数字的的网卡，记住这个名字（我这里是`wlan5`)。

## 再者

使用`vim`编辑文件`/etc/network/interfaces`，内容如下：

<!--more-->

```bash
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto wlan5
allow-hotplug wlan5
iface wlan5 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

```

保存然后创建上面配置的wpa-conf文件`/etc/wpa_supplicant/wpa_supplicant.conf`，内容如下：

```bash
ctrl_interface=/var/run/wpa_supplicant
update_config=1
network={
ssid="需要连接的SSID名称"
psk="WIFI密码"
proto=RSN
key_mgmt=WPA-PSK
pairwise=CCMP
auth_alg=OPEN
}
```

保存！

然后执行`ifdown wlan5`关闭并执行`ifup wlan5`重启网卡，正常的话应该能看到网卡连接WIFI并寻找DHCP服务器来请求IP地址。

如果`ifdown`或`ifup`报错，试一下`sudo killall wpa_supplicant`，然后继续尝试。

## 最后

如果失败了怎么办？`reboot`重启一下机器，它会自动连接WIFI的。

本篇仅为给自己的一个小记录，仅供参考
