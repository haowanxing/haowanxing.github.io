---
title: mysql中几种Log和打开方法
tags: mysql
abbrlink: 2e28f02f
date: 2018-05-17 18:45:18
categories:
---

> Mysql中常见的log有：`错误日志log_error`、`慢查询日志slow_query_log`、`二进制日志bin_log`和`通用查询日志general_log`

### 错误日志（error_log）

  这个日志记载mysql服务器的启动和关闭以及运行过程中发生的故障或异常情况，如果你发现mysql无法正常启动，那么你首先应该查看这个日志。
  
  配置：
  
  ```bash
  log_error = error.log
  ```
  
  服务器上查询log位置：`show variables like 'log_error'`
  
### 慢查询日志（slow_query_log）

  为了改善数据库性能，需要减少慢查询SQL的使用次数，那么哪些SQL需要改善呢？通过这个日志可以更清楚如何去改善。
  
  配置：
  
  ```bash
  slow_query_log = 1
  lone_query_time = 10
  slow_query_log_file = slow_query.log
  ```
  
### 二进制查询日志（bin_log）

  Mysql的binlog日志作用是用来记录mysql内部增删改查等对mysql数据库有更新的内容的记录（对数据库的改动），对数据库的查询select或show等不会被binlog日志记录;主要用于数据库的主从复制以及增量恢复。

  配置：
  
  ```bash
  log_bin = mysql_bin.log
  ```


### 通用查询日志（general_log）

  会记录mysql运行期间的所有sql语句

  配置：
  
  ```bash
  log_output=[none|file|table|file,table]  #通用查询日志输出格式
  general_log=[on|off]                     #是否启用通用查询日志
  general_log_file[=filename]              #通用查询日志位置及名字
  ```