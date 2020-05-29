---
title: JS实现同时提交多个form基础方法
tags:
id: 53
categories:
  - 学习笔记
abbrlink: be0a1834
date: 2014-07-21 10:28:14
---

```javascript
<script language="javascript">
//点击提交按钮触发下面的函数
function submitit(){

//第一个表单
var tform1= document.getElementById("formid1");

//第二个表单
var tform2= document.getElementById("formid2");

//提交第一个表单
tform1.submit();

//提交第二个表单
tform2.submit();
} </script>
     表单1 
<form id="formid1" action="#" method="post" name="formed">
 <input name="tname" type="text" value="张三" />
</form>
 表单2 
<form id="formid2" action="#" method="post" name="formed">
 <input name="tname" type="text" value="李四" />
 <input type="button" value="提交" onClick="javascript:submitit();" />
</form>
```