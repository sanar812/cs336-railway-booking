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
			
			String newPassword = request.getParameter("password-change");
			String newFirstName = request.getParameter("first-name-change");
			String newLastName = request.getParameter("last-name-change");
			String newUsername = request.getParameter("username-change");
			String ssn = request.getParameter("original_ssn");
			String password = request.getParameter("original_password");
			String firstName = request.getParameter("original_first_name");
			String lastName = request.getParameter("original_last_name");
			String username = request.getParameter("original_username");

			/* out.print(password);
			out.print(lastName);
			out.print(firstName);
			out.print(username);
			out.print(ssn);
			out.print(newLastName);
			out.print(newFirstName);
			out.print(newUsername);
			out.print("!!!"+newPassword+"???"); */
			
			if(!request.getParameter("first-name-change").isEmpty()){
				if(newFirstName.equals(firstName)){
					request.setAttribute("errorMessage", "Please enter a new first name.");
			        request.getRequestDispatcher("edit_representative.jsp").include(request, response);
			        return;
				}
				ps = con.prepareStatement("update employees set first_name = ? where ssn = ?");
				ps.setString(1, newFirstName);
				ps.setString(2, ssn);
				ps.executeUpdate();
				
				request.setAttribute("first_name", newFirstName);
			}
			else{
				request.setAttribute("first_name", firstName);
			}
			if(!request.getParameter("last-name-change").isEmpty()){
				if(newLastName.equals(lastName)){
					request.setAttribute("errorMessage", "Please enter a new last name.");
			        request.getRequestDispatcher("edit_representative.jsp").include(request, response);
			        return;
				}
				ps = con.prepareStatement("update employees set last_name = ? where ssn = ?");
				ps.setString(1, newLastName);
				ps.setString(2, ssn);
				ps.executeUpdate();
				
				request.setAttribute("last_name", newLastName);
			}
			else{
				request.setAttribute("last_name", lastName);
			}
			if(!request.getParameter("username-change").isEmpty()){	
				if(newUsername.equals(username)){
					request.setAttribute("errorMessage", "Please enter a new first name.");
			        request.getRequestDispatcher("edit_representative.jsp").include(request, response);
			        return;
				}
				
				//Check if username has already been taken.
				PreparedStatement userPS = con.prepareStatement("select 1 from customers where username = ?");
				userPS.setString(1, newUsername);
				ResultSet resultSet = userPS.executeQuery();
				if(resultSet.next()){
					request.setAttribute("errorMessage", "Username already exists. Please enter a new username.");
			        request.getRequestDispatcher("admin_access.jsp").include(request, response);
			        return;
				}
				else{
					userPS = con.prepareStatement("select 1 from employees where username = ?");
					userPS.setString(1, newUsername);
					resultSet = userPS.executeQuery();
					if(resultSet.next()){
						request.setAttribute("errorMessage", "Username already exists. Please enter a new username.");
				        request.getRequestDispatcher("edit_representative.jsp").include(request, response);
				        return;
					}
				}
				
				ps = con.prepareStatement("update employees set username = ? where ssn = ?");
				ps.setString(1, newUsername);
				ps.setString(2, ssn);
				ps.executeUpdate();
				
				request.setAttribute("username", newUsername);
			}
			else{
				request.setAttribute("username", username);
			}
			if(!request.getParameter("password-change").isEmpty()){
				if(newPassword.equals(password)){
					request.setAttribute("errorMessage", "Please enter a new password.");
			        request.getRequestDispatcher("edit_representative.jsp").include(request, response);
			        return;
				}
				ps = con.prepareStatement("update employees set e_password = ? where ssn = ?");
				ps.setString(1, newPassword);
				ps.setString(2, ssn);
				ps.executeUpdate();
				
				request.setAttribute("password", newPassword);
			}
			else{
				request.setAttribute("password", password);
			}
		
			request.setAttribute("ssn", ssn);
			request.setAttribute("successMessage", "Success! Changes saved.");
			request.getRequestDispatcher("edit_representative.jsp").include(request, response);
			
			db.closeConnection(con);
		} catch (Exception e) {e.printStackTrace();}
		%>
	</body>
</html>