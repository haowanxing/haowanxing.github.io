---
title: C(C++)、Java、PHP区别函数参数传递
tags:
  - C
  - Java
  - php
  - 方法
id: 369
categories:
  - 学习笔记
date: 2016-04-16 14:15:15
---

这篇文章，我专门测试了一下C、Java、PHP三种编程语言中对于函数（方法）参数传递的问题


## 一、C/C++篇

首先说明一下，这里仅在C语言下测试，C++类似，只不过在C++中多了一个传引用(&)，其性质还是指针，传递过程中可以看作是使用别名。
看代码：

```C
//
//  main.c
//  TestOfVlaue
//
//  Created by anthony on 16/4/16.
//  Copyright © 2016年 Anthony. All rights reserved.
//

#include <stdio.h>
//C语言测试
void prt1(int v) {
    printf("方法内执行后的结果：%d\n",v);
}
void prt2(int v[],short int len) {
    for (int i=0; i<len; i++) {
        printf("a[%d]:%d\n",i,v[i]);
    }
}
void ch1(int v) {   //按值传递
    ++v;
    prt1(v);
}
void ch2(int *v) {  //按地址(指针)传递
    ++(*v);
    prt1(*v);
}
//void ch3(int &v) {  //引用传递 C里面木有&（引用）C++中可用，底层还是指针
//    ++v;
//    prt1(*v);
//}
void ch4(int v[],short int len) {   //改变数组的值
    for (int i=0; i<len; i++) {
        v[i]++;
    }
}
void test1(int v) {     //测试整型变量
    printf("测试单个值：类型：int,值为：%d\n",v);
    ch1(v);
    printf("执行ch1()的结果：%d\n",v);
    ch2(&v);
    printf("执行ch2()的结果：%d\n\n",v);
}
void test2(int v[],short int len) {     //测试整型数组
    printf("测试数组：类型：int,值为：\n");
    prt2(v, len);
    ch4(v,len);
    printf("方法内执行后的结果：\n");
    prt2(v, len);
    printf("\n");
}
int main(int argc, const char * argv[]) {
    int a = 10;
    int b[] = {1,2,3};
    test1(a);       //测试变量a++
    test2(b, 3);    //测试数组b各元素++
    test1(b[0]);    //测试数组b[0]++
    return 0;
}
```
运行结果：
<!--more-->

```bash
测试单个值：类型：int,值为：10
方法内执行后的结果：11
执行ch1()的结果：10
方法内执行后的结果：11
执行ch2()的结果：11

测试数组：类型：int,值为：
a[0]:1
a[1]:2
a[2]:3
方法内执行后的结果：
a[0]:2
a[1]:3
a[2]:4

测试单个值：类型：int,值为：2
方法内执行后的结果：3
执行ch1()的结果：2
方法内执行后的结果：3
执行ch2()的结果：3

Program ended with exit code: 0

```

从结果中看，ch1(int v)中采用传值，可以理解为将a的值赋值给v，然后改变了v的值，所以函数体内v值的改变不会影响到a的值；
ch2(int *v)中采用_传指针_，实际上是传递了变量a的地址，在函数体内 (*v) 就是取地址上的值，即a变量所在内存上的值:10，执行++(*v)，实际上就是改变了a变量所在内存上的值，变成了:11，这就是真正的改变变量的值；
ch3(int &v)是_传引用_，在执行过程中，新定义了一个v变量，它指向与a变量相同的地址，v既是a。所以v的改变，即a的改变。（这里我没有执行，因为我是在c环境下测试，c中没有传引用，传引用是C++才有的。）

## 二、Java篇

一说到Java，不得不谈的就是Java的“指针”问题，在Java中，没有指针，因为Java一切皆“引用”，所以在理解上会有些与c和c++相冲突吧。不多说，先看代码：

```java
package testofvalue;

/**
 *
 * @author Anthony <york_mail@qq.com>
 */
public class TestOfValue {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        int a = 10, b[] = {1,2,3};
        A obj = new A("Hello");
        ch1(a);
        System.out.println(a);
        System.out.println("原数组:");
        prt2(b);
        ch2(b);
        System.out.println("改变后的数组:");
        prt2(b);
        ch1(b[1]);  //测试数组中的一个值  
        System.out.println("改变b[1]后的数组:"); 
        prt2(b);
        ch3(obj);
        System.out.println(obj.value);
        ch4(obj.value);        
        System.out.println(obj.value);
    }
    public static void ch1(int v) {
        ++v;
    }
    public static void ch2(int v[]) {
        System.out.println("原数组:");
        prt2(v);
        for(int i=0;i<v.length;i++){
            v[i]++;
        }
        System.out.println("改变后的数组:");
        prt2(v);
    }
    public static void ch3(A a) {
        a.value += " World!";
    }
    public static void ch4(String str) {
        str += " String!";
    }
    public static void prt2(int v[]) {
        for(int i=0;i<v.length;i++){
            System.out.println("v["+i+"]:"+v[i]);
        }
    }

}
class A {
    public String value;
    A(String value) {
        this.value = value;
    }
}

```
代码中，另外定义了一个类：A，用来测试对象的相关传递；其中我分别按照顺序测试了整型、整型数组、自定义对象的函数传递。
结果：

```bash
run:
10
原数组:
v[0]:1
v[1]:2
v[2]:3
改变后的数组:
v[0]:2
v[1]:3
v[2]:4
改变b[1]后的数组:
v[0]:2
v[1]:3
v[2]:4
Hello World!
Hello World!
```

第一个ch1(a)，没有改变a的值，所以它是一个传值。（传值调用）
第二个ch2(b)，b是一个数组_{1,2,3}_，改变后变成了_{2,3,4}_，说明ch2(b)在传递的时候，是将b的(首)地址给传入了（传引用）。
第三个ch1(b[1])，这里传入了b数组的第二个数，结果数组的值并没有变化，所以说明它还是一个传值调用。
第四个ch3(obj)，obj是A的一个对象，在函数中改变了对象的属性：value 的值，结果可以看到，obj.value的确被修改了，所以说，ch3()也就是传递的obj这个对象的引用。
第五个ch4(obj.value)，将_对象的属性值_作为参数来传递，并不能改变对象的属性值，是个_按值传递_。
注意：上面所说的传值和引用只是为了方便理解。其实JAVA都是传值，只不过在以对象作为参数的时候，这个是值是对象的一个引用，在方法内部其实是对象的另一个引用，他们指向同一个对象（存储区域），可以通过这个引用改变对象的属性，但是无法对原引用进行修改。

## 三、PHP篇

PHP是一种弱类型的语言变量的使用中不用指定类型，它会自我识别成目标类型，那么我们来看一下它在函数传递中又是怎么样的呢。
先看代码：

```php
<?php
/**
 * Created by PhpStorm.
 * User: anthony
 * Date: 16/1/20
 * Time: 上午11:46
 */
header("Content-type:text/html;charset=utf-8");
function ch1($v) {  //按值传递
  $v++;
}
function ch2(&$v) { //传引用
  $v++;
}
function ch3($ov) { //传对象的值
  $ov = " Changed! ch3";
}
function ch4($o) {  //传对象
  $o->value = " Changed! ch4";
}
function ch5($v) {  //改变数组
  for($i=0;$i<sizeof($v);$i++){
    $v[$i]++;
  }
}
function ch6(&$v) {  //改变数组 传引用
  for($i=0;$i<sizeof($v);$i++){
    $v[$i]+=10;
  }
}
$a = 10;
$arr = Array(1,2,3);
echo "\$a=".$a."
";
ch1($a);
echo "ch1():  ".$a."
";
ch2($a);
echo "ch2():  ".$a."
";
echo "创建对象:";
$obj = new A();
ch3($obj->value);
echo "ch3():  ";
echo $obj->value."
";
ch4($obj);
echo "ch4():  ";
echo $obj->value."
";
print_r($arr);
echo "
";
ch5($arr);
print_r($arr);
echo "
";
ch6($arr);
print_r($arr);
echo "
";

class A {
  public $value = "I'm A's value";
  public function __construct()
  {
    echo $this->value."
";
  }
}
```

代码的最下面我申明了一个类：A，用来测试类在函数传递中的效果。
结果：

```bash
$a=10
ch1(): 10
ch2(): 11
创建对象:I'm A's value
ch3(): I'm A's value
ch4(): Changed! ch4
Array ( [0] => 1 [1] => 2 [2] => 3 ) 
Array ( [0] => 1 [1] => 2 [2] => 3 ) 
Array ( [0] => 11 [1] => 12 [2] => 13 ) 
```

说明：
ch1($v)_按值传递_，不会造成变量的改动；
ch2(&$v)_传引用_，跟c一样，类似别名。
ch3($ov)用来测试对象的字符串属性，一开始$obj->value="I'm A's value"，执行了之后还是一样，不会改变；
ch4($o)直接传入一个$obj对象，在函数体中修改了对象的属性值value，可以看到最终$obj->value被修改成了"Changed! ch4"，说明在对象的传递中，是传递的_对象的引用_。
ch5($v)测试改变数组的值，失败了！这里跟C和Java都不一样！在数组传递过程中，它相当于Copy了一份一模一样的数组，这不会造成原数组的改变，所以如果要改变原数组的值，这就不能像C和Java那样理解和使用了。来看ch6()的使用。
ch6(&$v) 可以看到，我们加上一个_传引用_(&)符号，这样就可以达到修改数组的值的效果了。

## 总结：

通过上面三种语言的比较，我们可以看到：

1. c和c++都有_传值_和_传指针_，但c++比c多一个传引用；
2. PHP具有_传值_、_传引用_和_传指针_，例子中没使用指针，这里简单说明一下，_$b=&$a_，则$b就是$a的别名，二者就是同一个。
3. PHP中数组的调用跟C/C++和Java不一样，后者都是传入变量的首地址，相当于传引用(c中叫指针)，PHP相当于传值；
4. Java中所有基本类型都是_传值_调用，对象则是_传引用_，如果要修改对象的值，那必须以对象作为参数传递。

如果上述有何不妥或者您有任何新的想法，欢迎指正和提议！

_代码压缩包_：[归档](http://www.dshui.wang/2016-04-16/function-use-of-c-cpp-java-php.html/%e5%bd%92%e6%a1%a3) (因站点迁移，链接失效)