---
title: 初探MongoDB安全之RBAC（基于角色的访问控制）
tags:
  - MongoDB
  - 数据库
id: 557
categories:
  - 数据库
abbrlink: 432477cb
date: 2016-11-04 19:37:07
---

> 写在开头的一段话：我是一名忠实的SQL玩家，虽说MySQL并没有达到精通的级别，但在日常使用中还是会经常出现“这个表要是NoSQL的话就好办多了”的想法。所以说，我认为无论是站在关系型数据库还是非关系性数据库的立场上，二者并不是相对立的，而且我觉得应该用“相辅相成”来形容二者的关系。

通过在[《MongoDB 教程|菜鸟教程》](http://www.runoob.com/mongodb/mongodb-tutorial.html)轻量级的了解了一下MongoDB的基础知识，我在自己电脑上安装并使用了这款NoSQL软件。很明显地，读别人的教程只能是迅速的、简单的和容易理解的。也正是这样，我发现了其中有一块并没有提及！那就是并没有说要登录数据库啊。
<!--more-->

简单的使用：

1.  启动MongoDB服务：
<pre lang="bash">
Anthony-MacBook-Air:~ anthony$ mongod --dbpath ~/mongodata/
2016-11-04T16:48:15.170+0800 I CONTROL  [initandlisten] MongoDB starting : pid=1191 port=27017 dbpath=/Users/anthony/mongodata/ 64-bit host=Anthony-MacBook-Air.local
2016-11-04T16:48:15.171+0800 I CONTROL  [initandlisten] db version v3.2.8
...
2016-11-04T16:48:15.825+0800 I NETWORK  [HostnameCanonicalizationWorker] Starting hostname canonicalization worker
2016-11-04T16:48:15.826+0800 I NETWORK  [initandlisten] waiting for connections on port 27017
</pre>

2.  连接数据库：
<pre lang="bash">
Anthony-MacBook-Air:~ anthony$ mongo
MongoDB shell version: 3.2.8
connecting to: test
Server has startup warnings: 
2016-11-04T16:48:15.820+0800 I CONTROL  [initandlisten] 
2016-11-04T16:48:15.820+0800 I CONTROL  [initandlisten] ** WARNING: soft rlimits too low. Number of files is 256, should be at least 1000
> 
</pre>

这样就算连接上了，而且可以进行任何操作，没有限制。实际上在开发测试也没必要纠结安全登录问题，但是如果是正式环境，那也不能放松啊！

## Authorization

安全（Security）中的一种，用户授权机制

### Role-Based Access Control（RBAC)

MongoDB使用基于角色的访问控制(RBAC)来对一个MongoDB进行管理，用户可以被授予一个或多个角色（也可以说是策略组）来确保用户对资源的访问权限。

1.  #### 启用授权策略：

MongoDB默认是不开启授权机制的，所以我们在启动服务的时候，可以加上--auth参数来明确告诉它开启授权策略，也可以在配置文件中配置。不过一旦这样启动了，连接数据库就必须进行用户验证了，如果之前没有添加用户的话，可想而知。

2.  #### 角色（策略组）：

一个角色代表对某个资源上指定操作的权限. 每个权限可以是角色中明确指定的、从另外角色继承的，也可以二者都是。

3.  #### 用户和角色：

你可以在添加用户的时候对其进行角色（策略或权限）分配，也可以对已经存在的用户更新角色。

用户将拥有被分配角色的所有权限，当然，用户可以被分配多个角色。尽管这个用户仅在一个数据库中被创建，但只要Role中分配了其他数据库的权限，该用户也可以夸库访问。

4.  #### 内置角色和自定义角色：

MongoDB提供了一些内置的角色来实现一套系统的通用权限策略，当内置角色无法满足实际需要的时候，我们可以自定义独特的角色。

### 开启用户授权控制(Enable Auth)

1.  #### 概述：

当开启用户授权控制的时候，表示用户需要进行认证自己的身份才能够根据自己所拥有的权限进行数据库访问。

2.  #### 用户管理员：

使用用户授权控制，你必须确保'admin'数据库中有'userAdmin'或'userAdminAnyDatabase'二者之一角色的用户，该用户可以管理用户和角色，如：创建用户，授予或撤销用户的角色，创建或修改通用角色。

如果你在创建用户之前就开启了授权控制，那么系统会提供一个本地例外，允许你在'admin'数据库中创建一个用户管理员，一旦你创建了用户管理员，你必须使用该用户验证授权来创建你所需要的其他用户。

3.  #### 步骤：

接下来将介绍如何在授权控制和非授权控制模式下的MongoDB数据库中首次添加一个用户管理员。

    1.  #### 非授权模式启动MongoDB服务端:

<pre lang="bash">
mongod --port 27017 --dbpath ~/mongodata
</pre>
    2.  #### 连接MongoDB实例：

<pre lang="bash">
mongo --port 27017
</pre>
    3.  #### 创建用户管理员：
    
    在'admin'数据库中创建角色为“userAdminAnyDatabase”的用户“anthony”：

<pre lang="bash">
use admin
db.createUser(
  {
    user: "anthony",
    pwd: "passwd",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
</pre>
    4.  #### 以授权模式重启MongoDB服务端：
    
    命令行启动直接带上--auth参数即可，如果是使用的配置文件的形式，设置'security.authorization'。

<pre lang="bash">
mongod --auth --port 27017 --dbpath ~/mongodata
</pre>

    现在，连接到服务端的客户需要进行授权才能执行角色权限内的操作。
    
        5.  #### 连接服务端并使用用户管理员('anthony')进行授权验证：
    
    两种方式，连接时指定或在连接后使用db.auth()方法验证
    
    直接带上验证参数：

<pre lang="bash">
mongo --port 27017 -u anthony -p --authenticationDatabase 'admin'
</pre>

    连接后再进行身份认证：

<pre lang="bash">
Anthony-MacBook-Air:~ anthony$ mongo --port 27017
MongoDB shell version: 3.2.8
connecting to: test
...
> use admin
switched to db admin
> db.auth('anthony','passwd')
1
> 
</pre>
    6.  #### 添加你所需要的附加用户：
    
    当你使用用户管理员身份验证之后，你可以使用db.createUser()方法创建用户并给其分配角色。
    
    用户管理员（本文中的'anthony'）只能够进行用户的管理和角色分配，如果进行其他的操作的话就会报错。
    
    下面的例子将创建一个用户，他拥有两个不同数据库的不同权限：

<pre lang="bash">
use test
db.createUser(
  {
    user: "user01",
    pwd: "01",
    roles: [ { role: "readWrite", db: "test" },
             { role: "read", db: "local" } ]
  }
)
</pre>
    7.  #### 连接服务端并使用'user01'进行授权验证：

<pre lang="bash">
mongo --port 27017 -u user01 -p --authenticationDatabase 'test'
</pre>

    这样，使用user01连接数据库后，就可以对'test'库进行读和写操作，也可以切换到'local'库，但权限为‘只读’

## 用户与角色的管理(Manage Users and Roles)

这一块的内容，我们改日再聊。或者自己先阅读[官方文档](https://docs.mongodb.com/manual/tutorial/manage-users-and-roles/)