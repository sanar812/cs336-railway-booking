<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Edit Representative Page</title>
		<link rel="stylesheet" href="edit_representative.css">
	</head>
	
	<body>
	
		<!-- Logout Button -->
		<div class="logout-form">
			<form action="logout.jsp">
				<input type="submit" value="Logout">
			</form>
    	</div>
    	
    	<!-- RETRIEVING DATA -->
    	<%
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			String firstName = "";
			String lastName = "";
			String username = "";
			String password = "";
			String ssn = "";
			
			if(request.getParameter("representative-name") != null){
				String[] info = request.getParameter("representative-name").split(" ");
				firstName = info[0];
				lastName = info[1];
				username = info[2].substring(1, info[2].length()-1);
				
				PreparedStatement ps = con.prepareStatement("select ssn, e_password from employees where first_name = ? and last_name = ? and username = ?;");
				ps.setString(1, firstName);
				ps.setString(2, lastName);
				ps.setString(3, username);
				ResultSet result = ps.executeQuery();
				
				if(result.next()){
					password = result.getString("e_password");
					ssn = result.getString("ssn");
				}
			}
			else{
				firstName = (String) request.getAttribute("first_name");
				lastName = (String) request.getAttribute("last_name");
				username = (String) request.getAttribute("username");
				password = (String) request.getAttribute("password");
				ssn = (String) request.getAttribute("ssn");
			}	
			
			//out.print("."+firstName+".");
			//out.print("."+lastName+".");
			//out.print("."+username+".");
		%>	
			<h3>Edit User [SSN:<td><%= request.getParameter("original_ssn") != null ? request.getParameter("original_ssn") : username %>]</h3>
			<br><br>
			<form action="rep_update_queries.jsp" method="get">
				<input type="hidden" name="original_first_name" value="<%= firstName %>">
				<input type="hidden" name="original_last_name" value="<%= lastName %>">
				<input type="hidden" name="original_username" value="<%= username %>">
				<input type="hidden" name="original_password" value="<%= password %>">
				<input type="hidden" name="original_ssn" value="<%= ssn %>">
				<table class="user-info" border="1">
				<thead>
					<tr>
						<th></th>
						<th>Attribute<br>(Current Value)</th>
						<th>Modification<br>(New Value)</th>
						
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>First Name</th>
						<td><%= request.getParameter("original_first_name") != null ? request.getParameter("original_first_name") : firstName %></td>
						<td><input type="text" id="first-name-change" name="first-name-change" placeholder="Enter new first name..." value="<%= request.getParameter("first-name-change") != null ? request.getParameter("first-name-change") : "" %>"></input></td>
					</tr>
					<tr>
						<th>Last Name</th>
						<td><%= request.getParameter("original_last_name") != null ? request.getParameter("original_last_name") : lastName %></td>
						<td><input type="text" id="last-name-change" name="last-name-change" placeholder="Enter new last name..." value="<%= request.getParameter("last-name-change") != null ? request.getParameter("last-name-change") : "" %>"></input></td>
					</tr>
					<tr>
						<th>Username</th>
						<td><%= request.getParameter("original_username") != null ? request.getParameter("original_username") : username %></td>
						<td><input type="text" id="username-change" name="username-change" placeholder="Enter new username..." value="<%= request.getParameter("username-change") != null ? request.getParameter("username-change") : "" %>"></input></td>
					</tr>
					<tr>
						<th>Password</th>
						<td><%= request.getParameter("original_password") != null ? request.getParameter("original_password") : password %></td>
						<td><input type="text" id="password-change" name="password-change" placeholder="Enter new password..." value="<%= request.getParameter("password-change") != null ? request.getParameter("password-change") : "" %>"></input></td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="4">
							<input type="submit" value="Save Changes"></input>
						</td>
					</tr>
				</tfoot>
				</table>
				<!-- MESSAGE DISPLAY -->
				<%
				String errorMessage = (String) request.getAttribute("errorMessage");
				String successMessage = (String) request.getAttribute("successMessage");
				if(errorMessage != null) {
				%>
					<div class="error-message" style="color: red; margin:auto; width: 50%;">
						<%= errorMessage %>
					</div>
				<%
				}
				if(successMessage != null) {
				%>
						<div class="sucess-message" style="color: blue;">
							<%= successMessage %>
						</div>
				<%
					}
				%>			
			</form>
		<%
			db.closeConnection(con);
		} catch (Exception e) {out.print(e);}
		%>
		
		<a href="admin_access.jsp" style="text-decoration:none;"><button type="button" id="back">Back to Home</button></a>
	</body>
</html>