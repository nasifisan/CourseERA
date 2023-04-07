<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="course.course.model.Course"%>
<%@page import="courser.course.dao.CourseDao"%>
<%@page import="course.user.model.User"%>
<%@page import="courser.user.dao.UserDao"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.mongodb.MongoClient"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String errmsg = "";
	String courseid = request.getParameter("id");
	String selectedid = request.getParameter("selectedid");
	
	if (courseid == null || courseid.isEmpty()) {
		response.sendRedirect("welcome.jsp");
	}
	
	
    MongoClient mongo = (MongoClient) request.getServletContext()
    .getAttribute("MONGO_CLIENT");
    
    CourseDao courseDao = new CourseDao(mongo);
    UserDao userDao = new UserDao(mongo);
    
    if (!courseDao.exists(courseid)) {
    	response.sendRedirect("welcome.jsp");
    }
    
    if (selectedid != null && !selectedid.isEmpty() && userDao.exists(selectedid)) {
    	response.sendRedirect("assignteacher.jsp?cid="+courseid+"&tid="+selectedid);
    }
    
    Course course = new Course();
    /* assignteacher.jsp?cid=${course.id}&tid=${selectedid} */
    
    User teacher = new User();
    List<User> students = new ArrayList<User>();
    List<User> teachers = userDao.getTeacherList();
    
    if (courseDao.exists(courseid)) {
    	course = courseDao.getCourseById(courseid);
    }
    
    if (course.getTeacher() != null) {
    	User t = userDao.getUserById(course.getTeacher());
    	
    	if (t.getType().equals("teacher")) teacher = t;
    }
    
    if (course.getStudents() != null) {
    	for (int i = 0; i<course.getStudents().size(); ++i) {
    		String x = course.getStudents().get(i);
    		
    		if (userDao.exists(x)) {
    			User y = userDao.getUserById(x);
    			
    			if (y.getType().equals("student")) students.add(y);
    		}
    	}
    }
    
    String name = "";
    String type = "";
    String userId = "";
	if (session.getAttribute("username") == null) {
		response.sendRedirect("login.jsp");
	} else {
		name = session.getAttribute("username").toString();
		
		if (userDao.existsByName(name)) {
			User user = userDao.getUser(name);
			
			userId = user.getId();
			type = user.getType();
			
		} else {
			response.sendRedirect("login.jsp");
		}
	}

	pageContext.setAttribute("userid", userId);
	pageContext.setAttribute("type", type);
	pageContext.setAttribute("name", name);
    pageContext.setAttribute("errmsg", errmsg);
    pageContext.setAttribute("course", course);
    pageContext.setAttribute("teacher", teacher);
    pageContext.setAttribute("students", students);
    pageContext.setAttribute("teachers", teachers);
    pageContext.setAttribute("selectedid", selectedid);
%>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Course Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
  </head>
  <body>
    
    <div class="container h-100 w-100">
    	<jsp:include page="navbars.jsp" />
		
		<br>
	    <div class="mb-4">


	    	<div class="card mb-4">
		  <div class="card-header">
		    <c:out value="${course.category}"/>
		  </div>
		  <div class="card-body">
		    <div class="d-flex justify-content-between">
			    <h5 class="card-title"><c:out value="${course.title}"/></h5>
		    	
		    	<c:if test="${type == 'admin'}">
					<span>
						<a href="deletecourse.jsp?id=${course.id}" class="p-1 text-danger border-danger border rounded h-6 text-decoration-none" onclick="return confirm('Are you sure to delete this User?')">
							Delete
						</a>
					</span>
				</c:if>
		    
		    </div>
		    <br>
		    <p class="card-text">
		    	<c:out value="${course.description}"/>
		    </p>
		   </div>
		</div>
	    	
	    	<hr class="hr" />
	    	<hr class="hr mb-4" />
	    	
	    	
	    <c:if test="${type == 'admin'}">
	    	<div class="row">
	    	<div class="col-6">
	    		<div class="h4">Enrolled Students</div>
	    		
	    		<c:forEach var="st" items="${students}">
				  	<div><c:out value="${st.name}"/></div>
				  </c:forEach>
	    	</div>
	    	
	    	<div class="col-6">
	    		<div class="h4">Assigned Teacher</div>
	    		<br>
	    		<c:if test="${not empty teacher.getName()}">
	    			<div>Name: <%= teacher.getName() %></div>
	    		</c:if>
	    		<c:if test="${empty teacher.getName()}">
	    			<div>No teacher has been assigned!</div>
	    		</c:if>
	    		<br>
	    		<br>
	    		
	    		<form class="form-horizontal" action="coursedetails.jsp?id=${course.id}" method="Post">
				  	<div class="form-group">
				    	<label class="control-label col-sm-2" for="selectedid">Teacher:</label>
				    	<br>
				        <select class="form-select" aria-label="Default select example" name="selectedid">
						  <option selected>Select Course Teacher</option>
						  <c:forEach var="teach" items="${teachers}">
						  	<option value="${teach.id}"><c:out value="${teach.name}"/></option>
						  </c:forEach>
						</select>
				    </div>
				    
				    <br>
				    <div class="form-group">
				      <div class="col-sm-offset-2 col-sm-10 d-flex justify-content-end">
				        <button type="submit" class="btn btn-primary">Save</button>
				      </div>
				    </div>
				 </form>
	    	</div>
	    </div>
	    </c:if>
	    
	    <c:if test="${type == 'teacher'}">
	    	<div >
	    		<div class="h4">Enrolled Students</div>
	    		
	    		<c:forEach var="st" items="${students}">
				  	<div><c:out value="${st.name}"/></div>
				  </c:forEach>
	    	</div>
	    </c:if>
	    	

			
			<%-- <c:if test="${name == 'admin'}">
				<center>
					<a class="btn btn-primary bg-success" href="addcourse.jsp" >Add Course</a>
				</center>
			</c:if> --%>
	    
	    </div>
	    <br>
	    <br>
	    <br>
	    <br>
	    <div class="text-center mb-4 mt-4 text-danger">
	    	All right reserved by Jakarta.
	    </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
  </body>
</html>