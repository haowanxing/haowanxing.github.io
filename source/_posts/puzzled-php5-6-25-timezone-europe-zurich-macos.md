---
title: PHP时区默认为Europe/zurich且修改php.ini无效的困惑
tags:
  - php困惑
categories:
  - PHP
abbrlink: b9f89962
date: 2017-03-21 17:03:57
---

> 为何我的date("Y/m/d H:i:s")相差了7个小时？

`环境：MacOS X EI Capitan / PHP5.6.25`

　　今天在校验Crontab的计划执行时，利用PHP输出执行时间却发现输出的时间和当地事件相差了7个小时，对！是7不是8，并不是默认的UTC，呵呵了～

　　好吧，一贯思路，我去把php.ini中的`date.timezone`修改成`PRC`。嗯，肯定正常了吧。

　　要能正常我也不会写本文了^_~!

　　不论是修改成`PRC`还是`Asia/Shanghai`又或者`UTC`，全都未然。
　　
***

1. apache输出phpinfo()，查看date区域它的Default Timezone还是没变。
![Phpinfo的date区域](https://ooo.0o0.ooo/2017/03/21/58d0f0703d97a.png)
2. 在控制台查看`php -i | grep zone`也还是同样没变
![控制台输出timezone](https://ooo.0o0.ooo/2017/03/21/58d0f0feb930b.png)
3. 核对加载的php.ini文件是否正确并且配置信息格式是否正确
![](https://ooo.0o0.ooo/2017/03/21/58d0f15632504.png)
![](https://ooo.0o0.ooo/2017/03/21/58d0f17079823.png)
4. 控制台使用`php -a`交互模式，调用`ini_get('date.timezone')`，检查配置的INI是否生效
![](https://ooo.0o0.ooo/2017/03/21/58d0f6227df7c.png)

　　全都没有任何问题啊！！！为什么结果却出乎意料呢？？百度，谷歌我都问遍了，大家没人出现我这样的情况啊。正当我发愁的时候，小伙伴过来给我支招了。

<!--more-->

　　他说：配置文件改好了吗？服务器重启了吗？修改的配置文件的路径是正确的吗？

　　我说：Yes，对呀，没问题，好奇怪啊！(正在期待他给出我没想到的情况)，突然他说，你看看是不是其他地方也设置了这个值。

　　我一脸肯定地告诉他其他的INI都是扩展配置（其实内心并不是很确定），虽然扩展配置的INI文件特别多，一个一个查特别麻烦，但为了解决问题不能放过任何一个可能性啊。

　　打住，我可没有一个一个文件的去查！一条命令拯救了我：`find /usr/local/php5/ -name "*.ini" -print |
 xargs grep "Europe"`，解释：在PHP5根目录中查找所有的INI文件，并输出文件内容包含'Europe'的文件名+所在行。

　　那啥不负有心人啊，看结果看结果！！![查找文件内容](https://ooo.0o0.ooo/2017/03/21/58d0f3b1c7a11.png)

　　果然这不是一个扩展配置INI，屏蔽掉它的配置！![](https://ooo.0o0.ooo/2017/03/21/58d0f3f720b40.png)

　　验证通过！！！原来就是这个文件搞的鬼。这个文件是为MacOS适配PHP5的作者弄的，并非扩展配置。或许我没仔细看他的说明吧，怪我咯。哈哈哈～