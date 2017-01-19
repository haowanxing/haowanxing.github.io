---
title: mac(Linux)下批改mysql服务器的默认字符集为utf8
tags:
  - MacBook
  - mysql
  - utf8
id: 42
categories:
  - Linxu分享
date: 2014-07-07 14:17:25
---

在终端操作数据库：
mysql&gt; show variables like '%char%';
+--------------------------+--------------------------------------------------------+
| Variable_name | Value |
+--------------------------+--------------------------------------------------------+
| character_set_client | utf8 |
| character_set_connection | utf8 |
| character_set_database | latin1 |
| character_set_filesystem | binary |
| character_set_results | utf8 |
| character_set_server | latin1 |
| character_set_system | utf8 |
| character_sets_dir | /usr/local/mysql-5.6.19-osx10.7-x86_64/share/charsets/ |
+--------------------------+--------------------------------------------------------+
这里可以看见 character_set_database 和 character_set_server 都是默认的latin1，这就表明创建的数据库和表都是以latin1为字符集的，在这种情况下，无法正常使用中文！ 下面简单说一下怎么更改这个默认字符集：
1.将本地mysql目录中的支持文件my-xxxx.cnf copy到/etc/my.cnf 命令：（ sudo cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf ）
2.编辑my.cnf 命令（sudo vi /etc/my.cnf )
3.在文件中添加两段代码：“括号中没有的自己补上”
在[client]部分加入：
default-character-set = utf8
在[mysqld]部分加入：
character-set-server = utf8
4.重启mysql;
(提示，如果重启失败，尝试将<span style="color: #ff0000;">[client]</span>下面的<span style="text-decoration: underline;">default-character-set=utf8</span>改成[mysqld]中的一样)

然后就可以查看字符集是否修改成功了，登录mysql 命令查询：
mysql&gt; show variables like '%char%';
+--------------------------+--------------------------------------------------------+
| Variable_name | Value |
+--------------------------+--------------------------------------------------------+
| character_set_client | utf8 |
| character_set_connection | utf8 |
| character_set_database | utf8 |
| character_set_filesystem | binary |
| character_set_results | utf8 |
| character_set_server | utf8 |
| character_set_system | utf8 |
| character_sets_dir | /usr/local/mysql-5.6.19-osx10.7-x86_64/share/charsets/ |
+--------------------------+--------------------------------------------------------+
8 rows in set (0.00 sec)
这样就成功了。