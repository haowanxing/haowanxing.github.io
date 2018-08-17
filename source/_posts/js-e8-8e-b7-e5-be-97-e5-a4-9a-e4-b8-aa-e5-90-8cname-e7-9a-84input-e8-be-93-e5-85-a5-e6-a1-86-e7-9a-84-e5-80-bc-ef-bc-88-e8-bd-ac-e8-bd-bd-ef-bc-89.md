---
title: js 获得多个同name 的input输入框的值 （转载）
id: 68
categories:
  - JS分享
abbrlink: e38058a2
date: 2014-08-19 16:08:11
tags:
---

js 获得多个同name 的input输入框的值

起初是使用document.all.id.length获得输入框的个数，但时而正常，时而显示undefined，效果不是很好，网上信息说document.all不是兼容所有浏览器的,现在似乎是只支持IE。

解决方法是如下：
<pre lang="java" line="1" escaped="true">
var els =document.getElementsByName("search");
for (var i = 0, j = els.length; i &lt; j; i++){
alert(els[i].value);
}</pre>