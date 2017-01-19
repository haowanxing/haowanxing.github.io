---
title: CentOS 6下更新PHP版本到5.5后与Nginx发生的小事情
id: 334
categories:
  - Linux
date: 2016-01-29 00:32:33
tags:
---

今天在写API的时候用到了php中新版本的json_encode()方法，在5.4以后支持了不对中文进行Unicode编码，而我在服务器上的php版本还停留在yum源包自带的5.3版本，只有升级来满足需要了。
首先，找了一些关于升级PHP的文章，各不相同，我还是坚持简单、易操作的方法，使用yum来更新。
当然，yum update php 是完全不能解决的，因为它告诉我5.3是最新的版本了。不能怪它，因为没人告诉它今年是哪一年了^_^!
这个不行，肯定要换一个源包了。。
不过首先是要卸载已经安装的php。在这之前，先看看当前安装的PHP有哪些依赖包吧：
<pre lang="bash">
yum list installed | grep php
</pre>
结果如下：
[root@iZ28l1ca1vhZ scuec]# yum list installed | grep php
php.x86_64                           5.3.3-46.el6_6                     @updates
php-bcmath.x86_64                    5.3.3-46.el6_6                     @updates
php-cli.x86_64                       5.3.3-46.el6_6                     @updates
php-common.x86_64                    5.3.3-46.el6_6                     @updates
php-fpm.x86_64                       5.3.3-46.el6_6                     @updates
php-gd.x86_64                        5.3.3-46.el6_6                     @updates
php-imap.x86_64                      5.3.3-46.el6_6                     @updates
php-ldap.x86_64                      5.3.3-46.el6_6                     @updates
php-mbstring.x86_64                  5.3.3-46.el6_6                     @updates
php-mcrypt.x86_64                    5.3.3-4.el6                        @epel   
php-mysql.x86_64                     5.3.3-46.el6_6                     @updates
php-odbc.x86_64                      5.3.3-46.el6_6                     @updates
php-pdo.x86_64                       5.3.3-46.el6_6                     @updates
php-pear.noarch                      1:1.9.4-4.el6                      @base   
php-xml.x86_64                       5.3.3-46.el6_6                     @updates
php-xmlrpc.x86_64                    5.3.3-46.el6_6                     @updates
上面这些本来有的，安装新版本后还是加上去比较好办，对！
接着卸载php吧
<!--more-->

<pre lang="bash">
yum remove php*
</pre>
刷刷的卸完了。。。。然后执行下面的指令来添加源包列表
<pre lang="bash">
rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
</pre>
这是我在网上找到的，但是提示找不到主机，后来，将mirror更改成repo居然行了。
所以是：
<pre lang="bash">
rpm -Uvh http://repo.webtatic.com/yum/el6/latest.rpm
</pre>
完成之后开始安装新的php5.5，上面那些依赖都装上吧，所以指令就成了：
<pre lang="bash">
yum install -y php55w.x86_64 php55w-cli.x86_64 php55w-common.x86_64 php55w-gd.x86_64 php55w-ldap.x86_64 php55w-mbstring.x86_64 php55w-mcrypt.x86_64 php55w-mysql.x86_64 php55w-pdo.x86_64 php55w-fpm php55w-bcmath php55w-imap php55w-odbc php55w-pear php55w-xml php55w-xmlrpc
</pre>
总之全装上去，哈哈@——@
装完之后重启nginx和php-fpm就好了。
<pre lang="bash">
service nginx restart
service php-fpm restart
</pre>
这时候，我发现整个服务器是上的站点都打不开了，全部都是404报错。还以为这点点操作能把我站点给删了呢，检查站点目录，权限，nginx配置。统统没问题！ 问题肯定出在php上面！！所以百度了一下有关nginx上php升级后的404问题，看了一些废网页之后很着急，遍来了个搜索‘php-fpm 404’ 找到了这篇‘[nginx php-fpm 404 错误](http://blog.chinaunix.net/uid-11989741-id-3351352.html) ’，他提到了php-fpm中user和group不匹配导致的404错误，我马上去查看php-fpm的配置文件一查清楚，对！就是这个问题，新装的php-fpm默认配置中user和group都是apache,但是我这是直接使用Nginx做的服务器。我想，Apache用户应该就不用这么麻烦了。。。修改user和group为nginx用户之后，一切恢复正常！