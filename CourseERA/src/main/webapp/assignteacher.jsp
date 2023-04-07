<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> --%>
<%@page import="courser.course.dao.CourseDao"%>
<%@page import="course.course.model.Course"%>
<%@page import="courser.user.dao.UserDao"%>
<%@page import="course.user.model.User"%>
<%@page import="com.mongodb.MongoClient"%>
<%
	String tid = request.getParameter("tid");
	String cid = request.getParameter("cid");
	String errmsg = "";
	
	if (session.getAttribute("username") != null) {
		String username = session.getAttribute("username").toString();
		
		if (!username.equals("admin")) response.sendRedirect("welcome.jsp");
		else {
			if (tid == null || tid.isEmpty() || cid == null || cid.isEmpty()) {
				response.sendRedirect("welcome.jsp");
			} else {
			    MongoClient mongo = (MongoClient) request.getServletContext()
			            .getAttribute("MONGO_CLIENT");
			    
			    CourseDao courseDao = new CourseDao(mongo);
			    UserDao userDao = new UserDao(mongo);
			    
			    Course course = courseDao.getCourseById(cid);
			    
			    if (course != null && userDao.exists(tid)) {
			    	User user = userDao.getUserById(tid);
			    	
			    	if (user.getType().equals("teacher")) {
			    		course.setTeacher(tid);
			    		courseDao.update(course);
			    	}
			    	
			    	response.sendRedirect("coursedetails.jsp?id="  + cid);
			    } else {
			    	if (course != null) {
			    		response.sendRedirect("coursedetails.jsp?id="  + cid);
			    	} else {
			    		response.sendRedirect("welcome.jsp");
			    	}
			    }
			}
		}
	} else {
		response.sendRedirect("login.jsp");
	}
	
	
	pageContext.setAttribute("errmsg", errmsg);
%>
<%-- <html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Delete Course</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<jsp:include page="courseheader.jsp"></jsp:include>
	<div>
	  <h3>Delete A Course</h3>
	  <h3 style='color:red'>${errmsg}</h3>
	</div>
</body>
</html> --%>
