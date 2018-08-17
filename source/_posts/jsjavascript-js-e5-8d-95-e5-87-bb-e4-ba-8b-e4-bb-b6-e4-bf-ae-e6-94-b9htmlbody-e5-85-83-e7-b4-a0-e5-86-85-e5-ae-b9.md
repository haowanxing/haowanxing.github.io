---
title: js&javascript js单击&事件修改html&body元素内容
id: 60
categories:
  - JS分享
abbrlink: 82b0582a
date: 2014-08-07 15:42:49
tags:
---

```
<script>
function myFunction()
{
document.getElementById("demo");  // 找到元素
document.getElementById("demo").innerHTML="Hello JavaScript!";    // 改变内容
}
function myFunction1()
{
x=document.getElementById("demo");  // 找到元素
x.innerHTML="JavaScript 能改变 HTML 元素的内容。";    // 改变内容
}

</script>

<button type="button" onclick="myFunction()">点击这里</button>
<button type="button" onclick="myFunction1()">点击这里</button>

```