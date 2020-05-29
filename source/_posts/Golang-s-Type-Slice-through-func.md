---
title: Go语言中的切片(Slice)是引用类型还是值类型？
tags: Golang
abbrlink: d83c494c
date: 2018-05-31 14:51:10
categories: 编程语言
---

在最近的学习和实践中，照着别人的代码敲，仅仅只是把别人写在方法内的片段直接拿出来用，结果却出人意料，所以很纳闷！

示例代码：

```Go
func CryptBlocks(dst, src []byte) {
	// ...省略内容
	for len(src) > 0 {
		encrypt(dst, src[:16]) //类似copy
		dst = dst[16:]
		src = src[16:]
	}
}
```
这个分块处理切片数据的方法很巧妙，我第一次看见的时候（认定切片是传引用），认为这个方法错了，最终dst变成了空切片。

先看一个Slice的例子：

```Go
package main

import(
    "fmt"
)

func main () {
    var slice []int
    slice = make([]int, 6)
    slice = []int{0,1,2,3,4,5}
    fmt.Println("Slice: ",slice)
    changeSlice(slice)
    fmt.Println("Changed Slice: ", slice)
    
}

func changeSlice(s []int) {
    s[2] = 100
}
```

输出：

```
Slice:  [0 1 2 3 4 5]
Changed Slice:  [0 1 100 3 4 5]
```

我们会发现，在方法changeSlice中对形参的修改即真实修改。如果这时我们将其定性为引用传值，为之过早！

我们将代码稍微修改一下：

```Go
package main

import(
    "fmt"
)

func main () {
    var slice []int
    slice = make([]int, 6)
    slice = []int{0,1,2,3,4,5}
    fmt.Printf("SliceAddr: %p , Slice: %v\r\n",&slice, slice)
    changeSlice(slice)
    fmt.Printf("Changed SliceAddr: %p , Changed Slice: %v\r\n", &slice, slice)
    
}

func changeSlice(s []int) {
    fmt.Printf("In func's sliceAddr: %p\r\n", s)
    s[2] = 100
}
```

输出：

```
SliceAddr: 0xc82000e0a0 , Slice: [0 1 2 3 4 5]
In func's sliceAddr: 0xc8200460c0
Changed SliceAddr: 0xc82000e0a0 , Changed Slice: [0 1 100 3 4 5]
```

由此可见，在方法内的那个s（地址：0xc8200460c0）并非传入的那个slice（地址：0xc82000e0a0），但是为什么它的修改能影响到原来的数据呢？

<!--more-->

原因是Golang中的Slice类型在创建的时候，可以理解为：创建一个新的变量，存储数组中的一个片段的数据，虽然自己是一个新的变量，有自己的内存地址，但是内部的数据确实共享的以前的底层数据。

我们在做一个尝试：

```Go
package main

import(
    "fmt"
)

func main () {
    var slice []int
    slice = make([]int, 7)
    slice = []int{0,1,2,3,4,5,6}
    fmt.Printf("Slice addr: %p\r\n", &slice)
    for i, v := range slice {
        fmt.Printf("i: %d , v: %d , addr: %p\r\n", i, v ,&slice[i])
    }
    changeSlice(slice)
    
}

func changeSlice(s []int) {
    fmt.Printf("In func Slice addr: %p\r\n", &s)
    s[2] = 100
    for i, v := range s {
        fmt.Printf("i: %d , v: %d , addr: %p\r\n", i, v ,&s[i])
    }
}
```

输出：

```
Slice addr: 0xc82000e0a0
i: 0 , v: 0 , addr: 0xc82003a140
i: 1 , v: 1 , addr: 0xc82003a148
i: 2 , v: 2 , addr: 0xc82003a150
i: 3 , v: 3 , addr: 0xc82003a158
i: 4 , v: 4 , addr: 0xc82003a160
i: 5 , v: 5 , addr: 0xc82003a168
i: 6 , v: 6 , addr: 0xc82003a170
In func Slice addr: 0xc82000e0e0
i: 0 , v: 0 , addr: 0xc82003a140
i: 1 , v: 1 , addr: 0xc82003a148
i: 2 , v: 100 , addr: 0xc82003a150
i: 3 , v: 3 , addr: 0xc82003a158
i: 4 , v: 4 , addr: 0xc82003a160
i: 5 , v: 5 , addr: 0xc82003a168
i: 6 , v: 6 , addr: 0xc82003a170
```

可以看出，切片内部存储是内容其实是同一块内存，被共享的数据，而切片自己却拥有自己的地址。

所以说，Golang的基本类型都是传值，还是没错的。

> 参考内容

* [Golang 切片与函数参数“陷阱”](https://studygolang.com/articles/9876)