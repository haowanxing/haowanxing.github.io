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
// Reader implements buffering for an io.Reader object.
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


Reader的用例：

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
	fmt.Println(bufRd.Buffered(), bufRd.Size())	// 0 4096

	b, _ := bufRd.ReadByte()
	fmt.Println(bufRd.Buffered(), b, string(b))	// 37 97 a

	bs, _ := bufRd.ReadBytes('d')
	fmt.Println(bufRd.Buffered(), bs, string(bs))	// 34 [98 99 100] bcd

	discard, _ := bufRd.Discard(1)
	fmt.Println("discard:", discard, "bufferd:", bufRd.Buffered()) // discard: 1 bufferd: 33

	b, _ = bufRd.ReadByte()
	fmt.Println(bufRd.Buffered(), b, string(b))	// 32 102 f

	bs, _  = bufRd.Peek(7)
	fmt.Println(bufRd.Buffered(), bs, string(bs))	// 32 [103 10 65 66 67 68 69] g"换行"ABCDE

	line, isPrefix, _ := bufRd.ReadLine()
	fmt.Println(bufRd.Buffered(), line, string(line), isPrefix)	// 30 [103] g false

	r, size, _ := bufRd.ReadRune()
	fmt.Println(bufRd.Buffered(), r, string(r), size)	// 29 65 A 1

	slice, _ := bufRd.ReadSlice('D')
	fmt.Println(bufRd.Buffered(), slice, string(slice))	// 26 [66 67 68] BCD

	str, _ := bufRd.ReadString('G')
	fmt.Println(bufRd.Buffered(), str)	// 23 EFG

	bufRd.Reset(bytes.NewReader([]byte("Hello World.\nMy World.")))

	str, _ = bufRd.ReadString('r')
	fmt.Println(bufRd.Buffered(), str)	// 13 Hello Wor

	bufRd.UnreadByte()
	fmt.Println(bufRd.Buffered())	// 14

	str, _ = bufRd.ReadString('\n')
	fmt.Println(bufRd.Buffered(), str)	// 9 rld."换行符"

	r, size, _ = bufRd.ReadRune()
	fmt.Println(bufRd.Buffered(), r, string(r), size)	// 8 77 M 1

	bufRd.UnreadRune()
	fmt.Println(bufRd.Buffered())	// 9

	str, _ = bufRd.ReadString('\n')
	fmt.Println(bufRd.Buffered(), str)	// 0 My World.
}
```

> Writer结构体

```Go
// Writer implements buffering for an io.Writer object.
// If an error occurs writing to a Writer, no more data will be
// accepted and all subsequent writes, and Flush, will return the error.
// After all data has been written, the client should call the
// Flush method to guarantee all data has been forwarded to
// the underlying io.Writer.
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



****

> Scanner结构体

```Go
// Scanner provides a convenient interface for reading data such as
// a file of newline-delimited lines of text. Successive calls to
// the Scan method will step through the 'tokens' of a file, skipping
// the bytes between the tokens. The specification of a token is
// defined by a split function of type SplitFunc; the default split
// function breaks the input into lines with line termination stripped. Split
// functions are defined in this package for scanning a file into
// lines, bytes, UTF-8-encoded runes, and space-delimited words. The
// client may instead provide a custom split function.
//
// Scanning stops unrecoverably at EOF, the first I/O error, or a token too
// large to fit in the buffer. When a scan stops, the reader may have
// advanced arbitrarily far past the last token. Programs that need more
// control over error handling or large tokens, or must run sequential scans
// on a reader, should use bufio.Reader instead.
//
type Scanner struct {
	r            io.Reader // The reader provided by the client.
	split        SplitFunc // The function to split the tokens.
	maxTokenSize int       // Maximum size of a token; modified by tests.
	token        []byte    // Last token returned by split.
	buf          []byte    // Buffer used as argument to split.
	start        int       // First non-processed byte in buf.
	end          int       // End of data in buf.
	err          error     // Sticky error.
	empties      int       // Count of successive empty tokens.
	scanCalled   bool      // Scan has been called; buffer is in use.
	done         bool      // Scan has finished.
}
```

`func NewScanner(r io.Reader) *Scanner`


`func (s *Scanner) Buffer(buf []byte, max int)`


`func (s *Scanner) Bytes() []byte`


`func (s *Scanner) Err() error`


`func (s *Scanner) Scan() bool`


`func (s *Scanner) Split(split SplitFunc)`


`func (s *Scanner) Text() string`













