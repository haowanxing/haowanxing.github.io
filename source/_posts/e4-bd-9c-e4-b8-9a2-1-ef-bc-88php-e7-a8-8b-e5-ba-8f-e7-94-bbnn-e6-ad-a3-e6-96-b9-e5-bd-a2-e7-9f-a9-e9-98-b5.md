---
title: 作业2-1（PHP程序画n*n正方形矩阵)
id: 146
categories:
  - PHP
  - 学习笔记
date: 2015-05-07 22:36:51
tags:
---

[![作业2-1要求](/wp-content/uploads/2015/05/QQ20150507-4@2x-300x210.png)](/wp-content/uploads/2015/05/QQ20150507-4@2x.png)
[展示页面：http://www.dshui.wang/html/work1.php](/html/work1.php)
可以在地址后面加参数哟！
如：http://www.dshui.wang/html/work1.php?colnum=7 试试看吧！最大31
<pre lang="php" line="1" escaped="true">
<?php
#Designed By Anthony_Box
#Date: 2015-05-07
#201321092028 OF SCUEC
$colnum = $_GET['colnum']?$_GET['colnum']:5;
if($colnum>31){
	$colnum = 5;
}
echo "<table border='1px' bordercolor='yellow'>\n\t<tr>\n";
for($i=0;$i<$colnum*$colnum;$i++){
	if(!($i%$colnum)){
		echo "\n\t</tr>\n\t<tr>\n";
	}
	if($i%2){
		echo "\t\t<td style='text-align: center;'>";
	}else{
		echo "\t\t<td style='background-color: red;text-align: center;'>";
	}
	echo $i+1;
	echo "</td>";
}
echo "\n\t</tr></table>";
?>
</pre>