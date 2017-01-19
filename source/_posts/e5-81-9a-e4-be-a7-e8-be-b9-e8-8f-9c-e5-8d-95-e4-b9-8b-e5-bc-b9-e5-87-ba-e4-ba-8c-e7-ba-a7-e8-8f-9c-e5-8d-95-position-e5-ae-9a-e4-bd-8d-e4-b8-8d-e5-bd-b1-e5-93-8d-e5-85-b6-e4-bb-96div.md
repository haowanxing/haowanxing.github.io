---
title: 做侧边菜单之弹出二级菜单-position定位不影响其他DIV
id: 83
categories:
  - JavaScript
date: 2014-09-24 19:48:19
tags:
---

[![二级展现菜单](/wp-content/uploads/2014/09/QQ20140924-1.png)](/wp-content/uploads/2014/09/QQ20140924-1.png)
常常使用position用于层的绝对定位，比如我们让一个层位于一个层内具体什么位置，为即可使用position:absolute和position:relative实现。

position:absolute；position:relative绝对定位使用通常是父级定义position:relative定位，子级定义position:absolute绝对定位属性，并且子级使用left或right和top或bottom进行绝对定位。

例子：
首先是JS实现二级菜单的展现
<pre lang="java" line="1" escaped="true">
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

## 
        学校

        <span class="bianh">
            [
                [切换]
            ](#)
        </span>

    <div style="position:absolute; left:40px;" onmousemove="tab('div','selectschool',1)"
    onclick="tab('div','selectschool',2)">

*   [
                    中南民族大学
                ](#)
*   [
                    XXXX大学
                ](#)
    </div>
</div>
</pre>