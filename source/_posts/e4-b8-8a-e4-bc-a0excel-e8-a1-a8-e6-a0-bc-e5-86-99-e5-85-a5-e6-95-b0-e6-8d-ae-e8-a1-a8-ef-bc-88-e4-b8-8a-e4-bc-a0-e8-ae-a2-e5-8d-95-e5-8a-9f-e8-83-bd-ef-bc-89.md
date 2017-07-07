---
title: 上传Excel表格写入数据表（上传订单功能）
id: 104
categories:
  - 我的分享
date: 2014-10-22 13:08:51
tags:
---

代码包：[ExcelToMysql](http://zhanzhang.fandouzi.com/?attachment_id=105)
此项功能的实现依赖PHPExcelReader，下载压缩包可得。
下面贴出PHP主要实现代码：

```
<form id="form1" name="form1" method="post" action="">
  <label>
  <input name="file" type="file" id="file13"/>
  <input type="submit" name="Submit" value="提交" />
  </label>
</form>
<p>
<?php
require_once 'reader.php';  
$Reader = new Spreadsheet_Excel_Reader(); 
$Reader->setOutputEncoding('gbk');
$conn= mysql_connect('localhost','root','root') or die("Can not connect to database.");  
mysql_query("set names 'gbk'");//设置编码输出
mysql_select_db('my_db'); //选择数据库
if($_POST['Submit'])
{
$Reader->read($_POST['file']);

for ($i = 2; $i <= $Reader->sheets[0]['numRows']; $i++) {
	//将EXCEL里面从第二行开始写入数据表'my_table'中
  $sql = "INSERT INTO my_table VALUES (null,'".$Reader->sheets[0]['cells'][$i][1]."','".$Reader->sheets[0]['cells'][$i][2]."','".$Reader->sheets[0]['cells'][$i][3]."','".$Reader->sheets[0]['cells'][$i][4]."','".$Reader->sheets[0]['cells'][$i][5]."','".$Reader->sheets[0]['cells'][$i][6]."','".$Reader->sheets[0]['cells'][$i][7]."','".$Reader->sheets[0]['cells'][$i][8]."','".$Reader->sheets[0]['cells'][$i][9]."')"; 

  $query=mysql_query($sql);
  if($query)
    {
     echo "<script type=\"text/javascript\"><!--
alert('数据已经提交成功');window.top.location='a.php'
// --></script>";
     }else{
     echo "<script type=\"text/javascript\"><!--
alert('数据已经提交失败');window.top.location='a.php'
// --></script>";
     }
}
}
?>

```