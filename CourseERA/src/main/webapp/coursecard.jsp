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
	String userId = "";
	String type = "";
	String name = "";
	List<Course> courses = new ArrayList<Course>();
	
    MongoClient mongo = (MongoClient) request.getServletContext()
    .getAttribute("MONGO_CLIENT");
    
    CourseDao courseDao = new CourseDao(mongo);
    UserDao userDao = new UserDao(mongo);
    
    if (session.getAttribute("username") != null) {
    	String userName = session.getAttribute("username").toString();
    	
    	if (userDao.existsByName(userName)) {
    		User user = userDao.getUser(userName);
    		
    		name = userName;
    		type = user.getType();
    		
    		if (user.getType().equals("student")) {
    			courses = courseDao.getListByUserId(user.getId(), "students");
    			
    	        if (courses == null || courses.size() == 0) {
    	            errmsg = "No courses has been enrolled!";
    	        }
    	        
    		} else if (user.getType().equals("teacher")) {
				courses = courseDao.getListByUserId(user.getId(), "teacher");
    			
    	        if (courses == null || courses.size() == 0) {
    	            errmsg = "No courses has been assigned!";
    	        }
    		} else {
    			response.sendRedirect("welcome.jsp");
    		}
    	} else {
    		response.sendRedirect("login.jsp");
    	}
    } else {
    	response.sendRedirect("login.jsp");
    }
	
    pageContext.setAttribute("userid", userId);
	pageContext.setAttribute("type", type);
	pageContext.setAttribute("name", name);
    pageContext.setAttribute("errmsg", errmsg);
    pageContext.setAttribute("courses", courses);
%>

<c:choose>
  <c:when test="${not empty errmsg}">
    <tr style='color:blue'><td>${errmsg}</td></tr>
  </c:when>
  <c:otherwise>
    <c:forEach var="course" items="${courses}">
      <div class="card mb-4">
		  <div class="card-header">
		    <c:out value="${course.category}"/>
		  </div>
		  <div class="card-body">
		    <div class="d-flex justify-content-between">
		    <a href="coursedetails.jsp?id=${course.id}">
			    <h5 class="card-title"><c:out value="${course.title}"/></h5>
			 </a>
		    	
		    	<c:if test="${type == 'admin'}">
					<span>
						<a href="deletecourse.jsp?id=${course.id}" class="p-1 text-danger border-danger border rounded h-6 text-decoration-none" onclick="return confirm('Are you sure to delete this User?')">
							Delete
						</a>
					</span>
				</c:if>
		    
		    </div>
		    <br>
		    <p class="card-text text-truncate">
		    	<c:out value="${course.description}"/>
		    </p>
		    
		    <c:if test="${type != 'admin' && type != 'teacher'}">
				<div class="d-flex justify-content-end gap-2">
			    	<button class="btn btn-success">Enrolled</button>
			    	<a href="unenrollcourse.jsp?id=${course.id}" class="btn btn-danger">Unenroll</a>
			    	<!-- <a href="#" class="btn btn-primary">Start</a> -->
			    </div>
			</c:if>
			
			<c:if test="${type == 'admin' || type == 'teacher'}">
				<div class="d-flex justify-content-end gap-2">
			    	<a href="coursedetails.jsp?id=${course.id}" class="btn btn-info">Details</a>
			    	<c:if test="${type == 'teacher'}">
			    		<button class="btn btn-success">Assigned</button>
			    	</c:if>
			    </div>
			</c:if>
		    
		  </div>
		</div>
    </c:forEach>
  </c:otherwise>
</c:choose>
