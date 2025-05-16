<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Registration Page</title>
		<link rel="stylesheet" href="registration.css">
	</head>
	
	<body>
	<div class="container">
		<h1>Online Railway Booking System</h1>
		<h2>User Registration</h2>
		
		<form method="post" action="registration.jsp">
			<div class="form-group">
				<label for="first_name_label">First Name: </label>
				<input id="first_name" name="first_name" value="<%= request.getParameter("first_name") != null ? request.getParameter("first_name") : "" %>"><br><br>
			</div>	
			<div class="form-group">	
				<label for="last_name_label">Last Name: </label>
				<input id="last_name" name="last_name" value="<%= request.getParameter("last_name") != null ? request.getParameter("last_name") : "" %>"><br><br>
			</div>	
			<div class="form-group">	
				<label for="email_label">Email Address: </label>
				<input id="email" name="email" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"><br><br>
			</div>	
			<div class="form-group">	
				<label for="user_label">Username: </label>
				<input id="username" name="username" value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"><br><br>
			</div>	
			<div class="form-group">	
				<label for="pass_label">Password: </label>
				<input type="password" name="password" value="<%= request.getParameter("password") != null ? request.getParameter("password") : "" %>"><br><br>
			</div>	
			<div class="form-group">
				<label for="pass_label_2">Repeat Password: </label>
				<input type="password" name="password2" value="<%= request.getParameter("password2") != null ? request.getParameter("password2") : "" %>"><br><br>
			</div>
			<div class="form-group">
				<input type="submit" value="Create Account">
			</div>	
		</form>
		
		<!-- MESSAGE DISPLAY -->
		<%
			String errorMessage = (String) request.getAttribute("errorMessage");
			if(errorMessage != null) {
		%>
				<div class="error-message" style="color: red;">
					<%= errorMessage %>
				</div>
		<%
			}
		%>
	</div>
	</body>
</html>