---
title: Linux上vi(vim)编辑器使用教程 - 转载
id: 118
categories:
  - Linxu分享
abbrlink: 1beb1f62
date: 2014-11-29 23:29:48
tags:
---

vi(vim)是上Linux非常常用的编辑器，很多Linux发行版都默认安装了vi(vim)。vi(vim)命令繁多但是如果使用灵活之后将会大大提高效率。vi是“visual interface”的缩写，vim是vi IMproved(增强版的vi)。在一般的系统管理维护中vi就够用，如果想使用代码加亮的话可以使用vim。下面vps侦探整理一下vi的使用教程：包含vi的基本介绍、使用模式、文件的打开关闭保存、插入文本或新建行、移动光标、删除、恢复字符或行、搜索等等，算是一篇比较适合新手学习vi的教程。

vi有3个模式：插入模式、命令模式、低行模式。

    插入模式：在此模式下可以输入字符，按ESC将回到命令模式。
    命令模式：可以移动光标、删除字符等。
    低行模式：可以保存文件、退出vi、设置vi、查找等功能(低行模式也可以看作是命令模式里的)。

一、打开文件、保存、关闭文件(vi命令模式下使用)
<pre lang="ruby" line="1" escaped="true">
vi filename       //打开filename文件
:w       //保存文件
:w vpser.net //保存至vpser.net文件
:q          //退出编辑器，如果文件已修改请使用下面的命令
:q!        //退出编辑器，且不保存
:wq         //退出编辑器，且保存文件
</pre>

二、插入文本或行(vi命令模式下使用，执行下面命令后将进入插入模式，按ESC键可退出插入模式)
<pre lang="bash" line="1" escaped="true">

a      //在当前光标位置的右边添加文本
i       //在当前光标位置的左边添加文本
A     //在当前行的末尾位置添加文本
I      //在当前行的开始处添加文本(非空字符的行首)
O     //在当前行的上面新建一行
o     //在当前行的下面新建一行
R    //替换(覆盖)当前光标位置及后面的若干文本
J    //合并光标所在行及下一行为一行(依然在命令模式)
</pre>

三、移动光标(vi命令模式下使用)

1、使用上下左右方向键

2、命令模式下：h   向左、j   向下 、k   向上、l  向右。
空格键 向右、Backspace  向左、Enter  移动到下一行首、-  移动到上一行首。
四、删除、恢复字符或行(vi命令模式下使用)
<pre lang="apache" line="1" escaped="true">

x         //删除当前字符
nx         //删除从光标开始的n个字符
dd      //删除当前行
ndd   //向下删除当前行在内的n行
u       //撤销上一步操作
U      //撤销对当前行的所有操作
</pre>

五、搜索(vi命令模式下使用)
<pre lang="ruby" line="1" escaped="true">

/vpser     //向光标下搜索vpser字符串
?vpser     //向光标上搜索vpser字符串
n           //向下搜索前一个搜素动作
N         //向上搜索前一个搜索动作
</pre>

六、跳至指定行(vi命令模式下使用)
<pre lang="ruby" line="1" escaped="true">

n+        //向下跳n行
n-         //向上跳n行
nG        //跳到行号为n的行
G           //跳至文件的底部
</pre>

七、设置行号(vi命令模式下使用)
<pre lang="ruby" line="1" escaped="true">

:set  nu     //显示行号
:set nonu    //取消显示行号
</pre>

八、复制、粘贴(vi命令模式下使用)
<pre lang="ruby" line="1" escaped="true">

yy    //将当前行复制到缓存区，也可以用 "ayy 复制，"a 为缓冲区，a也可以替换为a到z的任意字母，可以完成多个复制任务。
nyy   //将当前行向下n行复制到缓冲区，也可以用 "anyy 复制，"a 为缓冲区，a也可以替换为a到z的任意字母，可以完成多个复制任务。
yw    //复制从光标开始到词尾的字符。
nyw   //复制从光标开始的n个单词。
y^      //复制从光标到行首的内容。  VPS侦探
y$      //复制从光标到行尾的内容。
p        //粘贴剪切板里的内容在光标后，如果使用了前面的自定义缓冲区，建议使用"ap 进行粘贴。
P        //粘贴剪切板里的内容在光标前，如果使用了前面的自定义缓冲区，建议使用"aP 进行粘贴。
</pre>

九、替换(vi命令模式下使用)
<pre lang="ruby" line="1" escaped="true">

:s/old/new      //用new替换行中首次出现的old
:s/old/new/g         //用new替换行中所有的old
:n,m s/old/new/g     //用new替换从n到m行里所有的old
:%s/old/new/g      //用new替换当前文件里所有的old
</pre>

十、编辑其他文件
<pre lang="ruby" line="1" escaped="true">
:e otherfilename    //编辑文件名为otherfilename的文件。
</pre>

十一、修改文件格式
<pre lang="ruby" line="1" escaped="true">
:set fileformat=unix   //将文件修改为unix格式，如win下面的文本文件在linux下会出现^M。
</pre>

总结：vi(vim)教程虽然有比较多的命令，但是只要勤加练习，相信你会很快的熟练掌握，同时也会给你的工作或学习带来更高的效率。当如果不知道自己处在什么模式时可以按2次Esc键即可回到命令模式，会有最后提醒一点：注意大小写！！！
文章来源：[Linux上vi(vim)编辑器使用教程 - VPS侦探](http://www.vpser.net/manage/vi.html).