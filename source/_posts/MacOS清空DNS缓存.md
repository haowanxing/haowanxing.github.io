---
title: Mac OS(苹果电脑) 如何清空DNS缓存？
id: 177
categories:
  - 学习笔记
abbrlink: 24c6b55d
date: 2015-06-14 09:59:54
tags:
---

很多时候,因为域名的解析长时间未生效,我们无法通过域名访问刚刚解析的主机,最快的方法就是清空本地DNS缓存。
我们都知道,在Windows下面,想要清空本地dns缓存只需要执行一条CMD命令：
> ipconfig/flushdns
但是在使用苹果这样高大上的Mac系统的时候,就得用它独特的命令了。不过，不同的MAC系统版本命令也不一样！
Tiger或更低版本 Mac OS：
<pre lang="php" line="1" escaped="true">sudo lookupd -flushcache
</pre>
Leopard和Snow Leopard：
<pre lang="linux" line="1" escaped="true">sudo dscacheutil -flushcache
</pre>
而到了Lion、Mountain Lion和Mavericks：
<pre lang="linux" line="1" escaped="true">sudo killall -HUP mDNSResponder
</pre>
然后是Yosemite:
<pre lang="c" line="1" escaped="true">sudo discoveryutil mdnsflushcache

最后就到了EI Caption：

sudo dscacheutil -flushcache</pre>
另外，提一下，Linux下通用命令:
<pre lang="linux" line="1" escaped="true">sudo /etc/init.d/dns-clean start
</pre>