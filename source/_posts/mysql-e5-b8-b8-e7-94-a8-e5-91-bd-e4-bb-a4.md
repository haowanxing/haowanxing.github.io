---
title: MySQL常用命令
id: 17
categories:
  - 数据库
date: 2014-07-03 16:36:30
tags:
---

连接MySQL数据库：

mysql -h host -u user -p

1.SHOW DATABASES;  查询已有的数据库

2.USE DatabaseName; 使用某个数据库

3.SHOW TABLES; 查询已有的表单；

4.SELECT * FROM TableName; 检索表单所有数据（＊代表所有，可用字段名替代）

5.CREATE TABLE TableName (Id INT, Name VARCHAR(20)); 创建一个表

6.DESCRIBE TableName; 显示表的结构

7.INSERT INTO TableName VALUES (2014,"Jack");向表中添加记录
INSERT INTO TableName (Id,Name) VALUES (2014,"Jack");

8.DROP TABLE TableName; 删除表

9.DELATE FROM TableName; 清空表

10.UPDATE TableName set Name="Tom" where Id=2014;更新表中数据