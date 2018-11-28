---
title: Go语言包-path
categories: Learn-GO
tags:
  - path
abbrlink: 66c90df8
date: 2018-11-28 17:08:15
---

> 一天一个Golang包，慢慢学习之“path”

上一篇学习了[bytes包](./dab4275.html)，内容还是有点多，花的时间也多了一点。所以今天补充点小内容-path包。当然，path还有子包：filepath，这个下次再继续。

#### 阅读文档：

官方pkg地址：[https://golang.org/pkg/path/](https://golang.org/pkg/path/)

> 包方法

`func Base(path string) string`
// 返回最后一个元素（目录或文件）的路径

```Go
	fmt.Println(path.Base("/a/b/"))	// b
	fmt.Println(path.Base("/a/b"))		// b
	fmt.Println(path.Base("./a/b"))	// b
	fmt.Println(path.Base("../a/b"))	// b
	fmt.Println(path.Base("/"))		// /
	fmt.Println(path.Base("./"))		// .
	fmt.Println(path.Base("."))		// .
	fmt.Println(path.Base(""))			// .
```
***

`func Clean(path string) string`
// 返回最洁净的路径，在path比较复杂的情况下使用，可以简化path。

```Go
	paths := []string{
		"a/c",
		"a//c",
		"a/c/.",
		"a/c/b/..",
		"/../a/c",
		"/../a/b/../././/c",
		"",
	}
	for _, p := range paths {
		fmt.Printf("Clean(%q) = %q\n", p, path.Clean(p))
	}
	// Clean("a/c") = "a/c"
	// Clean("a//c") = "a/c"
	// Clean("a/c/.") = "a/c"
	// Clean("a/c/b/..") = "a/c"
	// Clean("/../a/c") = "/a/c"
	// Clean("/../a/b/../././/c") = "/a/c"
	// Clean("") = "."
```
***

`func Dir(path string) string`
// 返回元素（目录或文件）的目录路径

```Go
	fmt.Println(path.Dir("/a/b/c"))	// /a/b
	fmt.Println(path.Dir("a/b/c"))		// a/b
	fmt.Println(path.Dir("/a/"))		// /a
	fmt.Println(path.Dir("a/"))		// a
	fmt.Println(path.Dir("/"))			// /
	fmt.Println(path.Dir(""))			// .
```
***

`func Ext(path string) string`
// 返回path下文件名的后缀

```Go
	fmt.Println(path.Ext("/a/b/c/bar.css"))	// .css
	fmt.Println(path.Ext("/a/b/c/bar.tar.gz"))	// .gz
	fmt.Println(path.Ext("/"))					//
	fmt.Println(path.Ext(""))					//
```
***

`func IsAbs(path string) bool`
// 判断path是否是绝对路径

```Go
	fmt.Println(path.IsAbs("/dev/null"))	// true
	fmt.Println(path.IsAbs("dev/null"))	// false
	fmt.Println(path.IsAbs("./dev/null"))	// false
```
***

`func Join(elem ...string) string`
// 将多个路径元素连接成一个，空元素会被忽略。

```Go
	fmt.Println(path.Join("a", "b", "c"))	// a/b/c
	fmt.Println(path.Join("a", "b/c"))	// a/b/c
	fmt.Println(path.Join("a/b", "c"))	// a/b/c
	fmt.Println(path.Join("", ""))		//
	fmt.Println(path.Join("a", ""))		// a
	fmt.Println(path.Join("", "a"))		// a
```
***

`func Match(pattern, name string) (matched bool, err error)`
// 判断name是否符合pattern规则，并返回err

```Go
// pattern:
// { term }
// term:
//	'*'         matches any sequence of non-/ characters
//	'?'         matches any single non-/ character
//	'[' [ '^' ] { character-range } ']'
//	            character class (must be non-empty)
//	c           matches character c (c != '*', '?', '\\', '[')
//	'\\' c      matches character c

// character-range:
//	c           matches character c (c != '\\', '-', ']')
//	'\\' c      matches character c
//	lo '-' hi   matches character c for lo <= c <= hi

	fmt.Println(path.Match("abc", "abc"))			// true <nil>
	fmt.Println(path.Match("a*", "abc"))			// true <nil>
	fmt.Println(path.Match("a*d", "abcd"))		// true <nil>
	fmt.Println(path.Match("a*/b", "a/c/b"))		// false <nil>
	fmt.Println(path.Match("a/[a-f]/b", "a/c/b"))	// true <nil>
```
***

`func Split(path string) (dir, file string)`
// 返回path的目录和文件名

```Go
	fmt.Println(path.Split("static/myfile.css"))	// static/ myfile.css
	fmt.Println(path.Split("myfile.css"))			//  myfile.css
	fmt.Println(path.Split(""))	//
```
***

#### 子包：filepath

下一篇来学习：[path/filepath](./xxxxx.html)


