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
	       	ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			PreparedStatement ps = null;
		
       		if(request.getParameter("question") != null){
		       	String question = request.getParameter("question");
		      	
		       	//Creating random question number
				Random random = new Random();
				int qid = 0;
				boolean isUnique = false;
				while(!isUnique){
					qid = random.nextInt(900) + 100;
					ps = con.prepareStatement("select count(*) as count from forum where qid = ?;");
					ps.setInt(1, qid);
					
					ResultSet results = ps.executeQuery();

					if(results.next() && results.getInt("count") == 0)
						isUnique = true;
				}
				//out.print(reservationNumber+"!!!");

		       	ps = con.prepareStatement("insert into forum(qid, question) values (?, ?)");
		       	ps.setInt(1, qid);
		       	ps.setString(2, question);
		       	ps.executeUpdate();
				
				request.setAttribute("successMessage", "Sent. We appreciate your patience.");
				request.getRequestDispatcher("forum_page.jsp").include(request, response);
       		}
       		else if(request.getParameter("reply") != null){
       			String reply = request.getParameter("reply");
				int qid = Integer.parseInt(request.getParameter("qid"));
				
       			ps = con.prepareStatement("update forum set answer = ? where qid = ?;");
		       	ps.setString(1, reply);
       			ps.setInt(2, qid);
		       	ps.executeUpdate();
       			
       			request.setAttribute("successMessage", "Reply posted.");
				request.getRequestDispatcher("customer-rep_access.jsp").include(request, response);				
       		}
		%>
	</body>
</html>