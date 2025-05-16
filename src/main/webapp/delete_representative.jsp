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
			
			String[] info = request.getParameter("representative-name").split(" ");
			String firstName = info[0];
			String lastName = info[1];
			String username = info[2].substring(1, info[2].length()-1);
			
			ps = con.prepareStatement("select ssn, e_password from employees where first_name = ? and last_name = ? and username = ?;");
			ps.setString(1, firstName);
			ps.setString(2, lastName);
			ps.setString(3, username);
			ResultSet result = ps.executeQuery();
			
			String password = "";
			String ssn = "";
			if(result.next()){
				password = result.getString("e_password");
				ssn = result.getString("ssn");
			}
			
			ps = con.prepareStatement("delete from customer_representatives where ssn = ?");
			ps.setString(1, ssn);
			ps.executeUpdate();
			
			ps = con.prepareStatement("delete from employees where ssn = ?");
			ps.setString(1, ssn);
			ps.executeUpdate();
			
			request.setAttribute("successMessage", "Success! Changes saved.");
			request.getRequestDispatcher("admin_access.jsp").include(request, response);
			
			db.closeConnection(con);
		} catch (Exception e) {e.printStackTrace();}
		%>
	</body>
</html>