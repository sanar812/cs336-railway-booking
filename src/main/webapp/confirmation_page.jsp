<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Confirmation Page</title>
		<link rel="stylesheet" href="confirmation.css">
	</head>
	
	<body>
	
		<!-- USER INFORMATION -->
		<form class = "logout-form" action="logout.jsp">
		<%
			session = request.getSession(false);
			if(session != null && session.getAttribute("username") != null){
				String username = (String) session.getAttribute("username");
				String firstName = (String) session.getAttribute("firstName");
				String lastName = (String) session.getAttribute("lastName");
				String email = (String) session.getAttribute("email");
		%>
			<p><%= firstName %> <%= lastName %><br><%= username %><br><%= email %></p>
		<%
			}
			else{
				response.sendRedirect("login.jsp");
				request.setAttribute("logoutMessage", "You have been logged out.");
		        request.getRequestDispatcher("login_page.jsp").include(request, response);
			}
		%>	
			
			<input style="font-size:20px;" type="submit" value="Logout">
		</form>
    	
    	<!-- RETRIEVING DATA -->
    	<%
    
		try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			String reservationNumber = (String) request.getParameter("reservationNumber");
			String firstName = (String) request.getParameter("firstName");
			String lastName = (String) request.getParameter("lastName");
			String email = (String) request.getParameter("email");
			String lineName = request.getParameter("lineName");
			String trainID = (String) request.getParameter("train_id");
			String departureTime = (String) request.getParameter("departureTime");
			String destinationArrival = (String) request.getParameter("destinationArrival");
			String date = (String) request.getParameter("date");
			String fare = (String) request.getParameter("fare");
			String discount = (String) request.getParameter("discount");
			String originStationName = (String) request.getParameter("originStationName");
			String destinationStationName = request.getParameter("destinationStationName");
			
			/* out.print(reservationNumber);
			out.print(firstName);
			out.print(lastName);
			out.print(departureTime);
			out.print(trainID);
			out.print(destinationArrival);
			out.print(date);
			out.print(originStationName);
			out.print(destinationStationName);
			out.print(discount);
			out.print(reservationNumber);
			out.print(email);
			out.print(lineName);
			out.print(fare); */

		%>	

		<!-- DISPLAY -->
		<div class="container">
			<div class="header">
				<h1><u>Booking Confirmation</u></h1>
				<h2>You have reserved a seat. See details below:</h2>
			</div>
			<h3>Reservation #<%= reservationNumber %> - <%= date %></h3>
			<p><strong>Client Information: <%= firstName %> <%= lastName %></strong></p>
			<p><%= email %></p>
			<br>
			<p><strong><%= lineName %> <%= trainID %></strong></p>
			<p>Departs on <%= departureTime %> from <%= originStationName %></p>
			<p>Arrives at <%= destinationArrival %> at <%= destinationStationName %></p>
			<br>
			<p>
				<strong>Total due at Check-In: $<%= fare %></strong>
				<br><i><%= discount %> discount applied.</i>
			</p>
			
			<a href="welcome_page.jsp" style="text-decoration:none;"><button type="button" id="back">Back to Home</button></a>
		</div>
		
		
		<%
			db.closeConnection(con);
		} catch (Exception e) {e.printStackTrace();}
	
		%>
	</body>
</html>