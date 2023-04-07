<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="courser.course.dao.CourseDao"%>
<%@page import="course.course.model.Course"%>
<%@page import="course.user.model.User"%>
<%@page import="courser.user.dao.UserDao"%>
<%@page import="com.mongodb.MongoClient"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%
	String id = request.getParameter("id");
	String errmsg = "";

	
	if (id == null || id.isEmpty()) {
	    errmsg = "Invalid parameter!";
	} else {
	    MongoClient mongo = (MongoClient) request.getServletContext()
	            .getAttribute("MONGO_CLIENT");
	    CourseDao courseDao = new CourseDao(mongo);
	    UserDao userDao = new UserDao(mongo);
	    
	    if (session.getAttribute("username") != null) {
	    	String userName = session.getAttribute("username").toString();
	    	
	    	if (userDao.existsByName(userName)) {
	    		User user = userDao.getUser(userName);
			    
	    		if (user.getType().equals("student")) {
	    			if (courseDao.exists(id)) {
		    			Course course = courseDao.getCourseById(id);
					    
					    List<String> studentList = course.getStudents();
					    
					    studentList.add(user.getId());
					    course.setStudents(studentList);
					    
					    courseDao.update(course);
						
					    response.sendRedirect("welcome.jsp");
		    		} else {
		    			errmsg = "Course id: " + id + "is not valid!";
		    		}
	    		} else {
	    			errmsg = "You should be a student to enroll a course!";
	    		}
	    	} else {
	    		errmsg = "Please sign up to enroll the course!";
	    	}
	    } else {
	    	errmsg = "You need to login to enroll course!";
	    }
	    
	}
	
	pageContext.setAttribute("errmsg", errmsg);
	pageContext.setAttribute("id", id);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Enroll Course</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<jsp:include page="courseheader.jsp"></jsp:include>
	<div>
	  <h3>Enroll A Course</h3>
	  <h3 style='color:red'>${errmsg}</h3>
	</div>
</body>
</html>
