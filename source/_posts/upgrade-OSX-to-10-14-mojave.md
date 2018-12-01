---
title: 更新升级MacOSX到10.14 Mojave (MacBook Air 13-inch early 2014)
tags: Mac
abbrlink: 106d7501
date: 2018-10-24 15:13:17
categories:
---

### 写在前面的话：

如果不是真的很需要，其实最好是不去更新系统，以免带来更多的麻烦。如果新的系统对你真的很重要，我也建议你备份现有数据，然后全新安装新的系统版本。我就是那个单纯的升级系统，导致原有的软件无法正常运行的傻逼，下面虽然记录了我的问题，但我最终的解决方案还是把软件卸载后重新安装和配置。


> 既然App Store推送了本次更新，我也就傻傻的更新了，谁知道会发生什么呢？

<!---more--->

很不开心的是，第二天上班来发现系统更新好了，直接登录！一切安好。然鹅！！！发现了好几个惊喜：

1. svn和git命令无法执行，提示`xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun`
2. Apache和PHP配置全部恢复成初始状态，所有已安装的扩展没了
3. OSSRS(Simple-RTMP-Server)无法运行了，提示:`illegal hardware instruction`，目前没找到解决方案，提了[Issue](https://github.com/ossrs/srs/issues/1250)看怎么说。

解决第一个问题网上给了答案，安装XCode开发者工具就好了：
`xcode-select --install`

Apache和PHP的配置的恢复，主要是指httpd.conf的覆盖和php.ini的丢失，以及PHP扩展丢失，这样我就不得不重新编写配置文件和编译安装开发所需要的全部扩展了。

这里记录一下我的操作过程，因为之前更新系统也遇到这种问题，但是没有做笔记，导致现在又遇到问题时又花了很多时间去找资料。

### 安装Memcache扩展
从Github直接clone下来：[https://github.com/websupport-sk/pecl-memcache](https://github.com/websupport-sk/pecl-memcache)

执行`phpize`出现问题：

```bash
grep: /usr/include/php/main/php.h: No such file or directory
grep: /usr/include/php/Zend/zend_modules.h: No such file or directory
grep: /usr/include/php/Zend/zend_extensions.h: No such file or directory
Configuring for:
PHP Api Version:        
Zend Module Api No:     
Zend Extension Api No: 
```

百度出来的解决方案：

```
sudo ln -s /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include/ /usr/include
```

好的，遇到了就算使用`sudo`还是提示权限不足的情况。 不怕，之前有经验，需要关掉系统的保护机制。操作方法就是重启电脑，按住`command+R`直到进入新界面，通过实用工具打开终端，输入`csrutil disable`关闭保护，然后`reboot`重启

重启完打开终端，傻傻的执行ln命令后发现还是不行！phpize依旧报错， 怪我有点笨，然后才去读这行命令的意思，发现MacOSX10.11.sdk这个目录不存在，只有一个MacOSX10.14.sdk的目录。很傻，根据自己的系统来嘛！

所以下面的完整命令解决`phpize`的问题

```
sudo ln -s /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk/usr/include/ /usr/include
```

然后是`./configure` 接着`make && sudo make install`

执行完后再修改`/etc/php.ini`增加extension=memcache.so。然后重启apache:sudo apachectl -k restart

### 安装mcrypt扩展

这个我是直接去php官网下载系统当前版本的PHP源码（php-7.1.19.tar.gz），然后解压进入ext/mcrypt目录，如上所述的执行`phpize`和`./configure`以及`make && sudo make install`，修改php.ini增加extension=mcrypt.so。重启apache搞定。

### 重启打开安全策略csrutil enable

电脑重启后发现memcache和mcrypt扩展无法加载，提示了文件签名的问题。无解！ 

__所以，重点强调！！！ 直接舍弃系统自带的PHP和Apache吧，用brew全新安装一个，管理起来也非常的方便，系统更新后也不会导致软件丢失！__

不过，遇到了新的问题，brew在安装cmake的时候出现了错误，提示如下：

```
Error: You are using macOS 10.14.
We do not provide support for this pre-release version.
You may encounter build failures or other breakages.
Please create pull-requests instead of filing issues.
```

很明显，说当前系统版本时预发布版本，他们不支持，不支持！！？？

百度了，无解，无奈就去问了Google，然后说要去下载Command Line Tools (macOS 10.14) for Xcode 10，原文：[https://intellij-support.jetbrains.com/hc/en-us/community/posts/360000898980-CMake-not-compiling-after-macOS-10-14-Mojave-update](https://intellij-support.jetbrains.com/hc/en-us/community/posts/360000898980-CMake-not-compiling-after-macOS-10-14-Mojave-update)



#### 写在最后

官宣，作为一个需要稳定开发环境的开发人员和开发机器来说，不是闲的蛋疼就别随便的更新系统了吧，一个上午就折腾这事儿去了，真是满脸的不愉快，晚上8点还在重装软件，今儿可是1024啊，过节啊！！