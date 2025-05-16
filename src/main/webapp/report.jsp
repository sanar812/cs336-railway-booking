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
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			//Create a SQL statement.
			PreparedStatement ps = con.prepareStatement("select b.line_name, count(r.r_number) as reservation_count from books b join reservations r on b.r_number = r.r_number group by b.line_name order by reservation_count;");
			
			//Run the query against the database.
			ResultSet result = ps.executeQuery();
			List<String> lines = new ArrayList<>();
		   
			
			while(result.next()){
				String lineName = result.getString("line_name");
				String reservationCount = result.getString("reservation_count");
				lines.add(lineName+": "+reservationCount+" reservations");
			}
			
		    request.setAttribute("lines", lines);
			request.getRequestDispatcher("admin_access.jsp").include(request, response);

					
			//Close the connection.
			db.closeConnection(con);
		} catch (Exception e) {
			out.print(e);
		}
		
		%>
	</body>
</html>