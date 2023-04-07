<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="course.user.model.User"%>
<%@page import="courser.user.dao.UserDao"%>
<%@page import="java.util.List"%>
<%@page import="com.mongodb.MongoClient"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String errmsg = "";
    String name = "";
    String pass = "";
    String type = "";

    if ("GET".equalsIgnoreCase(request.getMethod())) {
    } else {
        name = request.getParameter("name");
        pass = request.getParameter("pass");
        type = request.getParameter("type");

        if(name == null || name.isEmpty()){
            errmsg = "User name can't be empty!";
        } else if(pass == null || pass.isEmpty()){
            errmsg = "password can't be empty!";
        } else if(type == null || type.isEmpty() || (!type.equals("teacher") && !type.equals("student"))){
            errmsg = "User type must be included!";
        }

        String dpass = "";
        if (errmsg.isEmpty()) {
			/* try { */
            	dpass = pass;
                User user = new User();
                user.setName(name);
                user.setPass(dpass);
                user.setType(type);
                // create
                MongoClient mongo = (MongoClient) request.getServletContext()
                    .getAttribute("MONGO_CLIENT");
                
                UserDao userDao = new UserDao(mongo);
      
                
                if (userDao.existsByName(name) == true) {
                	errmsg = "Username should be unique!";
                } else {
                	userDao.create(user);
                    response.sendRedirect("userlist.jsp");
                }
                
                
           /*  } */ 
        /* catch (Error) {
                errmsg = "Password must be not be empty!";
            } */
        }
    }
    pageContext.setAttribute("errmsg", errmsg);
    pageContext.setAttribute("name", name);
    pageContext.setAttribute("pass", pass);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Adding User</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
	<jsp:include page="header.jsp" />
	<div class="container">
	  <h2>Add New User</h2>
	  <h3 style='color:red'>${errmsg}</h3>
	  <form class="form-horizontal" action="adduser.jsp" method="Post">
	    <div class="form-group">
	      <label class="control-label col-sm-2" for="username">User Name:</label>
	      <div class="col-sm-10">
	        <input class="form-control" type="text" id="name" placeholder="Enter user name" name="name" value="${name}">
	      </div>
	    </div>
	    <div class="form-group">
	      <label class="control-label col-sm-2" for="pwd">Password:</label>
	      <div class="col-sm-10">
	        <input class="form-control" type="password" id="password" placeholder="Enter Password" name="pass" value="${pass}">
	      </div>
	    </div>
	    
	    <div class="form-group">
	    	<label class="control-label col-sm-2" for="type">Type:</label>
	        <select class="form-select" aria-label="Default select example" name="type">
			  <option selected>Select user type</option>
			  <option value="teacher">Teacher</option>
			  <option value="student">Student</option>
			</select>
	    </div>
	    
	    
	    <div class="form-group">
	      <div class="col-sm-offset-2 col-sm-10">
	        <button type="submit" class="btn btn-primary">Save</button>
	      </div>
	    </div>
	  </form>
	</div>
</body>
</html>
