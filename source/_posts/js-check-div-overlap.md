---
title: js判断两个块元素的相交与否
tags:
  - Javascript
id: 378
categories:
  - Web
abbrlink: fc8b3868
date: 2016-05-05 12:27:51
---

之前在做阿里笔试的时候，其中就有那么一个题，要求你用js写一个函数，用来判断两个Div是否相交，当时在那个上面并没有很快的写出来，结果时间到了。回头好好又想想，还是把他写一下，就算是最笨的方法，也得实现。
<!--more-->
提醒，这里讨论的都没有考虑到浏览器的兼容性差异，对于盒子模型不同的需要注意改写代码。

## 1、笨拙的边界判定法

首先，我先写一个简单的html页面，里面有两个div块，如下代码
```html
<!DOCTYPE html>
<!--suppress ALL -->
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>测试Div重叠实验</title>
  <style>
    body {
      margin: 0;
      padding: 0;
    }
    div {
      opacity: 0.8;
    }
    #div1 {
      position: relative;
      top: 50px;
      left: 200px;
      width: 100px;
      height: 150px;
      background-color: #0A87DD;
    }
    #div2 {
      position: relative;
      top:30px;
      left: 100px;
      width:350px;
      height:200px;
      background-color: #00A000;
    }
  </style>
</head>
<body>
<div id="div1"></div>
<div id="div2"></div>
</body>
</html>
```

### 效果如下：

[![divtest](../uploads/2016/05/divtest-300x272.png)](http://www.dshui.wang/2016-05-05/js-check-div-overlap.html/divtest)
<!--more-->

### 思路：

要判定两个元素是否重叠，一种笨拙的方法就是，获取到元素的4个边界的位置或者说坐标距离（上、下、左、右），然后对其进行判断。假设第一个块为Div1，第二个是Div2，用len(1,2)数组保存边界距离，如：
```javascript
    var len1 = new Array(),len2 = new Array();
    len1[0] = div1.offsetLeft;  //左边界
    len1[1] = div1.offsetTop;   //上边界
    len1[2] = div1.offsetWidth+len1[0];   //右边界
    len1[3] = div1.offsetHeight+len1[1];  //下边界

    len2[0] = div2.offsetLeft;
    len2[1] = div2.offsetTop;
    len2[2] = div2.offsetWidth+len2[0];
    len2[3] = div2.offsetHeight+len2[1];
```

然后对其进行判断，原则是：一个元素的左(右)边界在另一个元素的左右边界之间且它的上(下)边界在另一个元素的上下边界之间。那么写成代码的形式就是：
```javascript
if(( (len1[0]>=len2[0] && len1[0]<=len2[2]) || (len1[2]>=len2[0] && len1[2]<=len2[2]) ) && ( (len1[1]>=len2[1] && len1[3]<=len2[3]) || (len1[3]>=len2[1] && len1[3]<=len2[3]) )){
      alert('重叠');
    }
```
通过测试发现，这样的做法只能满足第一个元素至少有一个角(顶点)在第二个元素内，如果将两个元素的命名变量一替换，则不满足条件了。不过暂时性的解决办法还是有的，我们声明一个函数：
```
function check(div1,div2){
    var len1 = new Array(),len2 = new Array();
    len1[0] = div1.offsetLeft;  //左边界
    len1[1] = div1.offsetTop;   //上边界
    len1[2] = div1.offsetWidth+len1[0];   //右边界
    len1[3] = div1.offsetHeight+len1[1];  //下边界
    len2[0] = div2.offsetLeft;
    len2[1] = div2.offsetTop;
    len2[2] = div2.offsetWidth+len2[0];
    len2[3] = div2.offsetHeight+len2[1];
    if(((len1[0]>=len2[0]&&len1[0]<=len2[2])||(len1[2]>=len2[0]&&len1[2]<=len2[2]))&&((len1[1]>=len2[1]&&len1[3]<=len2[3])||(len1[3]>=len2[1]&&len1[3]<=len2[3]))){
      return true;
    }else{
      return false;
    }
  }
```

### 那么真正的判定就应该是：

```java
  if(check(div1,div2) || check(div2,div1)){
    alert("元素有重叠");
  }else{
    alert("元素没有重叠");
  }
```

这样就保证了，只要有满足任意一个元素的一个顶点(角)在另一个元素的内部，则两元素是相交（有重合）的。
    当然，这只是最笨拙的方法了！

## 2、元素中心判定法

应该是小学的时候就学过的几何问题吧？像正方形、长方形、圆，都可以通过中心点来判定在一个平面上的相交与否，当然，圆和圆跟另外两个类似，但是圆跟方形却不能用相同的方法，因为万一圆和方形的角相切呢？
    下面我们还是来文字解释一下吧：

### 1.获取元素中心点坐标

    学习几何数学的时候，都是告诉你各个点坐标，然后求各种数据，如：
已知一个方形的四个顶点坐标分别为(0,0) (0,4) (4,0) (4,4)，那么这个方形长4宽4，中心点为( (4-0)/2 , (4-0)/2 ) => (2,2)。 扯一下小知识，自己也复习一下。
    在用JavaScript获取元素的中心点，其实更简单，元素的左偏移(上偏移)+元素的宽(高)的一半，就是元素中心点的横坐标(纵坐标)。

### 2.相交(交集)判定

    两个元素的中心坐标的横(纵)坐标之差小于两元素的宽度(长度)之和的一半<一半再求和也是一样吼>，横纵坐标值都满足的话，则元素是相交的。(注意：差取绝对值!)

### 3.代码实现

```javascript
  var div1 = document.getElementById('div1');
  var div2 = document.getElementById('div2');
  function check2(div1,div2){
    //说明数组结构：Array(宽,高,x坐标,y坐标)
    var cPos1 = new Array(div1.offsetWidth,div1.offsetHeight,div1.offsetLeft+div1.offsetWidth/2,div1.offsetTop+div1.offsetHeight/2);
    var cPos2 = new Array(div2.offsetWidth,div2.offsetHeight,div2.offsetLeft+div2.offsetWidth/2,div2.offsetTop+div2.offsetHeight/2);
    if( Math.abs(cPos1[2]-cPos2[2]) < (cPos1[0]+cPos2[0])/2 && Math.abs(cPos1[3]-cPos2[3]) < (cPos1[1]+cPos2[1])/2 ){
      alert("有重叠部分");
    }else{
      alert("无重叠部分");
    }
  }
  check2(div1,div2);
```

我相信肯定有比这个更好的算法，如果你恰巧知道，在下面留言评论区告诉我吧!