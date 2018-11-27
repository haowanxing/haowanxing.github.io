---
title: Go语言包-bufio
categories: Learn-GO
tags:
  - bufio
abbrlink: e06b9990
date: 2018-11-26 14:41:54
---


> 一天一个Golang包，慢慢学习之“bufio”

今天学习带缓存的I/O操作，基础包“bufio”中有bufio.go和scan.go两个文件

#### 阅读文档：

官方pkg地址：[https://golang.org/pkg/bufio/](https://golang.org/pkg/bufio/)

> 包方法

`func NewReadWriter(r *Reader, w *Writer) *ReadWriter`
// 将r和w封装为一个bufio.Readwriter对象

`func NewReader(rd io.Reader) *Reader`
// 将rd封装为一个bufio.Reader对象(缓存大小默认4096)

`func NewReaderSize(rd io.Reader, size int) *Reader`
// 将rd封装成一个拥有size大小缓存的bufio.Reader对象

`func NewScanner(r io.Reader) *Scanner`
// 创建一个Scanner来扫描r

`func NewWriter(w io.Writer) *Writer`
// 将w封装成一个bufio.Writer对象(缓存大小默认4096)

`func NewWriterSize(w io.Writer, size int) *Writer`
//将w封装成一个拥有size大小缓存的bufio.Writer对象

> Reader结构体

```Go
// Reader 实现了对io.Reader对象的缓冲功能
type Reader struct {
	buf          []byte
	rd           io.Reader // reader provided by the client
	r, w         int       // buf read and write positions
	err          error
	lastByte     int
	lastRuneSize int
}
```

`func (b *Reader) Buffered() int`
// 返回缓存中的数据长度

`func (b *Reader) Discard(n int) (discarded int, err error)`
// 丢弃接下来的n个字节，返回丢弃的字节长度

`func (b *Reader) Peek(n int) ([]byte, error)`
// 返回前n字节的缓存切片

`func (b *Reader) Read(p []byte) (n int, err error)`
// 读取len(p)个字节到p中。
// 如果len(p)>缓存大小，且缓存不为空，则读取全部缓存。
// 若缓存为空，则从底层io.Reader直接读取

`func (b *Reader) ReadByte() (byte, error)`
// 读出一个字节并返回

`func (b *Reader) ReadBytes(delim byte) ([]byte, error)`
// 查找delim并读取delim及其之前的所有数据（byte切片）
// 如果在找到delim之前发生错误，则返回发生错误之前的数据和error。
// 当找不到delim的时候，err!=nil

`func (b *Reader) ReadLine() (line []byte, isPrefix bool, err error)`
// 返回一个单行数据(切片)，不包括行尾标记。
// 如果在缓存中找不到行尾标记，isPrefix为true，表示查找未完成，否则isPrefix为false

`func (b *Reader) ReadRune() (r rune, size int, err error)`
// 读取一个UTF8字符和字符的编码长度。
// 如果UTF8序列无法解码出一个正确的Unicode字符，则只读出一个字节，并返回U+FFFD字符，size返回1。

`func (b *Reader) ReadSlice(delim byte) (line []byte, err error)`
// 查找delim并读取delim及其之前的所有数据（byte切片-引用）

`func (b *Reader) ReadString(delim byte) (string, error)`
// 查找delim并读取delim及其之前的所有数据（字符串）

`func (b *Reader) Reset(r io.Reader)`
// 丢弃任何缓存数据，重置所有状态并切换io.Reader到r

`func (r *Reader) Size() int`
// 返回（底层）缓存的字节长度

`func (b *Reader) UnreadByte() error`
// 撤销最后一次读出的一个字节

`func (b *Reader) UnreadRune() error`
// 撤销最后一次读出的Unicode字符
// 如果最后一次执行的不是ReadRune()，则返回一个错误

`func (b *Reader) WriteTo(w io.Writer) (n int64, err error)`
// 实现了io.WriteTo接口。
// 可以（可能）对底层Reader的Read方法进行多次调用。
// 如果底层Reader支持WriteTo方法，则直接调用底层方法，无需缓存。


Reader的示例：

```Go
package bufio

import (
	"bufio"
	"bytes"
	"fmt"
)

func Reader(){
	testB := bytes.NewReader([]byte("abcdefg\nABCDEFG\nh i j k\nH I J K\n\nline."))
	bufRd := bufio.NewReader(testB)
	fmt.Println(bufRd.Buffered(), bufRd.Size())
	// 0 4096

	b, _ := bufRd.ReadByte()
	fmt.Println(bufRd.Buffered(), b, string(b))
	// 37 97 a

	bs, _ := bufRd.ReadBytes('d')
	fmt.Println(bufRd.Buffered(), bs, string(bs))
	// 34 [98 99 100] bcd

	discard, _ := bufRd.Discard(1)
	fmt.Println("discard:", discard, "bufferd:", bufRd.Buffered())
	// discard: 1 bufferd: 33

	b, _ = bufRd.ReadByte()
	fmt.Println(bufRd.Buffered(), b, string(b))
	// 32 102 f

	bs, _  = bufRd.Peek(7)
	fmt.Println(bufRd.Buffered(), bs, string(bs))
	// 32 [103 10 65 66 67 68 69] g
	// ABCDE

	line, isPrefix, _ := bufRd.ReadLine()
	fmt.Println(bufRd.Buffered(), line, string(line), isPrefix)
	// 30 [103] g false

	r, size, _ := bufRd.ReadRune()
	fmt.Println(bufRd.Buffered(), r, string(r), size)
	// 29 65 A 1

	slice, _ := bufRd.ReadSlice('D')
	fmt.Println(bufRd.Buffered(), slice, string(slice))
	// 26 [66 67 68] BCD

	str, _ := bufRd.ReadString('G')
	fmt.Println(bufRd.Buffered(), str)
	// 23 EFG

	bufRd.Reset(bytes.NewReader([]byte("Hello World.\nMy World.")))

	str, _ = bufRd.ReadString('r')
	fmt.Println(bufRd.Buffered(), str)
	// 13 Hello Wor

	bufRd.UnreadByte()
	fmt.Println(bufRd.Buffered())
	// 14

	str, _ = bufRd.ReadString('\n')
	fmt.Println(bufRd.Buffered(), str)
	// 9 rld.
	// 

	r, size, _ = bufRd.ReadRune()
	fmt.Println(bufRd.Buffered(), r, string(r), size)
	// 8 77 M 1

	bufRd.UnreadRune()
	fmt.Println(bufRd.Buffered())
	// 9

	str, _ = bufRd.ReadString('\n')
	fmt.Println(bufRd.Buffered(), str)
	// 0 My World.

}
```
***

> Writer结构体

```Go
// Writer 实现了对io.Writer对象的缓冲功能
// 如果在写入Writer时发生错误，则会停止继续写入和后续操作并返回这个错误。
// 在所有数据被写入后，应当调用Flush方法来保证所有数据都被写入底层Writer。
type Writer struct {
	err error
	buf []byte
	n   int
	wr  io.Writer
}
```

`func NewWriter(w io.Writer) *Writer`
// 将w封装成一个bufio.Writer对象，缓存大小为4096.

`func NewWriterSize(w io.Writer, size int) *Writer`
// 将w封装成一个拥有size大小缓存的bufio.Writer对象

`func (b *Writer) Available() int`
// 返回缓存中的可用空间

`func (b *Writer) Buffered() int`
// 返回缓存中未提交的数据长度

`func (b *Writer) Flush() error`
// 将缓存中的数据提交到底层io.Writer中

`func (b *Writer) ReadFrom(r io.Reader) (n int64, err error)`
// 实现了io.ReaderFrom接口。
// 如果底层writer支持ReadFrom方法且b的缓存数据为空，则直接调用底层的ReadFrom方法，不使用缓存。

`func (b *Writer) Reset(w io.Writer)`
// 丢弃所有未被提交的缓存数据，重置所有状态并切换io.Writer到w

`func (b *Writer) Size() int`
// 以字节为单位返回(底层)缓冲区大小

`func (b *Writer) Write(p []byte) (nn int, err error)`
// 将p中的数据写入b中，返回写入的字节数
// 如果写入的字节数小于p的长度，则返回错误

`func (b *Writer) WriteByte(c byte) error`
// 写入一个字节

`func (b *Writer) WriteRune(r rune) (size int, err error)`
// 写入一个UTF8编码字符

`func (b *Writer) WriteString(s string) (int, error)`
// 写入一个字符串，返回写入的字节数

Writer的示列：

```Go
package bufio

import (
	"bufio"
	"bytes"
	"fmt"
)

func Writer(){
	bt := make([]byte, 0)
	Bt := bytes.NewBuffer(bt)
	bufWt := bufio.NewWriter(Bt)

	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4096 0

	// Write
	nn, _ := bufWt.Write([]byte{65, 66})
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4094 2
	fmt.Println(nn, Bt)	// 2 "空"
	bufWt.Flush()
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4096 0
	fmt.Println(nn, Bt)	// 2 AB

	// WriteByte
	bufWt.WriteByte('C')
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4095 1
	fmt.Println(Bt)	// AB
	bufWt.Flush()
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4096 0
	fmt.Println(Bt)	// ABC

	// WriteRune
	size, _ := bufWt.WriteRune('D')
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4095 1
	fmt.Println(size, Bt)	// 1 ABC
	bufWt.Flush()
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4096 0
	fmt.Println(Bt)	// ABCD

	// WriteString
	n, _ := bufWt.WriteString("EFG")
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4093 3
	fmt.Println(n, Bt)	// 3 ABCD
	bufWt.Flush()
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4096 0
	fmt.Println(Bt)	// ABCDEFG

	fmt.Println(bufWt.Size())	// 4096

	// ReadFrom without buffered
	some := bytes.NewReader([]byte("HIJKLMN"))
	nChar, _ := bufWt.ReadFrom(some)
	fmt.Println(bufWt.Available(), bufWt.Buffered())	//4096 0
	fmt.Println(nChar, Bt)	//7 ABCDEFGHIJKLMN
	// 这里不用调用flush，因为在ReadForm之前缓存中没有数据，直接调用底层的ReadFrom写入了数据
	// 下面看下有缓存的情况，先写入一个换行
	bufWt.WriteByte('\n')
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4095 1
	fmt.Println(Bt)	// ABCDEFGHIJKLMN
	// 紧接着不Flash而是直接ReadForm
	some2 := bytes.NewReader([]byte("OPQRST"))
	nChar, _ = bufWt.ReadFrom(some2)
	fmt.Println(bufWt.Available(), bufWt.Buffered())	//4089 7
	fmt.Println(nChar, Bt)	//6 ABCDEFGHIJKLMN
	// 现在Flush然后看各个变量
	bufWt.Flush()
	fmt.Println(bufWt.Available(), bufWt.Buffered())	// 4096 0
	fmt.Println(Bt)	// ABCDEFGHIJKLMN"换行"OPQRST
}
```


****

> Scanner结构体

```Go
// Scanner为读取数据提供了便捷的接口，这些数据包括但不限于有换行分界符的文本文件。
// 连续调用Scan方法将会遍历文件的'Token'(指定部分)且跳过指定部分之间的字节。
// 指定部分的格式由SplitFunc类型的函数定义，默认的切分函数根据行尾将输入拆分成行但不包括行尾
// 本包下定义并提供的切分函数用于将文件扫描成line,bytes,UTF-8Encoded runes和空格拆分的单词。用户也可以使用自己的切分函数来替换它。
// 当扫描遇到EOF、第一次I/O错误或'指定部分'太大无法存入缓冲区时停止。
// 当一次扫描停止时，读取器有可能早已超出'指定部分'很远。如果程序想要对数据进行更多的控制，如错误处理或扫描更大的'指定部分'或顺序扫描，则应当使用bufio.reader来代替。
type Scanner struct {
	r            io.Reader // 用户提供的reader.
	split        SplitFunc // 拆分token的方法.
	maxTokenSize int       // token的上限
	token        []byte    // split返回的最后token.
	buf          []byte    // 作为参数给split的缓冲区.
	start        int       // 缓冲区起始位.
	end          int       // 缓冲区终止位.
	err          error     // Sticky error.
	empties      int       // 连续出现空token的次数.
	scanCalled   bool      // 扫描是否开始.
	done         bool      // 扫描完毕.
}
```

`func (s *Scanner) Buffer(buf []byte, max int)`
// 用于设置自定义缓存以及可扩展范围，如果max小于len(buf)，则buf的尺寸将固定不可调。
// Buffer必须在第一次Scan之前设置，否则引发Panic。
// 默认情况下，Scanner将会使用一个4096-bufio.MaxScanTokenSize大小的内部缓存。

`func (s *Scanner) Bytes() []byte`
// 将最后一次扫描出的‘指定部分’作为切片（引用）返回
// 下一次的扫描会覆盖本结果

`func (s *Scanner) Err() error`
// 返回扫描过程中遇到的非EOF错误

`func (s *Scanner) Scan() bool`
// 扫描数据中的‘指定部分’

`func (s *Scanner) Split(split SplitFunc)`
// 设置Scanner的分切函数，必须在Scan方法之前调用

`func (s *Scanner) Text() string`
// 最后一次扫描出的‘指定部分’作为String返回


Scanner的示例：

```Go
package bufio

import (
	"bufio"
	"bytes"
	"fmt"
)

func Scan(){
	b1 := bytes.NewReader([]byte("ABC\nDEF\r\nGHI\nJKL"))
	bs := bufio.NewScanner(b1)
	for bs.Scan() {
		fmt.Printf("%s %v\n", bs.Bytes(), bs.Text())
	}
	// ABC ABC
	// DEF DEF
	// GHI GHI
	// JKL JKL
	b2 := bytes.NewReader([]byte("ABC\nDEF GHI JKL"))
	bs = bufio.NewScanner(b2)
	bs.Split(bufio.ScanWords)
	for bs.Scan() {
		fmt.Println(bs.Text())
	}
	// ABC
	// DEF
	// GHI
	// JKL
	b3 := bytes.NewReader([]byte("Hello 世界！"))
	bs = bufio.NewScanner(b3)
	bs.Split(bufio.ScanRunes)
	for bs.Scan() {
		fmt.Printf("%v ", bs.Text())
	}
	// H e l l o   世 界 ！
	fmt.Println()
	b4 := bytes.NewReader([]byte("我的天哪!"))
	bs = bufio.NewScanner(b4)
	bs.Split(bufio.ScanBytes)
	for bs.Scan() {
		fmt.Printf("%v ", bs.Bytes())
	}
	// [230] [136] [145] [231] [154] [132] [229] [164] [169] [229] [147] [170] [33]
	fmt.Println()
}
```

另外的参考：

* [https://studygolang.com/articles/4367](https://studygolang.com/articles/4367)
* [https://www.cnblogs.com/golove/p/3282667.html](https://www.cnblogs.com/golove/p/3282667.html)








