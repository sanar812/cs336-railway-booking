<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<!-- Retrieve name of customer representative accessing system. -->
<%
	String accessorName = (String) session.getAttribute("accessorName");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Customer Representative - Home Page</title>
		<link rel="stylesheet" href="customer_rep_access.css">
	</head>
	
	<body>
	
	
		<!-- Logout Button -->
	    <div class="logout-form">
	        <form action="logout.jsp">
	            <input type="submit" value="Logout">
	        </form>
	    </div>
		
		<div class="wrapper"><div class="container">
			<div class="header">
				<h1>Online Railway Booking System</h1>
				<h2>Customer Representative: <%= accessorName %></h2>
			</div>
			
			
			
			<!-- Train Schedules by Station -->
			<div class="station-schedules">
				<h2>Train Schedules by Station</h2>
				<label for="station">Select Station:</label>

		<%
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
				try {
	            	//Retrieving all DISTINCT cities from stations table.
	            	PreparedStatement ps = con.prepareStatement("select distinct name from stations;");
            		ResultSet result = ps.executeQuery();
       			%>
    
		    	<!-- Station Dropdown Menu -->
		        <select name="station" id="station">
		        	<option value="" disabled selected style="color:gray;">-- Select a Station --</option>
		        	<%
		        		//Loop through the result set and create <option> tags for each city
		        		while(result.next()){
		        			String name = result.getString("name");
	           		%>
	           				<option value="<%= name %>"><%= name %></option>
         		<%
	           			}
					} catch (Exception e) {
						out.print(e);
					}
				%>
		        </select>

				<button onclick="filterSchedules()">Filter Schedules</button>
			</div>
			


			<!-- Train Schedules Management Section -->
			<div class="train-schedules">
				<h2>Manage Train Schedules</h2>
				<table>
					<thead>
						<tr>
							<th>Train</th>
							<th>Departure</th>
							<th>Origin</th>
							<th>Arrival</th>
							<th>Destination</th>
							<th>Total Travel Time</th>
							<th>Fare</th>
							<th>#Stops</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
			<%
			
            try {
            	//Retrieving all train schedules.
            	PreparedStatement ps = con.prepareStatement("select travel_time, fare, origin_station, destination_station, departure, arrival, line_name, train_id, stop_count from train_schedules;");
            	ResultSet result = ps.executeQuery();
        		while(result.next()){
        			String lineName = result.getString("line_name");
        			String travelTime = result.getString("travel_time");
        			int stops = result.getInt("stop_count");
        			String arrival = result.getString("arrival");
        			String departure = result.getString("departure");
        			int originStation = result.getInt("origin_station");
        			int destinationStation = result.getInt("destination_station");
        			String trainID = result.getString("train_id");
        			String fare = result.getString("fare");
        			
        			/* out.print(lineName);
        			out.print(travelTime);
        			out.print(stops);
        			out.print(arrival);
        			out.print(departure);
        			out.print(originStation);
        			out.print(destinationStation);
        			out.print(trainID);
        			out.print(fare); */
        			
        			//Formatting datetimes
    		        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    		        SimpleDateFormat outputFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy 'at' h:mm a");
    		        String formattedDeparture = outputFormat.format(inputFormat.parse(departure));
    		        String formattedArrival = outputFormat.format(inputFormat.parse(arrival));
    		        
    		        //Getting station names
    		        PreparedStatement originPS = con.prepareStatement("select name from stations where station_id = ?;");
    		        originPS.setInt(1, originStation); 		        
    		        ResultSet originResults = originPS.executeQuery();
    				String origin = originResults.next() ? originResults.getString("name") : ""; //Ternary operator
    				
    				PreparedStatement destinationPS = con.prepareStatement("select name from stations where station_id = ?;");
     		        destinationPS.setInt(1, destinationStation); 		        
     		        ResultSet destinationResults = destinationPS.executeQuery();
     				String destination = destinationResults.next() ? destinationResults.getString("name") : ""; //Ternary operator
    				
         	%>
        			<tr>
        				<td><%= lineName %> <%= trainID %></td>
        				<td><%= formattedDeparture %></td>
        				<td class="origin"><%= origin %></td>
        				<td><%= formattedArrival %></td>
        				<td class="destination"><%= destination %></td>
        				<td><%= travelTime %> minutes</td>
        				<td>$<%= fare %></td>
        				<td><%= stops %></td>
        				<td>
							<button>Edit</button>
							<button>Delete</button>
						</td>
        			</tr>
         	<%
        		}
			} catch (Exception e) {
				out.print(e);
			}
            
			%>
					</tbody>
				</table>
				
				<!-- If no results, unhide. -->
				<p id="hidden-text" style="color:red; display:none;" ><strong>No schedules found.</strong></p>
				
			</div>


			<!-- Reply to Customer Question Section -->
			<div class="reply-question">
				<h2>Reply to Customer Question</h2>
				<form id="forum_reply" action="submit_question.jsp" method="post">
				<%
				try {
	            	PreparedStatement ps = con.prepareStatement("select question, qid from forum;");
            		ResultSet result = ps.executeQuery();
            		int qid = 0;
            		
      			%>
					<select id="questionId" name="questionId">
						<option value="" disabled selected style="color:gray;">-- Select a Question --</option>
			        	<%
			        		//Loop through the result set and create <option> tags for each city
			        		while(result.next()){
			        			String question = result.getString("question");
			        			qid = result.getInt("qid");
		           		%>
		           				<option value="<%= question %>"><%= question %></option>
	         			<%
		           			}
						%>
					</select>
					<input type="hidden" name="qid" value="<%= qid %>">
				<%
					} catch (Exception e) {out.print(e);}
				%>
					<textarea name="reply" placeholder="Enter your reply..." rows="4" required></textarea>
					<br>
					<button type="submit" value="Post Reply" onclick="return validateQuestions()">Post Reply</button>
				</form>
				<!-- MESSAGE DISPLAY -->
				<%
					String successMessage = (String) request.getAttribute("successMessage");
					if(successMessage != null) {
				%>
						<div class="success-message" style="color: blue; margin:auto; width: 50%">
							<%= successMessage %>
						</div>
				<%
					}
				%>
			</div>
						
			
			<!-- List of Customers with Reservations -->
			<div class="reservations">
				<h2>List of Customers with Reservations</h2>
				<form id="get_reservations" action="customer-rep_access.jsp" method="post" onsubmit="return validateReservations()">
					<label for="train">Select Train:</label>
					<select id="train" name="train">
						<option value="" disabled selected style="color:gray;">-- Select a Train --</option>
						
					<%
						try {
		            	//Retrieving all trains from train_schedules table.
		            	PreparedStatement ps = con.prepareStatement("select distinct train_id, line_name from train_schedules;");
	            		ResultSet result = ps.executeQuery();
			        		//Loop through the result set and create <option> tags for each train
			        		while(result.next()){
			        			String lineName = result.getString("line_name");
			        			String trainID = result.getString("train_id");
		           		%>
		           				<option value="<%= lineName %> <%=trainID %>"><%= lineName %> <%= trainID %></option>
	         		<%
		           			}
						} catch (Exception e) {
							out.print(e);
						}
					%>
			        </select>
										
					<label for="date">Select Date:</label>
					<input type="date" id="date" name="date">
					
					<button type="submit">Show Reservations</button>
				</form>
				
				<div id="reservation-list">
					<%
						String train = request.getParameter("train");
						String date = request.getParameter("date");
						
						//Formatting date
						SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
	    		        SimpleDateFormat outputFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
	    		        String formattedDate = outputFormat.format(inputFormat.parse(date));
					%>
						<p><strong><u>Customers Reserved for <%= train %> on <%= formattedDate %>:</u></strong></p>
						
					<%						
						if(train != null && date != null){
							try {
								String lineName = train.substring(0, train.indexOf("#")-1);
								String trainID = train.substring(train.indexOf("#"), train.length());
								
								PreparedStatement ps = con.prepareStatement("select distinct concat(customers.first_name, ' ', customers.last_name) as customer_name " + 
									"from customers join reservations on customers.username = reservations.username join books on reservations.r_number = books.r_number " + 
									"where books.train_id = ? and books.line_name = ? and DATE(books.departure) = ?;");
								ps.setString(1, trainID);
								ps.setString(2, lineName);
								ps.setString(3, date);
								ResultSet result = ps.executeQuery();

								if(!result.isBeforeFirst())
									out.println("<p style=\"color:red;\"><strong>No reservations found.</strong></p>");
				        		while(result.next()){
				        			String customerName = result.getString("customer_name");
		        					out.println("<p>"+customerName+"</p>");
				        		}
							} catch (Exception e) {
								out.print(e);
							}
						}
					%>
				</div>
			</div>
			
		</div></div>
		
		
		<script>
			function filterSchedules() {
				var station = document.getElementById("station").value;
				if(!station){
					alert("Select a station.");
					return;
				}
				var table = document.querySelector(".train-schedules table tbody");
				var rows = table.getElementsByTagName("tr"); //Get all rows in the table
				
				for (var i = 0; i < rows.length; i++) {
					var origin = rows[i].querySelector(".origin").innerText; //Get rows from origin column
					var destination = rows[i].querySelector(".destination").innerText; //Get rows from destination column
					
					if (origin === station || destination === station) {
						rows[i].style.display = ""; //Match - show the row
						document.getElementById("hidden-text").style.display = "none";
					}
					else {
						rows[i].style.display = "none"; //No match - hide the row
						document.getElementById("hidden-text").style.display = "";
					}
				}
			}

			
			function validateReservations() {
				var train = document.getElementById("train").value;
				var date = document.getElementsByName('date')[0].value;
				if(!train){
					alert("Select a train.");
					return false;
				}
				if(date === ""){
					alert("Select a date.");
					return false;
				}
				
				//If form is complete, submit the form
		        document.getElementById("get_reservations").submit();
				
				return true;
			}
			
			function validateQuestions() {
				var question = document.getElementById("questionId").value;
				if(!question){
					alert("Select a question.");
					return false;
				}
				
				//If form is complete, submit the form
		        document.getElementById("forum_reply").submit();
				
				return true;
			}
		</script>
	</body>
</html>



