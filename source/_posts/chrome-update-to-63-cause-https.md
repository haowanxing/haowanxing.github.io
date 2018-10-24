---
title: 解决Chrome更新到63后.dev/.app后缀域名强制HTTPS的问题
tags: Chrome https
abbrlink: a508b207
date: 2017-12-11 14:57:18
categories:
---

　　又是周一，上班的日子总是来的太快，来到公司的第一件事，打开IDE并更新代码库。看看上周做到哪里了，还有什么BUG是待修复的？

　　然鹅，意想不到的事情就这么发生了，为什么本地环境访问不了？
![请求被拒绝](http://cdn.pipipa.cn/20171211151297573775954.png)

　　localhost能访问，本地服务器没问题；其他的本地域名可以访问，Apache配置没动过应该不是这个问题；试了试公司项目的其他域名，都是同样的报错；然后我注意了一下URL，被加上了https协议，去掉s再回车没解决；换个浏览器，行了？？ 好吧，可能谷歌抽风了，我试了清空缓存和浏览历史，完全不行。后来发现问题没那么简单，网上也很难找到相关的结果，发现自己遇到了难题。

　　然后我发现了[SegmentFault](https://segmentfault.com/q/1010000012339191)有人问了相同的问题，才在回答里面找到了答案：

![Chrome update news](http://cdn.pipipa.cn/20171211151297617476829.png)

　　原文地址：[Chrome 63 now forces .dev domains to HTTPS](https://laravel-news.com/chrome-63-now-forces-dev-domains-https)

　　既然如此，强大的谷歌对自己拥有的顶级域名（.dev和.app）进行了合法干涉，那么我们也只能认怂了吧。 默默的把原来的.dev改成了.local后缀。

　　但是有强迫症的我有点不甘心，相信有很多人跟我一样，都是执着的没事干的人！不找出一个能在chrome上用.dev的后缀的方法，心里面还是稍微有那么一点难受的（^_-!）

　　在github上有一个工具：[Fishdrowned的自签泛域名证书](https://github.com/Fishdrowned/ssl)，~~MacOS用户可以使用我FORK过来的[修改版](https://github.com/haowanxing/ssl)~~(原作者已做兼容2018/01/02)

　　咱们可以自己在本地生成一个xxx.dev的域名证书来直接让TA支持https访问！！！！ 具体的使用方法在上面链接有介绍

　　服务器端如何配置支持https自行搜索，这里不做解释了。

　　最终实现.dev的https访问，如图：

![url地址栏](http://cdn.pipipa.cn/2018010315149750616257.png)

![浏览器证书](http://cdn.pipipa.cn/2018010315149751936425.png)
　　