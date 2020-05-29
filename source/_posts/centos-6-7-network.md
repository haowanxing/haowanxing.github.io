---
title: Linux之CentOS 6.7 下无网络? 原来是网卡没启动！
id: 226
categories:
  - Linux
abbrlink: 3be490a0
date: 2015-08-26 16:37:12
tags:
  - CentOS
---

![CentOS-Network-eth0](../uploads/2015/08/CentOS-Network-eth0.jpg)
今天用Vbox安装了CentOS 6.7 准备测试游戏服务器,需要下载一个服务端，使用wget时发现无wget命令，聪明的我马上想到使用yum install wget 来安装一个，谁知道出现了无法连接镜像列表的报错，通过查看ifconfig发现，原来是网卡没有启动，于是查看了资料：

```
 vi /etc/sysconfig/network-scripts/ifcfg-eth0
```
修改开启自启:
```
DEVICE=eth0
HWADDR=00:0C:29:2E:37:F0
TYPE=Ethernet
UUID=69cd9740-184f-49b7-857f-e397e57f265b
ONBOOT=yes          //修改此处
NM_CONTROLLED=yes   //修改此处
BOOTPROTO=dhcp
```
然后重启网络：
```
//重启网络
/etc/init.d/network restart
//查看IP
```