---
title: php上传进度之uploadprogress
date: 2017-02-07 11:29:13
tags:
	- php上传进度
categories:
	- PHP
---

> 我的学习是项目驱动，这次遇到的需求是上传进度条。

通过查PHP手册，了解到PHP版本5.4+有一个新特性`uploadprogress`，也可以说是新扩展吧！

```
当 session.upload_progress.enabled INI 选项开启时，PHP 能够在每一个文件上传时监测上传进度。 这个信息对上传请求自身并没有什么帮助，但在文件上传时应用可以发送一个POST请求到终端（例如通过XHR）来检查这个状态
当一个上传在处理中，同时POST一个与INI中设置的session.upload_progress.name同名变量时，上传进度可以在$_SESSION中获得。 当PHP检测到这种POST请求时，它会在$_SESSION中添加一组数据, 索引是 session.upload_progress.prefix 与 session.upload_progress.name连接在一起的值。
```

将这个扩展启用，需要开启PHP.INI支持：

	session.upload_progress.enabled = On
	session.upload_progress.cleanup = On
	session.upload_progress.prefix = "upload_progress_"
	session.upload_progress.name = "PHP_SESSION_UPLOAD_PROGRESS"
	session.upload_progress.freq = "1%"
	session.upload_progress.min_freq = "1"

当然，我按照官方的示例操作了N久，就是读不到此类session的值。一开始以为是公司框架的问题，后来自己在本地单独写文件来测试，结果还是一样！

在网上查找各种此类问题的解决办法，虽说有相同提问的，但是解答问题的人根本就没找到根本的原因。其实很简单：`上传的文件Size太小`

<!--more-->

如果在本地测试，上传文件就相当于复制粘贴一个文件到磁盘的另一个地方，一般来说小于50M就是秒传了，因为我这里是SSD硬盘，所以会更快。所以本次测试一定要选一个大一点文件来进行，起码100M是要的。

好的，大文件上传也是要注意的，因为PHP默认限制的`upload_max_filesize`为2M，`post_max_size`为8M；所以尽可能设置大一点，我测试文件200M左右，就给这两项都设置为300M。

然后就是写测试程序了，代码就不贴了，讲讲思路：

* 测试页：
 - 创建表单，添加`session.upload_progress.prefix`字段，value=KEY的值；
 - 添加file域；
 - 提交表单，并带上`KEY`对上传进度接口进行轮询，直到进度达100%。
* 处理文件上传部分：
 - 主要是接收上传文件，然后将$_FILE中的文件保存到本地文件；
* 获得上传进度部分：
 - 需要打开session支持`session_start()`，然后通过`ini_get("session.upload_progress.prefix")`和`KEY`获取$_SEESION，在通过`bytes_processed`和`content_length`的比值x100%获取传输进度；