---
title: nginx+php-fpm环境下的mysqld痛不欲生
tags:
  - mysqld
  - Nginx
  - php-fpm
id: 390
categories:
  - Linux
abbrlink: 86e6b4be
date: 2016-05-22 00:57:47
---

## 问题背景

今天突然发现自己的服务器又出现了Mysql服务器的崩溃，重启一下便恢复了。
但是！下午2点的时候重启的，晚上回来一看，数据库又挂了！！！十分恼火啊！再重启一下，什么？直接启动不了啦！
发生报错：
<pre lang="bash">
[root@iZ28l1ca1vhZ ~]# service mysqld start
Starting MySQL.The server quit without updating PID file (/usr/local/mysql/data/iZ28l1ca1vhZ.pid).                                         [FAILED]
[root@iZ28l1ca1vhZ ~]# service mysqld restart
</pre>

## 排查过程

查看mysqld的日志：
<!--more-->

<pre lang="bash">
160521 11:06:36 InnoDB: Mutexes and rw_locks use GCC atomic builtins
160521 11:06:36 InnoDB: Compressed tables use zlib 1.2.3
160521 11:06:36 InnoDB: Initializing buffer pool, size = 128.0M
InnoDB: mmap(137363456 bytes) failed; errno 12
160521 11:06:36 InnoDB: Completed initialization of buffer pool
160521 11:06:36 InnoDB: Fatal error: cannot allocate memory for the buffer pool
160521 11:06:36 [ERROR] Plugin 'InnoDB' init function returned error.
160521 11:06:36 [ERROR] Plugin 'InnoDB' registration as a STORAGE ENGINE failed.
160521 11:06:36 [ERROR] Unknown/unsupported storage engine: InnoDB
160521 11:06:36 [ERROR] Aborting

160521 11:06:36 [Note] /usr/local/mysql/bin/mysqld: Shutdown complete

160521 11:06:37 mysqld_safe mysqld from pid file /usr/local/mysql/data/iZ28l1ca1vhZ.pid ended

#到这里，11点钟的时候，数据库服务器挂掉了，我在下面手动重启了一下

160521 14:09:53 mysqld_safe Starting mysqld daemon with databases from /usr/local/mysql/data
160521 14:09:53 [Note] /usr/local/mysql/bin/mysqld (mysqld 5.5.49-log) starting as process 7082 ...
160521 14:09:53 [Note] Plugin 'FEDERATED' is disabled.
160521 14:09:53 InnoDB: The InnoDB memory heap is disabled
160521 14:09:53 InnoDB: Mutexes and rw_locks use GCC atomic builtins
160521 14:09:53 InnoDB: Compressed tables use zlib 1.2.3
160521 14:09:53 InnoDB: Initializing buffer pool, size = 128.0M
160521 14:09:53 InnoDB: Completed initialization of buffer pool
160521 14:09:53 InnoDB: highest supported file format is Barracuda.
InnoDB: The log sequence number in ibdata files does not match
InnoDB: the log sequence number in the ib_logfiles!
160521 14:09:53  InnoDB: Database was not shut down normally!
InnoDB: Starting crash recovery.
InnoDB: Reading tablespace information from the .ibd files...
InnoDB: Restoring possible half-written data pages from the doublewrite
InnoDB: buffer...
InnoDB: Last MySQL binlog file position 0 66125264, file name ./mysql-bin.000006
160521 14:09:54  InnoDB: Waiting for the background threads to start
160521 14:09:55 InnoDB: 5.5.49 started; log sequence number 112243593
160521 14:09:56 [Note] Recovering after a crash using mysql-bin
160521 14:09:57 [Note] Starting crash recovery...
160521 14:09:57 [Note] Crash recovery finished.
160521 14:09:57 [Note] Server hostname (bind-address): '0.0.0.0'; port: 3306
160521 14:09:57 [Note]   - '0.0.0.0' resolves to '0.0.0.0';
160521 14:09:57 [Note] Server socket created on IP: '0.0.0.0'.
160521 14:09:57 [Note] Event Scheduler: Loaded 0 events
160521 14:09:57 [Note] /usr/local/mysql/bin/mysqld: ready for connections.
Version: '5.5.49-log'  socket: '/tmp/mysql.sock'  port: 3306  Source distribution
160521 15:44:06 [Warning] IP address '121.40.144.113' could not be resolved: Name or service not known

#到这里为止，上面显示启动是成功的，而且在15点44分的时候还有一条警告，说明是正常运行的，但是下面到了18点49分，开始有日志显示了

160521 18:49:27 mysqld_safe Number of processes running now: 0
160521 18:49:27 mysqld_safe mysqld restarted
160521 18:49:27 [Note] /usr/local/mysql/bin/mysqld (mysqld 5.5.49-log) starting as process 8329 ...
160521 18:49:28 [Note] Plugin 'FEDERATED' is disabled.
160521 18:49:28 InnoDB: The InnoDB memory heap is disabled
160521 18:49:28 InnoDB: Mutexes and rw_locks use GCC atomic builtins
160521 18:49:28 InnoDB: Compressed tables use zlib 1.2.3
160521 18:49:28 InnoDB: Initializing buffer pool, size = 128.0M
InnoDB: mmap(137363456 bytes) failed; errno 12
160521 18:49:28 InnoDB: Completed initialization of buffer pool
160521 18:49:28 InnoDB: Fatal error: cannot allocate memory for the buffer pool
160521 18:49:28 [ERROR] Plugin 'InnoDB' init function returned error.
160521 18:49:28 [ERROR] Plugin 'InnoDB' registration as a STORAGE ENGINE failed.
160521 18:49:28 [ERROR] Unknown/unsupported storage engine: InnoDB
160521 18:49:28 [ERROR] Aborting

160521 18:49:28 [Note] /usr/local/mysql/bin/mysqld: Shutdown complete

160521 18:49:28 mysqld_safe mysqld from pid file /usr/local/mysql/data/iZ28l1ca1vhZ.pid ended

#从上面的日志可以看出来，[ERROR]报错中 都是InnoDB的，上面有个Fatal error，说内存无法分配，由于my.cnf中没有给出InnoDB的缓冲池大小，默认是128M的，但是这在我的1GB小内存的服务器完全可以带动啊
#不管了，你说不够，我手动设置你少吃点内存把，修改了my.cnf中的InnoDB_buffer_pool_size = 16M。然后重启mysqld 

160521 23:30:24 mysqld_safe Starting mysqld daemon with databases from /usr/local/mysql/data
160521 23:30:24 [Note] /usr/local/mysql/bin/mysqld (mysqld 5.5.49-log) starting as process 10146 ...
160521 23:30:24 [Note] Plugin 'FEDERATED' is disabled.
160521 23:30:24 InnoDB: The InnoDB memory heap is disabled
160521 23:30:24 InnoDB: Mutexes and rw_locks use GCC atomic builtins
160521 23:30:24 InnoDB: Compressed tables use zlib 1.2.3
160521 23:30:24 InnoDB: Initializing buffer pool, size = 16.0M
160521 23:30:24 InnoDB: Completed initialization of buffer pool
160521 23:30:24 InnoDB: highest supported file format is Barracuda.
InnoDB: Log scan progressed past the checkpoint lsn 112315178
160521 23:30:24  InnoDB: Database was not shut down normally!
InnoDB: Starting crash recovery.
InnoDB: Reading tablespace information from the .ibd files...
InnoDB: Restoring possible half-written data pages from the doublewrite
InnoDB: buffer...
InnoDB: Doing recovery: scanned up to log sequence number 112323325
160521 23:30:25  InnoDB: Starting an apply batch of log records to the database...
InnoDB: Progress in percents: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 
InnoDB: Apply batch completed
InnoDB: Last MySQL binlog file position 0 127786, file name ./mysql-bin.000007
160521 23:30:25  InnoDB: Waiting for the background threads to start
160521 23:30:26 InnoDB: 5.5.49 started; log sequence number 112323325
160521 23:30:26 [Note] Recovering after a crash using mysql-bin
160521 23:30:26 [Note] Starting crash recovery...
160521 23:30:26 [Note] Crash recovery finished.
160521 23:30:27 [Note] Server hostname (bind-address): '0.0.0.0'; port: 3306
160521 23:30:27 [Note]   - '0.0.0.0' resolves to '0.0.0.0';
160521 23:30:27 [Note] Server socket created on IP: '0.0.0.0'.
160521 23:30:27 [Note] Event Scheduler: Loaded 0 events
160521 23:30:27 [Note] /usr/local/mysql/bin/mysqld: ready for connections.
Version: '5.5.49-log'  socket: '/tmp/mysql.sock'  port: 3306  Source distribution

#铛铛！启动成功了
</pre>

但是，这并不能说服我对内存大小的好奇心！

## 进一步探究

好的，我们看下内存的使用情况：
<pre lang="bash">
[root@iZ28l1ca1vhZ ~]# free -m
             total       used       free     shared    buffers     cached
Mem:           994        927         67          0          2         19
-/+ buffers/cache:        904         89 
Swap:            0          0          0 
</pre>
什么鬼！ 剩余的才67M了？我的内存都被谁吃了呢？

<pre lang="bash">
[root@iZ28l1ca1vhZ ~]# top

top - 23:42:33 up 113 days, 23:49,  1 user,  load average: 0.03, 0.05, 0.00
Tasks: 110 total,   1 running, 109 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.3%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   1018508k total,   949960k used,    68548k free,     2616k buffers
Swap:        0k total,        0k used,        0k free,    17124k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                                                                                
    1 root      20   0 19232  528  236 S  0.0  0.1   0:04.87 init                                                                                                                   
    2 root      20   0     0    0    0 S  0.0  0.0   0:00.08 kthreadd                                                                                                               
    3 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/0                                                                                                            
    4 root      20   0     0    0    0 S  0.0  0.0   0:15.29 ksoftirqd/0                                                                                                            
    5 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 stopper/0                                                                                                              
    6 root      RT   0     0    0    0 S  0.0  0.0   0:12.18 watchdog/0                                                                                                             
    7 root      20   0     0    0    0 S  0.0  0.0   8:25.89 events/0                                                                                                               
    8 root      20   0     0    0    0 S  0.0  0.0   0:00.00 events/0                                                                                                               
    9 root      20   0     0    0    0 S  0.0  0.0   0:00.00 events_long/0                                                                                                          
   10 root      20   0     0    0    0 S  0.0  0.0   0:00.00 events_power_ef                                                                                                        
   11 root      20   0     0    0    0 S  0.0  0.0   0:00.00 cgroup                                                                                                                 
   12 root      20   0     0    0    0 S  0.0  0.0   0:00.21 khelper                                                                                                                
   13 root      20   0     0    0    0 S  0.0  0.0   0:00.00 netns                                                                                                                  
   14 root      20   0     0    0    0 S  0.0  0.0   0:00.00 async/mgr                                                                                                              
   15 root      20   0     0    0    0 S  0.0  0.0   0:00.00 pm                                                                                                                     
   16 root      20   0     0    0    0 S  0.0  0.0   0:00.00 xenwatch                                                                                                               
   17 root      20   0     0    0    0 S  0.0  0.0   0:00.02 xenbus                                                                                                                 
   18 root      20   0     0    0    0 S  0.0  0.0   0:29.34 sync_supers                                                                                                            
   19 root      20   0     0    0    0 S  0.0  0.0   0:30.05 bdi-default                                                                                                            
   20 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kintegrityd/0                                                                                                          
   21 root      20   0     0    0    0 S  0.0  0.0   0:19.20 kblockd/0                                                                                                              
   22 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kacpid                                                                                                                 
   23 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kacpi_notify                                                                                                           
   24 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kacpi_hotplug                                                                                                          
   25 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ata_aux                                                                                                                
   26 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ata_sff/0                                                                                                              
   27 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksuspend_usbd                                                                                                          
   28 root      20   0     0    0    0 S  0.0  0.0   0:00.00 khubd                                                                                                                  
   29 root      20   0     0    0    0 S  0.0  0.0   0:00.04 kseriod                                                                                                                
   30 root      20   0     0    0    0 S  0.0  0.0   0:00.00 md/0                                                                                                                   
   31 root      20   0     0    0    0 S  0.0  0.0   0:00.00 md_misc/0                                                                                                              
   32 root      20   0     0    0    0 S  0.0  0.0   0:00.00 linkwatch                                                                                                              
   33 root      20   0     0    0    0 S  0.0  0.0   0:01.93 khungtaskd                                                                                                             
   34 root      20   0     0    0    0 S  0.0  0.0   0:08.05 kswapd0                                                                                                                
   35 root      25   5     0    0    0 S  0.0  0.0   0:00.00 ksmd                                                                                                                   
   36 root      39  19     0    0    0 S  0.0  0.0   0:33.08 khugepaged                                                                                                             
   37 root      20   0     0    0    0 S  0.0  0.0   0:00.00 aio/0                                                                                                                  
   38 root      20   0     0    0    0 S  0.0  0.0   0:00.00 crypto/0                                                                                                               
   45 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthrotld/0                                                                                                             
   47 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kpsmoused                                                                                                              
   48 root      20   0     0    0    0 S  0.0  0.0   0:00.00 usbhid_resumer                                                                                                         
   49 root      20   0     0    0    0 S  0.0  0.0   0:00.00 deferwq                                                                                                                
   81 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kdmremove                                                                                                              
   82 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kstriped                                                                                                               
  182 root      20   0     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_0                                                                                                              
  183 root      20   0     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_1                                                                                                              
  244 root      20   0     0    0    0 S  0.0  0.0   0:50.93 jbd2/xvda1-8                                                                                                           
  245 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ext4-dio-unwrit                                                                                                        
  337 root      16  -4 10668  436    0 S  0.0  0.0   0:00.12 udevd                                                                                                                  
  636 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kauditd                                                                                                                
  901 root      20   0  245m 4892  388 S  0.0  0.5   0:21.33 rsyslogd                                                                                                               
  962 root      20   0  463m 1520  828 S  0.0  0.1  82:14.67 AliYunDunUpdate                                                                                                        
 1014 ntp       20   0 26596  848  352 S  0.0  0.1   0:45.91 ntpd                                                                                                                   
 1046 root      20   0  114m  896  296 S  0.0  0.1   0:35.16 crond                                                                                                                  
 1080 root      20   0 31620   68    0 S  0.0  0.0   0:00.00 gshelld                                                                                                                
 1099 root      20   0  4064   72    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 1101 root      20   0  4064   76    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 1103 root      20   0  4064   72    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 1105 root      20   0  4064   72    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 1109 root      20   0  4064   72    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 1176 root      20   0  243m 6372 1572 S  0.0  0.6 230:19.97 AliYunDun                                                                                                              
 5070 nscd      20   0  615m 1064  576 S  0.0  0.1   1:10.26 nscd                                                                                                                   
 5563 nginx     20   0  364m  33m 1520 S  0.0  3.4   3:08.90 php-fpm                                                                                                                
 5615 nginx     20   0  330m  11m 1936 S  0.0  1.1   0:04.03 php-fpm 
</pre>
最后面的两个php-fpm让我起了疑心！
pstree -p 看了一下 php-fpm的进程，居然有35个子进程！！
Mem:   1018508k total,   949960k used,    68548k free,     2616k buffers
这里显示只有68548k 是 free（空闲）的，好！我重启了一下fpm，看看接下来的内存使用情况：
<pre lang="bash">
[root@iZ28l1ca1vhZ ~]# top

top - 23:43:51 up 113 days, 23:50,  1 user,  load average: 0.06, 0.05, 0.00
Tasks:  81 total,   1 running,  80 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.3%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   1018508k total,   170960k used,   847548k free,     7864k buffers
Swap:        0k total,        0k used,        0k free,    39568k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                                                                                
  962 root      20   0  463m 1520  828 S  0.3  0.1  82:14.72 AliYunDunUpdate                                                                                                        
 1176 root      20   0  243m 6372 1572 S  0.3  0.6 230:20.09 AliYunDun                                                                                                              
    1 root      20   0 19232  544  252 S  0.0  0.1   0:04.87 init                                                                                                                   
    2 root      20   0     0    0    0 S  0.0  0.0   0:00.08 kthreadd                                                                                                               
    3 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/0                                                                                                            
    4 root      20   0     0    0    0 S  0.0  0.0   0:15.29 ksoftirqd/0                                                                                                            
    5 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 stopper/0                                                                                                              
    6 root      RT   0     0    0    0 S  0.0  0.0   0:12.18 watchdog/0                                                                                                             
    7 root      20   0     0    0    0 S  0.0  0.0   8:25.89 events/0                                                                                                               
    8 root      20   0     0    0    0 S  0.0  0.0   0:00.00 events/0                                                                                                               
    9 root      20   0     0    0    0 S  0.0  0.0   0:00.00 events_long/0                                                                                                          
   10 root      20   0     0    0    0 S  0.0  0.0   0:00.00 events_power_ef                                                                                                        
   11 root      20   0     0    0    0 S  0.0  0.0   0:00.00 cgroup                                                                                                                 
   12 root      20   0     0    0    0 S  0.0  0.0   0:00.21 khelper                                                                                                                
   13 root      20   0     0    0    0 S  0.0  0.0   0:00.00 netns                                                                                                                  
   14 root      20   0     0    0    0 S  0.0  0.0   0:00.00 async/mgr                                                                                                              
   15 root      20   0     0    0    0 S  0.0  0.0   0:00.00 pm                                                                                                                     
   16 root      20   0     0    0    0 S  0.0  0.0   0:00.00 xenwatch                                                                                                               
   17 root      20   0     0    0    0 S  0.0  0.0   0:00.02 xenbus                                                                                                                 
   18 root      20   0     0    0    0 S  0.0  0.0   0:29.34 sync_supers                                                                                                            
   19 root      20   0     0    0    0 S  0.0  0.0   0:30.05 bdi-default                                                                                                            
   20 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kintegrityd/0                                                                                                          
   21 root      20   0     0    0    0 S  0.0  0.0   0:19.21 kblockd/0                                                                                                              
   22 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kacpid                                                                                                                 
   23 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kacpi_notify                                                                                                           
   24 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kacpi_hotplug                                                                                                          
   25 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ata_aux                                                                                                                
   26 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ata_sff/0                                                                                                              
   27 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ksuspend_usbd                                                                                                          
   28 root      20   0     0    0    0 S  0.0  0.0   0:00.00 khubd                                                                                                                  
   29 root      20   0     0    0    0 S  0.0  0.0   0:00.04 kseriod                                                                                                                
   30 root      20   0     0    0    0 S  0.0  0.0   0:00.00 md/0                                                                                                                   
   31 root      20   0     0    0    0 S  0.0  0.0   0:00.00 md_misc/0                                                                                                              
   32 root      20   0     0    0    0 S  0.0  0.0   0:00.00 linkwatch                                                                                                              
   33 root      20   0     0    0    0 S  0.0  0.0   0:01.93 khungtaskd                                                                                                             
   34 root      20   0     0    0    0 S  0.0  0.0   0:08.05 kswapd0                                                                                                                
   35 root      25   5     0    0    0 S  0.0  0.0   0:00.00 ksmd                                                                                                                   
   36 root      39  19     0    0    0 S  0.0  0.0   0:33.08 khugepaged                                                                                                             
   37 root      20   0     0    0    0 S  0.0  0.0   0:00.00 aio/0                                                                                                                  
   38 root      20   0     0    0    0 S  0.0  0.0   0:00.00 crypto/0                                                                                                               
   45 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthrotld/0                                                                                                             
   47 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kpsmoused                                                                                                              
   48 root      20   0     0    0    0 S  0.0  0.0   0:00.00 usbhid_resumer                                                                                                         
   49 root      20   0     0    0    0 S  0.0  0.0   0:00.00 deferwq                                                                                                                
   81 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kdmremove                                                                                                              
   82 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kstriped                                                                                                               
  182 root      20   0     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_0                                                                                                              
  183 root      20   0     0    0    0 S  0.0  0.0   0:00.00 scsi_eh_1                                                                                                              
  244 root      20   0     0    0    0 S  0.0  0.0   0:50.93 jbd2/xvda1-8                                                                                                           
  245 root      20   0     0    0    0 S  0.0  0.0   0:00.00 ext4-dio-unwrit                                                                                                        
  337 root      16  -4 10668  436    0 S  0.0  0.0   0:00.12 udevd                                                                                                                  
  636 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kauditd                                                                                                                
  901 root      20   0  245m 4892  388 S  0.0  0.5   0:21.33 rsyslogd                                                                                                               
 1014 ntp       20   0 26596  848  352 S  0.0  0.1   0:45.92 ntpd                                                                                                                   
 1046 root      20   0  114m  904  304 S  0.0  0.1   0:35.16 crond                                                                                                                  
 1080 root      20   0 31620   68    0 S  0.0  0.0   0:00.00 gshelld                                                                                                                
 1099 root      20   0  4064   72    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 1101 root      20   0  4064   76    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 1103 root      20   0  4064   72    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 1105 root      20   0  4064   72    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 1109 root      20   0  4064   72    4 S  0.0  0.0   0:00.00 mingetty                                                                                                               
 5070 nscd      20   0  615m 1068  580 S  0.0  0.1   1:10.26 nscd                                                                                                                   
 5990 root      20   0 66232  820  112 S  0.0  0.1   0:08.71 sshd                                                                                                                   
 9811 root      20   0 98.1m 2048 1028 S  0.0  0.2   0:00.09 sshd                                                                                                                   
 9813 root      20   0  105m 1552 1116 S  0.0  0.2   0:00.01 bash                                                                                                                   
[root@iZ28l1ca1vhZ ~]# free -m
             total       used       free     shared    buffers     cached
Mem:           994        166        828          0          7         38
-/+ buffers/cache:        120        874 
Swap:            0          0          0 
</pre>
有没有！ 瞬间变成了 847548k 的空闲内存！！！真的是fpm在吃我的小内存，把mysqld逼的跳楼了！！
那么怎么限制fpm这个贪婪的进程呢？
看看它的配置文件吧：/etc/php-fpm.d/www.conf
pm.max_children = 50       ;静态方式下开启的php-fpm进程数量
pm = dynamic               ;这里是动态方式，静态是static
pm.start_servers = 5       ;动态方式下的起始php-fpm进程数量
pm.min_spare_servers = 5   ;动态方式下的最小php-fpm进程数量
pm.max_spare_servers = 35  ;动态方式下的最大php-fpm进程数量

天呐！ 默认的启动就是5个，最大可达35个！按照一个进程至少3M的内存，35个*3=105M，呵呵，别看才105M，你要知道PHP这玩意儿，在执行完成之后，多少有内存泄漏的问题，这也是为啥一开始只要3M左右，运行一段时间之后，就飙到了20M~30M去了，一个进程就算25M，我的小内存服务器1GB，也就够它跑40个，何况还要运行其他的程序呢！这也是为啥mysqld会跳楼了，根本活不下去了！

## 优化配置

那么我现在把它修改一下：
pm.start_servers = 4
pm.min_spare_servers = 3
pm.max_spare_servers = 5
这下应该好多了吧！看看使用情况：
<pre lang="bash">
[root@iZ28l1ca1vhZ ~]# free -m
             total       used       free     shared    buffers     cached
Mem:           994        213        780          0         12         47
-/+ buffers/cache:        153        841 
Swap:            0          0          0 
[root@iZ28l1ca1vhZ ~]# service php-fpm restart
Stopping php-fpm:                                          [  OK  ]
Starting php-fpm:                                          [  OK  ]
[root@iZ28l1ca1vhZ ~]# free -m
             total       used       free     shared    buffers     cached
Mem:           994        198        796          0         13         60
-/+ buffers/cache:        124        870 
  ap:            0          0          0 
</pre>
因为没多久前重启了一次FPM，所以现在看来差距不大，但是和之前的剩余几十兆相比，差距啊！

我让服务器运行了一段时间，再看看结果：
<pre lang="bash">
[root@iZ28l1ca1vhZ ~]# free -m
             total       used       free     shared    buffers     cached
Mem:           994        417        577          0         22        112
-/+ buffers/cache:        281        712 
Swap:            0          0          0 
</pre>

情况还算不错！

第二天早上起来，继续观察内存使用情况：
<pre lang="bash">
[root@iZ28l1ca1vhZ ~]# free -m
             total       used       free     shared    buffers     cached
Mem:           994        715        279          0        132        182
-/+ buffers/cache:        400        594 
Swap:            0          0          0 

[root@iZ28l1ca1vhZ ~]# top
top - 11:50:06 up 114 days, 11:56,  1 user,  load average: 0.02, 0.01, 0.00
Tasks:  81 total,   1 running,  80 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.3%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   1018508k total,   735616k used,   282892k free,   136052k buffers
Swap:        0k total,        0k used,        0k free,   187264k cached
...
</pre>
看样子还是有点吃内存啊！ 先不重启，看看再过一段时间后的情况吧。

## 压力测试

通过[Atool.ORG](http://www.atool.org/batchpv.php)在线工具来进行一个简单的压力测试，放上去大概30～50个url地址，让它每隔8秒刷一次PV来模拟用户访问

最终结果发现，fpm进程维持在3～10个之间，最大不会超过10个，而且内存的剩余大小200M左右变动。说明这次的优化还是有那么一点点的效果！

## 总结：

mysql经常宕机是因为php-fpm进程数量太大，吃了太多的内存而造成的，通过合理的限制fpm的进程数量可以有效的缓解服务器压力，当然了，这样的后果就是php的并发量有所减小，当相对来说，牺牲一点php的进程数来维持mysql的正常运作还是值得的！对于低配的服务器，合理分配各个程序所占内存容量（简称优化），会更加有效的发挥服务器的最大价值！

## 下面是我参考的相关资料：

[php-fpm mysqld优化配置 解决502 bad getway ,wordpress数据库连接错误](https://www.douban.com/note/323349269/)
[【汇总】PHP-FPM 配置优化](http://zhengdl126.iteye.com/blog/1423566)