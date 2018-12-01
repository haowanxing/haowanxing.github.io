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
<!---more--->

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
***

`func IndexFunc(s []byte, f func(r rune) bool) int`
// 返回符合f方法的字符首次出现的位置，找不到则返回-1
***

`func IndexRune(s []byte, r rune) int`
// 同Index，sep变为r字符
***

`func Join(s [][]byte, sep []byte) []byte`
// 以sep为连接符将子串列表连接成一个字节串

```Go
	s := [][]byte{{65,66},{67,68}}
	sep := []byte{124,124}
	fmt.Printf("%q, %s, %s\n", s, sep, bytes.Join(s, sep))	// ["AB" "CD"], ||, AB||CD
```
***

`func LastIndex(s, sep []byte) int`
// 查找s中最后一次出现sep的位置，找不到返回-1
```Go
	s := []byte("abcddabcd")
	sep := []byte("abc")
	fmt.Printf("%s, %s, %d\n", s, sep, bytes.LastIndex(s, sep))	// abcddabcd, abc, 5
	sep = []byte("bcd")
	fmt.Printf("%s, %s, %d\n", s, sep, bytes.LastIndex(s, sep))	// abcddabcd, bcd, 6
	sep = []byte("")
	fmt.Printf("%s, %s, %d\n", s, sep, bytes.LastIndex(s, sep))	// abcddabcd, , 9
```
***

`func LastIndexAny(s []byte, chars string) int`
// 查找s中最后一次出现chars中任意字符的位置，找不到返回-1
***

`func LastIndexByte(s []byte, c byte) int`
// 查找s中最后一次出现c字节的位置，找不到返回-1
***

`func LastIndexFunc(s []byte, f func(r rune) bool) int`
// 查找s中符合f方法的字符位置，找不到返回-1
***

`func Map(mapping func(r rune) rune, s []byte) []byte`
// 将s中的r替换成mapping(r)返回的字符，如果mapping返回负值，则丢弃

```Go
rot13 := func(r rune) rune {
		switch {
		case r >= 'A' && r <= 'Z':
			return 'A' + (r-'A'+13)%26
		case r >= 'a' && r <= 'z':
			return 'a' + (r-'a'+13)%26
		}
		return r
	}
	fmt.Printf("%s\n", bytes.Map(rot13, []byte("'Twas brillig and the slithy gopher...")))
	// 'Gjnf oevyyvt naq gur fyvgul tbcure...
```
***

`func Repeat(b []byte, count int) []byte`
// 返回子串b重复count次后的串

```Go
	fmt.Printf("%s\n", bytes.Repeat([]byte("Abc"), 3))	// AbcAbcAbc
```
***

`func Replace(s, old, new []byte, n int) []byte`
// 将s中的前n个old替换成new，如果n<0则替换全部

```Go
	s := []byte("Bob takes you to Bob's house.")
	fmt.Printf("%s\n", bytes.Replace(s, []byte("Bob"), []byte("Lily"), 0))	// Bob takes you to Bob's house.
	fmt.Printf("%s\n", bytes.Replace(s, []byte("Bob"), []byte("Lily"), 1))	// Lily takes you to Bob's house.
	fmt.Printf("%s\n", bytes.Replace(s, []byte("Bob"), []byte("Lily"), -1))	// Lily takes you to Lily's house.
```
***

`func Runes(s []byte) []rune`
// 将s转换成[]rune型
***

`func Split(s, sep []byte) [][]byte`
// 以sep作为分隔符将s拆分成多个子串。
// 如果sep为空，则将s拆分成Unicode字符列表
***

`func SplitN(s, sep []byte, n int) [][]byte`
// 同Split，但可指定拆分次数n，超出n的部分不进行拆分
***

`func SplitAfter(s, sep []byte) [][]byte`
// 同Split，但是每个子串都包含分隔符sep
***

`func SplitAfterN(s, sep []byte, n int) [][]byte`
// 同SplitAfter，但可指定拆分次数n。
***

`func Title(s []byte) []byte`
// 将s中所有单词的首字符修改为Title格式返回
// Bug: 不能很好的处理Unicode标点符号分隔的单词。
***

`func ToLower(s []byte) []byte`
// 将s中的字符全部替换成小写并返回
***

`func ToUpper(s []byte) []byte`
// 将s中的字符全部替换成大小并返回
***

`func ToTitle(s []byte) []byte`
// 将s中的字符全部替换成标题并返回
***

`func ToLowerSpecial(c unicode.SpecialCase, s []byte) []byte`
// 使用指定的映射表将 s 中的所有字符修改为小写格式返回。
***

`func ToUpperSpecial(c unicode.SpecialCase, s []byte) []byte`
// 使用指定的映射表将 s 中的所有字符修改为大写格式返回。
***

`func ToTitleSpecial(c unicode.SpecialCase, s []byte) []byte`
// 使用指定的映射表将 s 中的所有字符修改为标题格式返回。
***

`func Trim(s []byte, cutset string) []byte`
`func TrimLeft(s []byte, cutset string) []byte`
`func TrimRight(s []byte, cutset string) []byte`
// 以上方法返回去掉s两边（左边、右边）包含在cutset中字符的切片
***

`func TrimFunc(s []byte, f func(r rune) bool) []byte`
`func TrimLeftFunc(s []byte, f func(r rune) bool) []byte`
`func TrimRightFunc(s []byte, f func(r rune) bool) []byte`
// 以上方法返回去掉s两边（左边、右边）符合f方法字符的切片
***

`func TrimPrefix(s, prefix []byte) []byte`
// 去掉s的前缀prefix
***

`func TrimSuffix(s, suffix []byte) []byte`
// 去掉s的后缀suffix
***

`func TrimSpace(s []byte) []byte`
// 去掉两边的空白
***

`func NewBuffer(buf []byte) *Buffer`
// 将buf包装成bytes.Buffer对象
***

`func NewBufferString(s string) *Buffer`
// 将s转换成[]byte后，包装成bytes.Buffer对象
***

`func NewReader(b []byte) *Reader`
// 将b包装成bytes.Reader对象
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
// 引用未读取部分的数据切片（不移动读取位置）
***

`func (b *Buffer) Cap() int`
// 返回缓冲区容量
***

`func (b *Buffer) Grow(n int)`
// 自动增加缓存容量，以保证有n字节的剩余空间
// 如果n<0或者无法增加容量则会报Panic
***

`func (b *Buffer) Len() int`
// 返回未读缓冲区的字节长度，b.Len()==len(b.Bytes())
***

`func (b *Buffer) Next(n int) []byte`
// 返回缓冲区中的下n个字节数据的切片，并推进读取位置（类似于返回的字节数据已经被读取）。
// 如果n大于缓冲区长度，则返回整个缓冲区数据。
// 返回的切片仅在下一次调用Read或Write方法前有效。
***

`func (b *Buffer) Read(p []byte) (n int, err error)`
// 从缓冲区读取len(p)个字节或整个缓冲区到p中，返回读取的字节数n，如果没有数据可返回，则err=io.EOF。
***

`func (b *Buffer) ReadByte() (byte, error)`
// 从缓冲区读取一个字节并返回，如果没有可返回的数据，err=io.EOF。
***

`func (b *Buffer) ReadBytes(delim byte) (line []byte, err error)`
// 从缓存中读取数据直到遇到delim时停止并返回包含delim的切片。
// 如果期间遇到错误，则返回遇到错误之前读取的数据并返回err。
***

`func (b *Buffer) ReadFrom(r io.Reader) (n int64, err error)`
// 从r中读取数据直到遇到EOF并且写入缓存区，必要时会增大缓存。
// 返回读取到的字节数量n，遇到除了EOF的其他错误也会返回结果。
// 如果缓存变的太大将会报一个ErrTooLarge的Panic错误。
***

`func (b *Buffer) ReadRune() (r rune, size int, err error)`
// 从缓存中读取并返回下一个UTF8编码字符，没有合适的字节则返回io.EOF。
***

`func (b *Buffer) ReadString(delim byte) (line string, err error)`
// 从缓存中读取直到第一次遇到delim字节，并作为string返回这个包含delim的数据。
***

`func (b *Buffer) Reset()`
// 将b重置并清空数据，如同Truncate(0)。
***

`func (b *Buffer) String() string`
// 将缓冲区所有未读数据作为string返回，如果b是nil，则返回"<nil>"。
***

`func (b *Buffer) Truncate(n int)`
// 从缓冲区中丢弃第n个未读数据之后数据，如果n<0或n>Cap则报Panic。
***

`func (b *Buffer) UnreadByte() error`
// 撤销最近一次的读操作中的最后字节数据。
// 如果在这之前执行了write或者最后一次读取返回了错误或者最后读取了空字节，则该方法会返回一个错误。
***

`func (b *Buffer) UnreadRune() error`
// 类似UnreadByte()，但是严格要求最后一次读取是Rune，否则报错。
***

`func (b *Buffer) Write(p []byte) (n int, err error)`
// 将p中的数据写入缓存，并返回写入的字节数n和可能发生的错误。
***

`func (b *Buffer) WriteByte(c byte) error`
// 往缓存中写入一个字节c并返回可能发生的错误(通常是nil)。
// 如果缓存扩容太大，则会报一个ErrTooLarge的Panic。
***

`func (b *Buffer) WriteRune(r rune) (n int, err error)`
// 同WriteByte，返回写入长度和可能发生的错误(通常是nil)。
***

`func (b *Buffer) WriteString(s string) (n int, err error)`
// 同WriteByte，将s的内容写入缓存，返回写入长度和可能发生的错误。
***

`func (b *Buffer) WriteTo(w io.Writer) (n int64, err error)`
// 将缓存数据写入w直到写入完毕或发生错误。
***

Buffer的示列：

```Go
package bytes

import (
	"bytes"
	"fmt"
)

func Buffer(){
	bt := make([]byte, 0)
	buffer := bytes.NewBuffer(bt)
	buffer.Write([]byte("Hello"))
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// Hello, 5, 5

	buffer.WriteString(" World")
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// Hello World, 16, 11

	buffer.WriteByte('!')
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// Hello World!, 16, 12

	buffer.WriteRune('$')
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// Hello World!$, 16, 13

	r, size, _ := buffer.ReadRune()
	fmt.Printf("%q, %d\n", r, size)	// 'H', 1
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// ello World!$, 16, 12

	buffer.UnreadRune()
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// Hello World!$, 16, 13

	b , _ :=buffer.ReadByte()
	fmt.Printf("%q\n", b)	// 'H'
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// ello World!$, 16, 12

	buffer.UnreadByte()
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// Hello World!$, 16, 13

	line, _ := buffer.ReadBytes('l')
	fmt.Printf("%q\n", line)		// "Hel"
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// lo World!$, 16, 10

	buffer.UnreadByte()
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// llo World!$, 16, 11

	str, _ := buffer.ReadString('o')
	fmt.Printf("%q\n", str)		// "llo"
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	//  World!$, 16, 8

	buffer.UnreadByte()
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// o World!$, 16, 9

	next := buffer.Next(2)
	fmt.Printf("%q\n", next)		// "o "
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// World!$, 16, 7

	btRead := make([]byte, 2)
	n, _ := buffer.Read(btRead)
	fmt.Printf("%d\n", n)	// 2
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// rld!$, 16, 5

	buffer.Grow(3)
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// rld!$, 16, 5
	buffer.Grow(4)
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// rld!$, 36, 5

	buffer.Truncate(4)
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// rld!, 36, 4

	buffer.Reset()
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// , 36, 0

	bt1 := []byte("I see you.")
	bf1 := bytes.NewReader(bt1)
	n64, _ :=buffer.ReadFrom(bf1)
	fmt.Printf("%d\n", n64)	// 10
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// I see you., 584, 10

	bt2 := make([]byte, 0)
	bf2 := bytes.NewBuffer(bt2)
	n64, _ = buffer.WriteTo(bf2)
	fmt.Printf("%d, %q, %q\n", n64, bf2, bt2)	// 10, "I see you.", ""
	fmt.Printf("%s, %d, %d\n", buffer, buffer.Cap(), buffer.Len())	// , 584, 0
}
```

***

> Reader结构体

```Go
// bytes.Reader 实现了如下接口：
// io.ReadSeeker
// io.ReaderAt
// io.WriterTo
// io.ByteScanner
// io.RuneScanner
type Reader struct {
	s        []byte
	i        int64 // current reading index
	prevRune int   // index of previous rune; or < 0
}
```

Reader的方法：

`func (r *Reader) Len() int`
// 返回未读部分的数据长度。
***

`func (r *Reader) Size() int64`
// 返回底层数据的总长度。
***

`func (r *Reader) Reset(b []byte)`
// 将底层数据切换为b，同时复位所有标记。
***

`func (r *Reader) Read(b []byte) (n int, err error)`
`func (r *Reader) ReadAt(b []byte, off int64) (n int, err error)`
`func (r *Reader) ReadByte() (byte, error)`
`func (r *Reader) ReadRune() (ch rune, size int, err error)`
`func (r *Reader) Seek(offset int64, whence int) (int64, error)`
`func (r *Reader) UnreadByte() error`
`func (r *Reader) UnreadRune() error`
`func (r *Reader) WriteTo(w io.Writer) (n int64, err error)`

Reader的示列：

```Go
package bytes

import (
	"bytes"
	"fmt"
)

func Reader(){
	b1 := []byte("你好，世界！")
	b2 := []byte("Hello World!")
	buf := make([]byte, 9)
	rd := bytes.NewReader(b1)
	n, _ := rd.Read(buf)
	fmt.Printf("%q, %d, %d, %d\n", buf, rd.Len(), rd.Size(), n)	// "你好，", 9, 18, 9
	n, _ = rd.Read(buf)
	fmt.Printf("%q, %d, %d, %d\n", buf, rd.Len(), rd.Size(), n)	// "世界！", 0, 18, 9

	rd.Reset(b2)
	buf = make([]byte, 6)
	n, _ = rd.Read(buf)
	fmt.Printf("%q, %d, %d, %d\n", buf, rd.Len(), rd.Size(), n)	// "Hello ", 6, 12, 6
	n, _ = rd.Read(buf)
	fmt.Printf("%q, %d, %d, %d\n", buf, rd.Len(), rd.Size(), n)	// "World!", 0, 12, 6

	rd.UnreadByte()
	n, _ = rd.Read(buf)
	fmt.Printf("%q, %d, %d, %d\n", buf, rd.Len(), rd.Size(), n)	// "!orld!", 0, 12, 1
	// UnreadByte使得最后一个字符'!'回到了rd中，在rd.Read写入buf时，则将'!'写入了buf[0]中。
}
```
