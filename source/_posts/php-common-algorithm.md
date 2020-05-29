---
title: PHP常用算法的方法实现(冒泡、选择、插入、快排、二分查找)
tags:
  - PHP
  - 排序算法
id: 516
categories:
  - 算法
abbrlink: eecfc875
date: 2016-10-24 13:19:03
---

以前说起写算法，基本上都是拿C语言来写，因为用C可以更清楚的理解各种排序算法和数据结构。今天遍换成使用PHP语言来写几个常用的算法。
这次要写的算法包括：

*   冒泡排序
*   插入排序
*   选择排序（直接）
*   快速排序
*   二分查找

### 冒泡：

	<?php
	$arr = array(4,3,5,6,8,0,10,15,11);
	echo implode(' ',$arr);
	//冒泡排序 最坏 平均O(N^2) 最好O(N)
	function BubbleSort($arr){
		$length = count($arr);
		if($length <= 1){
			return $arr;
		}
		for($i=0;$i<$length;$i++){
			for($j=0;$j<$length-$i-1;$j++){
				if($arr[$j] > $arr[$j+1]){
					$tmp = $arr[$j];
					$arr[$j] = $arr[$j+1];
					$arr[$j+1] = $tmp;
				}
			}
		}
		return $arr;
	}
	echo "\nBubbleSort:\n";
	echo implode(' ',BubbleSort($arr))."\n";
	?>
<!--more-->

### 插入：

```
<?php
header("Content-type:text/html;charset=utf-8");
$arr = array(4,3,5,6,8,0,10,15,11);
echo implode(' ',$arr);
//插入排序  最坏情况下O(N^2)   最好情况下O(N)
function InsertSort($arr){
	$length = count($arr);
	if($length <= 1){
		return $arr;
	}
	for($i=1;$i<$length;$i++){
		$now = $arr[$i];
		$j = $i-1;
		while ($now < $arr[$j] && $j >= 0) {
			$arr[$j] = $arr[$j--];
		}
		$arr[++$j] = $now;
	}
	return $arr;
}
echo "\nInsertSort:\n";
echo implode(' ',InsertSort($arr))."\n";
```
### 直接选择：

```
<?php
header("Content-type:text/html;charset=utf-8");
$arr = array(4,3,5,6,8,0,10,15,11);
echo implode(' ',$arr);
//选择排序 最坏 最好 平均都是O(N^2)
function SelectSort($arr){
	$length = count($arr);
	if($length <= 1){
		return $arr;
	}
	for($i=0;$i<$length;$i++){
		$min = $i;
		for($j=$i+1;$j<$length;$j++){
			if($arr[$min]>$arr[$j]){
				$min = $j;
			}
		}
		if($min != $i){
			$tmp = $arr[$min];
			$arr[$min] = $arr[$i];
			$arr[$i] = $tmp;
		}
	}
	return $arr;
}
echo "\nSelectSort:\n";
echo implode(' ',SelectSort($arr))."\n";
```

### 快排:

```
<?php
header("Content-type:text/html;charset=utf-8");
$arr = array(4,3,5,6,8,0,10,15,11);
echo implode(' ',$arr);
//快速排序 最好 平均O(NlgN) 最坏O(N^2)
function QuickSort($arr){
	$length = count($arr);
	if($length <= 1){
		return $arr;
	}
	$middle = $arr[0];
	$leftArray = array();
	$rightArray = array();
	for($i=1;$i<$length;$i++){
		if($arr[$i]<$middle){
			array_push($leftArray,$arr[$i]);
			// $leftArray[] = $arr[$i];
		}else{
			array_push($rightArray,$arr[$i]);
			// $rightArray[] = $arr[$i];
		}
	}
	$leftArray = QuickSort($leftArray);
	$rightArray = QuickSort($rightArray);
	return array_merge($leftArray,array($middle),$rightArray);
}
echo "\nQuickSort:\n";
echo implode(' ',QuickSort($arr))."\n";
```
还有一个，排好序的数组，进行查找key的位置：

### 二分查找：

```
<?php
header("Content-type:text/html;charset=utf-8");
$arr = array(0,1,2,3,4,5,6,7,8,9,10);
echo implode(' ',$arr);
//二分查找  
function BinarySearch($arr,$low,$hight,$key){
	while ($low <= $hight) {
		$mid = intval(($low+$hight)/2);
		if($key == $arr[$mid]){
			return $mid;
		}else if($key < $arr[$mid]){
			$hight = $mid - 1;
		}else{
			$low = $mid + 1;
		}
	}
	return -1;
}
$key = 4;
echo "\nBinarySearch:{$key}\n";
echo BinarySearch($arr,0,count($arr)-1,$key)."\n";
```