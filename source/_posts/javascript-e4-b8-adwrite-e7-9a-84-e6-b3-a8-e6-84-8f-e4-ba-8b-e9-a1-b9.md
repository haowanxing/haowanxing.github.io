---
title: Javascript中write的注意事项
id: 39
categories:
  - Linxu分享
date: 2014-07-07 10:08:15
tags:
---

在网页的学习中，需要利用js向页面写入文字，此时需要用到document.write();

但是，使用这个方法的时候需要注意，如果在页面都加载完成后调用这个方法，将会导致之前的内容全被它给覆盖重写。

例如：
> &lt;html&gt;> 
> &lt;head&gt;> 
> 
> &lt;script type="text/javascript"&gt;> 
> function myfunction(txt)> 
> {> 
> document.write(txt);> 
> }> 
> &lt;/script&gt;> 
> 
> &lt;/head&gt;> 
> &lt;body&gt;> 
> 
> &lt;form&gt;> 
> &lt;input type="button" onclick="myfunction('哎呀！我赢了！你们都不见啦，哈哈！')" value="点我试试！"&gt;> 
> &lt;/form&gt;> 
> 
> &lt;p&gt;通过点击这个按钮，可以调用一个函数。该函数会输出传递给它的参数。 此时所有内容被重写！&lt;/p&gt;> 
> 
> &lt;/body&gt;> 
> &lt;/html&gt;
<div id="xunlei_com_thunder_helper_plugin_d462f475-c18e-46be-bd10-327458d045bd"></div>