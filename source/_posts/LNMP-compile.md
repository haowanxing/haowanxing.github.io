---
title: 完全源码编译LNMP环境
date: 2017-11-06 15:45:46
tags:
categories:
---

环境：

* [CentOS 7](https://www.centos.org/download/) (https://www.centos.org)

软件：

* [nginx-1.13.6.tar.gz](http://nginx.org/download/nginx-1.13.6.tar.gz) (http://nginx.org)
* [php-5.6.31.tar.gz](http://php.net/get/php-5.6.31.tar.gz/from/a/mirror) (http://php.net)
* [mariadb-10.2.10.tar.gz](https://downloads.mariadb.org/interstitial/mariadb-10.2.10/source/mariadb-10.2.10.tar.gz) (https://mariadb.org)

依赖软件：

* [openssl-1.0.2m.tar.gz](https://www.openssl.org/source/) (https://www.openssl.org)
* [pcre-8.39.tar.gz](ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.gz) (http://www.pcre.org/)
* [zlib-1.2.11.tar.gz](http://www.zlib.net/zlib-1.2.11.tar.gz) (http://www.zlib.net/)
* [cmake-3.10.0-rc4.tar.gz](https://cmake.org/files/v3.10/cmake-3.10.0-rc4.tar.gz) (https://cmake.org)

<!--more-->

## 安装openssl
```bash
tar zxf openssl-1.0.2m.tar.gz

cd openssl-1.0.2m

./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl/conf

make && make install
```

## 安装pcre
```bash
tar zxf pcre-8.39.tar.gz

cd pcre-8.39

./configure --prefix==/usr/local/pcre

make && make install
```

## 安装zlib
```bash
tar zxf zlib-1.2.11.tar.gz

cd zlib-1.2.11

./configure --prefix=/usr/local/zlib

make && make install
```

## 安装Nginx
安装nginx必须先安装完上面的3个依赖软件(openssl/pcre和zlib)

我们需要nginx以非root身份运行，所以要新建用户和用户组

```bash
groupadd www
userass -g www www
```

```bash
##为虚拟主机新建目录（默认使用ngixn/html）
mkdir -p /var/www/wwwroot/
chmod -R 755 /var/www/wwwroot/
```

```bash
tar zxf nginx-1.13.6.tar.gz

cd nginx-1.13.6

./configure \
--user=www \
--group=www \
--prefix=/usr/local/nginx \
--with-http_ssl_module \
--with-openssl=/root/Download/openssl-1.0.2m \
--with-pcre=/root/Download/pcre-8.39 \
--with-zlib=/root/Download/zlib-1.2.11 \
--with-http_stub_status_module \
--with-threads

make && make install

##修改配置支持php-fpm
vim /usr/local/nginx/conf/nginx.conf

##在server段中增加
location ~ .php$ {
    root html;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
}
```


## 安装PHP

``` bash
tar zxf php-5.6.31.tar.gz

cd php-5.6.31

./configure --prefix=/usr/local/php --with-config-file-path=/etc/php --enable-fpm --enable-pcntl --enable-mysqlnd --enable-opcache --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-shmop --enable-zip --enable-soap --enable-xml --enable-mbstring --disable-rpath --disable-debug --disable-fileinfo --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pcre-regex --with-iconv --with-zlib --with-mcrypt --with-gd --with-openssl --with-mhash --with-xmlrpc --with-curl --with-imap-ssl

make && make install
```

## 安装Mysql(MariaDB)
（待续。。。）

## 开放80端口
由于centos7默认使用firewall，且没有对外开放80端口，所以这步也是必要的

```bash
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload

```

## 启动服务
启动php-fpm: /usr/local/php/sbin/php-fpm

启动nginx: /usr/local/nginx/sbin/nginx

## 安装过程中遇到的missing部分
- libmcrypt
- libedit
- re2c