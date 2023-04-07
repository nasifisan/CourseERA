<%@page import="course.user.model.User"%>
<%@page import="courser.user.dao.UserDao"%>
<%@page import="com.mongodb.MongoClient"%>
<%
    String name = "";
	MongoClient mongo = (MongoClient) request.getServletContext()
	.getAttribute("MONGO_CLIENT");
	
	UserDao userDao = new UserDao(mongo);
	
	if (session.getAttribute("username") == null) {
		response.sendRedirect("login.jsp");
	} else {
		name = session.getAttribute("username").toString();
		User user = userDao.getUser(name);
		
		pageContext.setAttribute("name", name);
		pageContext.setAttribute("userid", user.getId());
		pageContext.setAttribute("type", user.getType());
	}
%>