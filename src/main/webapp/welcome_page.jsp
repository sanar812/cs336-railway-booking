<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<!-- Retrieve name of customer accessing system. -->
<%
	String accessorName = (String) session.getAttribute("accessorName");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" type="text/css" href="welcome.css">
	<title>Welcome Page</title>
</head>

<body>
	<!-- USER INFORMATION -->
		<form class="logout-form" action="logout.jsp"">
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
			else
				response.sendRedirect("login.jsp");
		%>	
		
			<input style="font-size:20px;" type="submit" value="Logout">
		</form>
		
	<!-- FORUM BUTTON-->
	<a href="forum_page.jsp" style="text-decoration:none;"><button type="button" id="forum">Visit Q&A Forum</button></a>


	<div class="container">
	
	<div class="header">
		<h1>Online Railway Booking System</h1>
		<h2>Welcome, <%= accessorName %>!</h2>
	</div>
<!-- --------------------------------------------------Search Bar-------------------------------------------------- -->
	
	<h3>Browse Trips</h3>
	
	<div class="browse">
		<form id="search_form" action="welcome_page.jsp" method="post" onsubmit="return validateForm()">
	<!-- <form id="search_trains" action="browseResults()" method="get"> -->
	
			<!-- TRIP TYPE DROPDOWN MENU -->
			<select name="trip_type" class="trip_dropdown" onchange="roundTripDates()">One-Way
				<option value="one-way" onclick="">One-Way</option>
				<option value="round-trip" onclick="">Round Trip</option>
			</select>
		
	    
	    <!-- Establishing connection to database, globally. -->
	     <%
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            try {
            	//Retrieving all DISTINCT cities from stations table.
            	PreparedStatement ps = con.prepareStatement("select distinct name from stations");
            	ResultSet result = ps.executeQuery();
       	%>
    
    
	    	<!-- ORIGIN STATION DROPDOWN MENU -->
	        <select name="origin_station" class="station_dropdown">
	        	<option value="" disabled selected style="color:gray;">-- Select a Starting Station --</option>
	        	<%
	        		//Loop through the result set and create <option> tags for each city
	        		while(result.next()){
	        			String name = result.getString("name");
           		%>
           				<option value="<%= name %>"><%= name %></option>
           		<%
           			}
	            	result.beforeFirst();
	            %>
	        </select>
	        
	        
	        <!-- DESTINATION STATION DROPDOWN MENU -->
	        <select name="destination_station" class="station_dropdown">
	            <option value="" disabled selected style="color:gray;">-- Select a Destination Station --</option>
	            <%
	            
	            	//Loop through the result set and create <option> tags for each city
	            	while(result.next ()){
	            		String name = result.getString("name");
           		%>
           				<option value="<%= name %>"><%= name %></option>
           		<%
           			}
					db.closeConnection(con);
				} catch (Exception e) {
					out.print(e);
				}
	            %>
	        </select>
	        
	        <br>
	        
	        <!-- CALENDAR SELECT -->
	        <label id="departure_date_label" style="font-size: 22px; margin-left: 5px;">Select a date:</label>
	        	<input type="date" name="departure-date">
	        	
	        <!-- CALENDAR SELECT - ROUND TRIP RETURN DATE (initially hidden) -->
	        <div id="return_date_container" style="display: none;">
	        	<label id="return_date_label" style="font-size: 22px; margin-left: 5px;">Select a return date:</label>
	        		<input type="date" name="return-date">
	        </div>
	        
	        <!-- Changing visibility of return date & text of departure date based on trip type. -->
	        <script type="text/javascript">
	        	function roundTripDates(){
	        		var tripType = document.getElementsByName('trip_type')[0].value;
	        		
	        		if(tripType == 'round-trip'){
	        			document.getElementById('return_date_container').style.display = 'block';
	        			document.getElementById('departure_date_label').innerHTML = "Select a departure date:";
	        		}
	        		else{
	        			document.getElementById('return_date_container').style.display = 'none';
	        			document.getElementById('departure_date_label').innerHTML = "Select a date:";
	        		}
	        	}
	        </script>
	        
	        
	        <button type="submit">Search</button>
	    </form>
	</div>
	
	</div>
	
<!-- ------------------------------------------------Function to Check Form Completion------------------------------------------------ -->

 <script type="text/javascript">
 	function validateForm(){ 		
		var tripType = document.getElementsByName('trip_type')[0].value;
		var originStation = document.getElementsByName('origin_station')[0].value;
		var destinationStation = document.getElementsByName('destination_station')[0].value;
		var departureDate = document.getElementsByName('departure-date')[0].value;
		//document.write(tripType);
		
		var returnDate = "";
		if(tripType == "round-trip"){
			returnDate = document.getElementsByName('return-date')[0].value;
			if(returnDate === ""){
				alert("All fields are required.")
		        return false;
			}
		}
		
		if(!tripType || !originStation || !destinationStation || departureDate === ""){
			alert("All fields are required.")
	        return false;
		}	
		
		if(originStation === destinationStation){
			alert("Origin and destination stations must be different.");
	        return false;
		}
		
		//If form is complete, submit the form
        document.getElementById("search_form").submit();
		
		return true;
 	}
</script>

<br><br><br><br>	
<!-- ----------------------------------------------------------Search Results---------------------------------------------------------- -->
	
	<div id="search_results_container">
	<%
	
	try {

		//Get the database connection
		db = new ApplicationDB();	
		con = db.getConnection();
		ResultSet resultSet = null;
		PreparedStatement ps = null;
		
		
		//Get all parameters from the HTML form at the welcome_page.jsp
		String tripType = request.getParameter("trip_type");
		String originStation = request.getParameter("origin_station");
		String destinationStation = request.getParameter("destination_station");
		String departureDate = request.getParameter("departure-date");

        String returnDate = tripType.equals("round-trip") ? request.getParameter("return-date") : ""; //Ternary operator

		
		//Getting station_id based on station_name
		PreparedStatement originPS = con.prepareStatement("select station_id from stations where name = ?");
		originPS.setString(1, originStation);
		ResultSet originResults = originPS.executeQuery();
		int originStationID = originResults.next() ? originResults.getInt("station_id") : -1; //Ternary operator
		
		PreparedStatement destPS = con.prepareStatement("select station_id from stations where name = ?");
		destPS.setString(1, destinationStation);
		ResultSet destResults = destPS.executeQuery();
		int destStationID = destResults.next() ? destResults.getInt("station_id") : -1; //Ternary operator
		
		
		//One-way trip.
		if(returnDate.equals("")){		
			//Query the database to find matching trips.
			ps = con.prepareStatement("SELECT ts.fare, ts.stop_count, ts.line_name, ts.train_id, ts.departure AS origin_departure, " + 
			"s_origin.departure AS departure_time, ts.origin_station AS origin_station, ts.destination_station AS destination_station, " + 
			"s_origin.stop_number AS originStop, s_dest.stop_number AS destStop " + 
			"FROM train_schedules ts JOIN stops s_origin ON " + 
			"(ts.train_id = s_origin.train_id AND ts.line_name = s_origin.line_name AND ts.departure = s_origin.origin_departure) " + 
			"JOIN stops s_dest ON (ts.train_id = s_dest.train_id AND ts.line_name = s_dest.line_name AND ts.departure = s_dest.origin_departure) " + 
			"WHERE s_origin.stop_station = ? AND s_dest.stop_station = ? AND DATE(s_origin.departure) = ? " + 
			"AND s_origin.stop_number < s_dest.stop_number ORDER BY s_origin.departure;");
			ps.setInt(1, originStationID);
			ps.setInt(2, destStationID);
			ps.setString(3, departureDate);
			
			
		}
		//Round trip.
		/*else{
			//Query the database to find matching trips.
			ps = con.prepareStatement("select * from trips where origin = ? and destination = ? and departure_date = ? and return_date = ?");
			ps.setInt(1, originStationID);
			ps.setInt(2, destStationID);
			ps.setString(3, departureDate);
			ps.setString(4, returnDate);
		}*/
		resultSet = ps.executeQuery();
			
		if(!resultSet.isBeforeFirst()){
			out.print("<div style=\"color: red;\">No trips found.</div>");
		}
		else{
			out.print("<h3 align style=\"text-align:center;\">Search Results:</h3><ul>");
			
		    ArrayList<HashMap<String, String>> resultsList = new ArrayList<>();
			
			while (resultSet.next()){
				//Formatting fare
				double fare = 0.00;
				double totalFare = Double.parseDouble(resultSet.getString("fare"));
				int stopCount = resultSet.getInt("stop_count");
				int numStops = resultSet.getInt("destStop") - resultSet.getInt("originStop");
				fare = Math.round(((totalFare/stopCount)*numStops)*100.0)/100.0;
		        DecimalFormat df = new DecimalFormat("0.00"); // Format with two decimal places
		        String fareString = df.format(fare);
		        
		        //Formatting datetime
		        String departureTime = resultSet.getString("departure_time");
		        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		        SimpleDateFormat outputFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy 'at' h:mm a");
		        String formattedDeparture = outputFormat.format(inputFormat.parse(departureTime));
		        
		        //Retrieve station information (city and state)
		        //Origin Station
		        ps = con.prepareStatement("select s.city, s.state from stations s where s.station_id = ?");
		        ps.setInt(1, originStationID);
		        ResultSet stationResultSet = ps.executeQuery();
		        String originCity = "";
		        String originState = "";
		        if(stationResultSet.next()){
		        	originCity = stationResultSet.getString("city");
		        	originState = stationResultSet.getString("state");
		        }
		        
		        //Destination Station
		        ps.setInt(1, destStationID);
		        stationResultSet = ps.executeQuery();
		        String destCity = "";
		        String destState = "";
		        if(stationResultSet.next()){
		        	destCity = stationResultSet.getString("city");
		        	destState = stationResultSet.getString("state");
		        }
		        
				out.print("<form action=\"reservation_page.jsp\" method=\"post\">");
				out.print("    <input type=\"hidden\" name=\"origin_departure\" value=\"" + resultSet.getString("origin_departure") + "\">");
				out.print("    <input type=\"hidden\" name=\"line_name\" value=\"" + resultSet.getString("line_name") + "\">");
				out.print("    <input type=\"hidden\" name=\"train_id\" value=\"" + resultSet.getString("train_id") + "\">");
				out.print("    <input type=\"hidden\" name=\"departure_time\" value=\"" + resultSet.getString("departure_time") + "\">");
				out.print("    <input type=\"hidden\" name=\"origin_station\" value=\"" + originStation + "\">");
				out.print("    <input type=\"hidden\" name=\"destination_station\" value=\"" + destinationStation + "\">");
				out.print("    <input type=\"hidden\" name=\"origin_city\" value=\"" + originCity + "\">");
				out.print("    <input type=\"hidden\" name=\"origin_state\" value=\"" + originState + "\">");
				out.print("    <input type=\"hidden\" name=\"destination_city\" value=\"" + destCity + "\">");
				out.print("    <input type=\"hidden\" name=\"destination_state\" value=\"" + destState + "\">");
				out.print("    <input type=\"hidden\" name=\"fare\" value=\"" + fareString + "\">");
				out.print("    <input type=\"hidden\" name=\"formatted_departure\" value=\"" + formattedDeparture + "\">");
				
				out.print("    <button type=\"submit\" style=\"text-decoration: none; border: none; background: none;\">");
				out.print("        <div class=\"result-box\">");
				out.print("            <p><strong>" + resultSet.getString("line_name") +" "+ resultSet.getString("train_id") + "</strong></p>");
				out.print("            <p><strong>Departure Time:</strong> " + formattedDeparture+ "</p>");
				out.print("            <p><strong>From:</strong> " + originStation + "</p>");
				out.print("            <p><strong>To:</strong> " + destinationStation + "</p>");
				out.print("            <p><strong>Estimated Fare: $</strong>" + fareString + "</p>");
				out.print("        </div>");
				out.print("    </button>");
				out.print("</form>");

            }
			out.print("</ul>");
		    //request.setAttribute("searchResults", resultsList);
		    //request.getRequestDispatcher("reservation_page.jsp").forward(request, response);
		}
		db.closeConnection(con);
	} catch (Exception e) {}
	
	%>
	</div>	
</body>
</html>