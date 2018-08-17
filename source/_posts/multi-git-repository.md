---
title: 【干货】本地git对应多个远程仓库
tags: git
categories: 干货
abbrlink: ab967d99
date: 2017-07-24 10:18:41
---

> 当Githuber发现GitOSChina能发布项目演示，想把自己的项目也同步到OSChina上去时，同时维护两个本地仓库或者remote显得太过麻烦

## 提要

　　首先，为本地git仓库添加远程仓库，我们使用命令：`git remote add origin [url]`，这样一来，本地仓库就对应有了一个远程仓库的地址，包括`push`和`fetch`源，如下图所示：

![remote-v](https://i.loli.net/2017/07/24/59755adb887fd.png)

　　但是，我们如何才能做到既能将本地git仓库`PUSH`到Github，也能够`PUSH`到OSChina上呢？

　　可能有以下方式是你想到的：

1. 本地创建两个仓库，一一对应（你不嫌麻烦的话的确可行）
2. 添加多个远程库，即`git remote add [another-origin]`(那每次都要`PUSH`两次咯？)

　　其实，git的一个远程库本来就可以配置成多个地址，即一个origin拥有多个url。

## 敲黑板了（实现）

　　前提条件是，我们已经为本地仓库添加了一个origin远程库（没有添加的自行添加，方法前面说了）。我们现在为本地库继续添加url地址：`https://git.oschina.net/anthony_box/hitools.git`

　　这个命令是：`git remote set-url --add origin [url]`（url替换成如上地址）

![set-url](https://i.loli.net/2017/07/24/59755ea083267.png)

## 擦黑板了（原理）

　　其实该条命令执行就是在git项目的config文件里的`[remote "origin"]`配置新增一条记录，我们打开config文件看看，输入`git config -e`（文件路径:[repo]/.git/config）：

![config-e](https://i.loli.net/2017/07/24/59755fe85b743.png)

　　所以说，执行`git remote set-url -add origin`和编辑`config文件`，一码子事。