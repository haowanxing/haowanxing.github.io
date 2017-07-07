---
title: 'Javascript:向表格添加或删除一行（转载）'
id: 62
categories:
  - JS分享
date: 2014-08-14 11:54:00
tags:
---

<pre lang="java" line="1" escaped="true">
[html](http://www.2cto.com/kf/qianduan/css/)&gt;
&lt;head&gt;
&lt;title&gt;title&lt;/title&gt;
&lt;script type="text/javascript"&gt;
function delIndex(obj) {
var rowIndex = obj.parentNode.parentNode.rowIndex;//获得行下标
alert(rowIndex);
var tb = document.getElementById("tb");
tb.deleteRow(rowIndex);//删除当前行
add(rowIndex);//在当前行插入一行
}
function add(rowIndex) {
var tb = document.getElementById("tb");
if (rowIndex == "-1") {
rowIndex = tb.rows.length;//默认在末尾插入一行
}
var row = tb.insertRow(rowIndex);//在表格的指定插入一行
var c1 = row.insertCell(0);
c1.innerHTML = "new" + rowIndex;
var c2 = row.insertCell(1);
c2.innerHTML = '&lt;a href="javascript:void(0)" onclick="delIndex(this)"&gt;删除&lt;/a&gt;';
}
&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;input type="button" value="添加一行" onclick="add('-1')" &gt;&lt;input type="button" value="删除选中项" onclick="del()" /&gt;
&lt;table id="tb"&gt;
&lt;tr&gt;&lt;td&gt;1&lt;/td&gt;&lt;td&gt;&lt;a href="javascript:void(0)" onclick="delIndex(this)"&gt;删除&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;2&lt;/td&gt;&lt;td&gt;&lt;a href="javascript:void(0)" onclick="delIndex(this)"&gt;删除&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;3&lt;/td&gt;&lt;td&gt;&lt;a href="javascript:void(0)" onclick="delIndex(this)"&gt;删除&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;4&lt;/td&gt;&lt;td&gt;&lt;a href="javascript:void(0)" onclick="delIndex(this)"&gt;删除&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;5&lt;/td&gt;&lt;td&gt;&lt;a href="javascript:void(0)" onclick="delIndex(this)"&gt;删除&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;6&lt;/td&gt;&lt;td&gt;&lt;a href="javascript:void(0)" onclick="delIndex(this)"&gt;删除&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;tr&gt;&lt;td&gt;7&lt;/td&gt;&lt;td&gt;&lt;a href="javascript:void(0)" onclick="delIndex(this)"&gt;删除&lt;/a&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;/table&gt;
&lt;/body&gt;
&lt;/html&gt;</pre>