---
title: 作业2-2（PHP表单数据提交与接收)
id: 153
categories: 学习笔记
abbrlink: 25b754f7
date: 2015-05-07 22:44:02
tags:
---

[![作业2-2](/wp-content/uploads/2015/05/QQ20150507-5@2x-300x197.png)](/wp-content/uploads/2015/05/QQ20150507-5@2x.png)
[展示页面：http://www.dshui.wang/html/work2.php](/html/work2.php)
```
<?php
#Designed By Anthony_Box
#Date: 2015-05-07
#201321092028 OF SCUEC
?>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Second Class Work</title>
</head>
<!---
#Designed By Anthony_Box
#Date: 2015-05-07
#201321092028 OF SCUEC
--->
<body>
<?php if ($_POST['submit']){?>
姓名：<?php echo $_POST['name'];?>

兴趣：<?php echo $_POST['intrest'];?>

性别：<?php echo $_POST['sex'];?>

血型：<?php echo $_POST['blood'];?>

擅长语言：<?php echo implode(',',$_POST['lang']);?>

最擅长的操作系统：<?php echo $_POST['system'];?>

留言：<?php echo $_POST['note'];?>

<input type="submit" value="确认">
<?php }else{?>
<form method="post">
<label>姓名：<input type="text" name="name" /></label>

<label>兴趣：<input type="text" name="intrest" /></label>

<label>性别：<input type="radio" name="sex" value="男" />男 </label><label><input type="radio" name="sex" value="女"/>女</label>

<label>血型：<input type="radio" name="blood" value="A"/>A </label><label><input type="radio" name="blood" value="B"/>B </label><label><input type="radio" name="blood" value="AB"/>AB </label><label><input type="radio" name="blood" value="O"/>O</label>

请选择您擅长的一种或几种编程设计语言:

<label><input type="checkbox" name="lang[]" value="C++"/>C++ </label><label><input type="checkbox" name="lang[]" value="PHP"/>PHP </label><label><input type="checkbox" name="lang[]" value="Shell"/>Shell </label><label><input type="checkbox" name="lang[]" value="VBscript"/>VBscript</label>

请选择您最擅长的操作系统:<select name="system"><option>Linux</option><option>Windows</option><option>Unix</option></select>

如果您有什么建议，敬请留言:

<textarea name="note"></textarea>

<input type="submit" name="submit" value="提交"/> &nbsp;&nbsp;<input type="reset" value="重置"/>
</form>
</body>
</html>
<?php }?>
```