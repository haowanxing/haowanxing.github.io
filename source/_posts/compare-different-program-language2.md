---
title: 不同语言对网络IO的效率对比
tags:
  - 测试
  - 性能
abbrlink: 55e3ba30
date: 2018-08-21 17:07:37
categories:
---
![网络IO时间对比图](http://cdn.pipipa.cn/20180822153492632352365.png)

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
  
for($i=0; $i<20; $i++){  
    $url = "http://2018.ip138.com/ic.asp?count=".$i;
    $data = file_get_contents($url);
    // echo 'get:'.$i." ".$data."\r\n";
}  
  
$t2 = microtime(true);  
  
echo 'php time:' . ($t2 - $t1)*1000 . "ms\n";  
 
?>
```

测试结果：

```bash
~/Sites/languageDiff/io » php main.php
php time:2112.9629611969ms
-------------------------------------------------------
~/Sites/languageDiff/io » php main.php
php time:1960.746049881ms
-------------------------------------------------------
~/Sites/languageDiff/io » php main.php
php time:2055.7940006256ms
-------------------------------------------------------
~/Sites/languageDiff/io » php main.php
php time:2052.6430606842ms
-------------------------------------------------------
~/Sites/languageDiff/io » php main.php
php time:1990.2958869934ms
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
          
        for(int i=0; i<20; i++){
            String s=HttpRequest.sendGet("http://2018.ip138.com/ic.asp", "count="+i);
            // System.out.println(""+i+" : "+s);
        }  
          
        long t2 = System.currentTimeMillis();
          
        System.out.println("java time: " + String.valueOf(t2 - t1) + "ms");
    }
}
```

*HttpRequst.java* CodeOrigin:[https://www.cnblogs.com/guoyinli/p/7192839.html](https://www.cnblogs.com/guoyinli/p/7192839.html)

```Java

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;
import java.util.Map;

public class HttpRequest {
    /**
     * 向指定URL发送GET方法的请求
     * 
     * @param url
     *            发送请求的URL
     * @param param
     *            请求参数，请求参数应该是 name1=value1&name2=value2 的形式。
     * @return URL 所代表远程资源的响应结果
     */
    public static String sendGet(String url, String param) {
        String result = "";
        BufferedReader in = null;
        try {
            String urlNameString = url + "?" + param;
            URL realUrl = new URL(urlNameString);
            // 打开和URL之间的连接
            URLConnection connection = realUrl.openConnection();
            // 设置通用的请求属性
            connection.setRequestProperty("accept", "*/*");
            connection.setRequestProperty("connection", "Keep-Alive");
            connection.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            // 建立实际的连接
            connection.connect();
            // 获取所有响应头字段
            Map<String, List<String>> map = connection.getHeaderFields();
            // 遍历所有的响应头字段
            /*for (String key : map.keySet()) {
                System.out.println(key + "--->" + map.get(key));
            }*/
            // 定义 BufferedReader输入流来读取URL的响应
            in = new BufferedReader(new InputStreamReader(
                    connection.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送GET请求出现异常！" + e);
            e.printStackTrace();
        }
        // 使用finally块来关闭输入流
        finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return result;
    }

    /**
     * 向指定 URL 发送POST方法的请求
     * 
     * @param url
     *            发送请求的 URL
     * @param param
     *            请求参数，请求参数应该是 name1=value1&name2=value2 的形式。
     * @return 所代表远程资源的响应结果
     */
    public static String sendPost(String url, String param) {
        PrintWriter out = null;
        BufferedReader in = null;
        String result = "";
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            // 设置通用的请求属性
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            // 发送POST请求必须设置如下两行
            conn.setDoOutput(true);
            conn.setDoInput(true);
            // 获取URLConnection对象对应的输出流
            out = new PrintWriter(conn.getOutputStream());
            // 发送请求参数
            out.print(param);
            // flush输出流的缓冲
            out.flush();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送 POST 请求出现异常！"+e);
            e.printStackTrace();
        }
        //使用finally块来关闭输出流、输入流
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result;
    }    
}
```

测试结果：

```bash
~/Sites/languageDiff/io » java Main
java time: 1416ms
-------------------------------------------------------
~/Sites/languageDiff/io » java Main
java time: 1472ms
-------------------------------------------------------
~/Sites/languageDiff/io » java Main
java time: 1328ms
-------------------------------------------------------
~/Sites/languageDiff/io » java Main
java time: 1348ms
-------------------------------------------------------
~/Sites/languageDiff/io » java Main
java time: 1336ms
```

## Go
```
go version go1.10.3 darwin/amd64
```

```Go
package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"sync"
	"time"
)

func main() {
	wg := sync.WaitGroup{}
	start := time.Now()
	for k := 0; k < 2; k++ {
		wg.Add(1)
		go func(k int) {
			for i := 0; i < 10; i++ {
				HttpGet("http://2018.ip138.com/ic.asp?count=" + strconv.Itoa(i*2+k))
			}
			wg.Done()
		}(k)
	}
	wg.Wait()
	fmt.Printf("cost time: %f\n", time.Now().Sub(start).Seconds())
}

func HttpGet(url string) string {
	resp, err := http.Get(url)
	if err != nil {
		return err.Error()
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return err.Error()
	}
	return string(body)
}

```
测试结果：

```bash
~/Workspaces/go » go run main.go
cost time: 0.952737
-------------------------------------------------------
~/Workspaces/go » go run main.go
cost time: 0.983901
-------------------------------------------------------
~/Workspaces/go » go run main.go
cost time: 0.967799
-------------------------------------------------------
~/Workspaces/go » go run main.go
cost time: 0.972302
-------------------------------------------------------
~/Workspaces/go » go run main.go
cost time: 0.980509
```

## JavaScript(NodeJS)
```
~/Sites » node -v
v9.11.1
```

```Javascript
var t1 = (new Date()).getTime();  
var job = 0;
for(var i=0; i<20; i++){  
    get(i);  
}  
  
var t2 = (new Date()).getTime();  
  
console.log("nodejs time：" + (t2 - t1) + "ms");  
      

function get(i){

var http=require('http');
    //get 请求外网
    http.get('http://2018.ip138.com/ic.asp?count='+i,function(req,res){
        var html='';
        req.on('data',function(data){
            html+=data;
        });
        req.on('end',function(){
            job++
            // console.info(html);
            if(job == 20){
                var t2 = (new Date()).getTime();  
                console.log("finished time：" + (t2 - t1) + "ms");  
            }
        });
    });
}
```

测试结果：

```bash
~/Sites/languageDiff/io » node main.js
nodejs time：25ms
finished time：236ms
-------------------------------------------------------
~/Sites/languageDiff/io » node main.js
nodejs time：21ms
finished time：220ms
-------------------------------------------------------
~/Sites/languageDiff/io » node main.js
nodejs time：22ms
finished time：230ms
-------------------------------------------------------
~/Sites/languageDiff/io » node main.js
nodejs time：21ms
finished time：227ms
-------------------------------------------------------
~/Sites/languageDiff/io » node main.js
nodejs time：20ms
finished time：221ms
```

## Python
```
~/Sites » python -V
Python 2.7.10
```

```Python
import time,urllib2
 
def get(url):
	req = urllib2.Request(url)

	res_data = urllib2.urlopen(req)
	res = res_data.read()
	return res
 
 
t = time.time()
 
for i in xrange(0, 20):
	# print "Get("+str(i)+"):"
	data = get("http://2018.ip138.com/ic.asp?count="+str(i))
	# print data
 
print 'Python time: %.02fs' % (time.time() - t)

```
测试结果：

```bash
~/Sites/languageDiff/io » python main.py
Python time: 1.98s
-------------------------------------------------------
~/Sites/languageDiff/io » python main.py
Python time: 1.98s
-------------------------------------------------------
~/Sites/languageDiff/io » python main.py
Python time: 2.01s
-------------------------------------------------------
~/Sites/languageDiff/io » python main.py
Python time: 2.07s
-------------------------------------------------------
~/Sites/languageDiff/io » python main.py
Python time: 2.20s
-------------------------------------------------------
~/Sites/languageDiff/io » python main.py
Python time: 2.08s
```

目前这几种编程语言看来，排序如下：


1. NodeJs	平均 0.23s
2. Go		平均 0.97s	
3. Java	平均 1.38s
4. PHP		平均 2.03s
5. Python	平均 2.05s 

Ps: 如果你希望看到自己喜欢的语言也排进来，欢迎提供代码！