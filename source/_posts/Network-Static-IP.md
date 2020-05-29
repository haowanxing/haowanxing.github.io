---
title: Linux配置网卡（静态）IP地址
tags:
  - 网卡
abbrlink: 15ab52a4
date: 2019-09-23 15:00:08
categories: Linux
---

> 上一篇记录了在OrangePi-Zero连接WIFI的过程，今天试着给自带默认网卡配置一下静态IP地址，以方便在整个局域网内能够访问设备。

## 首先

还是得通过ssh等方式登录Server，然后查看网卡的名称。执行`ifconfig`命令，找到eth开头的网卡，我这里是`eth0`。

## 再者

使用`vim`编辑文件`/etc/network/interfaces`，增加新行如下：

<!--more-->

```bash
auto eht0
#iface eth0 inet dhcp #此处为DHCP自动获取IP，注释掉了哟
iface eth0 inet static #声明接口为静态的
address 172.16.105.134 #IP地址
network 172.16.105.0	#网段
netmask 255.255.255.0	#子网掩码
broadcast 172.16.105.255	#广播地址
gateway 172.16.105.254	#网关IP
```

保存！

然后重启网卡，这里我使用`ifconfig eth0 down`和`ifconfig eth0 up`达到关闭和重新打开的效果。

## 最后

执行`ifconfig eth0`查看IP是否正确配置，并且可以在局域网内`ping`通该地址和`ssh`到Server。

本篇仅为给自己的小记录，供大家参考！
