---
title: 一种较好的实现PHP异步发送邮件的实现
tags:
  - email
  - php
  - 异步发送
id: 502
categories:
  - PHP
date: 2016-09-11 21:02:45
---

前些天在写我的TR-System（社团招新管理系统）的时候，用到了邮箱验证用户注册，也就是注册成功后，需要访问收到的邮件中的URL进行用户激活。这个事件发生在用户提交注册请求之后，系统需要立即发送一封邮件用于激活，但是系统在调用PHPMailer的时候需要进行SMTP连接邮箱系统（用的腾讯企业邮），往往在这个时候会出现等待的情况。如果让用户来承担这个等待时间，体验也太差了！，没见过哪个系统上注册个用户，还需要慢慢等待系统告诉我到底有没有注册成功。
一开始在写的时候，直接在POST请求中处理，写入数据库后就调用sendEmail方法，情况是这样的：
`1.提交注册 --> 2.写入数据库 --> 3.发送Email --> 4.注册成功。`
这样在用户看来是有一个漫长的等待的。
实际上应该为：
`
1.提交注册 --> 2.写入数据库 --> 3.注册成功。
||||||||||||||||||-->发送Email
`
这样的才是一个拥有良好用户体验的系统 ^_^ 。
若是在Java等环境下，咱们可以很好利用多线程，分出来一个任务让另一个线程去完成。
但是！PHP这个单线程环境下，没有new Thread来搞这个事情啊。 不过，换一个角度，线程不行的，我就给个新进程呗。当然不是在当前进程创建新进程。
<!--more-->

咱们重新写一个文件，sendEmail.php
<pre lang='php'>
$input = file_get_contents("php://input");
            $data = json_decode($input,true);
            $signature = $data['signature'];
            unset($data['signature']);
            ksort($data);
            $sign = sha1(implode($data));
            if($sign == $signature){
                SendMail($data['address'],$data['title'], $data['message'], $data['fromname']);
            }
</pre>
通过代码可以看到，主要发送邮件的还是SendMail()方法，上面是做了一个验证算法的，这样是为了避免这个接口被他人恶意调用，当然，这只是很low的一个算法。
假如调用这个接口的URI为http://localhost/sendEmail.php
咱们在系统中写两个方法：
<pre lang='php'>
//异步调用方法
function SendMail_Sock($address, $title, $message, $fromname = '滴水网')
{
    $post_url = 'http://localhost/sendEmail.php';
    $arr=array(
            'address'=>$address,
            'title'=>$title,
            'message'=>$message,
            'fromname'=>$fromname,
    );
    ksort($arr);
    $arrstr = implode($arr);
    $arrstr = sha1($arrstr);
    $arr['signature'] = $arrstr;

    return sock_post($post_url,$arr);
}

//fsockopen模拟POST请求到指定url
function sock_post($url,$data=array()){
    // $query = http_build_query($data);
    $query = json_encode($data);
    $info = parse_url($url);
    $fp = fsockopen($info["host"], 80, $errno, $errstr, 8);
    $head = "POST ".$info['path']."?".$info["query"]." HTTP/1.0\r\n";
    $head .= "Host: ".$info['host']."\r\n";
    $head .= "Referer: http://".$info['host'].$info['path']."\r\n";
    $head .= "Content-type: application/x-www-form-urlencoded\r\n";
    $head .= "Content-Length: ".strlen(trim($query))."\r\n";
    $head .= "\r\n";
    $head .= trim($query);
    $write = fputs($fp, $head);
    return $write;    //只要fsockopen()成功打开，就返回成功，这里发送数据后并不需要接收反馈，所以无需等待
}
</pre>

以后在需要异步发送邮件的时候直接使用SendMail_Sock()方法就行了。但是这样也有不利之处，那就是到底有没有发送成功，只有用户自己知道 【悲哀】。