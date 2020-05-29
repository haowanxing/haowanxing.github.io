---
title: '[修复]wordpress WP_Image_Editor_Imagick 指令注入漏洞'
tags:
  - WordPress
  - 云盾
  - 修复
  - 漏洞
id: 453
categories:
  - Linux
abbrlink: 539cda52
date: 2016-07-28 16:15:00
---

漏洞描述：该修复方案为临时修复方案，可能存在兼容性风险，为了防止WP_Image_Editor_Imagick扩展的指令注入风险，将wordpress的默认图片处理库优先顺序改为GD优先，用户可在/wp-includes/media.php的_wp_image_editor_choose()函数中看到被修改的部分
云盾不提供自动修复，咱们自己来修复吧。根据提示，我们打开media.php 找到相关函数的内容：
<pre lang="php">
$implementations = apply_filters( 'wp_image_editors', array( 'WP_Image_Editor_Imagick', 'WP_Image_Editor_GD' ) );
</pre>
做如下顺序调整：
<pre lang="php">
$implementations = apply_filters( 'wp_image_editors', array( 'WP_Image_Editor_GD', 'WP_Image_Editor_Imagick' ) );
</pre>
正如上面的描述所说，临时方案嘛。Wordpress官方不做处理的话，你每次升级了程序，都会出现这样的报错，每次都得自己去修改。不过如果不在乎这个提示的话，不理也行！
<!--more （下面好像没有了...）-->
附当时的图片一张
![wp-Image 注入漏洞](http://www.dshui.wang/wp-content/uploads/2016/07/wp-Image-300x99.png)