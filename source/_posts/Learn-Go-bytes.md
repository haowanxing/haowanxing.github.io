---
title: Go语言包-bytes
categories: Learn-GO
tags:
  - bytes
abbrlink: dab4275
date: 2018-11-27 14:45:01
---

> 一天一个Golang包，慢慢学习之“bytes”

今天学习bytes包，其实之前就已经使用了bytes包的很多方法了，这次主要就是再次熟悉和认识这个包里面的方法。

#### 阅读文档：

官方pkg地址：[https://golang.org/pkg/bytes/](https://golang.org/pkg/bytes/)

> 包方法

`func Compare(a, b []byte) int`
// 比较a和b两个字节数组。
// if a==b return 0;
// if a < b return -1;
// if a > b return 1;

```Go
	var a, b []byte
	a = []byte{65,66,67}
	b = []byte{65,66,67}
	fmt.Printf("%s, %s, %d\n", a, b, bytes.Compare(a, b))

	a = []byte{65,66,67}
	b = []byte{65,66,68}
	fmt.Printf("%s, %s, %d\n", a, b, bytes.Compare(a, b))

	a = []byte{65,66,67}
	b = []byte{65,66,66}
	fmt.Printf("%s, %s, %d\n", a, b, bytes.Compare(a, b))

	a = []byte{65,66,67}
	b = []byte{65,66,67,68}
	fmt.Printf("%s, %s, %d\n", a, b, bytes.Compare(a, b))

	a = []byte{65,66,67,68}
	b = []byte{65,66,67}
	fmt.Printf("%s, %s, %d\n", a, b, bytes.Compare(a, b))
	// ABC, ABC, 0
	// ABC, ABD, -1
	// ABC, ABB, 1
	// ABC, ABCD, -1
	// ABCD, ABC, 1
```
***

`func Contains(b, subslice []byte) bool`
// 检查subslice是不是包含在b中

```Go
	a := []byte{65, 66, 67, 68, 69, 70}
	b := []byte{65, 66, 67, 68, 69, 70}
	fmt.Printf("%s, %s, %v\n", a, b, bytes.Contains(a, b))

	b = []byte{65, 66, 67, 68, 69}
	fmt.Printf("%s, %s, %v\n", a, b, bytes.Contains(a, b))

	b = []byte{65, 66, 67, 68, 69, 70, 71}
	fmt.Printf("%s, %s, %v\n", a, b, bytes.Contains(a, b))

	b = []byte{66, 67, 68, 69, 70, 71}
	fmt.Printf("%s, %s, %v\n", a, b, bytes.Contains(a, b))
	// ABCDEF, ABCDEF, true
	// ABCDEF, ABCDE, true
	// ABCDEF, ABCDEFG, false
	// ABCDEF, BCDEFG, false
```
***

`func ContainsAny(b []byte, chars string) bool`
// 检查b中是否包含chars中的任意字符

```Go
	a := []byte{65, 66, 67, 68}
	fmt.Printf("%v\n", bytes.ContainsAny(a, "abcd") // false
	fmt.Printf("%v\n", bytes.ContainsAny(a, "a"))	// false
	fmt.Printf("%v\n", bytes.ContainsAny(a, "aB"))	// true
	fmt.Printf("%v\n", bytes.ContainsAny(a, "aBcd"))	// true
	fmt.Printf("%v\n", bytes.ContainsAny(a, "abcd ABC")) 	// true
```
***

`func ContainsRune(b []byte, r rune) bool`
// 判断b中是否包含r字符

```Go
	a := []byte{65, 66, 67 ,68}
	fmt.Printf("%v\n", bytes.ContainsRune(a, 'b'))	// false
	fmt.Printf("%v\n", bytes.ContainsRune(a, 'B'))	//true
```
***

`func Count(s, sep []byte) int`
// sep在s中的重复次数（sep不重叠），即s=ababab,sep=abab则返回1

```Go
	a := []byte("ababab")
	sep := []byte("ab")
	fmt.Printf("%d\n", bytes.Count(a, sep))	// 3
	sep = []byte("abab")
	fmt.Printf("%d\n", bytes.Count(a, sep))	// 1
```
***

`func Equal(a, b []byte) bool`
// 判断a和b是否相等，nil等同于[]byte()

```Go
	a := []byte("ABC")
	b := []byte{65, 66, 67}
	fmt.Printf("%s, %s, %v\n", a, b, bytes.Equal(a, b))	// ABC, ABC, true
	b = []byte{65 ,66}
	fmt.Printf("%s, %s, %v\n", a, b, bytes.Equal(a, b))	// ABC, AB, false
```
***

`func EqualFold(s, t []byte) bool`
// 判断s和t是否相似，忽略大小写和标题三种格式

```Go
	a := []byte("abc")
	b := []byte("ABC")
	fmt.Printf("%s, %s, %v\n", a, b, bytes.EqualFold(a, b))	// abc, ABC, true
	b = []byte("ABCC")
	fmt.Printf("%s, %s, %v\n", a, b, bytes.EqualFold(a, b))	// abc, ABCC, false
```
***

`func Fields(s []byte) [][]byte`
// 以连续空白为分隔符切割s成多个子串（不含分隔符）

```Go
	a := []byte("abc def  ABC  CBA")
	fmt.Printf("%s, %v\n", a, bytes.Fields(a))
	// abc def  ABC  CBA, [[97 98 99] [100 101 102] [65 66 67] [67 66 65]]
```
***

`func FieldsFunc(s []byte, f func(rune) bool) [][]byte`
// 以符合f方法的字符为分隔符切割s成多个子串（不含分隔符）

```Go
	f := func(r rune) bool { return r == '#'}
	a := []byte("This is # and @")
	fmt.Printf("%s, %q\n", a, bytes.FieldsFunc(a, f))	// This is # and @, ["This is " " and @"]
```
***

`func HasPrefix(s, prefix []byte) bool`
// 检测s字节切片是否以prefix开头

```Go
	s := []byte("Hello World!")
	prefix := []byte("hello")
	fmt.Printf("%s, %s, %v\n", s, prefix, bytes.HasPrefix(s, prefix))	// Hello World!, hello, false
	prefix = []byte("Hello")
	fmt.Printf("%s, %s, %v\n", s, prefix, bytes.HasPrefix(s, prefix))	// Hello World!, Hello, true
	prefix = []byte("")
	fmt.Printf("%s, %s, %v\n", s, prefix, bytes.HasPrefix(s, prefix))	// Hello World!, , true
```
***

`func HasSuffix(s, suffix []byte) bool`
// 检测s字节切片是否以suffix结尾

```Go
	s := []byte("Hello World!")
	suffix := []byte("world!")
	fmt.Printf("%s, %s, %v\n", s, suffix, bytes.HasSuffix(s, suffix))	// Hello World!, world!, false
	suffix = []byte("Hello World!")
	fmt.Printf("%s, %s, %v\n", s, suffix, bytes.HasSuffix(s, suffix))	// Hello World!, World!, true
	suffix = []byte("")
	fmt.Printf("%s, %s, %v\n", s, suffix, bytes.HasSuffix(s, suffix))	// Hello World!, , true
```
***

`func Index(s, sep []byte) int`
// 返回sep在s中的起始位置，如果sep不在s中则返回-1

```Go
	s := []byte("Hello World!")
	sep := []byte("Hello")
	fmt.Printf("'%s' of '%s' is %d\n", sep, s, bytes.Index(s, sep))	// 'Hello' of 'Hello World!' is 0
	sep = []byte("World")
	fmt.Printf("'%s' of '%s' is %d\n", sep, s, bytes.Index(s, sep))	// 'World' of 'Hello World!' is 6
	sep = []byte("Bob")
	fmt.Printf("'%s' of '%s' is %d\n", sep, s, bytes.Index(s, sep))	// 'Bob' of 'Hello World!' is -1
	sep = []byte("")
	fmt.Printf("'%s' of '%s' is %d\n", sep, s, bytes.Index(s, sep))	// '' of 'Hello World!' is 0
```
***

`func IndexAny(s []byte, chars string) int`
// 返回chars中任意字符在s中出现的第一个位置，chars为空或找不到则返回-1.

```Go
	s := []byte("Hello World!")
	chars := "abcdefg"
	fmt.Printf("%s, %s, %d\n", s, chars, bytes.IndexAny(s, chars))	// Hello World!, abcdefg, 1
	chars = "aabbcc"
	fmt.Printf("%s, %s, %d\n", s, chars, bytes.IndexAny(s, chars))	// Hello World!, aabbcc, -1
	chars = "abcd"
	fmt.Printf("%s, %s, %d\n", s, chars, bytes.IndexAny(s, chars))	// Hello World!, abcd, 10
	chars = ""
	fmt.Printf("%s, %s, %d\n", s, chars, bytes.IndexAny(s, chars))	// Hello World!, , -1
	chars = " "
	fmt.Printf("%s, %s, %d\n", s, chars, bytes.IndexAny(s, chars))	// Hello World!,  , 5
```
***

`func IndexByte(b []byte, c byte) int`
// 同Index，sep变为c字节

`func IndexFunc(s []byte, f func(r rune) bool) int`
// 返回符合f方法的字符首次出现的位置，找不到则返回-1

`func IndexRune(s []byte, r rune) int`
// 同Index，sep变为r字符

`func Join(s [][]byte, sep []byte) []byte`
// 以sep为连接符将子串列表连接成一个字节串

```Go
	s := [][]byte{{65,66},{67,68}}
	sep := []byte{124,124}
	fmt.Printf("%q, %s, %s\n", s, sep, bytes.Join(s, sep))	// ["AB" "CD"], ||, AB||CD
```
***

`func LastIndex(s, sep []byte) int`
`func LastIndexAny(s []byte, chars string) int`
`func LastIndexByte(s []byte, c byte) int`
`func LastIndexFunc(s []byte, f func(r rune) bool) int`
`func Map(mapping func(r rune) rune, s []byte) []byte`
`func Repeat(b []byte, count int) []byte`
`func Replace(s, old, new []byte, n int) []byte`
`func Runes(s []byte) []rune`
`func Split(s, sep []byte) [][]byte`
`func SplitAfter(s, sep []byte) [][]byte`
`func SplitAfterN(s, sep []byte, n int) [][]byte`
`func SplitN(s, sep []byte, n int) [][]byte`
`func Title(s []byte) []byte`
`func ToLower(s []byte) []byte`
`func ToLowerSpecial(c unicode.SpecialCase, s []byte) []byte`
`func ToTitle(s []byte) []byte`
`func ToTitleSpecial(c unicode.SpecialCase, s []byte) []byte`
`func ToUpper(s []byte) []byte`
`func ToUpperSpecial(c unicode.SpecialCase, s []byte) []byte`
`func Trim(s []byte, cutset string) []byte`
`func TrimFunc(s []byte, f func(r rune) bool) []byte`
`func TrimLeft(s []byte, cutset string) []byte`
`func TrimLeftFunc(s []byte, f func(r rune) bool) []byte`
`func TrimPrefix(s, prefix []byte) []byte`
`func TrimRight(s []byte, cutset string) []byte`
`func TrimRightFunc(s []byte, f func(r rune) bool) []byte`
`func TrimSpace(s []byte) []byte`
`func TrimSuffix(s, suffix []byte) []byte`

`func NewBuffer(buf []byte) *Buffer`
`func NewBufferString(s string) *Buffer`

`func NewReader(b []byte) *Reader`

***

> Buffer结构体

```Go
// A Buffer is a variable-sized buffer of bytes with Read and Write methods.
// The zero value for Buffer is an empty buffer ready to use.
type Buffer struct {
	buf       []byte   // contents are the bytes buf[off : len(buf)]
	off       int      // read at &buf[off], write at &buf[len(buf)]
	bootstrap [64]byte // memory to hold first slice; helps small buffers avoid allocation.
	lastRead  readOp   // last read operation, so that Unread* can work correctly.

	// FIXME: it would be advisable to align Buffer to cachelines to avoid false
	// sharing.
}
```
Buffer的方法：

`func (b *Buffer) Bytes() []byte`
`func (b *Buffer) Cap() int`
`func (b *Buffer) Grow(n int)`
`func (b *Buffer) Len() int`
`func (b *Buffer) Next(n int) []byte`
`func (b *Buffer) Read(p []byte) (n int, err error)`
`func (b *Buffer) ReadByte() (byte, error)`
`func (b *Buffer) ReadBytes(delim byte) (line []byte, err error)`
`func (b *Buffer) ReadFrom(r io.Reader) (n int64, err error)`
`func (b *Buffer) ReadRune() (r rune, size int, err error)`
`func (b *Buffer) ReadString(delim byte) (line string, err error)`
`func (b *Buffer) Reset()`
`func (b *Buffer) String() string`
`func (b *Buffer) Truncate(n int)`
`func (b *Buffer) UnreadByte() error`
`func (b *Buffer) UnreadRune() error`
`func (b *Buffer) Write(p []byte) (n int, err error)`
`func (b *Buffer) WriteByte(c byte) error`
`func (b *Buffer) WriteRune(r rune) (n int, err error)`
`func (b *Buffer) WriteString(s string) (n int, err error)`
`func (b *Buffer) WriteTo(w io.Writer) (n int64, err error)`

***

> Reader结构体

```Go
// A Reader implements the io.Reader, io.ReaderAt, io.WriterTo, io.Seeker,
// io.ByteScanner, and io.RuneScanner interfaces by reading from
// a byte slice.
// Unlike a Buffer, a Reader is read-only and supports seeking.
type Reader struct {
	s        []byte
	i        int64 // current reading index
	prevRune int   // index of previous rune; or < 0
}
```

Reader的方法：

`func (r *Reader) Len() int`
`func (r *Reader) Read(b []byte) (n int, err error)`
`func (r *Reader) ReadAt(b []byte, off int64) (n int, err error)`
`func (r *Reader) ReadByte() (byte, error)`
`func (r *Reader) ReadRune() (ch rune, size int, err error)`
`func (r *Reader) Reset(b []byte)`
`func (r *Reader) Seek(offset int64, whence int) (int64, error)`
`func (r *Reader) Size() int64`
`func (r *Reader) UnreadByte() error`
`func (r *Reader) UnreadRune() error`
`func (r *Reader) WriteTo(w io.Writer) (n int64, err error)`
