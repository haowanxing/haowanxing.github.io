---
title: linux下允许外网对mysql的访问
id: 108
categories: Linux
abbrlink: 8db5876f
date: 2014-11-18 11:48:17
tags:
  - Linux
  - MySQL
---

从阿里云镜像市场安装的ubuntu(Apache+Mysql+VsFtp)里面Mysql默认是外网无法访问的，而在实际开发过程中需要对数据库的可视化比对操作，这样我们可以通过本地计算机来事实查改服务器的数据库。
<pre lang="mysql">

1、修改表,登录mysql数据库,切换到mysql数据库,使用sql语句查看
"select host,user from user ;"
\mysql -u root -p
\mysql>use mysql; 
\mysql>update user set host = '%' where user ='root'; 
\mysql>select host, user from user; 
\mysql>flush privileges;  （使修改生效，必须执行）

2、授权用户,你想root使用密码从任何主机连接到mysql服务器
\mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'admin1234' WITH GRANT OPTION;
\mysql>flush privileges;  （使修改生效，必须执行）

</pre>