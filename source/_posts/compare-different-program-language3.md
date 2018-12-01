---
title: 不同语言下文件读取和排序测试
tags:
  - 测试
  - 性能
  - Go
  - PHP
abbrlink: 9739d7d7
date: 2018-08-22 14:32:38
categories:
---

![排序时间对比图](http://qiniu.0x4f5da2.cn/20180822153492641115673.png)

测试机器配置：

* MacBook Air (13-inch, Early 2014)
* 处理器：1.4 GHz Intel Core i5
* 内存：4 GB 1600 MHz DDR3

<!---more--->

## PHP
```
PHP 7.1.16 (cli) (built: Mar 31 2018 02:59:59) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies
```

```PHP
<?php
$t1 = microtime(true);  

$fileName = "Data.txt";
if(($file=fopen($fileName,'r')) === false){
	echo '读取文件:'.$fileName."失败\n";
	exit;
}
if(empty($file)){
	echo "文件为空!\n";
	exit;
}
$data = array();
while(!feof($file)){
	$lineStr = fgets($file);
	array_push($data, trim($lineStr));
}
$t2 = microtime(true);
echo 'Read time:' . ($t2 - $t1)*1000 . "ms\n";  
BubbleSort($data);
var_dump($data);
fclose($file);

$t3 = microtime(true);
  
echo 'Sort time:' . ($t3 - $t2)*1000 . "ms\n";  
echo 'Finished time:' . ($t3 - $t1)*1000 . "ms\n";  

function BubbleSort(&$data){
	$len = count($data);
	for($i=0;$i<$len;$i++){
		$flag = 0;
		for($j=1;$j<($len-$i);$j++){
			if($data[$j]<$data[$j-1]) {
				$tmp = $data[$j];
				$data[$j] = $data[$j-1];
				$data[$j-1] = $tmp;
				$flag = 1;
			}
		}
		if($flag == 0){
			return;
		}
	}
}
?>
```

测试结果：

```bash
~/Sites/languageDiff/sort » php sort.php
Read time:20.021915435791ms
Sort time:219256.12616539ms
Finished time:219276.14808083ms
-------------------------------------------------------
~/Sites/languageDiff/sort » php sort.php
Read time:19.091129302979ms
Sort time:229677.68502235ms
Finished time:229696.77615166ms
-------------------------------------------------------
~/Sites/languageDiff/sort » php sort.php
Read time:21.70205116272ms
Sort time:228220.97086906ms
Finished time:228242.67292023ms
-------------------------------------------------------
~/Sites/languageDiff/sort » php sort.php
Read time:20.930051803589ms
Sort time:206329.57100868ms
Finished time:206350.50106049ms
-------------------------------------------------------
~/Sites/languageDiff/sort » php sort.php
Read time:18.213033676147ms
Sort time:201813.07411194ms
Finished time:201831.28714561ms
```

## Java
```
java version "10.0.1" 2018-04-17
Java(TM) SE Runtime Environment 18.3 (build 10.0.1+10)
Java HotSpot(TM) 64-Bit Server VM 18.3 (build 10.0.1+10, mixed mode)
```

```Java
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class sort {

	public static void main(String[] args) {
		try {
        	long t1 = System.currentTimeMillis();
        	int[] data = new int[50000];
            BufferedReader br = new BufferedReader(new FileReader("Data.txt"));

            String line = null;
            int index = 0;
            while ((line = br.readLine()) != null) {
            	data[index] = Integer.parseInt(line);
                index++;
            }
            if (br != null) {
                br.close();
            }
	        long t2 = System.currentTimeMillis();
	        System.out.println("Read time: " + String.valueOf(t2 - t1) + "ms");

	        BubbleSort(data);
	        long t3 = System.currentTimeMillis();
	        System.out.println("Sort time: " + String.valueOf(t3 - t2) + "ms");
	        System.out.println("Finished time: " + String.valueOf(t3 - t1) + "ms");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

	public static void BubbleSort(int[] a) {
	    int j, flag;
	    int temp;
	    for (int i = 0; i < a.length; i++) {
	        flag = 0;
	        for (j = 1; j < a.length - i; j++) {
	            if (a[j] < a[j-1]) {
	                temp = a[j];
	                a[j] = a[j - 1];
	                a[j - 1] = temp;
	                flag = 1;
	            }
	        }
	        if (flag == 0) {
	            return;
	        }
	    }
	}
}
```

测试结果：

```bash
~/Sites/languageDiff/sort » java sort
Read time: 56ms
Sort time: 5286ms
Finished time: 5342ms
-------------------------------------------------------
~/Sites/languageDiff/sort » java sort
Read time: 47ms
Sort time: 4911ms
Finished time: 4958ms
-------------------------------------------------------
~/Sites/languageDiff/sort » java sort
Read time: 46ms
Sort time: 4903ms
Finished time: 4949ms
-------------------------------------------------------
~/Sites/languageDiff/sort » java sort
Read time: 47ms
Sort time: 4953ms
Finished time: 5000ms
-------------------------------------------------------
~/Sites/languageDiff/sort » java sort
Read time: 49ms
Sort time: 5335ms
Finished time: 5384ms
```

## Go
```
go version go1.10.3 darwin/amd64
```

```Go
package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"time"
)

func main() {
	fileName := "Data.txt"
	data := make([]int, 0, 50000)
	start := time.Now()
	fi, err := os.Open(fileName)
	if err != nil {
		fmt.Printf("Error: %s\n", err)
		return
	}
	defer fi.Close()
	br := bufio.NewReader(fi)
	for {
		a, _, c := br.ReadLine()
		if c == io.EOF {
			break
		}
		num, _ := strconv.Atoi(string(a))
		data = append(data, num)
	}
	endReadTime := time.Now()
	fmt.Printf("Read time: %fs\n", endReadTime.Sub(start).Seconds())
	BubbleSort(data)
	endTime := time.Now()
	fmt.Printf("Sort time: %fs\n", endTime.Sub(endReadTime).Seconds())
	fmt.Printf("finished time: %fs\n", endTime.Sub(start).Seconds())
}

func BubbleSort(arr []int) {
	length := len(arr)
	var flag int
	var tmp int
	for i := 0; i < length; i++ {
		flag = 0
		for j := 1; j < (length - i); j++ {
			if arr[j] < arr[j-1] {
				tmp = arr[j]
				arr[j] = arr[j-1]
				arr[j-1] = tmp
				flag = 1
			}
		}
		if flag == 0 {
			return
		}
	}
}
```
测试结果：

```bash
~/Sites/languageDiff/sort » go build sort.go
~/Sites/languageDiff/sort » ./sort
Read time: 0.006603s
Sort time: 5.207361s
finished time: 5.213964s
-------------------------------------------------------
~/Sites/languageDiff/sort » ./sort
Read time: 0.005319s
Sort time: 5.167615s
finished time: 5.172934s
-------------------------------------------------------
~/Sites/languageDiff/sort » ./sort
Read time: 0.005648s
Sort time: 5.317512s
finished time: 5.323160s
-------------------------------------------------------
~/Sites/languageDiff/sort » ./sort
Read time: 0.005842s
Sort time: 5.267731s
finished time: 5.273573s
-------------------------------------------------------
~/Sites/languageDiff/sort » ./sort
Read time: 0.005585s
Sort time: 5.442154s
finished time: 5.447738s
```

## JavaScript(NodeJS)

```
~/Sites » node -v
v9.11.1
```

```Javascript
var t1 = (new Date()).getTime();  
var readline = require('readline');
var fs = require('fs');
var os = require('os');
 
var fReadName = './data.txt';
var fRead = fs.createReadStream(fReadName);
 
 
var objReadline = readline.createInterface({
	input: fRead,
});
 
 
var data = [];
objReadline.on('line', (line)=>{
	data.push(Number(line));
});
 
objReadline.on('close', ()=>{
	var t2 = (new Date()).getTime();  
    console.log("Read time：" + (t2 - t1) + "ms"); 
	var res = BubbleSort(data);
	// console.log(res);
	var t3 = (new Date()).getTime();  
    console.log("Sort time：" + (t3 - t2) + "ms");  
    console.log("finished time：" + (t3 - t1) + "ms");  
});

function BubbleSort(arr){
	for (var i = 0; i < arr.length; i++) {
		var flag = 0;
		for(var j = 1;j< arr.length-i;j++){
			if(arr[j]<arr[j-1]){
				var tmp = arr[j];
				arr[j] = arr[j-1]
				arr[j-1] = tmp
				flag = 1;
			}
		}
		if(flag == 0){
			return arr;
		}
	}
	return arr;
}
```

测试结果：

```bash
~/Sites/languageDiff/sort » node sort.js
Read time：55ms
Sort time：6067ms
finished time：6122ms
-------------------------------------------------------
~/Sites/languageDiff/sort » node sort.js
Read time：38ms
Sort time：6064ms
finished time：6102ms
-------------------------------------------------------
~/Sites/languageDiff/sort » node sort.js
Read time：37ms
Sort time：6339ms
finished time：6376ms
-------------------------------------------------------
~/Sites/languageDiff/sort » node sort.js
Read time：42ms
Sort time：6367ms
finished time：6409ms
-------------------------------------------------------
~/Sites/languageDiff/sort » node sort.js
Read time：40ms
Sort time：7110ms
finished time：7150ms
```

## Python
```
~/Sites » python -V
Python 2.7.10
```

```Python
import time
 
def BubbleSort(a):
	length = len(a)
	for i in range(0,length):
		flag = 0
		for j in range(1,length-i):
			if a[j] < a[j-1]:
				tmp = a[j]
				a[j] = a[j-1]
				a[j-1] = tmp
				flag = 1
		if flag == 0:
			return a
 
 
t1 = time.time()
fileName = "Data.txt"
data = []
for line in open(fileName):
	data.append(int(line.strip()))
t2 = time.time()
print 'Read time: %.02fs' % (t2 - t1)
res = BubbleSort(data)
t3 = time.time()
print 'Sort time: %.02fs' % (t3 - t2)
print 'finished time: %.02fs' % (t3 - t1)
```
测试结果：

```bash
-------------------------------------------------------
~/Sites/languageDiff/sort » python sort.py
Read time: 0.05s
Sort time: 282.76s
finished time: 282.82s
-------------------------------------------------------
~/Sites/languageDiff/sort » python sort.py
Read time: 0.07s
Sort time: 263.54s
finished time: 263.61s
-------------------------------------------------------
~/Sites/languageDiff/sort » python sort.py
Read time: 0.06s
Sort time: 346.26s
finished time: 346.32s
-------------------------------------------------------
~/Sites/languageDiff/sort » python sort.py
Read time: 0.06s
Sort time: 298.12s
finished time: 298.18s
-------------------------------------------------------
~/Sites/languageDiff/sort » python sort.py
Read time: 0.06s
Sort time: 251.43s
finished time: 251.49s
```

目前这几种编程语言看来，排序如下：IO时长,排序时长,总时长


1. Java	平均 0.0490s	5.078s	5.127s
2. Go		平均 0.0058s	5.281s	5.286s
3. NodeJs	平均 0.0424s	6.389s	6.432s
4. PHP		平均 0.0200s	217.059s	217.079s
5. Python	平均 0.0600s	288.422s	288.484s

Ps: 如果你希望看到自己喜欢的语言也排进来，欢迎提供代码！