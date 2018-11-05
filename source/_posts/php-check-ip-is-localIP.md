---
title: 判断IP地址是否内网IP
tags:
  - PHP
  - IP
abbrlink: ae0c030a
date: 2018-11-05 14:45:52
---

> 当你的服务同时开放于公网和内网，子服务却仅允许内网访问，那么则会涉及到IP白名单的功能。但是如果名单太多或者服务进行了迁移，那么维护起来会相当的麻烦，最简单的就是判断访问的来源IP是否内网IP地址，从而直接屏蔽掉公网IP。


首先，我们认识了3类私有地址：

A类：10.0.0.0-10.255.255.255

B类：172.16.0.0-172.31.255.255

C类：192.168.0.0-192.168.255.255

还有一个本机地址：127.0.0.1

他们就是我们平时所谓的内网IP地址。

### 方法一： PHP自带函数

> filter_var($IP, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE)

如果$IP是内网IP则会返回`false`，否则返回ip字符串。

```PHP
$IP = get_client_ip(); //该方法自己实现，返回客户端的IP地址
$is_publicIP = filter_var($IP, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);
if($is_publicIP){
	echo '公网IP';
}else{
	echo '内网IP';
}
```

### 方法二： 适合有网络基础的胖友阅读

关于IP地址的知识，这里就不讲太多了，下面的方法就是根据IP地址的定义和网段的划分等专业知识进行判定的。懂的就自然懂啦！

```PHP
<?php
function isLocal($ip){
        $long=ip2long($ip);
        $data=array(
                24=>'10.255.255.255',
                20=>'172.31.255.255',
                16=>'192.168.255.255'
        );
        foreach($data as $k=>$v){
                if($long >> $k === ip2long($v)>>$k){
                        return true;
                }
        }
        return false;
}
```

### 方法三：正则匹配

更加不用解释了。

```PHP
<?php
function isLocal($ip){        
    return preg_match('%^127\.|10\.|192\.168|172\.(1[6-9]|2|3[01])%',$ip);
}
```

参考：

1. [http://php.net/manual/zh/function.filter-var.php](http://php.net/manual/zh/function.filter-var.php)
3. [https://www.51-n.com/t-4360-1-1.html](https://www.51-n.com/t-4360-1-1.html)
2. [https://blog.csdn.net/z_qifa/article/details/75497577](https://blog.csdn.net/z_qifa/article/details/75497577)