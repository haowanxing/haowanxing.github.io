---
title: '[合集]面试中遇到的那些提问'
tags:
  - 提问
  - 面试
id: 522
categories:
  - 我的分享
date: 2016-10-24 15:37:46
---

参加了好几家公司的面试了，一直也没来得及将这些问题整理一下，今天正好不想到处跑了，所以先在这里写下这一篇文章，以后会不定期更新。

## 非技术篇：

1.  先来一个自我介绍吧（废话！ =_=!）
2.  用3个词组评价你自己
3.  说一说你一生中感到最有成就感的一件事
4.  说一说你曾经遇到过的最沮丧的一件事
5.  说说你的优缺点
6.  说说你的父母都是做什么的？
7.  你有多少个兄弟姐妹？
8.  你为什么选择来参加我们公司的招聘
9.  你对加班的看法和出差的看法，以及你对加班和出差的最大忍耐极限
10.  你觉得你在哪一方面比较优秀？
11.  别人都是怎么评价你的？
12.  在同一个Team中，当别人的意见和自己的意见冲突的时候，你会怎么办？
13.  拿一个你最熟悉的项目来讲讲，它的架构、设计、遇到的问题以及是如何解决的
14.  你对我们的开发团队有什么期望吗？
15.  最后，你有什么想要问我的？
...
<!--more-->

## 语言篇：

1.  非得让我比较：PHP和Java的区别和优缺点（PHP是面向对象+面向过程的弱类型语言，Java是纯面向对象的强类型语言）
Java:平台可移植性（平台无关性），多用于企业级开发，无论是桌面端、APP还是Web都可以使用Java进行开发；
PHP:后起之秀，融合了Java、Perl、C等语言的各种优点，在互联网领域有很高的专注度
总体相比：Java具有绝对优势，但是在Web领域，PHP完胜Java，我是一个PHPer，但也学过JavaEE，就我所知，Java的ssh三大框架配置复杂，学习和使用起来相当恶心，相比之下我觉得ThinkPHP、Yaf、Yii、Ci等框架甩Java的ssh框架两到三公里(^_^无心和Javaer打架)
2.  PHP中数组的数据结构是什么样子的？
3.  PHP中操作数组的函数你知道哪些？
4.  PHP的魔术函数（方法）你知道哪些？__get/__set什么时候，怎么调用？
5.  了解JVM吗？垃圾回收机制？
6.  JavaScript代码阅读：问输出结果
<pre lang="js">
(function(){
    var a=b=5;
})();
alert(b); //弹出框显示数字5，因为b没有var修饰，属于全局变量。
</pre>

7.  外部引用CSS，link标签和@import的区别
...

## 数据库篇：

1.  MySQL中如何实现查询结果为两个字段的组合，如[name-age]
使用CONCAT_WS()方法，如 SELECT CONCAT_WS('-',name,age) from user;
2.  MySQL数据库存储引擎有哪些以及它们的区别。
3.  你对锁机制了解吗？
4.  你所用过的NoSQL有哪些？什么情况下需要用NoSQL。
5.  豆瓣中，有演员，有电影，一个演员可能参演多部电影，一部电影由多个演员参与。
要求：
设计表结构，查询指定演员所参演的所有电影中，分数排名第二的那部电影的名称。

解答：
演员和电影之间是多对多关系，所以除了演员表和电影表，还需要一个关系表，总共3个表：
<pre lang="mysql" >
/*演员表 `douban_actors` */
CREATE TABLE `douban_actors` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `douban_actors` (`id`, `name`)
VALUES (1, '演员A'), (2, '演员B'), (3, '演员C'), (4, '演员D');

</pre>
<pre lang="mysql" >
/*电影表 `douban_movies` */
CREATE TABLE `douban_movies` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  `score` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `douban_movies` (`id`, `name`, `score`)
VALUES (1, '电影A', 2), (2, '电影B', 4),(3, '电影C', 5.3),(4, '电影D', 6.5),(5, '电影E', 4.1),(6, '电影F', 2.2),(7, '电影G', 4.4);

</pre>
<pre lang="mysql" >
/*关系表 `douban_acttomv` */
CREATE TABLE `douban_acttomv` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `aid` int(10) unsigned NOT NULL,
  `mid` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `douban_acttomv` (`id`, `aid`, `mid`)
VALUES (1, 1, 1),(2, 1, 6),(3, 1, 2),(4, 1, 4),(5, 1, 5),(6, 2, 1),(7, 2, 3),(8, 2, 4),(9, 2, 5),(10, 3, 2),(11, 3, 3),(12, 3, 5),(13, 3, 7),(14, 4, 1),(15, 4, 4),(16, 4, 6);
</pre>
查询语句：
<pre lang="mysql" >
select * from `douban_movies` m left join `douban_acttomv` t on t.mid = m.id left join `douban_actors` a on a.id = t.aid where a.name = "演员A" order by m.score desc limit 1,1;
</pre>

...

## 算法篇：

1.  各种排序算法的不同情况的时间复杂度：(图片源自网络)
![排序算法复杂度表格](http://www.dshui.wang/wp-content/uploads/2016/10/sortono.jpg)
2.  写一个二叉树的层序遍历（递归和队列的使用）
<pre lang="php" >
<?php
class BTree{
	public $_data = null;
	public $_left = null;
	public $_right = null;
	public function __construct($data){
		$this->_data = $data;
	}
}
$root = new BTree(1);
$root->_left = new BTree(2);
$root->_right = new BTree(3);
$root->_left->_left = new BTree(4);
$root->_left->_right = new BTree(5);
$root->_right->_left = new BTree(6);
$root->_right->_right = new BTree(7);

function cengxu($root,&$stack){
	echo $root->_data." ";
	if($root->_left != null){
		array_push($stack,$root->_left);
	}
	if($root->_right != null){
		array_push($stack,$root->_right);
	}
	$to = array_shift($stack);
	if($to)
		cengxu($to,$stack);
}
$arr = array();
cengxu($root,$arr);
</pre>
...

## 计算机原理篇：

1.  冯· 诺依曼体系结构中，计算机由哪几部分组成？（输入设备、输出设备、存储器、运算器、控制器）
...

## 网络与安全篇：

1.  计算机网络OSI七层模型 VS TCP/IP四层模型：
[caption id="attachment_532" align="aligncenter" width="300"]![OSI七层 VS TCP/IP四层模型](http://www.dshui.wang/wp-content/uploads/2016/10/OSI-tcpip-300x219.png) OSI七层 VS TCP/IP四层模型[/caption]

2.  TCP/IP协议簇（TCP传输控制协议、UDP用户数据包协议、IP网际协议、ICMP因特网消息控制协议、DHCP动态主机配置协议）：
TCP连接3次握手，断开4次握手；
TCP面向连接传输，UDP则相反；
TCP进行可靠传输，UDP传输不可靠，可靠手段（顺序编号、确认机制ACK、超时重传）；
3.  安全起见，数据传输中往往需要进行加密，你会怎么做？
4.  数据接口的调用，如何验证调用者的身份是否合法。
5.  微信中的接收消息与事件，可能由于网络问题会进行最多3次的重传，问：如何对消息排重
...

## Linux篇：

1.  输出当前正在执行的进程个数（ps -ef | wc -l） 考察ps、wc和管道
2.  查看Linux内核版本：uname -a、cat /proc/version
查看Linux系统版本：lsb_release -a、cat /etc/redhat-release、cat /etc/issue
3.  给你一台服务器，你如何找到它的web目录、php的配置文件。
...