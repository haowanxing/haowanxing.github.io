---
title: apache域名跳转法简单完成重定向
id: 122
categories:
  - Linux
abbrlink: cc99fffd
date: 2014-12-30 22:46:02
tags:
  - Apache
---

用.htaccess做域名跳转
apache默认是开启.htaccess的。
但是为了成功率还是检查一下配置有没有真的支持
编码apache的配置文件httpd.conf，把相应的内容修改为：
<pre>
Options FollowSymLinks
AllowOverride All
LoadModule rewrite_module modules/mod_rewrite.so 这一行的注释要去掉
</pre>
然后重启动apache服务器。

编辑apahce中web根目录下.htaccess文件（如题没有此文件，则直接新建立一个既可）。

RewriteEngine On
RewriteCond %{HTTP_HOST} ^fandouzi.com [NC]
RewriteRule ^(.*) http://www.fandouzi.com/ [R=301,L]

访问fandouzi.com同样会转向到www.fandouzi.com。