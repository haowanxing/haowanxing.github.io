---
title: 作业4-1（简易留言板）
id: 161
categories: 学习笔记
abbrlink: aee0563f
date: 2015-05-09 12:58:47
tags:
---

[![作业4-1（简易留言板）](/uploads/2015/05/QQ20150509-2@2x-273x300.png)](/uploads/2015/05/QQ20150509-2@2x.png)
[演示页面：http://www.dshui.wang/html/board1.php](/html/board1.php)
首先我们得建立一个数据表用来存放留言信息：（由于之前作业有建立数据库'XSGL'，我们就直接用这个数据库啦）

```
CREATE TABLE `msg` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `content` varchar(254) NOT NULL DEFAULT '',
  `username` char(10) DEFAULT '',
  `stime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```
建立一个mysql的连接文件： mysqlconfig.php

```
<?php
error_reporting(0);
header ( "Content-type:text/html;charset=utf-8" );
$dbhost = 'localhost';
$dbname = 'XSGL';
$user = 'root';
$pwd = '1234';
$conn = mysql_connect($dbhost,$user,$pwd) or die ( "could not connect mysql" );
mysql_select_db ( $dbname, $conn ) or die ( "could not open database" );
mysql_query ( "set names utf8;" );
?>
```
新建一个留言本程序：board1.php

```
<?php
include './mysqlconfig.php';
if($_POST['issubmit']!=null){
	$content = $_POST['content'];
	$sql = "insert into msg(content) values ('".$content."');";
	$res = mysql_query($sql);
	header ( "refresh:0;url=" );
}
$sql = "select * from msg order by id desc;";
$result = mysql_query($sql);
?>
```
```
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>简易留言板</title>
</head>

<body bgcolor="#56FF00">
	<div style="margin:0 auto;width:400px;">
        <div class="form">
            <form method="post">
            <textarea name="content" cols="45" rows="5" style="width: 400px; height: 88px;"></textarea>

            <div align="right"><input type="submit" name="issubmit" value="留言" />&nbsp;</div>
            </form>
        </div>
        <div class="msg">
        	<table border="1" bordercolor="#FFFFFF">
        	<?php while ($rows = mysql_fetch_assoc($result)){?>
            	<tr>
                	<td><span class="datetime">（<?php echo $rows['stime'];?>）</span>
<span class="content"><?php echo $rows['content'];?></span></td>
                </tr>
            <?php }?>
            </table>
        </div>
	</div>
</body>
</html>

```