---
title: 删除Mac中所有 .DS_Store 隐藏文件&不再产生.DS_Store文件
id: 74
categories:
  - 我的分享
date: 2014-09-22 18:10:26
tags:
---

![120031avxwmscar1wg6w1z](https://i.loli.net/2017/08/01/5980839a7e05a.png)Mac OS X系统下，几乎绝大部分文件夹中都包含 .DS_Store 隐藏文件，这里保存着针对这个目录的特殊信息和设置配置，例如查看方式，图标大小以及这个目录的一些附属元数据。

在Mac下这些 .DS_Store 文件默认是隐藏的，看不见。不过当将文件转移共享到Windows的时候，那么就是可见的了，并且感觉像是一些垃圾文件一样的存在。

操作方法摘自**Macx.cn** 和 **onmac.net **

**
1.删除系统中所有的.DS_Store文件：**
(a)、Spotlight搜索“终端”，打开[终端]程序
(b)、输入如下代码并回车：
sudo find / -name ".DS_Store" -depth -exec rm {} \;
等待个1分钟左右，删除就完成了！

**
2.不让系统生成.DS_Store文件：**
(a)、打开[终端]程序
(b)、输入以下代码并回车：(提示需要输入密码就输入 电脑密码)
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
(c)、sudo cp Library/Preferences/com.apple.desktopservices.plist /Library/Preferences/
(d)、sudo chmod 777 /Library/Preferences/com.apple.desktopservices.plist
(e)、重新启动计算机。

参考资料：
http://forum.onmac.net/archive/index.php/t-334.html
http://www.macx.cn/thread-2053938-1-1.html