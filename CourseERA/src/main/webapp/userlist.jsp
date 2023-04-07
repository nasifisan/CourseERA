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
    MongoClient mongo = (MongoClient) request.getServletContext()
    .getAttribute("MONGO_CLIENT");
    UserDao userDao = new UserDao(mongo);

    List<User> users = userDao.getList();
    if (users == null || users.size() == 0) {
        errmsg = "There is no user!";
    }

    pageContext.setAttribute("errmsg", errmsg);
    pageContext.setAttribute("users", users);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>User List</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container">
  <h2>User</h2>
  <p>Data from MongoDB</p>
  <table class="table">
    <thead>
      <tr>
        <th>User ID</th>
        <th>User Name</th>
        <th>Pass</th>
        <th>Type</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${not empty errmsg}">
          <tr style='color:red'><td>${errmsg}</td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="user" items="${users}">
            <tr>
              <td><c:out value="${user.id}"/></td>
              <td><c:out value="${user.name}"/></td>
              <td><c:out value="${user.pass}"/></td>
              <td><c:out value="${user.type}"/></td>
              <td><a class="btn btn-success" href="edituser.jsp?id=${user.id}">Edit</a>&nbsp;<a class="btn btn-danger" href="deleteuser.jsp?id=${user.id}" onclick="return confirm('Are you sure to delete this User?')">Delete</a></td> 
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>

	<%
		
    	if (session.getAttribute("username") == null) {
    		response.sendRedirect("login.jsp");
    	} else {
    		String username = session.getAttribute("username").toString();
    		
    		if (!username.equals("admin")) response.sendRedirect("welcome.jsp");
    	}
    %>
</body>
</html>