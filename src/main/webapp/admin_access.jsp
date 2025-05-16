<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<!-- Retrieve name of manager accessing system. -->
<%
	String accessorName = (String) session.getAttribute("accessorName");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Administrator - Home Page</title>
		<link rel="stylesheet" href="admin_access.css">
	</head>
	
<!-- ----------------------------------------------------------Logout Button---------------------------------------------------------- -->

	<body>
		<div class="logout-form">
			<form action="logout.jsp">
				<input type="submit" value="Logout">
			</form>
    	</div>

		<div class="container">
			<div class="header">
				<h1>Online Railway Booking System</h1>
				<h2>Admin Control: <%= accessorName %></h2>
			</div>

<!-- ----------------------------------------------------------Add/Edit/Delete Customer Representative---------------------------------------------------------- -->

			<div class="admin-functions">

				<div class="function-section">
				
					<!-- Add New Customer Representative -->
					<h3>Add Customer Representative</h3>
					<form method="post" action="rep-registration.jsp">
						<div class="form-group">
							<label for="first_name_label">First Name: </label>
							<input id="first_name" name="first_name" value="<%= request.getParameter("first_name") != null ? request.getParameter("first_name") : "" %>"><br><br>
						</div>	
						<div class="form-group">	
							<label for="last_name_label">Last Name: </label>
							<input id="last_name" name="last_name" value="<%= request.getParameter("last_name") != null ? request.getParameter("last_name") : "" %>"><br><br>
						</div>	
						<div class="form-group">	
							<label for="ssn_label">SSN: </label>
							<input id="ssn" name="ssn" value="<%= request.getParameter("ssn") != null ? request.getParameter("ssn") : "" %>"><br><br>
						</div>	
						<div class="form-group">	
							<label for="user_label">Username: </label>
							<input id="username" name="username" value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"><br><br>
						</div>	
						<div class="form-group">	
							<label for="pass_label">Password: </label>
							<input type="password" name="password" value="<%= request.getParameter("password") != null ? request.getParameter("password") : "" %>"><br><br>
						</div>	
						<div class="form-group">
							<label for="pass_label_2">Repeat Password: </label>
							<input type="password" name="password2" value="<%= request.getParameter("password2") != null ? request.getParameter("password2") : "" %>"><br><br>
						</div>
						<div class="form-group">
							<button type="submit">Save Customer Representative</button>
						</div>	
					</form>
					
					<!-- MESSAGE DISPLAY -->
					<%
						String errorMessage = (String) request.getAttribute("errorMessage");
						String registerMessage = (String) request.getAttribute("registerMessage");
						if(errorMessage != null) {
					%>
							<div class="error-message" style="color: red; margin:auto; width: 50%;">
								<%= errorMessage %>
							</div>
					<%
						}
						if(registerMessage != null) {
						%>
								<div class="register-message" style="color: blue margin:auto; width: 50%;">
									<%= registerMessage %>
								</div>
						<%
							}
						%>					
					
					<!-- Edit / Delete Existing Representative -->
					<h3>Edit/Delete Customer Representative</h3>
					<form id="modify-rep" method="post">
						<select id="representative-name" name="representative-name">
							<option value="" disabled selected style="color:gray;">-- Select a Customer Representative --</option>
							<%
								ApplicationDB db = new ApplicationDB();
								Connection con = db.getConnection();
								try {
					            	PreparedStatement ps = con.prepareStatement("select cr.ssn, e.first_name, e.last_name, e.username from customer_representatives cr left join employees e on cr.ssn = e.ssn group by cr.ssn;");
				            		ResultSet result = ps.executeQuery();
					        		//Loop through the result set and create <option> tags for each train
					        		while(result.next()){
					        			String firstName = result.getString("first_name");
					        			String lastName = result.getString("last_name");
					        			String username = result.getString("username");
					        			
				           		%>
				           				<option value="<%= firstName %> <%= lastName %> [<%= username %>]"><%= firstName %> <%= lastName %> [<%= username %>]</option>
			         		<%
				           			}
								} catch (Exception e) {
									out.print(e);
								}
							%>
			        	</select>						
						
						<div class="buttons">
							<button id="edit" type="submit" onclick="return submitForm('button', 'modify-rep', 'edit_representative.jsp')">Edit Representative</button>
							<button id="delete" type="submit" onclick="return submitForm('button', 'modify-rep', 'delete_representative.jsp')">Delete Representative</button>
						</div>
						
						<br>
						
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
					</form>
				</div>

<!-- ----------------------------------------------------------Admin Functions---------------------------------------------------------- -->

				<div class="function-section">
					<h3>Sales Reports</h3>
					<form action="report.jsp" method="post">
						<label for="report-month">Select Month</label>
						<input type="month" id="report-month" name="report-month">
						<button type="submit">Generate Report</button>
					</form>
				</div>

<!-- ----------------------------------------------------------Transit Line Information---------------------------------------------------------- -->

				<div class="function-section">
					<h3>Transit Line Functions</h3>
					
					<form id="line-functions" method="post">
						<select id="transit_lines" name="transit_lines">
							<option value="" disabled selected style="color:gray;">-- Select a Transit Line --</option>
						
							<%
								try {
				            	//Retrieving all trains from train_schedules table.
				            	PreparedStatement ps = con.prepareStatement("select distinct line_name from train_schedules;");
			            		ResultSet result = ps.executeQuery();
					        		//Loop through the result set and create <option> tags for each train
					        		while(result.next()){
					        			String lineName = result.getString("line_name");
				           		%>
				           				<option value="<%= lineName %>"><%= lineName %></option>
			         		<%
				           			}
								} catch (Exception e) {
									out.print(e);
								}
							%>
			        	</select>

						<input type="hidden" name="line-action" id="line-action" value="hihi"></input>
						<button type="submit" onclick="return submitForm('line-reservation-button', 'line-functions', 'admin_access.jsp')">View Reservations</button>
						<button type="submit" onclick="return submitForm('revenue-button', 'line-functions', 'line_revenue.jsp?')">View Revenue</button>
					</form>
					<br>
					<!-- RESULT DISPLAY -->
					<%
						String lineRevenue = (String) request.getAttribute("lineRevenue");
						String lineReservations = (String) request.getAttribute("lineReservations");
						String noLineReservations = (String) request.getAttribute("noLineReservations");
						if(lineRevenue != null) {
					%>
							<div class="results">
								<%= lineRevenue %>
							</div>
					<%
						}
					%>
					<div class="results">
					<%
					try {
				
						String lineName = request.getParameter("transit_lines");
					%>
						<p><strong><u>Reservations for <%= lineName %>:</u></strong></p>
					<%	
						//Create a SQL statement.
						PreparedStatement ps = con.prepareStatement("select c.first_name, c.last_name, c.email_address, r.r_number, b.train_id, b.departure from customers c join reservations r on c.username = r.username join books b on r.r_number = b.r_number where b.line_name = ?;");
						//Replace "?" with value entered in textboxes.
						ps.setString(1, lineName);
						//Run the query against the database.
						ResultSet result = ps.executeQuery();
						
						if(!result.isBeforeFirst()){
							out.println("<p style=\"color:red;\"><strong>No reservations found.</strong></p>");
						}
						while(result.next()){
							String trainID = result.getString("train_id");
							String departure = result.getString("departure");
							String reservationNumber = result.getString("r_number");
							String firstName = result.getString("first_name");
							String lastName = result.getString("last_name");
							String email = result.getString("email_address");
							
							//Formatting departure
					        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					        SimpleDateFormat outputFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy 'at' h:mm a");
					        String formattedDeparture = outputFormat.format(inputFormat.parse(departure));
							
							out.println("<p>Reservation #"+reservationNumber+": "+lineName+" "+trainID+" - "+formattedDeparture+". Reserved for "+firstName+" "+lastName+" ["+email+"]</p>");
						}
					} catch (Exception e) {
						out.print(e);
					}
					
					%>
					</div>
				</div>
				
<!-- ----------------------------------------------------------Customer Information---------------------------------------------------------- -->

				<div class="function-section">
					<h3>Customer Functions</h3>
					
					<form id="customer-functions" method="get">
						<select id="customers" name="customers">
							<option value="" disabled selected style="color:gray;">-- Select a Customer --</option>
						
							<%
								try {
				            	//Retrieving all customer from customer table.
				            	PreparedStatement ps = con.prepareStatement("select distinct concat(first_name, ' ', last_name) as customer_name, email_address from customers;");
			            		ResultSet result = ps.executeQuery();
					        		//Loop through the result set and create <option> tags for each train
					        		while(result.next()){
					        			String customerName = result.getString("customer_name");
					        			String email = result.getString("email_address");
				           		%>
				           				<option value="<%= customerName %> [<%= email %>]"><%= customerName %> [<%= email %>]</option>
			         		<%
				           			}
								} catch (Exception e) {}
							%>
			        	</select>
			        	
			        	<input type="hidden" name="customer-action" id="customer-action" value="hihi"></input>
						<button type="submit" onclick="return submitForm('customer-reservation-button', 'customer-functions', 'admin_access.jsp')">View Reservations</button>
						<button type="submit" onclick="return submitForm('revenue-button', 'customer-functions', 'customer_revenue.jsp')">View Revenue</button>
											
					</form>
					<br>
					<!-- RESULT DISPLAY -->
					<%
						String customerRevenue = (String) request.getAttribute("customerRevenue");
						if(customerRevenue != null) {
					%>
							<div class="results">
								<%= customerRevenue %>
							</div>
					<%
						}
					%>
					
				<div class="results">
				<%
					//String value = request.getParameter("customer-action");
					//out.print(value);
					
				//if(value.equals("View Customer Reservations")){
					
					try {
			
						String customer = request.getParameter("customers");
						String[] customerInfo = customer.split(" ");
						String firstName = customerInfo[0];
						String lastName = customerInfo[1];
						String email = customerInfo[2].substring(1, customerInfo[2].length()-1);
					%>
						<p><strong><u>Reservations for <%= firstName %> <%= lastName %>:</u></strong></p>
					<%
						//Create a SQL statement.
						PreparedStatement ps = con.prepareStatement("select b.line_name, b.train_id, b.departure, r.r_number from customers c join reservations r on c.username = r.username join books b on r.r_number = b.r_number where c.email_address = ?;");
						//Replace "?" with value entered in textboxes.
						ps.setString(1, email);
						//Run the query against the database.
						ResultSet result = ps.executeQuery();
						
						if(!result.isBeforeFirst()){
							out.println("<p style=\"color:red;\"><strong>No reservations found.</strong></p>");
						}
						while(result.next()){
							String lineName = result.getString("line_name");
							String trainID = result.getString("train_id");
							String departure = result.getString("departure");
							String reservationNumber = result.getString("r_number");
							
							//Formatting departure
					        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					        SimpleDateFormat outputFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy 'at' h:mm a");
					        String formattedDeparture = outputFormat.format(inputFormat.parse(departure));
							
							out.println("<p>Reservation #"+reservationNumber+": "+lineName+" "+trainID+" - "+formattedDeparture+"</p>");
						}			
					} catch (Exception e) {}
				//}
				
				%>
				</div>
			</div>
			
<!-- -----------------------------------------------------Best Customer and Most Active Transit Lines----------------------------------------------------- -->
								
				<div class="function-section">
					<h3>Best Customer & Most Active Transit Lines</h3>
					<button type="button" onclick="showBestCustomer()">Best Customer</button>
					<div class="results" id="best-customer" style="display:none;">
						<%
						try {
							//Create a SQL statement.
							PreparedStatement ps = con.prepareStatement("select c.first_name, c.last_name, sum(r.total_fare) as total_revenue from customers c join reservations r on c.username = r.username group by c.username, c.email_address order by sum(r.total_fare) desc limit 1;");
							
							//Run the query against the database.
							ResultSet result = ps.executeQuery();
							
							if(result.next()){
								String firstName = result.getString("first_name");
								String lastName = result.getString("last_name");
								String total = result.getString("total_revenue");
						%>
							<p style="color:navy blue;"><strong>Our best customer is <%= firstName %> <%= lastName %>, with a total revenue of $<%= total %>!</strong></p>
						<%
							}
						} catch (Exception e) {
							out.print(e);
						}
						
						%>
					</div>
					
					
					<button type="button" onclick="showTop5()">Top 5 Most Active Transit Lines</button>
					<div class="results" id="top-5" style="display:none;"><ol>
						<%
						try {
							//Create a SQL statement.
							PreparedStatement ps = con.prepareStatement("select b.line_name, count(r.r_number) as reservation_count from books b join reservations r on b.r_number = r.r_number group by b.line_name order by reservation_count desc limit 5;");
							
							//Run the query against the database.
							ResultSet result = ps.executeQuery();
							
							while(result.next()){
								String lineName = result.getString("line_name");
								String reservationCount = result.getString("reservation_count");
						%>
								<li style="color:navy blue;"><%= lineName %>: <%= reservationCount %> reservations</li>
						<%
							}
									
							//Close the connection.
							db.closeConnection(con);
						} catch (Exception e) {
							out.print(e);
						}
						
						%>
					</ol></div>
				</div>
			</div>
		</div>

<!-- ---------------------------------------------------------------Script--------------------------------------------------------------- -->

		<script type="text/javascript">
			function submitForm(buttonID, formID, actionURL) {
				//Check for empty selections
				if(formID === "line-functions"){
					var transitLine = document.getElementById("transit_lines").value;
					if(!transitLine){
						alert("Select a transit line.");
						return false;
					}
				}
				if(formID === "customer-functions"){
					var customer = document.getElementById("customers").value;
					if(!customer){
						alert("Select a customer.");
						return false;
					}
					//document.write("MAMA: "+document.getElementById("customer-action").value);
				}
				if(formID === "modify-rep"){
					var rep = document.getElementById("representative-name").value;
					if(!rep){
						alert("Select a customer representative.");
						return false;
					}
				}
				
				//Redirecting based on button type
				//document.write("ok");
				/* if(buttonID === "customer-reservation-button"){
					//document.write("worked");
					document.getElementById("customer-action").setAttribute('value', 'View Customer Reservations');
					//document.write("LALA: "+document.getElementById("customer-action").value);
				}
				else if(buttonID === "line-reservation-button"){
					document.getElementById("customer-action").value = "View Line Reservations";
				}
				else{
					document.getElementById("customer-action").value = "View Revenue";
				} */
					
				var form = document.getElementById(formID);
				form.action = actionURL;
				form.submit();
				
				return true;
			}
			
			function showBestCustomer(){
				document.getElementById("best-customer").style.display = "";
			}
			
			function showTop5(){
				document.getElementById("top-5").style.display = "";
			}
		</script>
	</body>
</html>