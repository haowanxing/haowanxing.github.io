---
title: Go语言包-archive/tar
categories: Learn-GO
tags:
  - archive
  - tar
abbrlink: 5df3d88
date: 2018-11-22 17:33:52
---

> 一天一个Golang包，慢慢学习之“archive/tar”

今天了解一下归档（压缩包）中的tar包，我们对压缩包其实并不陌生，像是"某某.tar"，自然能想到应该用压缩包工具打开并解压出来使用。

#### 阅读文档：

官方pkg地址：[https://golang.org/pkg/archive/tar/](https://golang.org/pkg/archive/tar/)

从官方的包文档中，我提取几个主要的内容出来分享一下：

<!---more--->

> 常量

```Go
const (
        // Type '0' indicates a regular file.(普通文件)
        TypeReg  = '0'
        TypeRegA = '\x00' // Deprecated: Use TypeReg instead.

        // Type '1' to '6' are header-only flags and may not have a data body.
        TypeLink    = '1' // Hard link(硬链接)
        TypeSymlink = '2' // Symbolic link(软链接/符号链接)
        TypeChar    = '3' // Character device node(字符设备节点)
        TypeBlock   = '4' // Block device node(块设备节点)
        TypeDir     = '5' // Directory(目录)
        TypeFifo    = '6' // FIFO node

        // Type '7' is reserved.（保留项）
        TypeCont = '7'

        // Type 'x' is used by the PAX format to store key-value records that
        // are only relevant to the next file.
        // This package transparently handles these types.
        TypeXHeader = 'x'	// 可扩展头部

        // Type 'g' is used by the PAX format to store key-value records that
        // are relevant to all subsequent files.
        // This package only supports parsing and composing such headers,
        // but does not currently support persisting the global state across files.
        TypeXGlobalHeader = 'g'	// 全局扩展头部

        // Type 'S' indicates a sparse file in the GNU format.
        TypeGNUSparse = 'S'	// 稀疏文件

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
        ErrHeader          = errors.New("archive/tar: invalid tar header")	// 无效的tar头部
        ErrWriteTooLong    = errors.New("archive/tar: write too long")		// 写入数据太长
        ErrFieldTooLong    = errors.New("archive/tar: header field too long")	// 头部太长
        ErrWriteAfterClose = errors.New("archive/tar: write after close")	// 关闭后写入
)
```

> Header结构体

```Go
type Header struct {
        Typeflag byte // the type of header entry.(文件类型)

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

        Devmajor int64 // Major device number (valid for TypeChar or TypeBlock)(字符设备或块设备的主设备号)
        Devminor int64 // Minor device number (valid for TypeChar or TypeBlock)(字符设备或块设备的次设备号)

        Xattrs map[string]string // Go 1.3
        
        PAXRecords map[string]string // Go 1.10

        Format Format // Go 1.10
}
```

Header的相关方法：

`func FileInfoHeader(fi os.FileInfo, link string)(*Header, error)`	//该方法通过os.FileInfo来创建一个tar.Header，用在对已有文件打包十分方便

`func (h *Header) FileInfo() os.FileInfo`	// 该方法获取Header的os.FileInfo信息

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
`func NewReader(r io.Reader) *Reader`	// 用r创建新的tar.Reader

`func (tr *Reader) Next() (*Header, error)`	// 使tr指向下一个文件实体并返回实体的Header，到最后会返回err为io.EOF

`func (tr *Reader) Read(b []byte) (int, error)`	// 读取当前实体到b，读取到最后时返回err为io.EOF


阅读到这儿，基本就可以解析一个tar文件了，从上述的方法我们可以得知，要想获得压缩包的内容，我们可以使用tar.Reader来完成，而tar.Reader的创建可以通过使用tar.NewReader()方法，该方法需要提供一个实现了io.Reader接口的对象，此对象可以通过os包的方法如os.Open()或者os.OpenFile()等方法获得。根据这个思路，我们便可以解析获得tar文件的所有内容了。


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
`func NewWriter(w io.Writer) *Writer`	// 用w创建新的tar.Writer

`func (tw *Writer) Close() error`		// 关闭tar文件，并将未写入的数据写入底层writer
`func (tw *Writer) Flush() error`		// 完成当前写入

`func (tw *Writer) Write(b []byte) (int, error)`	// 将b写入当前实体，如果写入长度大于WriteHeader所描述的Size，则会返回err为ErrWriteTooLong的报错

`func (tw *Writer) WriteHeader(hdr *Header) error`	// 将hdr写入tar文件中并准备接受Write()方法的写入，hdr.Size决定写入的文件字节大小。如果未完全写入，则会报错。写入hdr之前会隐式调用Flash()。


下面我们假设这样一个需求：

#### 需求描述：

1. 创建一个压缩包文件，命名为："tarArchive.tar"。
2. 压缩包中存有3个文本文档，分别命名："readme.md"、"gopher.txt"、"todo.txt"，内容随意。
3. 压缩包中还有一个目录(命名:dir)，其中有一个文件:dirFile.txt，内容随意
4. 将压缩包保存在"/tmp/go/learn/data"目录中。
5. 读取压缩包内容，并打印文件(或目录)以及文件内容。

#### 求解过程：

1. 最终结果是要创建一个文件，所以我们先创建这个文件：这里用到`f, err := os.OpenFile()`方法来获取一个文件指针
2. 然后创建一个tar的Writer对象来实现对文件的写入：`tw := tar.NewWriter(f)`，获得的tw对象就是一个写入器，他有Write方法。
3. 构建一个文件列表（任何方式，为了方便用循环添加文件）。
4. 使用`tw.WriteHeader()`和`tw.Write()`方法向压缩包写入文件。
5. 关闭文件和写入器：`f.Close()`、`tw.Close()`，tar文件创建完毕。
6. 读取tar文件，并使用tar.NewReader()获得Reader对象。
7. 循环Next()方法获得hdr并打印hdr.Name以及Reader的内容
8. 判断io.EOF结束并关闭文件。


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
	// 创建一个名字叫做myDir2的目录，用于区分上述的dir/dirFile.txt中的目录
	if err = tw.WriteHeader(&tar.Header{Name: "myDir2",Mode: 0766,Typeflag:tar.TypeDir}); err != nil{
		log.Fatal(err)
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

**注意：代码中有关myDir目录和myDir2目录的创建方式不一样，但是效果差异不大**

* 扩展阅读：利用compress/gzip压缩和解压:[https://golang.org/pkg/compress/gzip/](https://golang.org/pkg/compress/gzip/)