<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String name = "";
	if (session.getAttribute("username") == null) {
		response.sendRedirect("login.jsp");
	} else {
		name = session.getAttribute("username").toString();
		pageContext.setAttribute("name", name);
	}
%>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
  </head>
  <body>
    
    <div class="container h-100 w-100">
    	<jsp:include page="navbars.jsp" />
		
		<br>
	    <div class="mb-4">


	    	<div class="container">
		    	
		    	<h2>My Course List</h2>
	    	</div>
	    	
	    	<hr class="hr" />
	    	<hr class="hr mb-4" />
	    	
	    	<div class="mb-4">
	    		<jsp:include page="coursecard.jsp" />
<%-- 	    		<jsp:include page="card.jsp" />
	    		<jsp:include page="card.jsp" />
	    		<jsp:include page="card.jsp" /> --%>
	    	</div>
	    
	    </div>
	    
	    <div class="text-center mb-4 mt-4 text-danger">
	    	All right reserved by Jakarta.
	    </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
  </body>
</html>