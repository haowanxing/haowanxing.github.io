---
title: 弹出层－表单填写js实现
id: 48
categories:
  - JS分享
date: 2014-07-20 15:17:38
tags:
---

[点击打开效果](http://zhanzhang.fandouzi.com/wp-content/uploads/2014/07/12233.html)
<pre lang="java" line="1" escaped="true">
&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;
&lt;html xmlns="http://www.w3.org/1999/xhtml"&gt;
&lt;head&gt;
&lt;meta http-equiv="Content-Type" content="text/html; charset=GB2312" /&gt;
&lt;title&gt;弹出提示&lt;/title&gt;
&lt;style&gt;
* {margin:0;padding:0;font-size:12px;}
html,body {height:100%;width:100%;}
#content {background:#f8f8f8;padding:30px;height:100%;}
#content a {font-size:30px;color:#369;font-weight:700;}
#alert {border:1px solid #369;width:300px;height:150px;background:#e2ecf5;z-index:1000;position:absolute;display:none;}
#alert h4 {height:20px;background:#369;color:#fff;padding:5px 0 0 5px;}
#alert h4 span {float:left;}
#alert h4 span#close {margin-left:210px;font-weight:500;cursor:pointer;}
#alert p {padding:12px 0 0 30px;}
#alert p input {width:120px;margin-left:20px;}
#alert p input.myinp {border:1px solid #ccc;height:16px;}
#alert p input.sub {width:60px;margin-left:30px;}
&lt;/style&gt;

&lt;/head&gt;

&lt;body&gt;
&lt;div id="content"&gt;
&lt;a href="#"&gt;注册&lt;/a&gt;
&lt;/div&gt;
&lt;div id="alert"&gt;
&lt;h4&gt;&lt;span&gt;现在注册&lt;/span&gt;&lt;span id="close"&gt;关闭&lt;/span&gt;&lt;/h4&gt;
&lt;p&gt;&lt;label&gt;用户名&lt;/label&gt;&lt;input type="text" class="myinp" onmouseover="this.style.border='1px solid #f60'" onfoucs="this.style.border='1px solid #f60'" onblur="this.style.border='1px solid #ccc'" /&gt;&lt;/p&gt;
&lt;p&gt;&lt;label&gt;密　码&lt;/label&gt;&lt;input type="password" class="myinp" onmouseover="this.style.border='1px solid #f60'" onfoucs="this.style.border='1px solid #f60'" onblur="this.style.border='1px solid #ccc'" /&gt;&lt;/p&gt;
&lt;p&gt;&lt;input type="submit" value="注册" class="sub" /&gt;&lt;input type="reset" value="重置" class="sub" /&gt;&lt;/p&gt;
&lt;/div&gt;
&lt;script type="text/javascript"&gt;
var myAlert = document.getElementById("alert");
var reg = document.getElementById("content").getElementsByTagName("a")[0];
var mClose = document.getElementById("close");
reg.onclick = function()
{
myAlert.style.display = "block";
myAlert.style.position = "absolute";
myAlert.style.top = "50%";
myAlert.style.left = "50%";
myAlert.style.marginTop = "-75px";
myAlert.style.marginLeft = "-150px";

mybg = document.createElement("div");
mybg.setAttribute("id","mybg");
mybg.style.background = "#000";
mybg.style.width = "100%";
mybg.style.height = "100%";
mybg.style.position = "absolute";
mybg.style.top = "0";
mybg.style.left = "0";
mybg.style.zIndex = "500";
mybg.style.opacity = "0.3";
mybg.style.filter = "Alpha(opacity=30)";
document.body.appendChild(mybg);

document.body.style.overflow = "hidden";
}

mClose.onclick = function()
{
myAlert.style.display = "none";
mybg.style.display = "none";
}
&lt;/script&gt;
&lt;/body&gt;
&lt;/html&gt;</pre>