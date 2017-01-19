---
title: Learning-Markdown
date: 2017-01-19 16:57:03
tags: 
 - 随笔
 - MarkDown
categories: 我的分享
---
# MarkDown的学习
> 这里面就是一些简单的MarkDown语法，提供给我自己看一下，刚开始还是需要不断练习来接受这种语法，必然能够在码字的过程中体验乐趣！

下面开始啦：

<!--more-->
## 引用
> 这里就是引用

一个>符号就是引用
## 文字
**两个\*包围是粗体** *一个\*包围是斜体*
## 列表
### 一个* 是无序列表

* 第一行内容
* 第二行内容
* 第三行内容

### 序号加.是 有序列表

1. 有序列表1
2. 有序列表2
3. 有序列表3

## 表格

	|表格   |名字   |值   |
	|------|:-----:|---:|
	|测试|Anthony|$30|
	|测试|Anthony|$30|

|表格   |名字   |值   |
|------|:-----:|---:|
|测试|Anthony|$30|
|测试|Anthony|$30|

## 图片与超链接

	超链接：[点我跳转吧](http://www.imsry.cn)

	图片：
	![一张图片](http://img.cm-soft.cn/2017011975502me.png)

超链接：[点我跳转吧](http://www.imsry.cn)````

图片：
![一张图片](http://img.cm-soft.cn/2017011975502me.png)

## 代码测试

代码可以用三个`或者直接缩进一个tab

```
int main(int argc, const char * argv[]) {
	int n;
    double capital,deposit;
    printf("please input n and capital:");
    scanf("%d,%lf",&n,&capital);
    printf("n:%d and capital:%lf\n",n,capital);
    if(n>=0&&capital>=0){
        deposit = capital+capital*n*rate;
    }
    printf("%lf",deposit);
    return 0;
}
```