---
title: '[作业练习]带数据库的简易购物车'
tags:
  - javaee
  - netbean
  - web
id: 266
categories:
  - Web技术
  - 学习笔记
date: 2015-10-17 18:24:36
---

在前一次作业的基础上（[[作业]JavaBean+Jsp简易购物车实现](http://www.dshui.wang/2015-10-15/work-javabean-jsp-shopcart-1.html)）,加上数据库来管理商品和购买记录。
最后结果展示：<del>http://demo.dshui.wang/tomcat/ShopCartDemo/</del>
首先，建立数据表：

```
#用户表
CREATE TABLE `cart_users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(80) NOT NULL DEFAULT '',
  `password` varchar(220) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
<!--more-->

#商品表
CREATE TABLE `cart_goods` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `gname` varchar(50) NOT NULL DEFAULT '',
  `gprice` double NOT NULL,
  `gdname` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

#购买记录
CREATE TABLE `cart_lists` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(80) NOT NULL DEFAULT '',
  `gid` int(11) unsigned DEFAULT NULL,
  `gnumber` double DEFAULT NULL,
  `gtprice` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `users` (`username`),
  KEY `goodid` (`gid`),
  CONSTRAINT `goodid` FOREIGN KEY (`gid`) REFERENCES `cart_goods` (`id`),
  CONSTRAINT `users` FOREIGN KEY (`username`) REFERENCES `cart_users` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;
```
写入测试数据：

<!--more-->

```
INSERT INTO `cart_users` (`id`, `username`, `password`)
VALUES
	(1, '201321092028', '123456'),
	(2, '201321092027', '123456');

INSERT INTO `cart_goods` (`id`, `gname`, `gprice`, `gdname`)
VALUES
	(1, '苹果', 13, 'apple'),
	(2, '橘子', 8, 'orange'),
	(3, '西瓜', 2, 'watermalon'),
	(4, '火龙果', 15, 'fires');
```

上面我们在用户表中写入了两个用户 用户名201321092028和201321092027 密码都是123456，在商品表里面写入了4个水果，并给了价格和变量名。
接下来就是用到之前作业写的JSP和JavaBean了，其中一些文件有所改动。
index.jsp

```
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
//判断用户是否登陆，若登陆过则直接跳转商品页面
    if(session.getAttribute("IsLogin").equals("true") && session.getAttribute("UserName")!=null){
          response.sendRedirect("goods.jsp");
    }
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
                      <span class="text-warning">
                        <%
                        if(request.getParameter("error")!=null){
                            out.print("错误代码："+request.getParameter("error").toString());
                        }
                        %>
                      </span>
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
```

dologin.jsp

```
<%-- 
    Document   : dologin
    Created on : 2015-10-9, 11:28:29
    Author     : Anthony
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*,Mysql.MysqlBean"%>
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
        MysqlBean MB = new MysqlBean();
        ResultSet rs = MB.getRs("SELECT * FROM cart_users");
        while(rs.next()){
            if(rs.getString("username").equals(username)&&rs.getString("password").equals(password)){
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
            }
        }
        if(!session.getAttribute("IsLogin").equals("true"))
            response.sendRedirect("index.jsp?error=04");
        %>
    </body>
</html>
```

goods.jsp

```
<%-- 
    Document   : goods
    Created on : 2015-10-15, 17:11:28
    Author     : anthony
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*,Mysql.MysqlBean"%>
<%
  session = request.getSession(true);
  String username = "";
  if(session.getAttribute("UserName") != null)
  {
      username = session.getAttribute("UserName").toString();
  }
  if(username != null && !username.equals(""))
  {
      if(!session.getAttribute("IsLogin").equals("true")){
          response.sendRedirect("index.jsp?error=01");
      }
  }else{
      response.sendRedirect("index.jsp?error=01");
  }
 %>
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

            <form id="form1" method="post" action="order.jsp">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>编号</th><th>商品名</th><th>单价(元/斤)</th><th>购买数量</th>
                        </tr>
                    </thead>
                    <tbody>
    <%
        MysqlBean MB = new MysqlBean();
        ResultSet rs = MB.getRs("SELECT * FROM cart_goods");
        while(rs.next()){
    %>
                        <tr>
                            <td><%=rs.getInt("id")%></td><td><%=rs.getString("gname")%></td><td><%=rs.getString("gprice")%></td><td><input class="form-control" type="text" name="<%=rs.getString("gdname")%>" placeholder="0"/></td>
                        </tr>
    <%
        }
    %>
                    </tbody>
                </table>
                    <button class="btn btn-success col-sm-offset-11" type="submit">确认订单</button>
            </form>
        </div>
    </body>
</html>
```

order.jsp

```
<%-- 
    Document   : order
    Created on : 2015-10-15, 18:28:05
    Author     : anthony
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*,Mysql.MysqlBean"%>
<%
  session = request.getSession(true);
  String username = "";
  if(session.getAttribute("UserName") != null)
  {
      username = session.getAttribute("UserName").toString();
  }
  if(username != null && !username.equals(""))
  {
      if(!session.getAttribute("IsLogin").equals("true")){
          response.sendRedirect("index.jsp?error=01");
      }
  }else{
      response.sendRedirect("index.jsp?error=01");
  }
 %>
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
        <jsp:useBean id="cart" scope="page" class="Cart.CountPriceByDb">
            <jsp:setProperty name="cart" property="username" value="<%=username%>"/>
            <jsp:setProperty name="cart" property="n_apple" param="apple"/>
            <jsp:setProperty name="cart" property="n_orange" param="orange"/>
            <jsp:setProperty name="cart" property="n_watermalon" param="watermalon"/>
            <jsp:setProperty name="cart" property="n_fires" param="fires"/>
        <div class="container">

您的订单信息：

            <table class="table table-bordered">
                <thead>
                    <tr class="warning">
                        <th>商品名</th><th>单价(元/斤)</th><th>数量</th><th>价格</th><th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <jsp:getProperty name="cart" property="listtag"/>
                </tbody>
            </table>
            <div class="form-group">
                <label for="confirmination" class="col-sm-1 col-sm-offset-9 control-label text-right">总价：
<jsp:getProperty name="cart" property="totalprice"/>元</label>
                <div class="col-sm-2">
                    <button type="button" id="confirmination" class="btn btn-success">付款</button>
                    [<button type="button" class="btn btn-danger">返回</button>](goods.jsp)
                </div>
            </div>
        </div>
        </jsp:useBean>
    </body>
</html>
```
delcart.jsp 删除处理页面（新增的)

```
<%-- 
    Document   : delcart
    Created on : 2015-10-17, 16:00:26
    Author     : anthony
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.sql.*,Mysql.MysqlBean"%>
<%
  session = request.getSession(true);
  String username = "";
  if(session.getAttribute("UserName") != null)
  {
      username = session.getAttribute("UserName").toString();
  }
  if(username != null && !username.equals(""))
  {
      if(!session.getAttribute("IsLogin").equals("true")){
          response.sendRedirect("index.jsp?error=01");
      }
  }else{
      response.sendRedirect("index.jsp?error=01");
  }
 %>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>移除商品</title>
    </head>
    <body>
        <%
        String gid = request.getParameter("gid");
        if(gid==null){
            gid = "";
        }
        if(!gid.equals("")){
            MysqlBean MB = new MysqlBean();
            String sql = "DELETE FROM cart_lists where id="+gid+" and username=\""+username+"\"";
            int num = MB.executeUpdate(sql);
            if(num > 0)
                out.print("<script>alert('成功移除,请刷新页面');location.replace('order.jsp');</script>");
            else
                System.out.print("没有成功");
        }
        %>
    </body>
</html>
```

接下来来写javabean:
我们首先要一个操作数据库的Bean: MysqlBean.java 在包 Mysql里面

```
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Mysql;

/**
 *
 * @author anthony
 */
import java.sql.*;

public class MysqlBean {
    private Connection con = null;
    private ResultSet rs;
    private String driverName = "com.mysql.jdbc.Driver"; 
    private String serverName = "localhost";//填写你的数据库服务地址
    private String mydatabase = "test";//填写你的数据库名称
    private String username = "root";//登陆数据库的账号
    private String password = "pass";//账号的密码

    public MysqlBean() {
        try {
            String url = "jdbc:mysql://" + serverName + "/" + mydatabase; // a
            Class.forName(driverName);
            // con = DriverManager.getConnection(url, username, password);
            con = DriverManager.getConnection("jdbc:mysql://" + serverName
                    + ":3306/" + mydatabase + "?user=" + username
                    + "&password=" + password
                    + "&useUnicode=true&characterEncoding=UTF-8");
            // con.setAutoCommit(false);
        } catch (ClassNotFoundException e) {
            // Could not find the database driver
            System.out.println("Could not find the database driver");
        } catch (SQLException e) {
            // Could not connect to the database
            System.out.println("Could not connect to the database");
        }
    }

    public Connection getCon() {
        return con;
    }

    public ResultSet getRs(String sql) throws Exception {
        try {
            Statement stmt = con.createStatement(
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
            rs = stmt.executeQuery(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rs;
    }

    public int executeUpdate(String sql) {
        int count = 0;
        try {
            Statement stmt = con
                    .createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                            ResultSet.CONCUR_UPDATABLE);
            count = stmt.executeUpdate(sql);
            if (count != 0)
                ;
            // con.commit();
            else
                ;
            // con.rollback();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return count;
    }

    public void Close() {
        try {
            if (con != null)
                con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

在Cart包中新建一个Bean: CountPriceByDb.java 这是调取了数据库的

```
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
import Mysql.MysqlBean;
import java.sql.*;
public class CountPriceByDb {
    private String username;
    private double n_apple;
    private double n_orange;
    private double n_watermalon;
    private double n_fires;
    private double p_apple;
    private double p_orange;
    private double p_watermalon;
    private double p_fires;
    private double s_apple;
    private double s_orange;
    private double s_watermalon;
    private double s_fires;
    private double totalprice;
    private static final MysqlBean MB = new MysqlBean();;
    private ResultSet rs;

    public CountPriceByDb() throws Exception{
        //MB = new MysqlBean();
        rs = MB.getRs("SELECT * FROM cart_goods");
        while(rs.next()){
            switch (rs.getString("gname")) {
                case "苹果":
                    this.s_apple = rs.getDouble("gprice");
                    break;
                case "橘子":
                    this.s_orange = rs.getDouble("gprice");
                    break;
                case "西瓜":
                    this.s_watermalon = rs.getDouble("gprice");
                    break;
                case "火龙果":
                    this.s_fires = rs.getDouble("gprice");
                    break;
            }
        }
    }
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
        this.setP_apple(n_apple*s_apple);
        int num = MB.executeUpdate("INSERT INTO cart_lists (username,gid,gnumber,gtprice) VALUES (\""+this.getUsername()+"\",1,\""+n_apple+"\",\""+this.getP_apple()+"\")");
        System.out.println("影响："+num);
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
        this.setP_orange(n_orange*s_orange);
        int num = MB.executeUpdate("INSERT INTO cart_lists (username,gid,gnumber,gtprice) VALUES (\""+this.getUsername()+"\",2,\""+n_orange+"\",\""+this.getP_orange()+"\")");
        System.out.println("影响："+num);
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
        this.setP_watermalon(n_watermalon*s_watermalon);
        int num = MB.executeUpdate("INSERT INTO cart_lists (username,gid,gnumber,gtprice) VALUES (\""+this.getUsername()+"\",3,\""+n_watermalon+"\",\""+this.getP_watermalon()+"\")");
        System.out.println("影响："+num);
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
        this.setP_fires(n_fires*s_fires);
        int num = MB.executeUpdate("INSERT INTO cart_lists (username,gid,gnumber,gtprice) VALUES (\""+this.getUsername()+"\",4,\""+n_fires+"\",\""+this.getP_fires()+"\")");
        System.out.println("影响："+num);
    }

    /**
     * @return the totalprice
     */
    public double getTotalprice() throws Exception {
        ResultSet rs = MB.getRs("SELECT SUM(gtprice) tol from cart_lists where `username`=\""+this.getUsername()+"\";");
        while(rs.next()){
            this.totalprice = rs.getDouble("tol");
        }
        //this.totalprice = this.getP_apple()+this.getP_fires()+this.getP_orange()+this.getP_watermalon();
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

    public String getListtag() throws Exception{
        String tag = "";
        ResultSet rs = MB.getRs("SELECT * FROM cart_lists a left join cart_goods b on a.`gid`=b.`id` where a.username = \""+this.getUsername()+"\"");
        while(rs.next()){
            tag += "<tr>";
            tag += "<td>"+rs.getString("gname")+"</td>"+"<td>"+rs.getDouble("gprice")+"</td>"+"<td>"+rs.getDouble("gnumber")+"</td>"+"<td>"+rs.getDouble("gtprice")+"</td><td>[移除该商品](\)</td>";
            tag += "</tr>";
        }
        return tag;
    }

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @param username the username to set
     */
    public void setUsername(String username) {
        System.out.println(username);
        this.username = username;
    }
}

```

NetBean项目工程文件：
链接: http://pan.baidu.com/s/1gdvwzrd <del>密码: 84ru</del>
项目需自行添加mysql的connector Java库