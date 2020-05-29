---
title: 有关MacBook从10.9.5升级到10.11(EI capitan)后的问题及解决方法
tags:
  - Apache
  - Linux
  - MacOS
  - MySQL
id: 282
categories:
  - 学习笔记
abbrlink: ce23f4b0
date: 2015-10-26 20:16:55
---

看到别人的MAC在用最新的EI Capitan系统之后，我终于打破了自己坚持使用旧系统的原则，本着更好的体验和更高的性能，我将自己的本子也更新到最新，既然是更新升级上来的，不免有些小问题会出现，下面就逐个来说说我遇到的问题吧。

## 问题一：Apache无法正常启动？

首先遇到这个问题时，当然是去找日志了，因为在终端输入启动命令：sudo apachectl start之后，没有任何报错和提示，只是本地浏览器访问localhost or 127.0.0.1失败。但是，这个错误日志真的不好找，最后我干脆去配置文件etc/apache2/httpd.conf中寻找。

嗯！找到了！ ErrorLog "/private/var/log/apache2/error_log" 好的，我去看看到底是什么原因。可是，“/private/var/log/apache2/” 目录根本没有任何文件！想着自己给它创建这个错误日志文件吧，创建好了之后使用命令启动apache，结果文件里面没有任何内容！

这也不行，看来通过错误日志是行不通了，于是乎，在网上查找各种资料，终于看到有个人在网页上写到：现在尝试启动一下Apache: sudo apachectl -k start。看到这个，带着好奇我也输入了一遍，好奇心真的不会害死猫！终于出现了报错了！第一次这么开心地看见报错信息，于是乎根据提示找到错误点并屏蔽掉了这个错误的配置。
<!--more-->

最终，启动Apache的命令应该是：sudo apachectl -k start  当然 还有 stop | restart 这两个。

## 问题二：Mysql命令失效？难道Mysql要重装？

对于之前安装过Mysql的用户，当然不想重装啦，毕竟重装的话以前的数据库怎么办！至少我还不知道怎么恢复那么多的数据。我检查了一下目录，发现Mysql的文件 都在，只是命令失效而已。既然是这样的话，找到相关指令的目录不就解决了嘛！ 不！ 太麻烦了。我们应该设置环境变量，将命令全局使用。

Mysql的默认安装目录：/usr/local/mysql 相关命令都在目录的bin文件夹内。
> 执行命令：cd ~
> 
> 执行命令：vi ./.bash_profile
> 
> 
> 然后在里面写入一下信息并保存：
> 
> alias mysql=/usr/local/mysql/bin/mysql
> 
> alias mysqld=/usr/local/mysql/bin/mysqld
> 
> alias mysqladmin=/usr/local/mysql/bin/mysqladmin
这样就可以使用这3个命令了。不过mysqld start是不能启动Mysql的，目前原因未知，但是有两个方法可以启动。第一种就是在系统偏好设置里面通过Mysql按钮启动；第二种就是通过终端输入命令：/Library/StartupItems/MySQLCOM/MySQLCOM [start | stop | restart] 这三种方式控制。

## 问题三：网页程序无法通过localhost连接数据库！

当访问一下的Web项目的时候，发现连接数据库失败，以为之前的Mysql账户都没了，结果发现项目使用的都是root账户，既然账户密码没问题，肯定是数据库地址的问题了。查看了几个程序配置的信息，连接Mysql都是用的localhost作为连接地址的，当然，试了一下修改成127.0.0.1就没什么问题了，但是以前做了那么多项目和小程序，都改一下显然是不合理的，于是我开始寻找问题。首先检查了mysql数据库的user表，里面居然有Host为localhost的记录，用户表是没有问题的。既然这样的话也只有依靠网络的魅力了，通过大量检索各类网页，终于找到了一篇有用的资料，里面讲到了无法使用localhost连接数据库是因为，采用127.0.0.1连接是tcp协议，而localhost则是采用的socket协议，这就牵扯到了socket，众所周知，Mysql里面有个叫做mysql.sock的玩意儿（如果你没启动Mysql服务器就对其连接,你就会看到），如果连接的时候无法找到这个.sock文件，当然是连不上了。于是，看看mysql的配置my.cnf。结果发现这个文件不存在！

没办法，既然它是自己使用默认的配置的话，出现错误也是情有可原的，既然要解决问题，好的，新建配置！不过我们可以从mysql自带的支持文件中copy一份出来：sudo cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf ，然后配置socket ＝ /var/lib/mysql_/mysql.sock （PHP默认的访问位置）。不过这样比较麻烦，因为my.cnf其他的配置我们并不想用到，使其默认就好。_

另外，既然是PHP找不到正确的sock的话，我们还可以通过配置php.ini来指定，先看一下它的信息：$ php -v  和配置文件路径$ php -i | grep 'Configuration File' 发现文件不存在。一样地，如果/etc目录没有php.ini文件的话，我们要copy一个，这个在etc有示范文件，所以：cp /etc/php.ini.default /etc/php.ini ，然后编辑php.ini文件，找到三个地方(mysql.default_socket、mysqli.default_socket、pdo_mysql.default_socket) 给它指定sock文件：/tmp/mysql.sock (这个是当前mysql使用的sock文件)。配置修改并保存完毕，重启apache，用到上面的sudo apachectl -k restart ，一切恢复正常了！

## 问题四：自动启动失效了！

Apache自动启动：sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist

Mysql自动启动：sudo launchctl load -w /Library/LaunchDaemons/com.mysql.mysql.plist

注意：一个是在/System下，一个是在/Library下，两个目录都找一下 如果有的话 就直接使用那个plist文件，如果不存在，自己新建然后执行命令加入自启动行列。如果是要去掉自启动，把load改成unload就可以了。

### 附：两个启动项的列表文件

com.mysql.mysql.plist:
<pre lang='xml'>
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">  
<plist version="1.0">  
  <dict>  
    <key>KeepAlive</key>  
    <true/>  
    <key>Label</key>  
    <string>com.mysql.mysqld</string>  
    <key>ProgramArguments</key>  
    <array>  
    <string>/usr/local/mysql/bin/mysqld_safe</string>  
    <string>--user=root</string>  
    </array>    
  </dict>  
</plist>
</pre>

org.apache.httpd.plist:
<pre lang="xml">
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Disabled</key>
	<true/>
	<key>Label</key>
	<string>org.apache.httpd</string>
	<key>EnvironmentVariables</key>
	<dict>
		<key>XPC_SERVICES_UNAVAILABLE</key>
		<string>1</string>
	</dict>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/sbin/httpd-wrapper</string>
		<string>-D</string>
		<string>FOREGROUND</string>
	</array>
	<key>OnDemand</key>
	<false/>
</dict>
</plist>
</pre>