---
title: 利用Dockerfile创建PHP7.3环境镜像
tags:
  - Docker
abbrlink: a05a90fb
date: 2019-07-04 10:39:55
categories: 学习笔记
---

## 关于Docker以及Dockerfile

Docker容器就不详细介绍了，把它理解成类似“虚拟机”的一种介质吧。至于如何创建一个镜像，主要有两种方法：1. 从现有的镜像基础上，创建容器并自定义后Commit成镜像；2. 利用Dockerfile，根据自己的需要，如同写shell脚本一般，将自己需要搭建的容器环境所需的指令一条一条的汇集成指令集，然后让Docker根据Dockerfile来自动创建你想要的镜像

## 创建自己的PHP7.3镜像

下载PHP源码：https://www.php.net/downloads.php

我这里下载了php-7.3.6.tar.bz2

<!--more-->

### Dockerfile内容

```Dockerfile
# 指定基于ubuntu:16.04创建
FROM ubuntu:16.04
# 声明作者
MAINTAINER haowanxing <haowanxing@gmail.com>
# 定义环境变量，设置时区时使用
ENV TIME_ZONE Asia/Shanghai

# 修改root账号密码
RUN /bin/echo 'root:0x4f5da2.cn' | chpasswd
# 新增一个prod账号，并设置密码
RUN useradd prod
RUN /bin/echo 'prod:123456' | chpasswd

# 安装编译依赖
RUN apt-get update
RUN apt-get install -y gcc make openssl libssl-dev curl libbz2-dev libxml2-dev libjpeg-dev libpng-dev libfreetype6-dev libzip-dev
RUN apt-get install -y libcurl4-gnutls-dev
RUN ln -s /usr/lib/x86_64-linux-gnu/libssl.so /usr/lib

# 拷贝源码到环境中
ADD php-7.3.6.tar.bz2 /tmp/
# 编译和安装
RUN cd /tmp/php-7.3.6 && \
	./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=prod --with-fpm-group=prod --with-mysqli --with-pdo-mysql --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --enable-ftp --with-gd --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --disable-fileinfo --enable-maintainer-zts && \
	make && \
	make install

# 后续配置
RUN cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
	sed -i 's/127.0.0.1/0.0.0.0/g' /usr/local/php/etc/php-fpm.conf && \
	sed -i "21a daemonize=no" /usr/local/php/etc/php-fpm.conf && \
	echo "${TIME_ZONE}" > /etc/timezone && \
	ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# 清理无用缓存
RUN rm -rf /tmp/php-* && apt-get clean

# 拷贝已定义好的配置文件到环境中
COPY php.ini /usr/local/php/etc/

# 设置默认工作目录
WORKDIR /usr/local/php/

# 声明端口
EXPOSE 22
EXPOSE 9000

# 容器启动时的执行指令
CMD ["./sbin/php-fpm","-c","/usr/local/php/etc/php.ini","-y","/usr/local/php/etc/php-fpm.conf"]
```

一切都准备好了以后，打开shell终端，cd到Dockerfile目录，目录结构如下:

```
~/DockerSpace/phpserver/php » tree ./                                                                                                                                           anthony@Anthony-Macbook-Air
./
├── Dockerfile
├── php-7.3.6.tar.bz2
└── php.ini
```

将源码和Dockerfile放在同一目录，此目录中还有一个php.ini，放置此文件是方便在创建镜像的时候直接将PHP的配置文件替换进去，这样就省去后期手动修改配置的麻烦了。

使用build指令进行构建镜像：`docker build -t haowanxing/php:7.3.6 .`

解释：

1. -t #定义构建的镜像名称
2. 后面跟了一个`.`表示Dockerfile文件在当前目录

build指令执行完成之后，你会看到类似这样的输出：

```
...
 ---> c4838c0eca4a
Step 18/19 : EXPOSE 9000
 ---> Running in 447e0dfb161a
Removing intermediate container 447e0dfb161a
 ---> 25c6980f2084
Step 19/19 : CMD ["./sbin/php-fpm","-c","/usr/local/php/etc/php-fpm.conf"]
 ---> Running in d00d6a4b2a2a
Removing intermediate container d00d6a4b2a2a
 ---> e146bd75c478
Successfully built e146bd75c478
Successfully tagged haowanxing/php:7.3.6
```

说明构建成功，你可以使用`docker run`来创建并启动容器了。

否则会输出具体的错误信息和发生错误的具体指令。

### 创建容器并检查容器环境是否正常

```
~/DockerSpace/phpserver/php » docker run -itd --name myphp haowanxing/php:7.3.6                                                                                                 anthony@Anthony-Macbook-Air
a612173bd9e715a838b29ef0d7e94ddbcac3f42232668b1e43e1e090c8633e9f
------------------------------------------------------------
~/DockerSpace/phpserver/php » docker exec -it myphp /bin/bash                                                                                                                   anthony@Anthony-Macbook-Air
root@a612173bd9e7:/usr/local/php# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  1.3  0.8 170396 18408 pts/0    Ss+  05:09   0:00 php-fpm: master process (/usr/local/php/etc/php-fpm.conf)
prod         7  0.0  0.3 170396  6784 pts/0    S+   05:09   0:00 php-fpm: pool www
prod         8  0.0  0.3 170396  6784 pts/0    S+   05:09   0:00 php-fpm: pool www
root         9  1.6  0.1  18236  3192 pts/1    Ss   05:09   0:00 /bin/bash
root        19  0.0  0.1  34420  2812 pts/1    R+   05:09   0:00 ps aux

```

### 这里备注一下我遇到的错误以及我是如何解决的

#### OpenSSL's libraries错误

```
configure: error: Cannot find OpenSSL’s libraries
```

命名安装了openssl和libssl-dev，但还是报错，于是如下重新链接libssl.so到lib下，RUN `ln -s /usr/lib/x86_64-linux-gnu/libssl.so /usr/lib`。

至于这个libssl.so在哪儿？ 我是通过`find /usr/lib -name libssl.so`找到的。

#### libcurl错误

```
configure: error: Please reinstall the libcurl distribution -
      easy.h should be in <curl-dir>/include/curl/
```

检查并多次尝试之后，通过`apt-get install -y libcurl4-gnutls-dev`来解决；
