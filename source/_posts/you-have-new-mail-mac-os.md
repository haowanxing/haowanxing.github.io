---
title: You have new mail - Mac OS
tags:
  - MacOS
  - Email
  - Terminal
  - 终端
id: 475
categories: 学习笔记
abbrlink: 413689f
date: 2016-08-31 15:49:10
---

奇了怪了，莫名其妙！平时打开终端都没怎么注意，今天发现打开终端的时候，除了常规的上次登录提示，居然有一句“You have new mail”紧接着在下面出现了。
平时都不用自带的邮件.app的 打开邮件，却没有啥。
好的，本着好奇的心理，开始摸索。
<!--more-->

要知道，在Linux下是有mail命令的，试着在Mac下输入看看有没有：
我试着输入一下 mail -help
<pre lang="bash">Last login: Wed Aug 31 15:28:02 on ttys002
You have mail.
Anthony-MacBook-Air:~ anthony$ mail -help
mail: illegal option -- h
Usage: mail [-EiInv] [-s subject] [-c cc-addr] [-b bcc-addr] [-F] to-addr ...
       mail [-EHiInNv] [-F] -f [name]
       mail [-EHiInNv] [-F] [-u user]
       mail -e [-f name]
       mail -H
Anthony-MacBook-Air:~ anthony$ 
</pre>
没有-h这个参数，但是出现了英文的帮助，没啥用嘛！大致看起来就是收发邮件的咯？
直接输入mail看看：
<pre lang="bash">Anthony-MacBook-Air:~ anthony$ mail
Mail version 8.1 6/6/93\.  Type ? for help.
"/var/mail/anthony": 2 messages 2 unread
&gt;U  1 MAILER-DAEMON@Anthon  Sun Aug 21 18:16  74/2642  "Undelivered Mail Retu"
 U  2 MAILER-DAEMON@Anthon  Sun Aug 21 18:17  76/2662  "Undelivered Mail Retu"
? 
</pre>
**成了交互模式了，那我就顺势回车按下去，看看有啥结果：**
<pre lang="bash">Message 1:
From MAILER-DAEMON  Sun Aug 21 18:16:31 2016
X-Original-To: anthony@Anthony-MacBook-Air.local
Delivered-To: anthony@Anthony-MacBook-Air.local
Date: Sun, 21 Aug 2016 18:16:31 +0800 (CST)
From: MAILER-DAEMON@Anthony-MacBook-Air.local (Mail Delivery System)
Subject: Undelivered Mail Returned to Sender
To: anthony@Anthony-MacBook-Air.local
Auto-Submitted: auto-replied
MIME-Version: 1.0
Content-Type: multipart/report; report-type=delivery-status;
        boundary="714DB172D2C6.1471774591/Anthony-MacBook-Air.local"

This is a MIME-encapsulated message.

--714DB172D2C6.1471774591/Anthony-MacBook-Air.local
Content-Description: Notification
Content-Type: text/plain; charset=us-ascii

This is the mail system at host Anthony-MacBook-Air.local.

I'm sorry to have to inform you that your message could not
be delivered to one or more recipients. It's attached below.
:
</pre>
“邮件退回” ？ 开什么玩笑！继续还是交互模式！！ 继续回车一直把上面的信息看完，我发现，的确不是系统自己抽风搞这样一出戏的。
那2封邮件都看了，是我之前在写一个有关于站点通知发送Email给我的PHP脚本时的测试邮件。
当时第一次在本地测试的时候没有填写SMTP服务器，脚本肯定是默认调用本地的服务器，但是我本地没有，所以造成了邮件发送失败的提醒。这个不会在系统内的邮件.app提示也就说的通了，因为这个属于系统内核的通知，也就自然只有在终端才会有通知表现了。
既然不是什么系统Bug，那自然也就不需要我去担心了。读完这2个信息，在重新打开终端就不会出现这样的提示了！
[an]哈哈[/an]