<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Login Query</title>
</head>

<body>
	<%
    
	try {

		//Get the database connection.
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		


		//Get the selected username and password textboxes from login_page.jsp.
		String user = request.getParameter("username");
		String pass = request.getParameter("password");
		//Create a SQL statement.
		PreparedStatement ps = con.prepareStatement("select username from customers where username=? and c_password=?");
		//Replace "?" with value entered in textboxes.
		ps.setString(1, user);
		ps.setString(2, pass);
		//Run the query against the database.
		ResultSet result = ps.executeQuery();
		
		if(result.next()){
			//Retrieving accessor name from database.
			ps = con.prepareStatement("select first_name, last_name, email_address from customers where username = ? and c_password = ?");
			ps.setString(1, user);
			ps.setString(2, pass);
			ResultSet info = ps.executeQuery();
			if(info.next()){
				session.setAttribute("accessorName", info.getString("first_name"));
				session.setAttribute("username", user);
	            session.setAttribute("firstName", info.getString("first_name"));
	            session.setAttribute("lastName", info.getString("last_name"));
	            session.setAttribute("email", info.getString("email_address"));
			}
			
			//Redirect.
			response.sendRedirect("welcome_page.jsp");
		}
		else{
			//If login did not match customer credentials, check employee credentials.
			
			//Create SQL statment to check what type of employee is logging in.
			//Managers and customer representatives have different welcome screens.
			//SQL commands capitalized for clarity.
			ps = con.prepareStatement("SELECT e.username, e.e_password, " + 
						"CASE WHEN m.ssn IS NOT NULL THEN 'manager' " +
						"WHEN c.ssn IS NOT NULL THEN 'customer_representatives' " +
						"ELSE 'none' END AS role " +
					"FROM employees e " +
					"LEFT JOIN manager m ON e.ssn = m.ssn " +
					"LEFT JOIN customer_representatives c ON e.ssn = c.ssn " +
					"WHERE e.username = ? AND e.e_password = ?");	
			ps.setString(1, user);
			ps.setString(2, pass);
			result = ps.executeQuery();
			if(result.next()){
				//Determining which role (type of employee) accessor has.
				String role = result.getString("role");
				
				ps = con.prepareStatement("select first_name, last_name from employees where username = ? and e_password = ?");
				ps.setString(1, user);
				ps.setString(2, pass);
				ResultSet name = ps.executeQuery();
				if(name.next())
					session.setAttribute("accessorName", name.getString("first_name") + " " + name.getString("last_name"));

				if("manager".equals(role)){
					response.sendRedirect("admin_access.jsp");
				}
				else if("customer_representatives".equals(role)){
					response.sendRedirect("customer-rep_access.jsp");
				}
			}
			else{
				//Username and password do not exist anywhere in database.
				request.setAttribute("errorMessage", "Username or password is incorrect. Please try again.");
		        request.getRequestDispatcher("login_page.jsp").include(request, response);
			}
		}
		
		//Close the connection.
		db.closeConnection(con);
	} catch (Exception e) {
		out.print(e);
	}
	
	%>
</body>
</html>