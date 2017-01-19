---
title: 作业3-1（完成MYSQL操作）
id: 157
categories:
  - 学习笔记
  - 数据库
date: 2015-05-09 10:40:51
tags:
---

[![作业3-1要求](/wp-content/uploads/2015/05/QQ20150509-1@2x-285x300.png)](/wp-content/uploads/2015/05/QQ20150509-1@2x.png)
<pre lang="sql" line="1" escaped="true">
第一步，创建数据库'XSGL': 
create database XSGL;

第二步，创建学生表'student': 
create table student(
Sno char(7) NOT NULL,
Sname char(10) NOT NULL,
Ssex enum('男','女') NULL,
Sage tinyint(4) NULL,
Sdept char(20) NULL default '计算机系',
PRIMARY KEY(Sno)
)engine=innodb default charset=utf8;

第三步，插入数据：
insert into student(Sno,Sname,Ssex,Sage,Sdept) values ('9512101','李勇','男','19','计算机系'),('9512102','刘晨','男','20','计算机系'),('9512103','王敏','女','20','计算机系'),('9521101','张立','男','22','信息系'),('9521102','吴兵','女','21','信息系'),('9521103','张海','男','20','信息系'),('9531101','钱小平','女','18','数学系'),('9531102','王大力','男','19','数学系');

第四步，删除学号为'9531102'的记录：
delete from student where Sno='9531102';

第五步，将计算机系的学生年龄统一加'1'：
update student set Sage=Sage+1 where Sdept='计算机系';

第六步，显示学生的学号和姓名两列,这两列分别起别名为“ID”和“NAME”, 要求只列出查询结果的前 5 条记录：
select Sno as ID,Sname as NAME from student limit 5;

第七步，查询信息系所有男同学的所有信息：
select * from student where Sdept='信息系' and Ssex='男';

第八步，查询 student 表所有的数据,按照年龄排序,年龄相同则按照学号降序排序：
select * from student order by Sage ASC,Sno DESC;

第九步，查询所有姓“王”的同学的基本信息：
select * from student where Sname LIKE '王%';

第十步，查询每个院系学生的人数,要求列出院系名称和相应人数：
select COUNT(*) as '人数',Sdept from student GROUP BY Sdept;
//如果一张表里面学号有重复的，必须去重！使用下面语句：
select COUNT(DISTINCT Sno) as '人数',Sdept from student GROUP BY Sdept;
</pre>
到此，作业3-1就做完了！