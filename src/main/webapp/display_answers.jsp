<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Edit Representative Queries Page</title>
		<link rel="stylesheet" href="">
	</head>
	
	<body>
       	<%
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			PreparedStatement ps = null;
			
			String selectedQuestion = request.getParameter("questionId");
			ps = con.prepareStatement("select answer from forum where question = ?");
			ps.setString(1, selectedQuestion);
			ResultSet answers = ps.executeQuery();
			if(answers.next()){
				String reply = answers.getString("answer");
				request.setAttribute("reply", reply);
			}
			else{
				request.setAttribute("reply", "No answers posted.");
			}
			
			request.getRequestDispatcher("forum_page.jsp").include(request, response);
			
			db.closeConnection(con);
		} catch (Exception e) {e.printStackTrace();}
		%>
	</body>
</html>