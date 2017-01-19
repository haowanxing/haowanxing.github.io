---
title: 'linux下使用yum安装Apache+php+Mysql+phpMyAdmin [转载]'
id: 120
categories:
  - Linxu分享
date: 2014-12-23 21:32:44
tags:
---

适用redhat于32位及64位，前提架设好本地源。在这里不再赘述。

1 安装Apache+php+Mysql

a、安装Apahce, PHP, Mysql, 以及php连接mysql库组件 yum -y install httpd php mysql mysql-server php-mysql

b、安装mysql扩展    yum -y install mysql-connector-odbc mysql-devel libdbi-dbd-mysql

或一次性粘贴安装:

yum -y install httpd php mysql mysql-server php-mysql httpd-manual mod_ssl mod_perl mod_auth_mysql php-mcrypt php-gd php-xml php-mbstring php-ldap php-pear php-xmlrpc mysql-connector-odbc mysql-devel libdbi-dbd-mysql

c、设置mysql数据库root帐号密码。
mysqladmin -u root password ‘newpassword’ [引号内填密码]

d、 让mysql数据库更安全
mysql -u root -p [此时会要求你输入刚刚设置的密码，输入后回车即可

mysql> DROP DATABASE test; [删除test数据库]
mysql> DELETE FROM mysql.user WHERE user = ”; [删除匿名帐户]
mysql> FLUSH PRIVILEGES; [重载权限]

e、 按照以上的安装方式, 配置出来的默认站点目录为/var/www/html/新建一个php脚本:
<?php
phpinfo();
?>

2、安装phpMyAdmin
进入phpMyAdmin官方下载(不要最新版本，下phpMyAdmin 2.11.9.5就行了,3.1以上需php 5.2以上)，上传到你的网站目录下，然后进行配置。只需几步即可搞定。
I. config.sample.inc.php更名为config.inc.php;
II. 打开config.inc.php文件，进行以下修改;
// $cfg['Servers'][$i]['controluser'] = ‘pma’;
// $cfg['Servers'][$i]['controlpass'] = ‘pmapass’;
// $cfg['Servers'][$i]['pmadb'] = ‘phpmyadmin’;
// $cfg['Servers'][$i]['bookmarktable'] = ‘pma_bookmark’;
// $cfg['Servers'][$i]['relation'] = ‘pma_relation’;
// $cfg['Servers'][$i]['table_info'] = ‘pma_table_info’;
// $cfg['Servers'][$i]['table_coords'] = ‘pma_table_coords’;
// $cfg['Servers'][$i]['pdf_pages'] = ‘pma_pdf_pages’;
// $cfg['Servers'][$i]['column_info'] = ‘pma_column_info’;
// $cfg['Servers'][$i]['history'] = ‘pma_history’;
// $cfg['Servers'][$i]['designer_coords'] = ‘pma_designer_coords’;

去掉每行前面的//;
II.$cfg['blowfish_secret'] = ”; |修改为| $cfg['blowfish_secret'] = ‘http’;
IV.$cfg['Servers'][$i]['controluser'] = ‘pma’; |把’pma’修改为你的帐号|$cfg['Servers'][$i]['controlpass'] = ‘pmapass’; |把’pmapass设置为你的mysql登录密码|
V. $cfg['blowfish_secret'] = ”; | 添加短语密码例如：$cfg['blowfish_secret'] = ‘onohot’;

3、//安装php的扩展
yum -y install php-gd php-xml php-mbstring php-ldap php-pear php-xmlrpc

4、//安装apache扩展

yum -y install httpd-manual mod_ssl mod_perl mod_auth_mysql

5、 配置防火墙
添加允许访问HTTP、FTP端口

iptables -I RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPTiptables -I RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
重启iptables: service iptables restart 
转载于：[linux下使用yum安装Apache+php+Mysql+phpMyAdmin - - ITeye技术网站](http://heyh0520.iteye.com/blog/540851).