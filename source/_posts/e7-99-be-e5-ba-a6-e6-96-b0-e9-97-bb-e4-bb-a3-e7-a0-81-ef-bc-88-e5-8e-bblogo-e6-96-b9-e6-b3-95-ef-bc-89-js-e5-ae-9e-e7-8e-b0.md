---
title: 百度新闻代码（去LOGO方法）- JS实现
id: 98
categories:
  - JavaScript
date: 2014-09-26 18:35:11
tags:
---

获取代码请到：http://news.baidu.com/newscode.html 按自己的需要获取
<pre lang="html" line="1" escaped="true">
//展现新闻的DIV框架
<div id="news">
<!-- @百度新闻代码 start! -->
    <style type=text/css>
        div{font-size:12px;font-family:arial}.baidu{font-size:12px;line-height:20px;font-family:arial}
        a,a:link{color:#00bbbb;} .baidu span{color:#6f6f6f;font-size:12px} a.more{color:#008000;}a.blk{color:#000;font-weight:bold;}
    </style>
    <script language="JavaScript" type="text/JavaScript" src="http://news.baidu.com/n?cmd=1&class=socianews&pn=1&tn=newsbrofcu">
    </script>
<!-- @百度新闻代码 end! -->
</div>
</pre>

[![QQ20140926-10](http:///wp-content/uploads/2014/09/QQ20140926-10-300x249.png)](http:///wp-content/uploads/2014/09/QQ20140926-10.png)

这样不做修改的代码展现出来是带有百度新闻LOGO的，有时候我们不想这个LOGO出来，所以这里来教你们怎么去掉这个LOGO！
在页面中加入JS函数：
<pre lang="java" line="1" escaped="true">
<script type="text/javascript">
    //函数定义（DIV框架ID，第i个子DIV框架）
    function removebdlogo(obj, i) {
        a = document.getElementById(obj).getElementsByTagName("div");   //获取LOGO的DIV节点
        a[i].style.display = "none";   //将其设置为隐藏
        return false;
    }
</script>
</pre>
然后我们在id="news"的DIV框架外面执行这个函数：
<pre lang="java" line="1" escaped="true">
<!-- id='news'框架下面的第0个DIV框架 -->
<script type="text/javascript" >removebdlogo("news",0);</script>
</pre>
这样我们展现出来的效果就好多了！
[![QQ20140926-11](http://zhanzhang.fandouzi.com/wp-content/uploads/2014/09/QQ20140926-11-300x225.png)](http://zhanzhang.fandouzi.com/wp-content/uploads/2014/09/QQ20140926-11.png)

当然，我们也可以通过修改STYLE来改变一些元素属性，比如字体大小、颜色等等