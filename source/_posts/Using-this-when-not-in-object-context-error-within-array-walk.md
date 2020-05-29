---
title: array_walk中的$this报错
abbrlink: 82527d05
date: 2017-04-14 16:46:59
tags:
categories: PHP
---

>Fatal Error:Using $this when not in object context on line 54

　　今天在完成一个小功能开发并提交SVN后，收到前端的求助，说是更新了我的代码后页面打不开了。很着急啊，我这里都是测试成功才提交版本的。现在只能麻溜的跑过查看了。

　　首先，出现的情况是空白页面（对，没有任何输出）。报错肯定没打开，帮他打开E_ALL后就看到了今天的重点报错提示了。说是在54行有个`$this`不在对象环境中？

　　然后我去看了，那个`$this`出现在array_walk方法的function中，从语句上来看是完全没有问题的，在类的方法里面用`$this`肯定没毛病啊，可是为什么他那里就报错呢？

　　我突然想起来，如果要在array_walk里面使用外面的变量的时候需要使用`use`方法。所以改进一下:

```
$user_id = $this->user->id;
array_walk($arr,function(&$v) use($user_id) {
	$v['user_id']=$user_id;
});
```

　　这样就没毛病了。看来这个`array_walk`还挺调皮啊，不得不说这个方法的使用还真有许多需要注意的地方呢。

　　通过查资料，得知这个$this在PHP版本低于5.4的情况下是会出现问题的。高版本的不会出现。

参考：[Using $this when not in object context error within array_walk](http://stackoverflow.com/questions/19033184/using-this-when-not-in-object-context-error-within-array-walk)