---
title: Go语言包-archive/tar
categories: Learn_GO
tags:
  - archive
  - tar
abbrlink: 5df3d88
date: 2018-11-22 17:33:52
---

> 一天一个Golang包，慢慢学习之“archive/tar”

今天了解一下归档（压缩包）中的tar包，我们对压缩包其实并不陌生，像是"某某.tar"，自然能想到应该用压缩包工具打开并解压出来使用。

#### 阅读文档：

从官方的包文档中，我提取几个主要的内容出来分享一下：

> 常量

```Go
const (
        // Type '0' indicates a regular file.
        TypeReg  = '0'
        TypeRegA = '\x00' // Deprecated: Use TypeReg instead.

        // Type '1' to '6' are header-only flags and may not have a data body.
        TypeLink    = '1' // Hard link(硬链接)
        TypeSymlink = '2' // Symbolic link(软链接/符号链接)
        TypeChar    = '3' // Character device node
        TypeBlock   = '4' // Block device node
        TypeDir     = '5' // Directory
        TypeFifo    = '6' // FIFO node

        // Type '7' is reserved.
        TypeCont = '7'

        // Type 'x' is used by the PAX format to store key-value records that
        // are only relevant to the next file.
        // This package transparently handles these types.
        TypeXHeader = 'x'

        // Type 'g' is used by the PAX format to store key-value records that
        // are relevant to all subsequent files.
        // This package only supports parsing and composing such headers,
        // but does not currently support persisting the global state across files.
        TypeXGlobalHeader = 'g'

        // Type 'S' indicates a sparse file in the GNU format.
        TypeGNUSparse = 'S'

        // Types 'L' and 'K' are used by the GNU format for a meta file
        // used to store the path or link name for the next file.
        // This package transparently handles these types.
        TypeGNULongName = 'L'
        TypeGNULongLink = 'K'
)
```
> 变量(主要用于错误输出)

```Go
var (
        ErrHeader          = errors.New("archive/tar: invalid tar header")
        ErrWriteTooLong    = errors.New("archive/tar: write too long")
        ErrFieldTooLong    = errors.New("archive/tar: header field too long")
        ErrWriteAfterClose = errors.New("archive/tar: write after close")
)
```

> Header结构体

```Go
type Header struct {
        Typeflag byte // the type of header entry.

        Name     string // 文件名称
        Linkname string // 链接名称 (适用于硬链接和软链接)

        Size  int64  // 文件的字节大小
        Mode  int64  // 权限，如：0600
        Uid   int    // 用户ID
        Gid   int    // 组ID
        Uname string // 用户名
        Gname string // 组名

        ModTime    time.Time // 最后一次修改文件或目录的时间
        AccessTime time.Time // 最后一次访问文件或目录的时间
        ChangeTime time.Time // 最后一次改变文件或目录(改变的是原数据即:属性)的时间

        Devmajor int64 // Major device number (valid for TypeChar or TypeBlock)
        Devminor int64 // Minor device number (valid for TypeChar or TypeBlock)

        Xattrs map[string]string // Go 1.3
        
        PAXRecords map[string]string // Go 1.10

        Format Format // Go 1.10
}
```

> Reader结构体

```Go
type Reader struct {
	r    io.Reader
	pad  int64      // Amount of padding (ignored) after current file entry
	curr fileReader // Reader for current file entry
	blk  block      // Buffer to use as temporary local storage

	// err is a persistent error.
	// It is only the responsibility of every exported method of Reader to
	// ensure that this error is sticky.
	err error
}
```
Reader结构体有以下方法：
`func NewReader(r io.Reader) *Reader`
`func (tr *Reader) Next() (*Header, error)`
`func (tr *Reader) Read(b []byte) (int, error)`

> Writer结构体

```Go
type Writer struct {
	w    io.Writer
	pad  int64      // Amount of padding to write after current file entry
	curr fileWriter // Writer for current file entry
	hdr  Header     // Shallow copy of Header that is safe for mutations
	blk  block      // Buffer to use as temporary local storage

	// err is a persistent error.
	// It is only the responsibility of every exported method of Writer to
	// ensure that this error is sticky.
	err error
}
```
Writer结构体有如下方法：
`func NewWriter(w io.Writer) *Writer`
`func (tw *Writer) Close() error`
`func (tw *Writer) Flush() error`
`func (tw *Writer) Write(b []byte) (int, error)`
`func (tw *Writer) WriteHeader(hdr *Header) error`


下面我们假设这样一个需求：

#### 需求描述：

1. 创建一个压缩包文件，命名为："tarArchive.tar"。
2. 压缩包中存有3个文本文档，分别命名："readme.md"、"gopher.txt"、"todo.txt"，内容随意。
3. 压缩包中还有一个目录(命名:dir)，其中有一个文件:dirFile.txt，内容随意
4. 将压缩包保存在"/tmp/go/learn/data"目录中。

#### 求解过程：

1. 最终结果是要创建一个文件，所以我们先创建这个文件：这里用到`f, err := os.OpenFile()`方法来获取一个文件指针
2. 然后创建一个tar的Writer对象来实现对文件的写入：`tw := tar.NewWriter(f)`，获得的tw对象就是一个写入器，他有Write方法。
3. 构建一个文件列表（任何方式，为了方便用循环添加文件）。
4. 使用`tw.WriteHeader()`和`tw.Write()`方法向压缩包写入文件。
5. 关闭文件和写入器：`f.Close()`、`tw.Close()`


#### 完整代码
```Go
package tar

import (
	"archive/tar"
	"fmt"
	"io"
	"log"
	"os"
)
var(
	filePath = "/tmp/go/learn/data/tarArchive.tar"
)

func CreateArchive(){
	f, err := os.OpenFile(filePath, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, 0666)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	tw := tar.NewWriter(f)
	var files = []struct{
		Name, Body string
	}{
		{"Readme.md", "This is a readme markdown file."},
		{"gopher.txt", "Gopher names:\nGeorge\nGeoffrey\nGonzo"},
		{"todo.txt", "Get animal handling license."},
		{"dir/dirFile.txt", "it's content is in directory"},
	}
	for _, file := range files {
		hdr := &tar.Header{
			Name: file.Name,
			Mode: 0600,
			Size: int64(len(file.Body)),
		}
		if err := tw.WriteHeader(hdr); err != nil {
			log.Fatal(err)
		}
		if _, err := tw.Write([]byte(file.Body)); err != nil {
			log.Fatal(err)
		}
	}
	if err := tw.Close(); err != nil {
		log.Fatal(err)
	}
}

func ReadArchive(){
	f, err := os.OpenFile(filePath, os.O_RDONLY, 0)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	tr := tar.NewReader(f)
	for {
		hdr, err := tr.Next()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}
		fmt.Printf("Contents of %s:\n",hdr.Name)
		if _, err := io.Copy(os.Stdout, tr); err != nil {
			log.Fatal(err)
		}
		fmt.Println("\n====")
	}
}
```

**注意：我在创建目录下的文件的时候取巧直接当做文件名传入，在我的Mac本下成功了，不保证其他环境下也行，自行验证咯^_^**