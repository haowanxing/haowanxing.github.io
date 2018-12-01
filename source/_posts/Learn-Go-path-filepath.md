---
title: Go语言包-path/filepath
categories: Learn-GO
tags:
  - path
  - filepath
abbrlink: 6ac47315
date: 2018-11-29 10:30:23
---

> 一天一个Golang包，慢慢学习之“path/filepath”

上一篇学习了[path包](./66c90df8.html)，了解了几个对路径处理的方法。今天继续完成它的子包“filepath”，包中的函数会根据不同平台做不同的处理，如路径分隔符、卷名等。

#### 阅读文档：

官方pkg地址：[https://golang.org/pkg/path/filepath](https://golang.org/pkg/path/filepath)

> 包方法

`func Base(path string) string`
`func Clean(path string) string`
`func Dir(path string) string`
`func Ext(path string) string`
`func IsAbs(path string) bool`
`func Join(elem ...string) string`
`func Match(pattern, name string) (matched bool, err error)`
`func Split(path string) (dir, file string)`
// 以上8种方法跟path包同名方法功能类似

<!---more--->

***

`func Abs(path string) (string, error)`
// 返回相对当前路径的path的绝对路径

```Go
	fmt.Println(filepath.Abs(""))
	fmt.Println(filepath.Abs("name.txt"))
	fmt.Println(filepath.Abs("/name.txt"))
	fmt.Println(filepath.Abs("../name.txt"))
	fmt.Println(filepath.Abs("~/../name.txt"))
	/*
	/Users/anthony/Workspaces/GoLand/src/application/learn/path/filepath <nil>
	/Users/anthony/Workspaces/GoLand/src/application/learn/path/filepath/name.txt <nil>
	/name.txt <nil>
	/Users/anthony/Workspaces/GoLand/src/application/learn/path/name.txt <nil>
	/Users/anthony/Workspaces/GoLand/src/application/learn/path/filepath/name.txt <nil>
	*/
```
***

`func EvalSymlinks(path string) (string, error)`
// 返回Path的实际路径（如果path是个软链接的话）

```Go
	fmt.Println(filepath.EvalSymlinks("/etc"))		// /private/etc <nil>
	fmt.Println(filepath.EvalSymlinks("/usr/local"))// /usr/local <nil>
```
***

`func ToSlash(path string) string`
`func FromSlash(path string) string`
// 以上两种方法作主要用于Windows平台。
// 将path中的平台相关的路径分隔符(或'/')转换为'/'(或平台相关的路径分隔符)
***

`func Glob(pattern string) (matches []string, err error)`
// 列出与指定模式pattern完全匹配的文件或目录，匹配原则同Match一样。

```Go
	fmt.Println(filepath.Glob("/usr/*"))
	// [/usr/bin /usr/include /usr/lib /usr/libexec /usr/local /usr/sbin /usr/share /usr/standalone] <nil>
```
***

`func HasPrefix(p, prefix string) bool`
// 该方法已弃用，不再被建议使用。
***

`func Rel(basepath, targpath string) (string, error)`
// 返回targpath相对于basepath的路径。
// 要求二者必须同为“相对路径”或“绝对路径”

```Go
	fmt.Println(filepath.Rel("/usr/local","/usr/local/bin/go"))			// bin/go <nil>
	fmt.Println(filepath.Rel("/usr/local","/usr/local/../local/bin/go"))// bin/go <nil>
	fmt.Println(filepath.Rel("/usr/local","/usr/bin/go"))				// ../bin/go <nil>
	fmt.Println(filepath.Rel("/usr/local","/"))							// ../.. <nil>
```
***

`func SplitList(path string) []string`
// 将路径序列path分割为多条独立路径。
// path类似Unix/Linux下的环境变量PATH。

```Go
	fmt.Printf("%q\n", filepath.SplitList("/bin:/sbin:/usr/bin:/usr/sbin  : /usr/local/bin"))
	// ["/bin" "/sbin" "/usr/bin" "/usr/sbin  " " /usr/local/bin"]
```
***

`func VolumeName(path string) string`
// 返回路径字符中的卷名
// Windows 中的 `C:\Windows` 会返回"C:"
// Linux 中的 `//dev/host/dir` 会返回 `//dev/host`
***

`func Walk(root string, walkFn WalkFunc) error`
// 遍历指定目录root（包括子目录），对遍历到的项目用walkFn函数进行处理。
// walkFn返回nil，则walkFn继续遍历，如果返回SkipDir，则Walk函数跳过当前目录，继续遍历下一目录。
// 如果返回其他错误，则Walk函数终止。
// 在Walk遍历过程中，如遇到错误，则会将错误通过err传递给walkFn，同时跳过出错的项目，继续处理后续项目。

```Go
	// 打印目录及目录下所有文件及大小
	fn := func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		fmt.Printf("%q, %q, %d\n", path, info.Name(), info.Size())
		return nil
	}

	filepath.Walk("/Users/anthony/Downloads/conf", fn)
	/*
		"/Users/anthony/Downloads/conf", "conf", 224
		"/Users/anthony/Downloads/conf/0x4f5da2.cn.key", "0x4f5da2.cn.key", 1700
		"/Users/anthony/Downloads/conf/0x4f5da2.cn_bundle.crt", "0x4f5da2.cn_bundle.crt", 3323
		"/Users/anthony/Downloads/conf/world.cert.key.pem", "world.cert.key.pem", 1675
		"/Users/anthony/Downloads/conf/world.dev.bundle.crt", "world.dev.bundle.crt", 2802
		"/Users/anthony/Downloads/conf/world.local.bundle.crt", "world.local.bundle.crt", 2863
	*/

	// WalkFunc 函数：
	// 列出含有 *.txt 文件的目录（不是全部，因为会跳过一些子目录）
	findTxtDir := func(path string, info os.FileInfo, err error) error {
		ok, err := filepath.Match(`*.txt`, info.Name())
		if ok {
			fmt.Println(filepath.Dir(path), info.Name())
			// 遇到 txt 文件则继续处理所在目录的下一个目录
			// 注意会跳过子目录
			return filepath.SkipDir
		}
		return err
	}
	// 列出含有 *.txt 文件的目录（不是全部，因为会跳过一些子目录）
	err := filepath.Walk(`/usr`, findTxtDir)
	fmt.Println(err)
	/*
	/usr/local/Cellar/chromaprint/1.4.3 NEWS.txt
	/usr/local/Cellar/fontconfig/2.13.1/share/doc/fontconfig fontconfig-devel.txt
	/usr/local/Cellar/frei0r/1.6.1 AUTHORS.txt
	/usr/local/Cellar/game-music-emu/0.6.2 changes.txt
	...
	<nil>
	*/

	// WalkFunc 函数：
	// 列出所有以 ab 开头的目录（全部，因为没有跳过任何项目）
	findabDir := func(path string, info os.FileInfo, err error) error {
		if info.IsDir() {
			ok, err := filepath.Match(`[aA][bB]*`, info.Name())
			if err != nil {
				return err
			}
			if ok {
				fmt.Println(path)
			}
		}
		return nil
	}
	// 列出所有以 ab 开头的目录（全部，因为没有跳过任何项目）
	err = filepath.Walk(`/usr`, findabDir)
	fmt.Println(err)
	/*
	/usr/local/Cellar/node/11.0.0/libexec/lib/node_modules/npm/node_modules/abbrev
	/usr/local/Homebrew/Library/Taps/homebrew/homebrew-services/.git/objects/ab
	/usr/local/lib/node_modules/gulp/node_modules/resolve/test/dotdot/abc
	/usr/local/lib/node_modules/hexo-cli/node_modules/abbrev
	...
	<nil>
	*/

```
***



