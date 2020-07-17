---
title: 自建CA服务器学习笔记
categories:
  - 学习笔记
abbrlink: '32476646'
date: 2020-07-17 18:29:05
author:
tags: 
  - CA
  - Linux
  - https
thumbnail:
blogexcerpt:
---

​		我人生中的第一次遇到证书问题并加以解决，还是在大约3年前，那时还专门写了一篇文章[《解决Chrome更新到63后.dev/.app后缀域名强制HTTPS的问题》](/posts/a508b207.html)。当时是因为本地开发环境一直都是用的`.dev`后缀结尾的域名，一直都是以`http://www.test.dev`的方式进行本地web开发。那天浏览器突然提示访问不安全的网站，此处黑人问号？？ Chrome强制`.dev`后缀的域名都得走https，无奈之下，不想更换后缀的我走上了自签发https证书的道路，但当时直接使用了开源工具，并没有深入研究。

​		日月如梭，今时今日的我已经不再是那个年少的小孩！日常工作中免不了与SSL/TLS这玩意儿打交道，除了访问web用https外，只要与建立加密连接有关的统统都少不了证书和秘钥。这次需要自建CA服务器并签发下级证书以达到加密访问的目的，那么这次的笔记将会成为以后温习的主要文献了。（哈哈哈）

<!--more-->

## 搭建CA服务器

Server：Ubuntu 16.04.6 TLS

Core：1

RAM：1GB

提前安装好openssl，版本：`OpenSSL 1.0.2g 1 Mar 2016`。

使用默认配置`/usr/lib/ssl/openssl.cnf`:

```ini
# 主要配置如下

####################################################################
[ ca ]
default_ca  = CA_default        # 默认的CA配置段

####################################################################
[ CA_default ]

dir     = ./demoCA      # Where everything is kept （工作目录）
certs       = $dir/certs        # Where the issued certs are kept （证书存储目录）
crl_dir     = $dir/crl      # Where the issued crl are kept	（证书吊销列表目录）
database    = $dir/index.txt    # database index file.	（证书索引文件）
#unique_subject = no            # Set to 'no' to allow creation of	（允许相同的Subject证书请求）
                    # several ctificates with same subject.
new_certs_dir   = $dir/newcerts     # default place for new certs.	（最新证书存储目录）

certificate = $dir/cacert.pem   # The CA certificate	（自签CA证书）
serial      = $dir/serial       # The current serial number	（当前序列号）
crlnumber   = $dir/crlnumber    # the current crl number	（当前吊销号码）
                    # must be commented out to leave a V1 CRL
crl     = $dir/crl.pem      # The current CRL
private_key = $dir/private/cakey.pem# The private key	（CA私钥）
RANDFILE    = $dir/private/.rand    # private random number file

x509_extensions = usr_cert      # The extentions to add to the cert

name_opt    = ca_default        # Subject Name options
cert_opt    = ca_default        # Certificate field options


default_days    = 365           # how long to certify for	（有效时长）
default_crl_days= 30            # how long before next CRL
default_md  = default       # use public key default MD
preserve    = no            # keep passed DN ordering

policy      = policy_match

# For the CA policy
[ policy_match ]
countryName     = match
stateOrProvinceName = match
organizationName    = match
organizationalUnitName  = optional
commonName      = supplied
emailAddress        = optional

```

根据配置中的内容，需要提前创建好目录和文件：

```bash
$ tree demoCA
demoCA/
|-- crl
|   `-- ca.crl
|-- crlnumber
|-- index.txt
|-- newcerts
`-- serial

#===写入初始证书序列号===#
$ echo 01 > demoCA/serial
```



### 生成CA证书

```bash
# 生成跟证书和秘钥
openssl req -x509 -new -days 3650 -keyout ca.key -out ca.crt -nodes
# 查看证书
openssl x509 -text -in ca.crt -noout 
```



## 下级（节点）证书签发

1. 私钥：

   ```bash
   # 生成私钥
   openssl genrsa -out server.key 2048
   ```

2. 生成证书请求文件CSR：

   ```bash
   # 生成csr文件
   openssl req -new -key server.key -out server.csr
   ```

3. 利用CA对CSR签发证书：

   ```bash
   # 签发证书
   openssl ca -in server.csr -out server.crt -cert ca.crt -keyfile ca.key -days 3650
   ```

4. 查看签发的证书：

   ```bash
   # 查看证书
   openssl x509 -text -in server.crt -noout 
   ```



## 证书的吊销

1. 查看要吊销的证书序列号和Subject：

   ```bash
   # server.crt为证书文件
   openssl x509 -in server.crt  -noout -serial -subject
   #====以下是内容====#
   serial=01
   subject= /C=CN/ST=World/O=Home/OU=Home Bedroom/CN=mybed
   ```

2. 对比证书索引文件中的信息：

   ```bash
   cat demoCA/index.txt
   #====以下是内容====#
   V	300715070118Z		01	unknown	/C=CN/ST=World/O=Home/OU=Home Bedroom/CN=mybed
   ```

3. CA吊销该证书：

   ```bash
   openssl ca -revoke ./demoCA/newcerts/01.pem
   #====以下是内容====#
   Using configuration from /usr/lib/ssl/openssl.cnf
   Revoking Certificate 01.
   Data Base Updated
   ```

4. 更新吊销列表：

   ```bash
   #第一次吊销需要先生成编号
   echo 00 > ./demoCA/crlnumber
   # 更新列表
   openssl ca -gencrl -out ./demoCA/crl/ca.crl
   ```

5. 查看CRL文件内容：

   ```bash
   openssl crl -in ./demoCA/crl/ca.crl -noout -text
   ```

   

> 参考文献

[搭建私有CA服务器](https://www.cnblogs.com/zhaojiedi1992/p/zhaojiedi_linux_011_ca.html)