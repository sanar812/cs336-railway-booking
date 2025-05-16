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
		<title>Forum Page</title>
		<link rel="stylesheet" href="forum.css">
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
		
		<div class="wrapper"><div class="container">
			<div class="header">
				<h1>Online Railway Booking System</h1>
				<h2>Q&A Forum</h2>
			</div>

			<!-- Q&A Section for Browsing Questions -->
			<div class="qa-section">
				<h2>Browse Customer Questions</h2>
				<%
				ApplicationDB db = new ApplicationDB();
				Connection con = db.getConnection();
				
				try {
	            	PreparedStatement ps = con.prepareStatement("select distinct question from forum;");
            		ResultSet result = ps.executeQuery();
            		
      			%>
   				<form method="post" action="display_answers.jsp">
					<select id="questionId" name="questionId">
						<option value="" disabled selected style="color:gray;">-- Select a Question --</option>
			        	<%
			        		//Loop through the result set and create <option> tags for each city
			        		while(result.next()){
			        			String question = result.getString("question");
		           		%>
		           				<option onkeyup="displayAnswers()" value="<%= question %>"><%= question %></option>
	         			<%
		           			}
				} catch (Exception e) {out.print(e);}
				%>
					</select>
					
					<button type="submit">Search</button>
					
					<div class="results">
						<% 
					        String answer = (String) request.getAttribute("reply");
					        if (answer != null) { 
					    %>
					        <p><strong><%= answer %></strong></p>
					    <% 
					        } 
					    %>
					</div>
				</form>
			</div>
			
			<!-- Search Bar for Questions -->
			<div class="search-section">
				<h2>Search Customer Questions</h2>
				<input type="text" id="searchInput" placeholder="Search questions..." onkeyup="searchQuestions()">
				<div id="qa-list">
					<!-- Dynamic question list will be filtered here -->
				</div>
			</div>
			
			<!-- Customer Question Submission -->
			<div class="submit-question">
				<h2>Send a Question to Customer Service</h2>
				<form action="submit_question.jsp" method="post">
					<textarea name="question" placeholder="Enter your question..." rows="4" required></textarea>
					<br>
					<input type="submit" value="Send Question">
				</form>
				
				<br><br>
				
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
			
			<!-- FAQ Accordion -->
			<div class="faq-section">
				<h2>Frequently Asked Questions</h2>
				<div class="accordion">
					<button class="accordion-item">Q: Where do I submit my payment?</button>
					<div class="panel">
						<p>A: Our website does not currently support online payments. All payments are to be made in-person on the day of your trip. If you reserved with a discount, proof of status is required.</p>
					</div>
					
					<button class="accordion-item">Q: How can I change my reservation?</button>
					<div class="panel">
						<p>A: You can change your reservation via our website or contact customer support.</p>
					</div>
				</div>
			</div>
		</div></div>
			
		<script>
			// Function to toggle FAQ accordion
			var acc = document.getElementsByClassName("accordion-item");
			for (var i = 0; i < acc.length; i++) {
				acc[i].addEventListener("click", function() {
					this.classList.toggle("active");
					var panel = this.nextElementSibling;
					if (panel.style.display === "block"){
						panel.style.display = "none";
					}
					else{
						panel.style.display = "block";
					}
				});
			}
			
			function searchQuestions() {
				var input, filter, qaList, questions, i, questionText;
				input = document.getElementById("searchInput");
				filter = input.value.toUpperCase();
				qaList = document.getElementById("qa-list");
				questions = qaList.getElementsByClassName("question");
				
				for (i = 0; i < questions.length; i++) {
					questionText = questions[i].textContent || questions[i].innerText;
					if (questionText.toUpperCase().indexOf(filter) > -1) {
						questions[i].style.display = "";
					}
					else {
						questions[i].style.display = "none";
					}
				}
			}
			
			function searchAnswer() {
				document.getElementById("results").style.display = "";
				return;
			}
			
			function displayAnswers() {
				var questionId = document.getElementById("questionId").value;
				var resultsDiv = document.getElementById("results");
				resultsDiv.style.display = "block";
				// You need to reload the page with the selected question
				location.search = "?questionId=" + questionId;
			}
		</script>
	</body>
</html>



