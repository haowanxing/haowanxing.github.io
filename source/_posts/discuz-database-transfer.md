---
title: Discuz的数据库的迁移
id: 231
categories:
  - 我的分享
date: 2015-09-26 23:06:48
tags:
---

如果WEB服务器迁移，除了将论坛所有的文件转移到新的服务器上之外，还需要将数据库一同迁移。文件转移完毕之后，并不能算完成了，因为这里还有数据库的配置没有修改。
Discuz论坛，如果需要迁移数据库，那么我们在转移的数据库的所有数据之后，还需要重新配置一下Discuz的配置文件：
论坛连接Ucenter的配置：config/config_ucenter.php 
论坛的配置：config/config_global.php
Ucenter的配置：uc_server/data/config.inc.php
在这三个文件里面，修改对应的数据库地址、数据库名称、用户名、密码。
全部配置完毕之后，保存就可以了。