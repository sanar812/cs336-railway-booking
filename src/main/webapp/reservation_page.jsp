<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Reservation Page</title>
		<link rel="stylesheet" href="reservation.css">
	</head>
	
	<body>
		<!-- USER INFORMATION -->
		<form class="logout-form" action="logout.jsp" style="position: absolute; top: 0; right: 0; margin-top: 5px; margin-right: 5px;">
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
	
		<div class="container">
		<form method="post" action="reservation.jsp">
		
<!-- ----------------------------------------------------Trip Information Display---------------------------------------------------- -->
			<h2 class="trip-info-heading">Trip Information:</h2>
        <%
        	String originDeparture = request.getParameter("origin_departure");
	        String lineName = request.getParameter("line_name");
	        String trainID = request.getParameter("train_id");
	        String departureTime = request.getParameter("departure_time");
	        String originStation = request.getParameter("origin_station");
	        String destinationStation = request.getParameter("destination_station");
	        String originCity = request.getParameter("origin_city");
	        String originState = request.getParameter("origin_state");
	        String destCity = request.getParameter("destination_city");
	        String destState = request.getParameter("destination_state");
	        String formattedDeparture = request.getParameter("formatted_departure");
	        String fare = request.getParameter("fare");
	        
	        //Getting date of train schedule
	        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        SimpleDateFormat outputDateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
	        String itineraryDate = "";
	        if(originDeparture != null && !(originDeparture.isEmpty()))
	        	itineraryDate = outputDateFormat.format(inputFormat.parse(originDeparture));

        %>
        	<div class="trip-info">
				<p><strong><%= lineName %> <%= trainID %></strong></p>
				<p>Departure on <%= formattedDeparture %>
					<br> from <%= originStation %>, <%= originCity %>, <%= originState %>
				</p>
				<p>Arriving at <%= destinationStation %>, <%= destCity %>, <%= destState %></p>
				<p id="fare">Estimated Fare: $<%= fare %></p>
				
				<!-- Store the original fare in a hidden element for accessing each time discount is selected -->
				<input type="hidden" id="original_fare" value="<%= fare %>">
				
				<!-- Hidden inputs to pass values using form -->
				<input type="hidden" name="line_name" value="<%= lineName %>">
				<input type="hidden" name="train_id" value="<%= trainID %>">
				<input type="hidden" name="origin_departure" value="<%= originDeparture %>">
				<input type="hidden" name="departure_time" value="<%= departureTime %>">
				<input type="hidden" name="origin_station" value="<%= originStation %>">
				<input type="hidden" name="destination_station" value="<%= destinationStation %>">
				<input type="hidden" name="fare" value="<%= fare %>">
				<input type="hidden" id="discount" name="discount" value="No">
			</div>
		    
		    <!-- Retrieving train schedule stop info & creating itinerary table-->
		    <h3 class="center" style="margin-bottom:-18px;">Itinerary</h3>
		    <table border=2 class="itinerary-table">
		    	<tr><th colspan=2 style="padding:3px;">
	       			<%= lineName %> <%= trainID %>
	       			<br><%= itineraryDate %>
	       		</th></tr>
		    
		    <%
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
		   
			try {
				db = new ApplicationDB();	
				con = db.getConnection();
				ResultSet resultSet = null;
				PreparedStatement ps = con.prepareStatement("select stop_station, departure, arrival from stops where train_id = ? and line_name = ? and origin_departure = ?;");
				ps.setString(1, trainID);
				ps.setString(2, lineName);
				ps.setString(3, originDeparture);
				
				resultSet = ps.executeQuery();
				while(resultSet.next()){
					int stationID = resultSet.getInt("stop_station");
					
					//Formatting departure time
					String stopDeparture = resultSet.getString("departure");
					if(stopDeparture == null && originDeparture != null)
						stopDeparture = resultSet.getString("arrival");
			        SimpleDateFormat inputTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			        SimpleDateFormat outputTimeFormat = new SimpleDateFormat("h:mm a");
			        String formattedStopDeparture = outputTimeFormat.format(inputTimeFormat.parse(stopDeparture));
					
			        //Querying database for individual stop attributes
					ps = con.prepareStatement("select name, city, state from stations where station_id = ?;");
					ps.setInt(1, stationID);
					ResultSet stationResults = ps.executeQuery();
					
					String stationName = "";
					String stationCity = "";
					String stationState = "";
					if(stationResults.next()){
						stationName = stationResults.getString("name");
						stationCity = stationResults.getString("city");
						stationState = stationResults.getString("state");
			%>
						<tr>
							<td style="padding:3px;"><%= formattedStopDeparture %></td>
							<td style="padding:3px;"><%= stationName %>, <%= stationCity %>, <%= stationState %></td>
						</tr>
			<%
					}
				}
				db.closeConnection(con);
			} catch (Exception e) {}
			
			%>
			</table>
			
<!-- ----------------------------------------------------Selecting Discounts---------------------------------------------------- -->

        	<h3>Discounts:</h3>
        	<div>
				<h3>Are you reserving for...</h3>
				<button type="button" class="discount-btn" onclick="purchaseForChild()">A Child?<br>25% Off</button>
				<button type="button" class="discount-btn" onclick="purchaseForSeniorCitizen()">A Senior Citizen?<br>35% Off</button>
				<button type="button" class="discount-btn" onclick="purchaseForDisabledPerson()">A Disabled Person?<br>50% Off</button>
				<br>
				<button type="button" class="reset-btn" onclick="resetFare()">Reset</button>
			</div>
			
			<br>
				
			<script>
				function getFareValue() {
			        var fareText = document.getElementById("original_fare").value;
			        var fare = fareText.replace("$", "");
			        return parseFloat(fare);
			    }
				
				function purchaseForChild() {
					var fare = getFareValue();
					var newfare=fare*0.75;
					document.getElementById("fare").innerHTML = "Estimated Fare: $"+newfare.toFixed(2)+"<br>Children's Discount";
					document.getElementById("fare").style.color = "red";
					document.getElementById("fare").style.fontWeight = "bold";
					document.getElementById("discount").value = "Children's";
				}
				
				function purchaseForSeniorCitizen() {
					var fare = getFareValue();
					var newfare=fare*0.65;
					document.getElementById("fare").innerHTML = "Estimated Fare: $"+newfare.toFixed(2)+"<br>Senior Citizen Discount";
					document.getElementById("fare").style.color = "red";
					document.getElementById("fare").style.fontWeight = "bold";
					document.getElementById("discount").value = "Senior Citizen";
				}
				
				function purchaseForDisabledPerson() {
					var fare = getFareValue();
					var newfare=fare*0.5;
					document.getElementById("fare").innerHTML = "Estimated Fare: $"+newfare.toFixed(2)+"<br>Disability Discount";
					document.getElementById("fare").style.color = "red";
					document.getElementById("fare").style.fontWeight = "bold";
					document.getElementById("discount").value = "Disability";
				}
				function resetFare() {
					document.getElementById("fare").innerHTML = "Estimated Fare: $"+document.getElementById("original_fare").value;
					document.getElementById("fare").style.color = "black";
					document.getElementById("fare").style.fontWeight = "normal";
				}
			</script>
			
<!-- ------------------------------------------------------Reserve Seat------------------------------------------------------ -->
			
			<input type="submit" class="reserve-btn" value="Reserve Now">
		</form>	
    	</div>
	</body>
</html>