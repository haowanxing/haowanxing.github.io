---
title: 引用符号'&'在foreach循环中的惊喜
tags: PHP
abbrlink: 5f047c20
date: 2019-06-21 14:51:27
categories: PHP
---

> 工作中总会遇到一些奇奇怪怪的由前人所写下的不可置疑的代码，如果你仅仅跟着眼前所见的代码去理解他人的思路，Well You have fell into a terrible situation.

贴一段示例代码：

```PHP
<?php
$students = [
    ['name'=>'Jackson','age'=>15],
    ['name'=>'Jerry','age'=>14],
    ['name'=>'Amy','age'=>14]
];
$classes = [
    'CL001'=>['name'=>'Language','classTime'=>30],
    'CL002'=>['name'=>'PE','classTime'=>13]
];

/* 
 * 循环$students,为其添加一个属性'name-age'
 * 这里使用了&$v以获得数组内部元素的引用，使的可以在循环体内修改元素内容
 */
foreach ($students as $k=>&$v){
    $v['name-age'] = $v['name'] . '-' .$v['age'];
}

$classString = '';	//定义一个空串
/*
 * 循环$classes,将所有课程ID和名称联结成串
 */
foreach ($classes as $k=>$v){
    $classString .= 'ClassID:'.$k.'-'.$v['name'].PHP_EOL;
}
echo $classString;
var_dump($students);	//Think here!
```

你也许会回答这样一个输出结果：

<!--more-->

```
ClassID:CL001-Language
ClassID:CL002-PE
array(3) {
  [0]=>
  array(3) {
    ["name"]=>
    string(7) "Jackson"
    ["age"]=>
    int(15)
    ["name-age"]=>
    string(10) "Jackson-15"
  }
  [1]=>
  array(3) {
    ["name"]=>
    string(5) "Jerry"
    ["age"]=>
    int(14)
    ["name-age"]=>
    string(8) "Jerry-14"
  }
  [2]=>
  array(3) {
    ["name"]=>
    string(3) "Amy"
    ["age"]=>
    int(14)
    ["name-age"]=>
    string(6) "Amy-14"
  }
}
```

也许会有不少人会使用foreach+引用符号'&'来遍历更新数组内容，这样也的确可行。但是！这里就惊现了这样一个巨坑，为何在循环`$classes`之后，`$students`变得面目全非？来看看实际输出结果：

```
ClassID:CL001-Language
ClassID:CL002-PE
array(3) {
  [0]=>
  array(3) {
    ["name"]=>
    string(7) "Jackson"
    ["age"]=>
    int(15)
    ["name-age"]=>
    string(10) "Jackson-15"
  }
  [1]=>
  array(3) {
    ["name"]=>
    string(5) "Jerry"
    ["age"]=>
    int(14)
    ["name-age"]=>
    string(8) "Jerry-14"
  }
  [2]=>
  &array(2) {
    ["name"]=>
    string(2) "PE"
    ["classTime"]=>
    int(13)
  }
}
```

发现了吧，最后一项为什么是`$classes`的元素？而且是其最后一项？聪明的你现在应该在开始思考'&'符号了！

两次foreach循环我们都用了`$k`和`$v`来代替键和值，但在`&`符号作用在`$v`上的时候，这个`$v`实际是每次循环的元素地址。而在第二个foreach中使用的`$v`实际上已经是一个存在的引用（指向上一个数组的最后一次访问的元素），在对他进行赋值修改时，就会导致与其实际指向的数据发生修改，因为他们就是逻辑上的“相同内存”。

我所举例的代码比较容易发现问题，其实我实际遇到的问题却糟糕的多，因为第二次循环是为了给第一次循环的内容进行填补，所以元素结构是一模一样的，这样出现的现象就是同一个元素在数组中出现了两次，其中原数组的最后一个元素指向第二次循环的数组的最后一个。

这里举例的是当`&`符号用在`=>`后面的值变量，如果用在`=>`前面的键变量呢？？？

实在可怕！ 还好我喜欢用array_walk来代替此类做法。