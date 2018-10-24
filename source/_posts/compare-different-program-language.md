---
title: 不同语言的基本性能测试
tags:
  - 测试
  - 性能
abbrlink: 1b3229fb
date: 2018-08-10 16:56:48
categories:
---
![计算时间对比图](http://ojrm4585k.bkt.clouddn.com/20180822153492626124054.png)
测试机器配置：

* MacBook Air (13-inch, Early 2014)
* 处理器：1.4 GHz Intel Core i5
* 内存：4 GB 1600 MHz DDR3

## PHP
```
PHP 7.1.16 (cli) (built: Mar 31 2018 02:59:59) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies
```

```PHP
<?php
$t1 = microtime(true);  
  
for($i=0; $i<10000000; $i++){  
    aaa($i);  
}  
  
$t2 = microtime(true);  
  
echo 'php time:' . ($t2 - $t1)*1000 . "ms\n";  
 
function aaa($i){  
    $a = $i + 1;  
    $b = 2.3;  
    $s = "abcdefkkbghisdfdfdsfds";  
  
    if($a > $b){  
        ++$a;  
    }else{  
        $b = $b + 1;  
    }  
  
    if($a == $b){  
        $b = $b + 1;  
    }  
  
    $c = $a * $b + $a / $b - pow($a, 2);  
    $d = substr($s, 0, strpos($s, 'kkb')) . strval($c);  
}  
?>
```

测试结果：

```bash
~/Sites » php tes.php
php time:8196.1958408356ms
-------------------------------------------------------
~/Sites » php tes.php
php time:7649.4419574738ms
-------------------------------------------------------
~/Sites » php tes.php
php time:7908.7510108948ms
-------------------------------------------------------
~/Sites » php tes.php
php time:7708.6410522461ms
-------------------------------------------------------
~/Sites » php tes.php
php time:7515.1500701904ms
-------------------------------------------------------
~/Sites » php tes.php
php time:7468.3780670166ms
```

## Java
```
java version "10.0.1" 2018-04-17
Java(TM) SE Runtime Environment 18.3 (build 10.0.1+10)
Java HotSpot(TM) 64-Bit Server VM 18.3 (build 10.0.1+10, mixed mode)
```
<!---more--->
```Java
public class Main {
 
    public static void main(String[] args) {
        long t1 = System.currentTimeMillis();
          
        for(int i=0; i<10000000; i++){
            aaa((float)i);
        }  
          
        long t2 = System.currentTimeMillis();
          
        System.out.println("java time: " + String.valueOf(t2 - t1) + "ms");
    }  
      
    static void aaa(float i) {
        float a = i + 1;
        float b = 2.3f;
        String s = "abcdefkkbghisdfdfdsfds";
          
        if(a > b){
            ++a;
        }else{
            b = b + 1;
        }  
  
        if(a == b){
            b = b + 1;
        }  
          
        float c = (float)(a * b  + a / b - Math.pow(a, 2));
        String d = s.substring(0, s.indexOf("kkb")) + String.valueOf(c);
    }
}
```

测试结果：

```bash
~/Sites » java Main
java time: 1537ms
-------------------------------------------------------
~/Sites » java Main
java time: 1497ms
-------------------------------------------------------
~/Sites » java Main
java time: 1466ms
-------------------------------------------------------
~/Sites » java Main
java time: 1610ms
-------------------------------------------------------
~/Sites » java Main
java time: 1488ms
-------------------------------------------------------
~/Sites » java Main
java time: 1503ms
-------------------------------------------------------
~/Sites » java Main
java time: 1475ms
```

## Go
```
go version go1.10.3 darwin/amd64
```

```Go
package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
	"time"
)

func main() {
	t1 := time.Now()
	for i := 0; i < 10000000; i++ {
		Aaa(float64(i))
	}
	t2 := time.Now()
	fmt.Printf("Go time: %f s\n", t2.Sub(t1).Seconds())
}

func Aaa(i float64) {
	var a float64 = i + 1
	var b float64 = 2.3
	s := "abcdefkkbghisdfdfdsfds"

	if a > b {
		a++
	} else {
		b = b + 1
	}

	if a == b {
		b = b + 1
	}

	c := a*b + a/b - math.Pow(a, 2)
	d := s[0:strings.Index(s, "kkb")] + strconv.FormatFloat(c, 'E', -1, 64)
	_ = d
}
```
测试结果：

```bash
~/Workspaces/GoLand/src/Aaa » go build main.go
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 4.083166 s
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 4.095651 s
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 4.154200 s
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 4.175203 s
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 4.111375 s
```

## Go并发版本

```Go
package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
	"sync"
	"time"
)

func main() {
	wg := sync.WaitGroup{}
	t1 := time.Now()
	for k := 0; k < 2; k++ {
		wg.Add(1)
		go func() {
			for i := 0; i < 5000000; i++ {
				Aaa(float64(i))
			}
			wg.Done()
		}()
	}
	wg.Wait()
	t2 := time.Now()
	fmt.Printf("Go time: %f s\n", t2.Sub(t1).Seconds())
}

func Aaa(i float64) {
	var a float64 = i + 1
	var b float64 = 2.3
	s := "abcdefkkbghisdfdfdsfds"

	if a > b {
		a++
	} else {
		b = b + 1
	}

	if a == b {
		b = b + 1
	}

	c := a*b + a/b - math.Pow(a, 2)
	_ = s[0:strings.Index(s, "kkb")] + strconv.FormatFloat(c, 'E', -1, 64)
}
```
测试结果：

```bash
~/Workspaces/GoLand/src/Aaa » go build main.go
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 2.326077 s
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 2.270769 s
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 2.277345 s
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 2.252540 s
-------------------------------------------------------
~/Workspaces/GoLand/src/Aaa » ./main
Go time: 2.255374 s
```


## JavaScript(NodeJS)
```
~/Sites » node -v
v9.11.1
```

```Javascript
var t1 = (new Date()).getTime();  
 
for(var i=0; i<10000000; i++){  
    aaa(i);  
}  
  
var t2 = (new Date()).getTime();  
  
console.log("nodejs time：" + (t2 - t1) + "ms");  
      
  
function aaa(i){  
    var a = i + 1;  
    var b = 2.3;  
    var s = "abcdefkkbghisdfdfdsfds";  
 
    if(a > b){  
        ++a;  
    }else{  
        b = b + 1;  
    }  
 
    if(a == b){  
        b = b + 1;  
    }  
 
    var c = a  * b + a / b - Math.pow(a, 2);  
      
    var d = s.substring(0, s.indexOf("kkb")) + c.toString();  
}  
```

测试结果：

```bash
~/Sites » node main.js
nodejs time：4898ms
-------------------------------------------------------
~/Sites » node main.js
nodejs time：5567ms
-------------------------------------------------------
~/Sites » node main.js
nodejs time：4846ms
-------------------------------------------------------
~/Sites » node main.js
nodejs time：4853ms
-------------------------------------------------------
~/Sites » node main.js
nodejs time：4955ms
-------------------------------------------------------
~/Sites » node main.js
nodejs time：5113ms
```

## Python
```
~/Sites » python -V
Python 2.7.10
```

```Python
import sys, time, math
 
def aaa(i):
	a = i + 1
	b = 2.3
	s = "abcdefkkbghisdfdfdsfds"
 
	if a > b:
		a = a + 1
	else:
		b = b + 1
 
	if a == b:
		b = b + 1
 
	c = a * b +a / b - math.pow(a, 2)
 
	d = s[0: s.find("kkb")] + str(c)
 
 
t = time.time()
 
for i in xrange(0, 10000000):
	aaa(i)
 
print 'Python time: %.02f s' % (time.time() - t)
```
测试结果：

```bash
~/Sites » python main.py
Python time: 20.34
-------------------------------------------------------
~/Sites » python main.py
Python time: 19.90
-------------------------------------------------------
~/Sites » python main.py
Python time: 20.07
-------------------------------------------------------
~/Sites » python main.py
Python time: 19.88
-------------------------------------------------------
~/Sites » python main.py
Python time: 22.89
```

目前这几种编程语言看来，排序如下：

1. Java	平均 1.51s		(稳居第一)
2. Go		平均 3.94s		(并发2.28s)
3. NodeJs	平均 5.03s
4. PHP		平均 7.65s
5. Python	平均 20.62s 	(差距大应该是我对这语言不熟，密集运算应该有优化方案)

Ps: 如果你希望看到自己喜欢的语言也排进来，欢迎提供代码！