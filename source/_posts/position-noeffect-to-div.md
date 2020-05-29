---
title: 做侧边菜单之弹出二级菜单-position定位不影响其他DIV
id: 83
categories:
  - 学习笔记
abbrlink: 276126bb
date: 2014-09-24 19:48:19
tags:
 - HTML
---

![二级展现菜单](https://i.loli.net/2017/08/01/5980843667be0.png)
常常使用position用于层的绝对定位，比如我们让一个层位于一个层内具体什么位置，为即可使用position:absolute和position:relative实现。

position:absolute；position:relative绝对定位使用通常是父级定义position:relative定位，子级定义position:absolute绝对定位属性，并且子级使用left或right和top或bottom进行绝对定位。

例子：
首先是JS实现二级菜单的展现

```
<script language="javascript">
    function tab(tag, className, isDisplay) {
        var list = document.getElementsByTagName(tag);
        for (var i = 0,
        len = list.length; i < len; i++) {
            if (list[i].className == className) {
                if (isDisplay == 1) {
                    list[i].style.display = "block"
                } else {
                    list[i].style.display = "none"
                }
            }
        }
    }
</script>
</pre>
页面代码：
<pre lang="html" line="1" escaped="true">
<div style="float:left; position:relative">

##学校
<span class="bianh">
<a herf="#">[切换]</a></span>
<div style="position:absolute; left:40px;" onmousemove="tab('div','selectschool',1)" onclick="tab('div','selectschool',2)">
<a herf="#">中南民族大学</a>
<a herf="#">XXXX大学</a>
    </div>
</div>
```