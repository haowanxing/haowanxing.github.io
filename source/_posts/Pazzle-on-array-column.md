---
title: Pazzle on array_column
date: 2017-11-10 10:28:18
tags:
categories:
---

　　在PHP中内置的对数组操作的方法（函数）有一个叫做'array_column'的非常实用，它可以用作返回一个二维数组的指定列。

　　先介绍一下它！

　　好比这样一个用法：

```php
$students = array(
	array(
		'id'=>1,
		'name'=>'Jerry'
		),
	array(
		'id'=>3,
		'name'=>'Tom'
		),
	array(
		'id'=>6,
		'name'=>'Lily'
		),
	array(
		'id'=>11,
		'name'=>'Bob'
		),
	);
$student_names = array_column($students,'name');
var_dump($student_names);
```

输出结果：

```
array (size=4)
  0 => string 'Jerry' (length=5)
  1 => string 'Tom' (length=3)
  2 => string 'Lily' (length=4)
  3 => string 'Bob' (length=3)
```
　　这样就得到了一个所有名字的数组，想必对于一个PHPER来说并不陌生。但是今天要讲的重点是`array_column`的另外一个用法，如果给它第三个参数，那么它将以第三个参数对应的数组中的值作为返回数组的键，用例如下：

```php
$studentID_name = array_column($students,'name','id');
var_dump($studentID_name);
```

　　输出结果：

```
array (size=4)
  1 => string 'Jerry' (length=5)
  3 => string 'Tom' (length=3)
  6 => string 'Lily' (length=4)
  11 => string 'Bob' (length=3)
```

　　利用这样的数组，你可以直接使用id去访问此id对应的名字，`$studentID_name[3] as Tom`

　　如果student不仅仅包含id和name，假如还有其他如age,sex字段，你还想同时通过id得到这个'对象'的其他字段值，你不必定义多个类似`$studentID_age`/`$studentID_sex`的变量，只需要将`array_column`的第二个参数设置成`NULL`即可，如下：

```php
$studentID_student = array_column($students,NULL,'id');
var_dump($studentID_student);
```

　　输出结果：

```
array (size=4)
  1 => 
    array (size=2)
      'id' => int 1
      'name' => string 'Jerry' (length=5)
  3 => 
    array (size=2)
      'id' => int 3
      'name' => string 'Tom' (length=3)
  6 => 
    array (size=2)
      'id' => int 6
      'name' => string 'Lily' (length=4)
  11 => 
    array (size=2)
      'id' => int 11
      'name' => string 'Bob' (length=3)
```

　　它的介绍到这里就算完了，那么问题在哪里呢？

　　在于第三个参数！！ 第三个参数指定的值必须是整型或字符串型，如果是其它类型(如浮点型等)，则不会如你所愿，即使float(10)和int(10)看着没啥区别？

　　上栗子！

```php
$students = array(
	array(
		'id'=>1,
		'name'=>'Jerry'
		),
	array(
		'id'=>floatval(3),
		'name'=>'Tom'
		),
	array(
		'id'=>6,
		'name'=>'Lily'
		),
	array(
		'id'=>11,
		'name'=>'Bob'
		),
	array(
		'id'=>floatval(30),
		'name'=>'Sam'
		),
	);
$studentID_student = array_column($students,NULL,'id');
var_dump($studentID_student);
```

　　上面的栗子中，我将第二个数据的id换成了浮点型3，然后最后新增了一个数据，id为浮点型30。

　　理想中的结果应该是在上面介绍的结果中多了一个索引为30的Sam,嗯！我也是这样想的，但结果总是那么的’相似‘。

　　看结果：

```
array (size=5)
  1 => 
    array (size=2)
      'id' => int 1
      'name' => string 'Jerry' (length=5)
  2 => 
    array (size=2)
      'id' => float 3
      'name' => string 'Tom' (length=3)
  6 => 
    array (size=2)
      'id' => int 6
      'name' => string 'Lily' (length=4)
  11 => 
    array (size=2)
      'id' => int 11
      'name' => string 'Bob' (length=3)
  12 => 
    array (size=2)
      'id' => float 30
      'name' => string 'Sam' (length=3)
```

　　从结果中来看，数量的确是5个了，但是索引不是我想要的呀喂！！ 原因就在于id不为`int`或`string`类型的时候，该条数据在新数组的索引会被赋值为当前最大索引加1，第二条数据id=float(3)，当前最大索引为1，那么它被设置键为1+1=2，最后新加的那条id为float(30)的Sam，在它之前的索引最大是11，那么它就应当为11+1=12了。

　　其实，一般情况下，我们不会遇到像float这样的类型作为ID，自己写的自然是Int型，从数据库读取的默认是String型。然鹅～我是读Excel获得的数据，它给了我float类型，在这样的弱类型语言里面，不仔细琢磨还真不容易发现会有这样的Bug存在！！！ PHP真的是最好的语言，也最容易犯错！！

　　所以说，尽管它是弱类型语言，今后还是尽量自我约束，拿强类型规则来约束自己！