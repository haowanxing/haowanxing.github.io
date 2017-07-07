---
title: 实现寻找两个字符串的最大公子串的方法
tags:
  - php
  - 子串
id: 552
categories:
  - PHP
date: 2016-10-27 15:32:50
---

昨天在做某兔的校招笔试题的时候遇到的题目，就这一个编程题，然而当时却没有拿下，把它和字符串匹配中的子串包含给弄混了，哎！
废话少说，上代码！

```
<?php
function MaxSubCommonStr($str1,$str2){
    $a = str_split($str1);	//字符串分割成数组
    $b = str_split($str2);
    $len1 = strlen($str1);	//字符串的长度
    $len2 = strlen($str2);
    $maxlen = 0;	//最大计数器
    for($i=0;$i<$len1;$i++){
        for($j=0;$j<$len2;$j++){
            if($a[$i] == $b[$j]){	//找到第一个相等的字符
                $as = $i;	//拷贝字符串1的起点
                $bs = $j;	//拷贝字符串2的起点
                $count = 1;	//有一个相等的字符了
                while ($as + 1 < $len1 && $bs + 1 < $len2 && $a[++$as] == $b[++$bs])
                    $count++;	//往后比较，每匹配一个计数+1，直到其中一个查完或者出现不相等
                if($count > $maxlen){	//当本次计数长度大于最大记录时
                    $maxlen = $count;	//更新最大计数长度
                    $start1 = $i;		//更新本次比较的字符串1起点
                    $start2 = $j;		//更新本次比较的字符串2起点
                }
            }
        }
    }    
    return substr($str1,$start1,$maxlen);	//直接返回字符串1，从$start1起点往后$maxlen最大匹配长度个数的子串
}

$str1 = 'abcdefgabc';
$str2 = 'defghijabc';
echo MaxSubCommonStr($str1,$str2);
?>
```
没什么含金量，只是写出来练练手，思路照搬过来的。