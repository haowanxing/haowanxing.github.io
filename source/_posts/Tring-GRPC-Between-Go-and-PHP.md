---
title: Go-Server/Client以及PHP-Client之间的GRPC初次尝试
tags:
  - Golang
  - PHP
  - RPC
abbrlink: b37f5033
date: 2018-12-02 13:47:24
categories: 学习笔记
---

> 写这篇笔记的目的

为了应对后续开发生涯中可能遇到的种种情况以及分布式计算的趋势（讲白了就是后续对工作会很有帮助）。如若总是依赖http-api/restful编写并提供外部调用接口，当接口数量不断上升，文档内容不断增加，这给设计者和使用者都带来非常不好的体验，而RPC在这体就现出了非常大的优势。我将自己的理解和体会以及学习的过程记录在这里，以便今后遇到问题能够从这儿获得些许的线索以及提供一个参考给同道中人。

> 前提

不妨思考这样一个情形：作为接口设计者，我早已经定义好的接口的请求方式(RESTFul)和返回结构(json)，但是每个接口我还需要另外维护一个文档来说明各个接口的用法(请求参数)和解释返回的结果(字段描述)。而对于接口的调用者而言，不但要去文档中查找自己需要的接口并阅读说明，在实际调用中，还要以防接口提供者返回非既定结构的结果而导致的报错。

<!---more--->

> 介绍

Remote Procedure Call（远程过程调用），简称RPC。它可以使得调用远程服务接口如同调用本地方法一样简单。虽然实质还是通过网络通信，但是相比http请求api的网络开销还是极小的，其原因简单来说，HTTP协议每次请求都需要建立TCP连接，就会涉及3次握手的网络开销问题以及冗余报文，而rpc直接使用TCP多路复用(gRPC基于HTTP/2)无需重复建立连接。就文档方面而言，编写一份开发文档足矣，因为接口的定义由接口定义语言（IDL）来完成，而阅读IDL便可理解所有接口，并且通过编译器可以将IDL编译成不同的语言实现源码（gRPC通过protoc编译器将protobuf编译）。其他优点例如：注册、监控、发布等的这里不做论述。

> Go-Server

GRPC的官方资源：[go get google.golang.org/grpc](google.golang.org/grpc)

GRPC的镜像资源：[https://github.com/grpc/grpc](https://github.com/grpc/grpc)

官方的相关示列可以在grpc/examples/中找到。

#### 定义服务

使用`protocol buffers`去定义gRPC service和方法 request以及 response 的类型。

新增并编辑文件：something.proto

```protobuf
syntax = "proto3";

// 声明包/作用域
package something;

// 定义一个服务，名为Wiwider
service Wiwider {
  rpc FindUser (UserRequest) returns (UserReply) {}	// 声明一个方法
  rpc FindUsers (UserRequest) returns (UsersReply) {}
}

// 定义一个请求消息
message UserRequest {
  string name = 1;
}

// 定义一个响应消息
message UserReply {
  int64 id = 1;
  string name = 2;
  int32 age = 3;
  sexes sex = 4;

  enum sexes {
    Male = 0;
    Female = 1;
  }
}

// 定义一个包含消息的消息
message UsersReply {
  repeated UserReply users = 1;
}
```

#### 生成代码

> Go-代码

```
protoc --go_out=plugins=grpc:. something.proto
```

运行这个命令后，会在当前目录生成一个`something.pb.go`文件，内容包含：

* 所有用于填充，序列化和获取我们请求和响应消息类型的 protocol buffer 代码
* 一个为客户端调用定义在Wiwider服务的方法的接口类型（或者 存根 ）
* 一个为服务器使用定义在Wiwider服务的方法去实现的接口类型（或者 存根 ）

> PHP-代码

```
protoc --proto_path=./ --php_out=./ --grpc_out=./ --plugin=protoc-gen-grpc=/Users/anthony/git/grpc/bins/opt/grpc_php_plugin ./something.proto
```
其中`/Users/anthony/git/grpc/bins/opt/grpc_php_plugin`对应从git中获取的`<grpc-git-path>/bins/opt/grpc_php_plugin`

运行这个命令后，会在当前目录生成如下：

* GPBMetadata/something.php
* Something/UserReply/sexes.php
* Something/UserReply.php
* Something/UserReply_sexes.php
* Something/UserRequest.php
* Something/UsersReply.php
* Something/WiwiderClient.php

#### 创建服务器

首先我们需要实现服务定义的服务接口：

`something/something.go`：

```Go
package something

import (
	"Wiwide/cmi"
	"context"
)
type UserServer struct {

}

func (s *UserServer) FindUser(ctx context.Context, in *UserRequest) (*UserReply, error) {
	name := in.GetName()
	rs, err := cmi.Db("local").Table("users").Where("name", name).First()	// 从数据库查询
	if err != nil || len(rs) == 0 {
		return &UserReply{},err
	}
	rId := rs["id"].(int64)
	rName := rs["name"].(string)
	rAge := int32(rs["age"].(int64))
	rSex := UserReplySexes(rs["sex"].(int64))
	rep := &UserReply{Id:rId,Name:rName,Age:rAge,Sex:rSex}
	return rep, nil
}

func (s *UserServer) FindUsers(ctx context.Context, in *UserRequest) (*UsersReply, error) {
	name := in.GetName()
	rs, err := cmi.Db("local").Table("users").Where("name","like","%"+name+"%").Get()	// 从数据库查询
	if err != nil {
		return &UsersReply{}, err
	}
	list := make([]*UserReply, 0)
	for _, v := range rs {
		rId := v["id"].(int64)
		rName := v["name"].(string)
		rAge := int32(v["age"].(int64))
		rSex := UserReplySexes(v["sex"].(int64))
		list = append(list, &UserReply{Id:rId,Name:rName,Age:rAge,Sex:rSex})
	}
	rep := &UsersReply{Users: list}
	return rep, nil
}
```

然后运行一个gRPC服务器，注册我们的服务并监听来自客户端的请求：

`server.go`：

```Go
package main

import (
	"Wiwide/rpc/something"
	"context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"log"
	"net"
)

var (
	port = ":50051"
)
func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	something.RegisterWiwiderServer(s, &something.UserServer{})
	reflection.Register(s)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

#### 运行服务器

简单执行命令：`go run server.go`，然后等待客户端请求。

#### 创建客户端

> Go-Client

创建文件`client.go`：

```Go
package main

import (
	"Wiwide/rpc/something"
	"context"
	"google.golang.org/grpc"
	"log"
	"os"
	"time"
)

const(
	address = "localhost:50051"
	defaultName = "World"
)

func main(){
	conn, err := grpc.Dial(address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()

	name := defaultName
	if len(os.Args) > 1 {
		name = os.Args[1]
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	s := something.NewWiwiderClient(conn)
	u, err := s.FindUser(ctx, &something.UserRequest{Name:name})
	if err != nil {
		log.Fatalf("could not Find: %v", err)
	}
	us, err := s.FindUsers(ctx, &something.UserRequest{Name:name})
	if err != nil {
		log.Fatalf("could not Find users: %v", err)
	}
	log.Printf("Find user: %v", u)
	log.Printf("Find users: %v", us)
}
```

> PHP-Client

PHP首先要安装grpc的php扩展，下载地址：[http://pecl.php.net/package/gRPC](http://pecl.php.net/package/gRPC)

直接使用phpize安装:

```bash
tar -zxf grpc-1.17.0.tgz
cd grpc-1.17.0
phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make
make install
# 在php.ini中增加
extension = grpc.so
```

执行php -m | grep grpc 应该会输出"grpc"，就代表成功了。

创建客户端文件，这里需要用到composer获取两个包，其中composer.json内容为：

```json
{
  "name": "grpc/grpc-demo",
  "description": "gRPC example for PHP",
  "require": {
    "grpc/grpc": "^v1.3.0",
    "google/protobuf": "^v3.3.0"
  }
}
```

`something.php`：

```PHP
<?php
require dirname(__FILE__).'/vendor/autoload.php';

include_once dirname(__FILE__).'/Something/UserReply.php';
include_once dirname(__FILE__).'/Something/UsersReply.php';
include_once dirname(__FILE__).'/Something/UserRequest.php';
include_once dirname(__FILE__).'/Something/WiwiderClient.php';
include_once dirname(__FILE__).'/GPBMetadata/Something.php';

$client = new Something\WiwiderClient('127.0.0.1:50051', ['credentials' => Grpc\ChannelCredentials::createInsecure()]);
$req = new Something\UserRequest();
$name = !empty($argv[1]) ? $argv[1] : 'world';
$req->setName($name);
list($reply, $status) = $client->FindUser($req)->wait();
var_dump($reply->getId(), $reply->getName(), $reply->getAge(), $reply->getSex(), $status);

list($reply, $status) = $client->FindUsers($req)->wait();
$uers = $reply->getUsers();
$users = array();
foreach ($uers as $key => $value) {
	array_push($users, array('id'=>$value->getId(),'name'=>$value->getName(),'age'=>$value->getAge(),'sex'=>$value->getSex()));
}
var_dump($users);

```

#### 运行客户端

> Go-Client

我们先编译一下：`go build client.go`，输出可执行文件`client`，然后直接运行：

* `./client Anthony`
* `./client ny`

分别输出如下：

```
2018/12/02 13:40:15 Find user: id:1 name:"Anthony" age:24 sex:Female 
2018/12/02 13:40:15 Find users: users:<id:1 name:"Anthony" age:24 sex:Female >
```

```
2018/12/02 13:40:25 Find user: 
2018/12/02 13:40:25 Find users: users:<id:1 name:"Anthony" age:24 sex:Female > users:<id:4 name:"funny" age:15 sex:2 > 
```

> PHP-Client

直接执行PHP文件：`php something.php Anthony`和`php something.php ny`，结果如下：

```
int(1)
string(7) "Anthony"
int(24)
int(1)
object(stdClass)#8 (3) {
  ["metadata"]=>
  array(0) {
  }
  ["code"]=>
  int(0)
  ["details"]=>
  string(0) ""
}
array(1) {
  [0]=>
  array(4) {
    ["id"]=>
    int(1)
    ["name"]=>
    string(7) "Anthony"
    ["age"]=>
    int(24)
    ["sex"]=>
    int(1)
  }
}
```

```
int(0)
string(0) ""
int(0)
int(0)
object(stdClass)#8 (3) {
  ["metadata"]=>
  array(0) {
  }
  ["code"]=>
  int(0)
  ["details"]=>
  string(0) ""
}
array(2) {
  [0]=>
  array(4) {
    ["id"]=>
    int(1)
    ["name"]=>
    string(7) "Anthony"
    ["age"]=>
    int(24)
    ["sex"]=>
    int(1)
  }
  [1]=>
  array(4) {
    ["id"]=>
    int(4)
    ["name"]=>
    string(5) "funny"
    ["age"]=>
    int(15)
    ["sex"]=>
    int(2)
  }
}
```

### 结束

本次笔记接近结尾了，内容很简单，主要记录使用grpc的大体流程。为后续的测试做一点点的准备。

> 参考资料

* [gRPC官方文档中文版v1.0](http://doc.oschina.net/grpc)
* [grpc简易教程 go server+php client](https://blog.csdn.net/xuduorui/article/details/77726393)
* [PRC服务和HTTP服务对比](https://blog.csdn.net/wangyunpeng0319/article/details/78651998)
* [grpc官方网站](https://grpc.io/)