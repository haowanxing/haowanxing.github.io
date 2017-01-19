---
title: '[作业]JavaBean+Jsp简易购物车实现'
tags:
  - javaee
  - netbean
  - web
id: 250
categories:
  - 我的分享
date: 2015-10-15 19:36:37
---

本次作业要求使用到JavaBean+纯Jsp，带有登陆功能的购物车系统。
登陆功能这里就不多讲了，前面的聊天室已经做过，这边直接拷贝就能使用了。
另外，本次作业中我加入了BootStrap来做一个小小风格美化。
不多说，直接上代码！
index.jsp 首页，也是登陆界面
<pre lang="java">
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Cookie[] cookies = request.getCookies();
    String uname = "";
    String upwd = "";
    if(cookies!=null){
        for(int i=0;i<cookies.length;i++)
        {
            Cookie cookie=cookies[i];
            if(cookie.getName().equals("remname"))
            {
                uname = cookie.getValue();
            }
            else if(cookie.getName().equals("rempwd"))
            {
                upwd = cookie.getValue();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>请登录ShopCartDemo</title>
        <link href="bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <form class="form-horizontal" action="dologin.jsp" method="post" name="loginform">
                <div class="form-group">
                    <label for="inputusername" class="col-sm-5 control-label">用户名</label>
                    <div class="col-sm-2">
                        <input class="form-control" id="inputusername" type="text" name="username" value="<%=uname%>" placeholder="username" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputpassword" class="col-sm-5 control-label">密码</label>
                    <div class="col-sm-2">
                        <input class="form-control" id="inputpassword" type="password" name="password" value="<%=upwd%>" placeholder="password" />
                    </div>
                </div>
                <div class="form-group">
                <div class="col-sm-offset-5 col-sm-2">
                  <div class="checkbox">
                    <label>
                        <input type="checkbox" name="remember" value="true"> 记住我
                    </label>
                  </div>
                </div>
              </div>

                <div class="form-group">
                  <div class="col-sm-offset-5 col-sm-2">
                    <button type="submit" class="btn btn-default">登陆</button>
                    <button type="reset" class="btn btn-default">重置</button>
                  </div>
                </div>

            </form>
        </div>
    </body>
</html>
</pre>

dologin.jsp 登陆信息处理页面
<pre lang="java">
<%-- 
    Document   : dologin
    Created on : 2015-10-9, 11:28:29
    Author     : Anthony
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>正在登录...</title>
    </head>
    <body>
        <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = (String) request.getParameter("remember");
        if(username == null)
            username="";
        if(password == null)
            password="";
        if(remember == null)
            remember = "false";
        if(username.equals("201321092028")&&password.equals("123456") || username.equals("201321092027")&&password.equals("123456"))
        {
            if(remember != null && remember.equals("true"))
            {
                Cookie cookie1 = new Cookie("remname",username);
                Cookie cookie2 = new Cookie("rempwd",password);
                cookie1.setMaxAge(60*60*24*5);
                cookie2.setMaxAge(60*60*24*5);
                response.addCookie(cookie1);
                response.addCookie(cookie2);
            }
            session.setAttribute("UserName",username);
            session.setAttribute("IsLogin","true");
            response.sendRedirect("goods.jsp");
        }else{
            response.sendRedirect("index.jsp");
        }
        %>
    </body>
</html>
</pre> 

goods.jsp 商品列表页面

<pre lang="java">
<%-- 
    Document   : goods
    Created on : 2015-10-15, 17:11:28
    Author     : anthony
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>商品列表</title>
        <link href="bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">

温馨提示：请选购商品并填写所需购买的数量

            <form method="post" action="order.jsp">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>编号</th><th>商品名</th><th>单价(元/斤)</th><th>购买数量</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td><td>苹果</td><td>13</td><td><input class="form-control" type="text" name="apple" placeholder="0"/></td>
                        </tr>
                        <tr>
                            <td>2</td><td>橘子</td><td>8</td><td><input class="form-control" type="text" name="orange" placeholder="0"/></td>
                        </tr>
                        <tr>
                            <td>3</td><td>西瓜</td><td>2</td><td><input class="form-control" type="text" name="watermalon" placeholder="0"/></td>
                        </tr>
                        <tr>
                            <td>4</td><td>火龙果</td><td>15</td><td><input class="form-control" type="text" name="fires" placeholder="0"/></td>
                        </tr>
                    </tbody>
                </table>
                <button class="btn btn-success col-sm-offset-11" type="submit">确认订单</button>
            </form>
        </div>
    </body>
</html>
</pre> 

order.jsp 订单信息页面
<pre lang="java">
<%-- 
    Document   : order
    Created on : 2015-10-15, 18:28:05
    Author     : anthony
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>订单信息</title>
        <link href="bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:useBean id="cart" scope="page" class="Cart.CountPrice">
            <jsp:setProperty name="cart" property="n_apple" param="apple"/>
            <jsp:setProperty name="cart" property="n_orange" param="orange"/>
            <jsp:setProperty name="cart" property="n_watermalon" param="watermalon"/>
            <jsp:setProperty name="cart" property="n_fires" param="fires"/>
        <div class="container">

您的订单信息：

            <table class="table table-bordered">
                <thead>
                    <tr class="warning">
                        <th>编号</th><th>商品名</th><th>单价(元/斤)</th><th>数量</th><th>价格</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td><td>苹果</td><td>13</td><td><jsp:getProperty name="cart" property="n_apple"/></td><td><jsp:getProperty name="cart" property="p_apple"/></td>
                    </tr>
                    <tr>
                        <td>2</td><td>橘子</td><td>8</td><td><jsp:getProperty name="cart" property="n_orange"/></td><td><jsp:getProperty name="cart" property="p_orange"/></td>
                    </tr>
                    <tr>
                        <td>3</td><td>西瓜</td><td>2</td><td><jsp:getProperty name="cart" property="n_watermalon"/></td><td><jsp:getProperty name="cart" property="p_watermalon"/></td>
                    </tr>
                    <tr>
                        <td>4</td><td>火龙果</td><td>15</td><td><jsp:getProperty name="cart" property="n_fires"/></td><td><jsp:getProperty name="cart" property="p_fires"/></td>
                    </tr>
                </tbody>
            </table>
            <div class="form-group">
                <label for="confirmination" class="col-sm-1 col-sm-offset-9 control-label text-right">总价：
<jsp:getProperty name="cart" property="totalprice"/>元</label>
                <div class="col-sm-2">
                    <button type="button" id="confirmination" class="btn btn-success">付款</button>
                    [<button type="button" class="btn btn-danger">取消</button>](goods.jsp)
                </div>
            </div>
        </div>
        </jsp:useBean>
    </body>
</html>
</pre> 

另外，还需要一个JavaBean CountPrice.java

<pre lang="java" >
package Cart;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author anthony
 */
public class CountPrice {
    private double n_apple;
    private double n_orange;
    private double n_watermalon;
    private double n_fires;
    private double p_apple;
    private double p_orange;
    private double p_watermalon;
    private double p_fires;
    private double totalprice;

    /**
     * @return the n_apple
     */
    public double getN_apple() {
        return n_apple;
    }

    /**
     * @param n_apple the n_apple to set
     */
    public void setN_apple(double n_apple) {
        this.n_apple = n_apple;
        this.setP_apple(n_apple*13);
    }

    /**
     * @return the n_orange
     */
    public double getN_orange() {
        return n_orange;
    }

    /**
     * @param n_orange the n_orange to set
     */
    public void setN_orange(double n_orange) {
        this.n_orange = n_orange;
        this.setP_orange(n_orange*8);
    }

    /**
     * @return the n_watermalon
     */
    public double getN_watermalon() {
        return n_watermalon;
    }

    /**
     * @param n_watermalon the n_watermalon to set
     */
    public void setN_watermalon(double n_watermalon) {
        this.n_watermalon = n_watermalon;
        this.setP_watermalon(n_watermalon*2);
    }

    /**
     * @return the n_fires
     */
    public double getN_fires() {
        return n_fires;
    }

    /**
     * @param n_fires the n_fires to set
     */
    public void setN_fires(double n_fires) {
        this.n_fires = n_fires;
        this.setP_fires(n_fires*15);
    }

    /**
     * @return the totalprice
     */
    public double getTotalprice() {
        this.totalprice = this.getP_apple()+this.getP_fires()+this.getP_orange()+this.getP_watermalon();
        return totalprice;
    }

    /**
     * @return the p_apple
     */
    public double getP_apple() {
        return p_apple;
    }

    /**
     * @return the p_orange
     */
    public double getP_orange() {
        return p_orange;
    }

    /**
     * @return the p_watermalon
     */
    public double getP_watermalon() {
        return p_watermalon;
    }

    /**
     * @return the p_fires
     */
    public double getP_fires() {
        return p_fires;
    }

    /**
     * @param p_apple the p_apple to set
     */
    public void setP_apple(double p_apple) {
        this.p_apple = p_apple;
    }

    /**
     * @param p_orange the p_orange to set
     */
    public void setP_orange(double p_orange) {
        this.p_orange = p_orange;
    }

    /**
     * @param p_watermalon the p_watermalon to set
     */
    public void setP_watermalon(double p_watermalon) {
        this.p_watermalon = p_watermalon;
    }

    /**
     * @param p_fires the p_fires to set
     */
    public void setP_fires(double p_fires) {
        this.p_fires = p_fires;
    }

}</pre> 

附上NetBean项目工程：
链接: http://pan.baidu.com/s/1o66DrjO <del>密码: yksy</del>