---
title: Laravel5.5 发送邮件遇到Connection could not be established with host xxxxx
tags: Laravel
abbrlink: ac505287
date: 2018-02-11 15:08:38
categories:
---

Laravel输出的错误页面如下图：
![Laravel异常捕获-mail](http://ojrm4585k.bkt.clouddn.com/20180211151833306552899.png)

服务器：阿里云香港节点（B区） CentOS6.8 64bit

lamp环境：PHP7.2.1

Laravel .env mail部分：
```bash
MAIL_DRIVER=smtp
MAIL_HOST=hwsmtp.exmail.qq.com
MAIL_PORT=465
MAIL_USERNAME=noreply@0x4f5da2.cn
MAIL_PASSWORD=XXXXXXXX
MAIL_FROM_ADDRESS=noreply@0x4f5da2.cn
MAIL_FROM_NAME=noreply
MAIL_ENCRYPTION=ssl
```

问题发生前景：本地测试完全正常，相同配置在服务器上就被抛出异常。

因为之前遇到过由于端口没有放行而造成无法建立连接的问题，在此问题上我也做了一样的尝试，在安全组配置里面对465端口进行放行（无论是出口还是入口）。但是结果表示并不是这个问题，而我在没有配置放行的情况下，telnet host:port 是通的。

经过大约两天的间接性排查和尝试，最终提交工单咨询阿里，他们给了我处理意见：尝试他们的Demo！

尝试[阿里云提供的Demo](https://help.aliyun.com/knowledge_detail/60692.html)测试发件是没有问题的，这就令我很纳闷的，于是我去看该Demo是如何建立连接的。

通过一步一步的探索，发现该Demo也是同样使用了`stream_socket_client`方法来建立连接，那为什么它可以，Laravel内的却不行？说明不是该环境的问题！

问题逐渐定位到了`stream_socket_client`这个方法上，查询[PHP.NET](http://php.net/manual/zh/function.stream-socket-client.php)来认识一下它。

```php
resource stream_socket_client ( string $remote_socket [, int &$errno [, string &$errstr [, float $timeout = ini_get("default_socket_timeout") [, int $flags = STREAM_CLIENT_CONNECT [, resource $context ]]]]] )
```

方法描述上，只有一个参数可能会不一样，就是最后那个$context，它是一个Resource，由`stream_conntext_create`方法创建并返回。

我注意到Laravel中使用的Swift_Mailer所引用的StreamBuffer类中，在`stream_socket_client`方法前面加上了`@`符号来屏蔽error，而在下面自己判断来抛出异常。

那么我果断将`@`符号去掉！ 真正的错误爆出来了！！！！

```bash
stream_socket_enable_crypto(): SSL operation failed with code 1. OpenSSL Error messages:
error:14090086:SSL routines:ssl3_get_server_certificate:certificate verify failed
```

乍眼一看，证书校验失败？？？？

### 上面的废话只是简单描述我遇到这个问题是如何应对的

解决方案来了！ 既然是走SSL协议(465端口)，且程序抛出错误为证书校验失败，那么就去直接搜索有关Laravel/SwitEmailer的证书校验问题。

在stackOverflow上找到两个相关的问题：

1. [localhost and “stream_socket_enable_crypto(): SSL operation failed with code 1”
](https://stackoverflow.com/questions/44423096/localhost-and-stream-socket-enable-crypto-ssl-operation-failed-with-code-1)
2. [how to fix stream_socket_enable_crypto(): SSL operation failed with code 1](https://stackoverflow.com/questions/30556773/how-to-fix-stream-socket-enable-crypto-ssl-operation-failed-with-code-1)

他们都提出了一个配置：

```php
//	在/config/mail.php中增加

'stream' => [
	'ssl' => [
	    'allow_self_signed' => true,
	    'verify_peer' => false,
	    'verify_peer_name' => false,
	],
],
```

然后测试，Bingo！！！


当然，既然是SSL必然使用校验才是最安全的，但是我这里仅满足能够发件即可，至于如何进行证书校验，请移步：[使用PHPMailer 中的报错解决 "Connection failed. Error #2: stream_socket_client(): SSL operation failed with code 1. OpenSSL Error messages:"](https://www.cnblogs.com/wpjamer/p/7421304.html)