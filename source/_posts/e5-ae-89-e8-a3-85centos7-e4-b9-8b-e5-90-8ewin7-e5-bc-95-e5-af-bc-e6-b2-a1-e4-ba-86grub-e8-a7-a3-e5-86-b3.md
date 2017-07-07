---
title: '安装CentOS7之后win7引导没了,Grub解决'
id: 175
categories:
  - Linux
date: 2015-06-09 10:37:03
tags:
---

    因为学习linux需要，虚拟机安装又显得太简单，所以在实验室win7电脑上装个windows和linux的双系统，自然采用最新的centos7来试着玩一玩咯！但是没想到装完cnetos7之后，windows进不去了（没有windows的引导），上网查了各种资料，最终确定了修改Grub的配置文件来增加对windows的引导。
    首先我们要登陆Centos,打开Grub的配置文件：
<pre>
执行命令：
vi /boot/grub2/grub.cfg
</pre>
找到 ### BEGIN /etc/grub.d/30_os-prober ### 在下面添加：
<pre>
menuentry "Windows 7 Loader On Dev/sda1" {
     insmod ntfs
     set root=(hd0,1)
     chainloader +1
}
</pre>
关键代码：set root=(hd0,1) 其中 hd0 表示硬盘，1 表示C盘 ，因为我这里win7是安装在C盘的，所以是1，如果你不是C盘（第一个分区），那么就要需改成你对应的分区号了。