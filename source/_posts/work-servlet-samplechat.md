---
title: '[作业]Servlet简易聊天室'
tags:
  - netbean
  - servlet
  - web
id: 234
categories:
  - Web技术
date: 2015-09-28 17:08:55
---

简单例子-Servlet聊天室，所用工具：NetBeans IDE(配备GlassFish)
本次例子重在思路，页面未做任何美化。
最后结果展示：<del>http://demo.dshui.wang/tomcat/First_chat_room/</del>
首先,需要一个登陆页面。
Login.jsp
```
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
//上面代码用来判断用户是否曾保存过登陆信息
%>
<!DOCTYPE html>
<html>
    <head>
        <title>牛逼的登陆界面</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <div>
            <form action="Main" method="post" name="loginform">
                <table>
                    <tr>
                        <td>用户名：</td>
                        <td>
                            <input type="text" name="username" value="<%=uname%>" />
                        </td>
                    </tr>
                    <tr>
                        <td>密码：</td>
                        <td>
                            <input type="password" name="password" value="<%=upwd%>" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: right;">
                            记住信息<input name="remember" type="checkbox" value="true" />
                            <input type="submit" name="submit" value="登录"/>
                            <input type="reset" name="" value="重置"/>
                        </td>
                    </tr>
                </table>

            </form>
        </div>
    </body>
</html>
```
新建一个用来处理登录信息的Servlet: Main.java 所有的处理都在DoPost()完成

<!--more-->

```
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package User;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Administrator
 */
public class Main extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * `GET` and
     * `POST` methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
        } finally {            
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * `GET` method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * `POST` method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        String username,password,remember;
        HttpSession session = request.getSession(true);
        username = (String) request.getParameter("username");
        password = (String) request.getParameter("password");
        remember = (String) request.getParameter("remember");
        System.out.println("remember:"+remember);
        System.out.println(username);
        System.out.println(password);
        if(username != null && username.equals("201321092028") && password.equals("123456"))
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
            response.sendRedirect("LoginSuccess.jsp");
        }else if(username != null && username.equals("201321092027") && password.equals("123456"))
        {
            if(remember.equals("true"))
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
            response.sendRedirect("LoginSuccess.jsp");
        }
        else
        {
            session.setAttribute("IsLogin","false");
            response.sendRedirect("LoginFail.jsp");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}

```
如果登录失败,跳转到LoginFail.jsp
```
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="refresh" content ="3;url=Login.jsp">
        <title>请告诉他,登录失败了</title>
    </head>
    <body>
        **嗨,登陆失败了哟,3秒后跳转到登录页重新登陆哟! [点击此处直接跳转](Login.html)**
    </body>
</html>
```
登录成功，则跳转到FrameSet窗口框架 LoginSuccess.jsp
```
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  session = request.getSession(true);
  String username = "";
  if(session.getAttribute("UserName") != null)
  {
      username = session.getAttribute("UserName").toString();
  }
  if(username != null && !username.equals(""))
  {
      if(!session.getAttribute("IsLogin").equals("true"))
      {System.out.println(session.getAttribute("IsLogin").toString());
          response.sendRedirect("Login.jsp");
      }
  }else{
      response.sendRedirect("Login.jsp");
  }
 %>
<!DOCTYPE html>
<html>
    <frameset rows="50%,25%">
        <frame name="message" src="messagebox" />
        <frame name="uinput" src="userinput.jsp"/>
    </frameset>
</html>
```
上面的Frame加载了两个页面，一个是用来展示Messagebox聊天记录的，一个是用户的输入框
Messagebox.Java
```
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package User;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Administrator
 */
public class messagebox extends HttpServlet {

    /**
     * Processes requests for both HTTP `GET` and `POST`
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            HttpSession session = request.getSession(true);
            String username = "";
            if(session.getAttribute("UserName") != null)
            {
                username = session.getAttribute("UserName").toString();
            }
            if(username != null && !username.equals(""))
            {
                if(!session.getAttribute("IsLogin").equals("true"))
                {System.out.println(session.getAttribute("IsLogin").toString());
                    response.sendRedirect("Login.jsp");
                    //request.getRequestDispatcher("/Login.html").forward(request, response);
                }
            }else{
                response.sendRedirect("Login.jsp");
            }
            String words = (String) getServletConfig().getServletContext().getAttribute("Words");
            String messages = "";
            if(request.getParameter("usermessages") != null)
            {
                messages = request.getParameter("usermessages");
            }
            if (words == null) {
                words = "系统提示：可以聊天\n";
            } else if(!messages.equals("")){
                words = (String) getServletConfig().getServletContext().getAttribute("Words") + username + " 说："+messages + "\n";
            }
            getServletConfig().getServletContext().setAttribute("Words", words);
            String temp = (String) getServletConfig().getServletContext().getAttribute("online");
            if(temp==null)temp="0";
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet messagebox</title>");
            out.println("<meta http-equiv=\"refresh\" content =\"2;url=messagebox\">");
            out.println("</head>");
            out.println("<body>");
            out.println("

当前在线：");
            out.println(temp);
            out.println("人
");
            out.println("<textarea name=\"messagebox\" cols=\"100\" words=\"400\" style=\"height:450px;\">");
            out.println(words);
            out.println("</textarea>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP `GET` method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP `POST` method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
```
用户填写框：userinput.jsp
```
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% session = request.getSession(true);%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>输入框</title>
    </head>
    <body>
        <table>
            <tr>
                <td>
                    <label><%= session.getAttribute("UserName")%>  </label>
                    [退出登陆](logout.jsp)
                </td>
            </tr>
        </table>
        <form id="fm" action="messagebox" method="post" target="message">
            <table>
                <tr>
                    <td>
                        <textarea name="usermessages" cols="50" style="height:100px;"></textarea>
                    </td>
                    <td>
                        <input type="button" id="submitt" onclick="cleart()" value="发送"/>
                        <input type="reset" id="resett" value="清空输入"/>
                    </td>
                </tr>
            </table>
        </form>
    </body>
    <script>
        function submit(callback){
            document.getElementById("fm").submit();
            callback();
        }
        function reset(){
            document.getElementById("fm").reset();
       }
        function cleart(){
            //document.getElementById("resett").click();
             submit(reset);
        }
    </script>
</html>

```

我们还需要一个退出登录的功能：Loginout.jsp

```

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    session = request.getSession(true);
    session.removeAttribute("UserName");
    session.removeAttribute("IsLogin");
%>
<!DOCTYPE html>
  <html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="refresh" content ="2;url=LoginSuccess.jsp">
        <title>Logout</title>
    </head>
    <body>

# 成功退出!

    </body>
  </html>

```

注意了，既然是聊天室的话，也要知道当前有多少人在线吧，这个用监听来实现：SessionListrner.java

```

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Listener;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/**
 * Web application lifecycle listener.
 *
 * @author Anthony
 */
@WebListener()
public class SessionListenr implements HttpSessionListener, HttpSessionAttributeListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {

    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {

    }

    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        if(event.getName().equals("UserName"))
        {
            String current = (String) event.getSession().getServletContext().getAttribute("online");
            String info = (String) event.getSession().getServletContext().getAttribute("Words");
            if(info==null)info ="";
            if(current == null) current="0";
            int c=Integer.parseInt(current);
            c++;
            current = String.valueOf(c);
            event.getSession().getServletContext().setAttribute("online", current);
            event.getSession().getServletContext().setAttribute("Words", info+event.getValue()+" 加入聊天室\n");
        }
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        if(event.getName().equals("UserName"))
        {
            String current = (String) event.getSession().getServletContext().getAttribute("online");
            String info = (String) event.getSession().getServletContext().getAttribute("Words");
            if(info==null)info ="";
            if(current==null)current = "0";
            int c = Integer.parseInt(current);
            c--;
            current = String.valueOf(c);
            event.getSession().getServletContext().setAttribute("online", current);
            event.getSession().getServletContext().setAttribute("Words", info+event.getValue()+" 离开了聊天室\n");
        }
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
```
附上NetBean项目工程：
链接: http://pan.baidu.com/s/1qWL2xRm <del>密码: 22wa</del>