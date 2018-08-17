---
title: Apache设置目录的访问权限（用户名和密码）
tags: Apache
abbrlink: b54dd86c
date: 2018-02-01 14:58:17
categories:
---

　　最近重新搞了个阿里云香港ECS用来科学上网，另外使用[LAMP一键安装包](https://lamp.sh)搭环境，搭建完成后开放云盾端口即可通过IP访问到web默认页，这默认页有些实用的小工具，如：探针、MyAdmin啥的。如图：

　　![](http://ojrm4585k.bkt.clouddn.com/20180201151746870535154.png)

　　然后我想让这默认页只有我自己能看到，其他人最好不要看到，毕竟其他人看到也没啥用，最多给服务器施压而已，然后就想弄个如下图的效果：

　　![](http://ojrm4585k.bkt.clouddn.com/20180201151746846888519.png)

　　下面来讲讲如何实现此效果的步骤，假设需要设置权限的目录(DIR)为"/data/www/default"

* 修改apache的配置文件（可以是httpd.conf，也可以是具体的vhost的单独配置文件）,内容如下：
```
<Directory "/data/www/default">
    Options Indexes
    AllowOverride AuthConfig
    Order allow,deny
    Allow from all
</Directory>
```

* 在DIR下新增.htaccess文件，内容如下
```
AuthName "sys"
AuthType Basic
AuthUserFile /data/www/default/.htpasswd
require user username
```

* 使用Apache的htpasswd创建.htpasswd文件
```
/usr/local/apache/bin/htpasswd -c /data/www/default/.htpasswd username
##这里会提示你输入两次密码##
```

　　完成上述步骤后，重启Apache即可