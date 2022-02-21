---
title: 利用js在dedecms标签内插入图片
id: 19
categories: 学习笔记
abbrlink: 44c8ea86
date: 2014-07-04 20:24:38
tags:
---

加入javascript函数代码：
> &lt;script&gt;
> 
> function gettempletsurl(string){
> 
> document.write("&lt;img src=\"{dede:global.cfg_basehost/｝{dede:global.cfg_templets_skin/}/"+string+"\" /&gt;");
> 
> }
> 
> &lt;/script&gt;
在需要插入图片的地方插入一下代码：
> &lt;script&gt;
> 
> gettempletsurl("images/right-arrow.jpg");    //引号内写默认模版下的图片路径
> 
> &lt;/script&gt;
&nbsp;
这种利用javascript插入图片的方法完美解决了在dedecms中标签嵌套无法插入图片的问题！