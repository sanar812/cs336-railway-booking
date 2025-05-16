<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.regex.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Registration Query</title>
</head>

<body>
	<%
    
	try {

		//Get the database connection.
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Get all parameters from the HTML form at the registration_page.jsp, making sure none is null.
		String firstName = request.getParameter("first_name");
		String lastName = request.getParameter("last_name");
		String user = request.getParameter("username");
		String email = request.getParameter("email");
		String pass = request.getParameter("password");
		String pass2 = request.getParameter("password2");
		if(firstName.isEmpty() || lastName.isEmpty() || user.isEmpty() || pass.isEmpty() || email.isEmpty()){
			request.setAttribute("errorMessage", "All fields are required.");
	        request.getRequestDispatcher("registration_page.jsp").include(request, response);
	        return;
		}

		//Check if email is valid.
		Pattern emailPattern = Pattern.compile("^[\\w\\.]+@[\\w]+\\.[\\w]{2,}$");
		Matcher emailMatcher = emailPattern.matcher(email);
		if(!emailMatcher.matches()){
			request.setAttribute("errorMessage", "Please enter a valid email address.");
	        request.getRequestDispatcher("registration_page.jsp").include(request, response);
	        return;
		}
		
		//Check if username has already been taken.
		PreparedStatement ps = con.prepareStatement("select 1 from customers where username = ?");
		ps.setString(1, user);
		ResultSet resultSet = ps.executeQuery();
		if(resultSet.next()){
			request.setAttribute("errorMessage", "Username already exists. Please enter a new username.");
	        request.getRequestDispatcher("registration_page.jsp").include(request, response);
	        return;
		}
		else{
			ps = con.prepareStatement("select 1 from employees where username = ?");
			ps.setString(1, user);
			resultSet = ps.executeQuery();
			if(resultSet.next()){
				request.setAttribute("errorMessage", "Username already exists. Please enter a new username.");
		        request.getRequestDispatcher("registration_page.jsp").include(request, response);
		        return;
			}
		}
				
		//Check if passwords match.
		if(!(pass.equals(pass2))){
			request.setAttribute("errorMessage", "Passwords do not match. Please try again.");
	        request.getRequestDispatcher("registration_page.jsp").include(request, response);
			return;
		}

		//Create a SQL statement.
		ps = con.prepareStatement("insert into customers values (?, ?, ?, ?, ?)");
		ps.setString(1, lastName);
		ps.setString(2, firstName);
		ps.setString(3, email);
		ps.setString(4, user);
		ps.setString(5, pass);

		//Run the query against the database and close the connection.
		ps.executeUpdate();
		con.close();
		
		request.setAttribute("registerMessage", "Success!");
		request.getRequestDispatcher("login_page.jsp").include(request, response);
	} catch (Exception e) {}
	
	%>
</body>
</html>