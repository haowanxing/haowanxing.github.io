---
title: ' CENTOS 6.0 iptables 开放端口80 3306 22端口'
id: 312
categories:
  - Linxu分享
date: 2015-11-11 21:13:01
tags:
---

#/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
#/sbin/iptables -I INPUT -p tcp --dport 22 -j ACCEPT
#/sbin/iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
然后保存：
#/etc/rc.d/init.d/iptables save

查看打开的端口：

# /etc/init.d/iptables status

-------------------------------------------------------

补充说明：
<!--more-->

#关闭防火墙

/etc/init.d/iptables stop

service iptables stop # 停止服务

#查看防火墙信息

/etc/init.d/iptables status

#开放端口:8080

/sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT

#重启防火墙以便改动生效:(或者直接重启系统)

/etc/init.d/iptables restart

#将更改进行保存

/etc/rc.d/init.d/iptables save

另外直接在/etc/sysconfig/iptables中增加一行：

-A RH-Firewall-1-INPUT -m state –state NEW -m tcp -p tcp –dport 8080 -j ACCEPT

#永久关闭防火墙
chkconfig –level 35 iptables off #此方法源自网络，未实验，安全考虑拒绝使用此方法

[文章出处：CENTOS 6.0 iptables 开放端口80 3306 22端口](http://blog.sina.com.cn/s/blog_4c4a24db0100vb0h.html)