---
title: '通用笔试-PHP测试编程题[2题]'
tags:
  - 测试
  - 笔试
  - 编程
id: 488
categories:
  - PHP
date: 2016-09-02 09:53:21
---

### 水仙花数

题目描述：
`春天是鲜花的季节，水仙花就是其中最迷人的代表，数学上有个水仙花数，他是这样定义的：
“水仙花数”是指一个三位数，它的各位数字的立方和等于其本身，比如：153=1^3+5^3+3^3。
现在要求输出所有在m和n范围内的水仙花数。`

输入
`输入数据有多组，每组占一行，包括两个整数m和n（100<=m<=n<=999）。`

输出
`对于每个测试实例，要求输出所有在给定范围内的水仙花数，就是说，输出的水仙花数必须大于等于m,并且小于等于n，如果有多个，则要求从小到大排列在一行内输出，之间用一个空格隔开;
如果给定的范围内不存在水仙花数，则输出no;
每个测试实例的输出占一行。`

样例输入
`
100 120
300 380
`

样例输出
`
no
370 371
`

<pre lang="php">
<?php
echo "Please Input\n";
$in = '';
while($in != "\n"){
	$first = false;
	// $stdin = fopen("php://stdin",'r');
    // $in = fgets($stdin);
    $in = fgets(STDIN);//使用标准输入
    $args[] = explode(' ',trim($in));
}
// fclose($stdin);
array_pop($args);
foreach ($args as $item) {
	if($item[0] <100 || $item[1]>999 || $item[0]>=$item[1]) {
	  	echo "输入参数不合法！\n";
	   	exit(0);
	}
	$start = $item[0];
	$end = $item[1];
	$res = array();
	while($start <= $end){
		$a = floor($start/100);
		$b = floor(($start-$a*100)/10);
		$c = $start%10;
		if($start == ($a*$a*$a+$b*$b*$b+$c*$c*$c)){
		    $res[] = $start;
		}
		$start += 1;
	}
	echo empty($res)?"No\n":implode(' ',$res)."\n";
}
?>
</pre>

第二题：
<!--more-->

### 求数列的和

题目描述：`
数列的定义如下：
数列的第一项为n，以后各项为前一项的平方根，求数列的前m项的和。`

输入
`输入数据有多组，每组占一行，由两个整数n（n<10000）和m(m<1000)组成，n和m的含义如前所述。
`
输出
`对于每组输入数据，输出该数列的和，每个测试实例占一行，要求精度保留2位小数。`

样例输入
`
81 4
2 2`

样例输出
`
94.73
3.41`

之前为了赶火车，现在到宿舍整理好了重新写了下面的代码
<pre lang="php">
<?php
echo 'Please Input 2 Intger:';
$in = ' ';
while($in != "\n"){
	$first = false;
	$stdin = fopen("php://stdin",'r');
    $in = fgets($stdin);
    $args[] = explode(' ',trim($in));
}
fclose($stdin);
array_pop($args);
foreach($args as $item){
    $n = $item[0];
    $m = $item[1];
    if($n >=10000 || $m >= 1000){
        echo 'Input error!';
        exit(0);
    }
    $sum = 0;
  	$pre = $n;
  	while($m>=1){
        $sum += $pre;
        $pre = round(sqrt($pre),2);
        $m--;
  	}
  	echo $sum."\n";
}

?>
</pre>
整个思路很简单，所以这里的代码就[an]没有注释[/an]