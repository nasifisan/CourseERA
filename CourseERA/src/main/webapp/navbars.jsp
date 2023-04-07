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


<nav class="navbar navbar-expand-lg bg-body-tertiary">
  <div class="container-fluid">
    <a class="navbar-brand" href="welcome.jsp">
	    <img src="https://getbootstrap.com/docs/5.3/assets/brand/bootstrap-logo-shadow.png" width="30" height="30" class="d-inline-block align-top" alt="">
	    CourseERA
  </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="welcome.jsp">Home</a>
        </li>
        
        <c:if test="${name != 'admin'}">
			<li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="mycourses.jsp">My Courses</a>
	        </li>
		</c:if>
		
		<c:if test="${name == 'admin'}">
			<li class="nav-item">
	          <a class="nav-link active" aria-current="page" href="userlist.jsp">User List</a>
	        </li>
		</c:if>
		
        <li class="nav-item">
          <a class="nav-link" href="Logout">Logout</a>
        </li>
      </ul>
    </div>
  </div>
</nav>
