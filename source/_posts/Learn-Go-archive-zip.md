---
title: Go语言包-archive/zip
categories: Learn-GO
tags:
abbrlink: 6200ba6d
date: 2018-11-23 17:08:10
---

> 一天一个Golang包，慢慢学习之“archive/zip”

昨天阅读了archive包的tar包，对Go语言操作压缩包有了一定的基础，今天就继续把另外一个包“zip”也来熟悉一下。

#### 阅读文档：

官方pkg地址：[https://golang.org/pkg/archive/zip/](https://golang.org/pkg/archive/zip/)

今天同样从官方的包文档中提取几个主要的内容出来分享一下：

> 常量

```Go
const (
        Store   uint16 = 0 // no compression
        Deflate uint16 = 8 // DEFLATE compressed
)
```

<!---more--->

> 变量

```Go
var (
        ErrFormat    = errors.New("zip: not a valid zip file")				// 不合法的zip文件
        ErrAlgorithm = errors.New("zip: unsupported compression algorithm")	// 不支持的压缩算法
        ErrChecksum  = errors.New("zip: checksum error")					//校验错误
)
```


> FileHeader结构体

```Go
type FileHeader struct {
        Name string	// 文件名，必须是相对路径，不能以设备或斜杠开始，分隔符用'/'表示

        Comment string

        NonUTF8 bool // Go 1.10

        CreatorVersion uint16
        ReaderVersion  uint16
        Flags          uint16

        Method uint16

        Modified     time.Time // Go 1.10
        ModifiedTime uint16 // Deprecated: Legacy MS-DOS date; use Modified instead.
        ModifiedDate uint16 // Deprecated: Legacy MS-DOS time; use Modified instead.

        CRC32              uint32
        CompressedSize     uint32 // Deprecated: Use CompressedSize64 instead.
        UncompressedSize   uint32 // Deprecated: Use UncompressedSize64 instead.
        CompressedSize64   uint64 // Go 1.1
        UncompressedSize64 uint64 // Go 1.1
        Extra              []byte
        ExternalAttrs      uint32 // Meaning depends on CreatorVersion
}
```

FileHeader相关的方法：

`func FileInfoHeader(fi os.FileInfo) (*FileHeader, error)`	// 通过传入的fi填充一个FileHeader并返回，由于os.FileInfo的Name方法只返回文件描述的Name，所以实际使用有可能需要自行修改为完整的全路径

`func (h *FileHeader) FileInfo() os.FileInfo` // 返回一个os.FileInfo

`func (h *FileHeader) ModTime() time.Time`	// 修改时间

`func (h *FileHeader) Mode() (mode os.FileMode)`	// 权限和模式位

`func (h *FileHeader) SetModTime(t time.Time)`	// 设置修改时间

`func (h *FileHeader) SetMode(mode os.FileMode)`	// 设置权限



> ReadCloser结构体

```Go
type ReadCloser struct {
        Reader
        // contains filtered or unexported fields
}
```


ReadCloser的相关方法：

`func OpenReader(name string) (*ReadCloser, error)`	// 传入文件名(路径)，返回一个ReadCloser指针(继承了Reader)

`func (rc *ReadCloser) Close() error`	// 关闭ReadCloser



> Reader结构体

```Go
type Reader struct {
        File    []*File
        Comment string
        // contains filtered or unexported fields
}
```

Reader的相关方法：

`func NewReader(r io.ReaderAt, size int64) (*Reader, error)`	// 从r中读取size个字节并返回一个新的Reader

`func (z *Reader) RegisterDecompressor(method uint16, dcomp Decompressor)`



> Writer结构体

```Go
type Writer struct {
        // contains filtered or unexported fields
}
```

Writer的相关方法：

`func NewWriter(w io.Writer) *Writer`	// 创建并返回一个将zip文件写入w的Writer

`func (w *Writer) Close() error`	// 关闭Writer

`func (w *Writer) Create(name string) (io.Writer, error)`	// 使用name添加一个文件到zip文件中，返回一个Writer。name必须是相对路径，不能以设备或斜杠开头，用'/'作为分隔符。新增文件内容必须在下一次调用CreateHeader、Create或Close方法前全部写入。

`func (w *Writer) CreateHeader(fh *FileHeader) (io.Writer, error)`	// 使用fh所描述的元数据添加一个文件到zip文件中，并返回一个用于写入数据的io.Writer。

`func (w *Writer) Flush() error` // 将缓存写入底层IO

等等..

***

实现一个跟昨天一样的需求：简单的创建和读取压缩包，[传送门](/posts/5df3d88.html)

#### 代码实现

```Go
package zip

import (
	"archive/zip"
	"fmt"
	"io"
	"log"
	"os"
	"time"
)

var(
	filePath = "/tmp/go/learn/data/zipArchive.zip"
)

func CreateArchive(){
	fmt.Println("This is function CreateArchive called")
	var files = []struct{
		Name, Body string
	}{
		{"Readme.md", "## Hello World\n1. line 1\n2. line 2\n3. line 3"},
		{"gopher.txt", "Gopher names:\nGorge\nGeoffrey\nGonzo"},
		{"todo.txt", "Get animal handling licence.\nWrite more examples"},
		{"myDir/file.txt", "This is a sub dir's file"},
	}
	fi, err := os.Create(filePath)
	defer fi.Close()
	if err != nil {
		log.Fatal(err)
	}
	zw := zip.NewWriter(fi)
	for _, file := range files {
		fh := &zip.FileHeader{
			Name: file.Name,
			Modified: time.Now(),
		}
		//	这里也可以使用 f, err := zw.Create(file.Name); 快速创建文件
		if f, err := zw.CreateHeader(fh); err != nil{
			log.Fatal(err)
		}else{
			if _, err := f.Write([]byte(file.Body));err != nil {
				log.Fatal(err)
			}
		}
	}
	if err = zw.Close(); err != nil {
		log.Fatal(err)
	}
	fmt.Println("Created Archive file is stored in:", filePath)
}

func ReadArchive(){
	fmt.Println("This is function ReadeArchive called")
	zr, err := zip.OpenReader(filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer zr.Close()
	for _, f := range zr.File {
		fmt.Printf("\tContents of %s:\n",f.Name)
		if rc, err := f.Open();err != nil {
			log.Fatal(err)
		}else{
			if _, err := io.Copy(os.Stdout, rc, ); err != nil {
				log.Fatal(err)
			}
			rc.Close()
			fmt.Println()
		}
	}
}
```


**通过今天的学习，突然发现了昨天的tar并没有涉及到压缩，所以它应该就是个普通的归档，而zip中带有了压缩算法，所以它可以被称为压缩包。不过我今天也悄悄的看了一下tar.gz的相关内容，非常简单！这里就不多说，感兴趣的自行移步官方文档。**

