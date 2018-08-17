---
title: The Problems When Python2.6 to 2.7 on CentOS6.5
tags: '-Python2.7'
categories: '-Python'
abbrlink: 91af55e9
date: 2017-04-24 16:41:20
---

>当Python从2.6升级到2.7后，pip找不到了？

　　对的，基本上都能遇到这个问题。我很暴力的直接去下载一个pip然后用Python去安装它。

```
python setup.py install
```

　　却被告知`ImportError: No module named setuptools`，想通过yum直接给安装，却出现下图所示：
![](https://ooo.0o0.ooo/2017/04/24/58fdbbdb473ae.png)

　　没办法，去下载一个setuptools的包自己来装吧(我试过了下载setuptools-35.0.1.zip，这个不适用)。所以下面的这个亲测有效：

```
wget https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg  --no-check-certificate
sh setuptools-0.6c11-py2.7.egg
```

<!--more-->

　　如果你也遇到了下图：(什么都别说，执行一下`yum -y install zlib*`，然后按步骤来)
![](https://ooo.0o0.ooo/2017/04/24/58fdbd50a8e9e.png)
　　但是，如果你发现还是一样：请重新编译安装Python，在这之前，修改一下Modules/Setup.dist文件，去掉`#zlib zlibmodule.c -I$(prefix)/include -L$(exec_prefix)/lib -lz`的注释。

　　重新编译安装完之后再`sh setuptools-0.6c11-py2.7.egg`就没问题了。
![](https://ooo.0o0.ooo/2017/04/24/58fdbe8d0cccd.png)

　　然后进入pip目录完成pip的安装`python setup.py install`

![](https://ooo.0o0.ooo/2017/04/24/58fdbf027c303.png)

搞定了。整个解题思路还是根据报错，一个一个的去检查和解决。

参考:[zipimport.ZipImportError: can't decompress data; zlib not available 解决办法](http://www.cnblogs.com/zhangym/p/6226435.html)