---
title: kubernetes nginx ingress custom 401/500 page
categories:
  - 学习笔记
author: 刘经济
tags: k8s
abbrlink: 4fa20f2
date: 2022-02-21 14:30:41
thumbnail:
blogexcerpt:
---

在k8s中，通常会使用ingress的方式将内部服务进行暴露，与此同时会加上鉴权的功能，如：Basic Auth、Oauth2和JWT等等。

#### 使用方法

在Ingress资源的metadata的annotations中增加`nginx.ingress.kubernetes.io/auth-url`来指定鉴权的地址。如：nginx.ingress.kubernetes.io/auth-url: http://10.11.0.123:8081/api-auth

这样一来，我们在编写`/api-auth`这个接口的时候，可以根据请求头拿到客户端的认证信息，进而判断是否对其请求进行放行，返回状态码为200即为放行，nginx会将客户端的请求转发到对应的后端服务；返回状态码为401即表示没有授权，nginx直接对其拦截，并返回给客户端默认的响应。

响应Header头：

```bash
HTTP/2 401
date: Mon,21 Feb 2022 06:42:41 GMT
content-type: text/html
content-length: 574
```

响应Body体：

```htm
<html>
<head><title>401 Authorization Required</title></head>
<body>
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx</center>
</body>
</html>
<!-- a padding to disable MSIE and Chrome friendly error page -->
<!-- a padding to disable MSIE and Chrome friendly error page -->
<!-- a padding to disable MSIE and Chrome friendly error page -->
<!-- a padding to disable MSIE and Chrome friendly error page -->
<!-- a padding to disable MSIE and Chrome friendly error page -->
<!-- a padding to disable MSIE and Chrome friendly error page -->
```

但是客户端仅知道请求是因为授权问题被拒绝了，但是不知道具体的原因，如果需要得知具体的拒绝原因，可以按照如下方法进行优化。

#### 优化方法

因为nginx中没有直接获取upsream返回结果的方法（可通过重新编译，用Lua实现），但是可获取到响应头，所以我们利用响应头来返回拒绝的原因。

首先，在`/api-auth`中，增加一个响应头`my_auth_error`，内容可以直接填写您需要返回给客户端的原因，我这里会填入一个json串的Base64编码值。

然后我们回到nginx-ingress的配置文件，增加两个声明：`nginx.ingress.kubernetes.io/configuration-snippet`和`nginx.ingress.kubernetes.io/server-snippet`。

```yaml
metadata:
  # 此处省略N个字
  annotations:
    nginx.ingress.kubernetes.io/auth-url: http://10.11.0.123:8081/api-auth
    nginx.ingress.kubernetes.io/configuration-snippet: |
      error_page 401 = @ingress_service_custom_error_401;
      
      auth_request_set $my_auth_error $upstream_http_wwd_auth_error;
      auth_request_set $my_auth_error_content_type $upstream_http_content_type;
      auth_request_set $my_auth_status $upstream_status;
    nginx.ingress.kubernetes.io/server-snippet: |
      location @ingress_service_custom_error_401 {
        internal;

        # Decode auth response header
        set_decode_base64 $my_auth_error_decoded $my_auth_error;

        # Return the error from auth service if any
        if ($my_auth_error_decoded != ""){
          add_header Content-Type $my_auth_error_content_type always;
          return 401 $my_auth_error_decoded;
        }

        # Fall back to default nginx response
        return 401;
      }
  # 此处省略N个字
```

#### 配置解释

`configuration-snippet`用来对location进行自定义配置，上面对401的错误页面定义了一个`@ingress_service_custom_error_401`，然后增加了3个变量`my_auth_error`、`my_auth_error_content_type`和`my_auth_status`分别取值自定义响应头、响应类型和响应状态码。

`server-snippet`用来对server块进行自定义配置，上面相当于在server块增加了一个location，该location即为401时的默认响应，其中会对`my_auth_error`进行base64解码，然后判断解码内容，若其内容为空，则直接返回最初的默认401页面，否则在响应头中增加`Content-Type`为具体的自定义类型，并返回401状态码和自定义响应Body。

如此一来，就可以实现nginx-ingress根据auth接口响应的结果来执行不同的行为。最终实现不同的效果。

响应头：

```txt
HTTP/2 401
date: Mon, 21 Feb 2022 07:14:36 GMT
content-type: text/html
content-length: 51
content-type: application/json
```

响应Body体：

```json
{
  "message": "用户未登录",
  "code": 14,
  "data": null
}
```



#### 参考资料

[Custom response for Ingress-Nginx External Authentication](https://stackoverflow.com/questions/65951602/custom-response-for-ingress-nginx-external-authentication?answertab=active#tab-top)
