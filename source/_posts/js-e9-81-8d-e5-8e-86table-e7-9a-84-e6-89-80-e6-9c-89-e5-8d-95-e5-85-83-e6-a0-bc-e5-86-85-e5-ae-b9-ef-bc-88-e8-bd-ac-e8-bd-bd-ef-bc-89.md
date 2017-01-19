---
title: JS遍历Table的所有单元格内容 （转载）
id: 70
categories:
  - JS分享
date: 2014-08-19 16:48:06
tags:
---

<pre lang="java" line="1" escaped="true">
function GetInfoFromTable(tableid) {
var tableInfo = "";
var tableObj = document.getElementById(tableid);
for (var i = 0; i &lt; tableObj.rows.length; i++) {    //遍历Table的所有Row
for (var j = 0; j &lt; tableObj.rows[i].cells.length; j++) {   //遍历Row中的每一列
tableInfo += tableObj.rows[i].cells[j].innerText;   //获取Table中单元格的内容
tableInfo += "   ";
}
tableInfo += "\n";
}
return tableInfo;
}</pre>