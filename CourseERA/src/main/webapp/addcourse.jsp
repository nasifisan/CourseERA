<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="course.course.model.Course"%>
<%@page import="courser.course.dao.CourseDao"%>
<%@page import="java.util.List"%>
<%@page import="com.mongodb.MongoClient"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String errmsg = "";
    String category = "";
    String title = "";
    String description = "";

    if ("GET".equalsIgnoreCase(request.getMethod())) {
    } else {
        category = request.getParameter("category");
        title = request.getParameter("title");
        description = request.getParameter("description");

        if(category == null || category.isEmpty()){
            errmsg = "Course category must be selected!";
        } else if(title == null || title.isEmpty()){
            errmsg = "Course title can't be empty!";
        } else if(description == null || description.isEmpty()){
            errmsg = "Course description must be included!";
        }

        if (errmsg.isEmpty()) {
			/* try { */

                Course course = new Course();
                course.setCategory(category);
                course.setTitle(title);
                course.setDescription(description);
                // create
                MongoClient mongo = (MongoClient) request.getServletContext()
                    .getAttribute("MONGO_CLIENT");
                
                CourseDao courseDao = new CourseDao(mongo);
      
                
                /* if (courseDao.existsByName(name) == true) {
                	errmsg = "Username should be unique!";
                } else { */
                	courseDao.create(course);
                    response.sendRedirect("welcome.jsp");
               /*  } */
                
                
           /*  } */ 
        /* catch (Error) {
                errmsg = "Password must be not be empty!";
            } */
        }
    }
    pageContext.setAttribute("errmsg", errmsg);
    pageContext.setAttribute("category", category);
    pageContext.setAttribute("title", title);
    pageContext.setAttribute("description", description);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Add Course</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
	<%-- <jsp:include page="header.jsp" /> --%>
	<jsp:include page="courseheader.jsp"></jsp:include>
	<div class="container">
	  <h2>Add New Course</h2>
	  <h3 style='color:red'>${errmsg}</h3>
	  <form class="form-horizontal" action="addcourse.jsp" method="Post">
	  	<div class="form-group">
	    	<label class="control-label col-sm-2" for="category">Category:</label>
	        <select class="form-select" aria-label="Default select example" name="category">
			  <option selected>Select Course Category</option>
			  <option value="Featured">Featured</option>
			  <option value="Information Technology">Information Technology</option>
			  <option value="Business">Business</option>
			  <option value="Social Sciences">Social Sciences</option>
			  <option value="Arts and Humanities">Arts and Humanities</option>
			  <option value="Computer Science">Computer Science</option>
			  <option value="Math and Logic">Math and Logic</option>
			  <option value="Health">Health</option>
			  <option value="Language Learning">Language Learning</option>
			</select>
	    </div>
	  
	  
	    <div class="form-group">
	      <label class="control-label col-sm-2" for="title">Course title:</label>
	      <div class="col-sm-10">
	        <input class="form-control" type="text" id="name" placeholder="Enter course title" name="title" value="${title}">
	      </div>
	    </div>
	    
	    <div class="form-group">
	      <label class="control-label col-sm-2" for="description">Course description:</label>
	      <div class="col-sm-10">
	        <input class="form-control" id="text" placeholder="Enter description" name="description" value="${description}">
	      </div>
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