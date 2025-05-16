<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Login Page</title>
		<link rel="stylesheet" href="login.css">
	</head>
	
	<body>
		<div class="container">
			<h1>Online Railway Booking System</h1>
			<h2>Customer/Employee Login</h2>
			
			<p>Welcome back! Please log in to access the railway booking system.</p>
			
			<form method="post" action="login.jsp">
				<div class="form-group">
					<label for="user_label">Username: </label>
					<input id="username" name="username" value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"><br><br>
				</div>
				<div class="form-group">
					<label for="pass_label">Password: </label>
					<input type="password" name="password" value="<%= request.getParameter("password") != null ? request.getParameter("password") : "" %>"><br><br>
				</div>
				<div class="form-group">
					<input type="submit" value="Login">		
				</div>
			</form>
			<!-- value attribute checks condition and returns accordingly -->
			<!-- if field is not null, retrieve user-entered information, else keep null -->
			
			<!-- MESSAGE DISPLAY -->
			<%
				String errorMessage = (String) request.getAttribute("errorMessage");
				String logoutMessage = (String) request.getAttribute("logoutMessage");
				String registerMessage = (String) request.getAttribute("registerMessage");
				if(errorMessage != null) {
			%>
					<div class="error-message" style="color: red;">
						<%= errorMessage %>
					</div>
			<%
				}
				if(logoutMessage != null) {
			%>
					<div class="logout-message" style="color: blue;">
						<%= logoutMessage %>
					</div>
			<%
				}
				if(registerMessage != null) {
			%>
					<div class="register-message" style="color: blue;">
						<%= registerMessage %>
					</div>
			<%
				}
			%>
			<div class="create-account">
				<label for="account_registration">Don't have an account?</label>
				<a href="registration_page.jsp"><p class="learn-more">Create an Account</p></a>
			</div>
		</div>
	</body>
</html>