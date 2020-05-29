---
title: 神奇的空格符
tags: 
abbrlink: ece045fd
date: 2017-07-20 10:25:44
categories: 学习笔记
---

> 　　当我通过表单提交带空格的数据并保存到数据库，然后通过再次渲染出的页面修改该数据，意想不到的事情发生了，再也不同通过这个值检索到这条数据了。

　　首先，我们先写一个PHP的测试文件：

```
<?php
if(isset($_POST['model'])){
	echo $_POST['model'];
	echo "<br>";
	echo str_replace(' ','&nbsp;',$_POST['model']);
	echo "<br>";
	echo urlencode($_POST['model']);
}
?>
<form method='post'>
<input name='model' value='' />
<button type='submit'>ttttt</button>
</form>
```

　　可以看到，这里面有个表单，提交到自己这个页面，然后由PHP获取到POST过来的参数`model`，第一行直接输出它的值，第二行输出防SQL注入对空格的转化后的值，第三行输出encode之后的值（为什么？我们最后说TA的用途^_^）。

　　我们现在试着输入并提交`Sumsang S8`：

![结果1](https://i.loli.net/2017/07/20/597048232aaf5.png)

　　由此可见，后台获取到的是一个`Sumsang`+`空格`+`S8`，第二行跟上面一样（显示一样，源码不一样），第三行空格变成加号是urlencode后的转义，那么看下源码：

![源码1](https://i.loli.net/2017/07/20/5970485c97308.png)

　　当然，很多情况下，为了防止SQL注入，我们会将`空格`转化成`&nbsp;`存库，然后取数据的时候在逆回来。

***

　　紧接着，我们模拟数据的修改，基本过程是：从数据库取出这条数据-->填充到input标签的value属性中（没有做逆处理）-->渲染页面，渲染的页面源码如下：
　　
<!--more-->

```
<html>
 <head>
 </head>
 <body>
  <form method="post">
   <input name="model" value="Sumsang&nbsp;S8">
   <button type="submit">ttttt</button>
  </form>
 </body>
</html>
```

　　看到源码中的value是有`&nbsp;`的，那么界面显示是这样的：
　　
![界面1](https://i.loli.net/2017/07/20/597042d9d7965.png)

　　这样的情况，跟之前输入的`Sumsang S8`看似没有什么不同，但是如果我们直接提交这个默认值，看看后台接收到的是什么结果：

![结果2](https://i.loli.net/2017/07/20/5970495899096.png)

　　第一、二行输出效果跟原先一样，是一个`Sumsang`+`空格`+`S8`，但是第二行出现了`Sumsang`+`%C2%A0`+`S8`，我们再来看一下渲染出来的源码：

![源码2](https://i.loli.net/2017/07/20/597049a229f2b.png)

　　其实第一、二行的输出是`Sumsang`+`&nbsp;`+`S8`，在网页中显示`&nbsp;`就是一个空格，但是，这真的是源码嘛？ 我点击显示网页源码看看究竟：

![源码3](https://i.loli.net/2017/07/20/597049f469ae9.png)

　　第一行和第二行都是`Sumsang`+`空格`+`S8`，你会发现，第二行的`空格`应该被替换成`&nbsp;`，而这里却没有被替换。 现在知道为什么我们要在第三行输出一个urlencode后的值了吧？

　　两次提交的时，输入框里面显示的看起来是同一个东西，其实他们不一样呢！通过urlencode就能很明显的看出来了。那么，这样的不一样会造成什么后果呢？

　　亲身经历啊！不是没事瞎折腾。 第二次存库时，存进去的不是`Sumsang&nbsp;S8`，而是`Sumsang S8`，你会觉得没问题是吧，检索的时候搜索`Sumsang S8`不就出来了吗？ 你不信自己试试，怎么也搜索不到！！！！！查不出来这条数据了！！！！   因为此空格非彼`空格`啊！

　　想必发现这个神奇事件的人，应该不会很多。