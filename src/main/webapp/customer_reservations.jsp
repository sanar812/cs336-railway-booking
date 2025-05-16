<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Reservations By Customer Query</title>
	</head>
	
	<body>
		<%
    
	try {

		//Get the database connection.
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();		

		String customer = request.getParameter("customers");
		String[] customerInfo = customer.split(" ");
		String firstName = customerInfo[0];
		String lastName = customerInfo[1];
		String email = customerInfo[2].substring(1, customerInfo[2].length()-1);
		
		//Create a SQL statement.
		PreparedStatement ps = con.prepareStatement("select b.line_name, b.train_id, b.departure from customers c join reservations r on c.username = r.username join books b on r.r_number = b.r_number where c.email_address = ?;");
		//Replace "?" with value entered in textboxes.
		ps.setString(1, email);
		//Run the query against the database.
		ResultSet result = ps.executeQuery();
		
		if(!result.isBeforeFirst()){
			request.setAttribute("noCustomerReservations", "No reservations found.");
	        request.getRequestDispatcher("admin_access.jsp#customer-functions").include(request, response);
		}
		if(result.next()){
			String lineName = result.getString("line_name");
			String trainID = result.getString("train_id");
			String departure = result.getString("departure");
			
			//Formatting departure
	        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        SimpleDateFormat outputFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy 'at' h:mm a");
	        String formattedDeparture = outputFormat.format(inputFormat.parse(departure));
			
			request.setAttribute("customerReservations", lineName+" "+trainID+" - "+formattedDeparture);
	        request.getRequestDispatcher("admin_access.jsp#customer-functions").include(request, response);
		}
				
		//Close the connection.
		db.closeConnection(con);
	} catch (Exception e) {
		out.print(e);
	}
	
	%>
	</body>
</html>