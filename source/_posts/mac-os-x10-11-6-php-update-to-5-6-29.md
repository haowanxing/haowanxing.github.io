---
title: 我是如何将mac OS X(10.11.6)的PHP版本升级到5.6.29的
tags:
  - macosx
  - php
id: 589
categories:
  - Linxu分享
  - PHP
abbrlink: 8ca39648
date: 2017-01-16 18:52:38
---

![](http://qiniu.0x4f5da2.cn/20170116148456405447908.jpg?imageView2/0/format/jpg)
由于项目和学习的需要，本机曾经升级到了5.5.38已经不够折腾了，所以时候升级一波5.6了（没必要到7的时候，我是不会去升级的）。
首先直接去搜索引擎找便捷的方法呗，直接就选中了一款来自“简书”的文章，因为它就简单的一条命令：
```
curl -s http://php-osx.liip.ch/install.sh | bash -s 5.6
```
看到这个地址，我心里就放心了！因为上一个版本也是liip的。
我首先看了一下这个install.sh的内容，确定没有什么危险，里面其实就是检测一下设备的系统版本和cpu类型是否可以升级。
环境检测没问题就去下载了一个叫做“packager.tgz”的压缩包，然后解压，运行里面的pythony脚本。
```
#TYPE = 5.6-10.10
sudo packager.py install $TYPE-frontenddev
```
<!--more-->

看到了sudo哦，嘻嘻，自己下载那个packager.tgz看看python代码。好，打开packager.py，找到脚本入口:
c = Cli()
c.run()
嗯，好！     看不懂了。。。管他呢 直接运行吧。。。
然而结果是，install.sh运行没啥问题，到了python脚本的时候，要下载一个更新包，就一直不动了。
```
downloading https://s3-eu-west-1.amazonaws.com/php-osx.liip.ch/install/5.6-10.10-frontenddev-latest.dat
downloading https://s3-eu-west-1.amazonaws.com/php-osx.liip.ch/install/5.6-10.10/frontenddev/5.6-10.10-frontenddev-5.6.29-20170114-210819.tar.bz2
```
第一行是获取最新的更新包url，第二行是下载并保存这个更新包。
然而我却傻傻的等了一下午！！！！！一个下午，喝了两杯水，改了一个BUG，上了两次厕所！  等不了了，control+c终止脚本运行，重新运行试一下，结果还是一样。
所以我直接去浏览器打开这个URL，发现真的龟速啊！
机智的我直接用迅雷下好了，但是不知道这个包怎么用呀，里面除了包含编译好的php一整套，还有别的，我也不知是干嘛的和该怎么用，不行，不能自己覆盖，想看一下python脚本都执行了些什么，自己手动操作吧，但是打开python代码文件的之后，跑来跑去，给绕晕了。
最终，我选择在它下载这个更新文件的时候，替换成直接使用我本地下好的文件。（不得不说，我还是挺会想办法的）

```
def __fetchIndividual(self, url):
        try:
            print "downloading %s" % url
            filename, headers = urllib.urlretrieve(url)
            print "filename: %s" % filename
            self.__filename = filename
            self.__file = tarfile.open(self.__filename, 'r')
            self.__file.errorlevel = 2
            return True
        except IOError:
            return False
        except tarfile.ReadError:
            return False
```
果断修改成：

```
def __fetchIndividual(self, url):
        try:
            print "downloading %s" % url
            # 修改开始
            if url.find('5.6-10.10-frontenddev-5.6.29-20170114-210819.tar.bz2'):
                filename = "/usr/local/packager/tmp/5.6-10.10-frontenddev-5.6.29-20170114-210819.tar.bz2"
            else:
                filename, headers = urllib.urlretrieve(url)
            print "filename: %s" % filename
            # 修改结束
            self.__filename = filename
            self.__file = tarfile.open(self.__filename, 'r')
            self.__file.errorlevel = 2
            return True
        except IOError:
            return False
        except tarfile.ReadError:
            return False
```
那一串字符其实就是要下载的文件的名字，这样他就不会去网上下载了直接用本地的。
好！ 然后自己手动执行这个python脚本
```
sudo /usr/local/packager/packager.py install 5.6-10.10-frontenddev
```
没毛病，自己乖乖的执行完了。。。
最终：/usr/local/php5/bin/php -v
输出：
PHP 5.6.29 (cli) (built: Jan 14 2017 21:05:20) 
Copyright (c) 1997-2016 The PHP Group
Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies
    with Zend OPcache v7.0.6-dev, Copyright (c) 1999-2016, by Zend Technologies
    with Xdebug v2.2.5, Copyright (c) 2002-2014, by Derick Rethans
没毛病！

感谢[https://php-osx.liip.ch/](https://php-osx.liip.ch/)提供的一切！

参考：
[【简书】- mac下更新自带的PHP版本到5.6或7.0](http://www.jianshu.com/p/0456dd3cc78b)