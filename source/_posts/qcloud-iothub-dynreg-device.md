---
title: 腾讯云物联网通信平台设备动态注册鉴权流程
tags: Qcloud
abbrlink: 4ede204f
date: 2020-02-26 15:16:22
categories: 开放平台
thumbnail: 
#blogexcerpt: 抽空研究了一下腾讯物联网平台的设备接入功能的自动注册部分，由于官网只提供了C-SDK，所以在我开发的Go程序中只能自己动手去扒SDK的逻辑然后集成到现有项目。
---

## 前置条件

### 物联网平台

1. 在物联网平台创建新产品（普通产品），认证方式选用“秘钥认证”。
2. 在产品设置中打开动态注册配置开关，并允许自动创建设备。
3. 记录产品ID和产品秘钥（ProductID/ProductSecret）。

### 设备端

1. 命名设备的唯一标识（如设备MAC、IMEI号、芯片ID等）即DeviceName。
2. 将物联网平台获取的产品ID和产品秘钥烧录至设备中。

## 注册流程

#### 第一步：生成验签参数

```yaml
deviceName: #设备名称
nonce: #随机整数
productId: #产品ID
timestamp: #时间戳
```

拼接字符串“deviceName=%s&nonce=%d&productId=%s&timestamp=%d”，使用HMAC_SHA1算法，ProductSecret作为Key对字符串进行摘要，然后使用Base64编码该摘要获得验签参数(Signature)的值

<!--more-->

#### 第二步：封装请求参数并发送鉴权请求

拼接JSON格式的字符串为Body：

```bash
# 请求地址：http(s)://gateway.tencentdevices.com/register/dev
# Body内容：
{\"deviceName\":\"%s\",\"nonce\":%d,\"productId\":\"%s\",\"timestamp\":%d,\"signature\":\"%s\"}
# 请求Header
Accept: text/xml,application/json;*/*
Content-type: application/x-www-form-urlencoded
Content-Length: 实际的Body长度
# 如果使用https方式，需要设置不校验证书，或者信任tencent自签发的证书
```

```wiki
# CA证书内容如下：
-----BEGIN CERTIFICATE-----
MIIDxTCCAq2gAwIBAgIJALM1winYO2xzMA0GCSqGSIb3DQEBCwUAMHkxCzAJBgNV
BAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMRAw
DgYDVQQKDAdUZW5jZW50MRcwFQYDVQQLDA5UZW5jZW50IElvdGh1YjEYMBYGA1UE
AwwPd3d3LnRlbmNlbnQuY29tMB4XDTE3MTEyNzA0MjA1OVoXDTMyMTEyMzA0MjA1
OVoweTELMAkGA1UEBhMCQ04xEjAQBgNVBAgMCUd1YW5nRG9uZzERMA8GA1UEBwwI
U2hlblpoZW4xEDAOBgNVBAoMB1RlbmNlbnQxFzAVBgNVBAsMDlRlbmNlbnQgSW90
aHViMRgwFgYDVQQDDA93d3cudGVuY2VudC5jb20wggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDVxwDZRVkU5WexneBEkdaKs4ehgQbzpbufrWo5Lb5gJ3i0
eukbOB81yAaavb23oiNta4gmMTq2F6/hAFsRv4J2bdTs5SxwEYbiYU1teGHuUQHO
iQsZCdNTJgcikga9JYKWcBjFEnAxKycNsmqsq4AJ0CEyZbo//IYX3czEQtYWHjp7
FJOlPPd1idKtFMVNG6LGXEwS/TPElE+grYOxwB7Anx3iC5ZpE5lo5tTioFTHzqbT
qTN7rbFZRytAPk/JXMTLgO55fldm4JZTP3GQsPzwIh4wNNKhi4yWG1o2u3hAnZDv
UVFV7al2zFdOfuu0KMzuLzrWrK16SPadRDd9eT17AgMBAAGjUDBOMB0GA1UdDgQW
BBQrr48jv4FxdKs3r0BkmJO7zH4ALzAfBgNVHSMEGDAWgBQrr48jv4FxdKs3r0Bk
mJO7zH4ALzAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQDRSjXnBc3T
d9VmtTCuALXrQELY8KtM+cXYYNgtodHsxmrRMpJofsPGiqPfb82klvswpXxPK8Xx
SuUUo74Fo+AEyJxMrRKlbJvlEtnpSilKmG6rO9+bFq3nbeOAfat4lPl0DIscWUx3
ajXtvMCcSwTlF8rPgXbOaSXZidRYNqSyUjC2Q4m93Cv+KlyB+FgOke8x4aKAkf5p
XR8i1BN1OiMTIRYhGSfeZbVRq5kTdvtahiWFZu9DGO+hxDZObYGIxGHWPftrhBKz
RT16Amn780rQLWojr70q7o7QP5tO0wDPfCdFSc6CQFq/ngOzYag0kJ2F+O5U6+kS
QVrcRBDxzx/G
-----END CERTIFICATE-----
```



#### 第三步：根据响应结果进一步处理和解密payload

响应结果格式：

```json
{"code":0,"message":"","len":53,"payload":"+b93hoyyPKdArkNo+FIwCJXYQi+zVppqBGM+1kWuMxgHbfknWh2udKorHnb4t9RywJM8g23ryT/sTL1rmGGTyA=="}
```

其中，code为0表示鉴权成功，message为错误时的提示信息，payload为返回的注册结果密文，len为payload的明文长度。

解密步骤：

```bash
# 将payload使用base64解码获得原始密文,记为$raw
# 将$raw使用AES_128_CBC算法进行解密，Key为ProductSecret的前16字节，IV向量为16个字节的'0'（即rune(48)），填充方式为ZERO_PADDING
```

解密后的字符串长度应该为16的整数倍，需要将字符串尾部多余的`0`字节去除（或者直接截取字符串的前len个字节）得到一个最终json串，格式为：

```json
{"encryptionType":2,"psk":"MpKyD0rDNaAwq+zsDvGY9w=="}
```

其中，`encryptionType`表示认证类型（1证书，2秘钥），`psk`表示秘钥。

#### 第四步：将秘钥烧录到设备

将psk烧录到设备中存储，对应的内容应该是一个3元组或4元组：

```yaml
productId: #产品ID
productSecret: #产品秘钥
deviceName:	#设备名称
deviceSecret: #设备认证秘钥
```

#### 第五步：设备认证+上线

此处参照文档：[腾讯云物联网通信文档中心-设备接入-设备基于MQTT接入](https://cloud.tencent.com/document/product/634/32546)


