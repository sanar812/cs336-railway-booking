<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Reservation Query</title>
	<link rel="stylesheet" href="reserve.css">
</head>

<body>
	<div class ="container">
	<%
    
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		PreparedStatement ps = null;
		
		//Creating random reservation number
		Random random = new Random();
		int reservationNumber = 0;
		boolean isUnique = false;
		while(!isUnique){
			reservationNumber = random.nextInt(900) + 100;
			ps = con.prepareStatement("select count(*) as count from reservations where r_number = ?;");
			ps.setInt(1, reservationNumber);
			
			ResultSet results = ps.executeQuery();

			if(results.next() && results.getInt("count") == 0)
				isUnique = true;
		}
		//out.print(reservationNumber+"!!!");
		
		//Get all parameters from the HTML form at the reservation_page.jsp.
		String fare = request.getParameter("fare");
		String discount = request.getParameter("discount");
		String lineName = request.getParameter("line_name");
		String trainID = request.getParameter("train_id");
		String departureTime = request.getParameter("departure_time");
		String destinationStationName = request.getParameter("destination_station");
		String originStationName = request.getParameter("origin_station");
		String originDeparture = request.getParameter("origin_departure");
		//out.print(originDeparture+"!!!"+", "+trainID+", "+lineName+" | ");

		//Getting additional relevant information
		ps = con.prepareStatement("select stops.stop_number as num, stops.stop_station as ID from stops join stations on stops.stop_station = stations.station_id " +
			"where stops.train_id = ? and stops.line_name = ? and stops.origin_departure = ? and stations.name = ?;");
		ps.setString(1, trainID);
		ps.setString(2, lineName);
		ps.setString(3, originDeparture);
		ps.setString(4, originStationName);

		ResultSet stationResults = ps.executeQuery();
		
		int originStopNumber = 0;
		if(stationResults.next()){
			originStopNumber = stationResults.getInt("num");
		}
		
		ps.setString(1, trainID);
		ps.setString(2, lineName);
		ps.setString(3, originDeparture);
		ps.setString(4, destinationStationName);

		stationResults = ps.executeQuery();
		
		int destStopNumber = 0;
		int destStopStation = 0;
		if(stationResults.next()){
			destStopNumber = stationResults.getInt("num");
			destStopStation = stationResults.getInt("ID");
		}
		//out.print(originStopNumber+", "+destStopNumber+"!!!");

		
		//Getting arrival time & formatting for display
		ps = con.prepareStatement("select arrival from stops where train_id = ? and line_name = ? and origin_departure = ? and stop_number = ?;");
		ps.setString(1, trainID);
		ps.setString(2, lineName);
		ps.setString(3, originDeparture);
		ps.setInt(4, destStopNumber);
		
		ResultSet arrivalResults = ps.executeQuery();
		String arrival = "";
		if(arrivalResults.next())
			arrival = arrivalResults.getString("arrival");
		SimpleDateFormat inputTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat outputTimeFormat = new SimpleDateFormat("h:mm a");
		String destinationArrival = outputTimeFormat.format(inputTimeFormat.parse(arrival));
		//out.print("!!!!!"+destinationArrival+"WOOT");	
		
		//Formatting departureTime for display
		String temp = departureTime;
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat outputFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy 'at' h:mm a");
        departureTime = outputFormat.format(inputFormat.parse(temp));

		//Getting today's date & formatting for display
		String currentDate = "" + java.sql.Date.valueOf(java.time.LocalDate.now());
		SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat outputDateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
        String date = outputDateFormat.format(inputDateFormat.parse(currentDate));

		//Create reservation (insert into books and reservations tables)
		ps = con.prepareStatement("insert into reservations values (?, ?, ?, ?);");
		ps.setInt(1, reservationNumber);
		ps.setDate(2, java.sql.Date.valueOf(java.time.LocalDate.now()));
		ps.setBigDecimal(3, new java.math.BigDecimal(fare));
		ps.setString(4, (String) session.getAttribute("username"));
		
		ps.executeUpdate();
		//out.print("maybe not success!!!");

		
		ps = con.prepareStatement("insert into books values (?, ?, ?, ?, ?, ?);");
		ps.setInt(1, reservationNumber);
		ps.setString(2, lineName);
		ps.setString(3, trainID);
		ps.setString(4, originDeparture);
		ps.setInt(5, originStopNumber);
		ps.setInt(6, destStopNumber);
		
		ps.executeUpdate();
	%>
	<h2>Almost there...</h2>
	<div class="almost-there">
		<form method="post" action="confirmation_page.jsp">
			<input type="hidden" name="reservationNumber" value="<%= reservationNumber %>">
			<input type="hidden" name="firstName" value="<%= session.getAttribute("firstName") %>">
			<input type="hidden" name="lastName" value="<%= session.getAttribute("lastName") %>">
			<input type="hidden" name="email" value="<%= session.getAttribute("email") %>">
			<input type="hidden" name="lineName" value="<%= lineName %>">
			<input type="hidden" name="train_id" value="<%= trainID %>">
			<input type="hidden" name="departureTime" value="<%= departureTime %>">
			<input type="hidden" name="destinationArrival" value="<%= destinationArrival %>">
			<input type="hidden" name="date" value="<%= date %>">
			<input type="hidden" name="fare" value="<%= fare %>">
			<input type="hidden" name="originStationName" value="<%= originStationName %>">
			<input type="hidden" name="destinationStationName" value="<%= destinationStationName %>">
			<input type="hidden" name="discount" value="<%= discount %>">
			<input type="submit" value="Click to Confirm Registration">
		</form>
	</div>
	<%
		//Redirecting back to registration_page.jsp with necessary attributes
		/* session.setAttribute("reservationNumber", reservationNumber);
		session.setAttribute("firstName", session.getAttribute("firstName"));
		session.setAttribute("lastName", session.getAttribute("lastName"));
		session.setAttribute("email", session.getAttribute("email"));
		session.setAttribute("lineName", lineName);
		session.setAttribute("trainID", trainID);
		session.setAttribute("departureTime", departureTime);
		session.setAttribute("destinationArrival", destinationArrival);
		session.setAttribute("date", java.sql.Date.valueOf(java.time.LocalDate.now()));
		session.setAttribute("fare", fare);
		session.setAttribute("originStationName", originStationName);
		session.setAttribute("destinationStationName", destinationStationName);
		session.setAttribute("discount", discount); */
		
		/* out.print(reservationNumber);
		out.print(session.getAttribute("firstName"));
		out.print(session.getAttribute("lastName"));
		out.print(departureTime);
		out.print(trainID);
		out.print(destinationArrival);
		out.print(date);
		out.print(originStationName);
		out.print(destinationStationName);
		out.print(discount);
		out.print(reservationNumber);
		out.print(session.getAttribute("email"));
		out.print(lineName);
		out.print(fare); */
 
		//request.getRequestDispatcher("confirmation_page.jsp").forward(request, response);
		
		db.closeConnection(con);
	} catch (Exception e) {e.printStackTrace();}
	
	%>
	</div>
</body>
</html>