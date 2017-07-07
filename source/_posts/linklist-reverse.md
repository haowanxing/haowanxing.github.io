---
title: 已知单链表，写一算法将其倒置
tags:
  - 倒置
  - 数据结构
  - 链表
id: 412
categories:
  - 我的分享
date: 2016-07-23 01:26:03
---

## 题目：已知单链表H，写一算法将其倒置。

即实现如图2.22的操作。(a)为倒置前，(b)为倒置后。
![1-120222145J02V](http://www.dshui.wang/wp-content/uploads/2016/07/1-120222145J02V-1.jpg)
依次取原链表中的每个结点，将其作为第一个结点插入到新链表中去，指针p用来指向当前结点，p为空时结束。

<!--more-->

参考来源：**[_线性表的链式存储和运算—单链表应用举例_](http://c.biancheng.net/cpp/html/952.html)**

### 实际操练：

下面是根据这个思想所写出来的测试代码：
<pre lang="c">
//
//  main.c
//  NodeTest
//
//  Created by anthony on 16/7/23.
//  Copyright © 2016年 Anthony. All rights reserved.
//

#include <stdio.h>
#include "stdlib.h"

typedef struct node{
    int data;
    struct node *next;
}Node,*Linklist;

/*
 *  初始化（创建）一个链表
 *  @Return Linklist
 */
Linklist link_create(){
    Linklist L;
    if((L = malloc(sizeof(Node))) == NULL){ //申请节点空间失败
        printf("ERROR!");
        return NULL;
    }
    L->next = NULL;
    return L;
}

/*
 *  销毁链表
 */
void link_clear(Linklist L){
    Linklist p = L;
    while (L->next != NULL) {   //逐个判断，释放空间
        p = L->next;
        L->next = p->next;
        free(p);
        p = NULL;
    }
}

/*
 *  链表的打印（顺序输出）
 */
void link_print(Linklist L){
    Linklist p = L->next;
    while (p!=NULL) {
        printf("%d\n",p->data);
        p = p->next;
    }
}

/*
 *  在链表前面插入一个数
 */
void link_insert_before(Linklist L,int x){
    Linklist q;
    q = malloc(sizeof(Node));   //申请节点
    q->data = x;    //赋值数据
    q->next = L->next;  //将新节点的Next指向第一个节点
    L->next=q;  //将头节点的Next只想新的节点
}

/*
 *  在链表后面插入一个数
 */
void link_insert_after(Linklist L,int x){
    Linklist p,q;
    p = L->next;
    while (p->next != NULL) {   //遍历找到最后一个节点给p
        p = p->next;
    }
    q = malloc(sizeof(Node));   //申请节点
    q->data = x;
    q->next = p->next;  //将新节点q的Next指向最后一个节点p的Next 即：NULL
    p->next = q;    //将原本最后一个节点p的Next指向新节点q
}

/*
 *  该算法只是对链表中顺序扫描一边即完成了倒置，所以时间性能为O(n)。
 */
void link_reverse(Linklist L){
    Linklist p,q;
    p = L->next;
    L->next = NULL; //将原链表置空
    while (p) { //从头开始遍历链表
        q = p;  //临时保存当前节点p为q
        p = p->next;    //p指向下一个节点
        q->next = L->next;  //当前节点的Next指向表尾 即：NULL
        L->next = q;    //将当前节点往L链表的头部插入，因为每次都是往开头插入，这样最后的节点就变成了头结点了
    }
}

int main(int argc, const char * argv[]) {
    //创建空链表
    Linklist link = link_create();

    //往头部插数据
    link_insert_before(link, 2);
    link_insert_before(link, 5);
    link_insert_before(link, 9);
    link_insert_before(link, 20);

    //往尾部插数据
    link_insert_after(link, 22);

    link_print(link);   //打印

    link_reverse(link); //逆序

    link_print(link);   //打印

    link_clear(link);   //清空
    return 0;
}

</pre>