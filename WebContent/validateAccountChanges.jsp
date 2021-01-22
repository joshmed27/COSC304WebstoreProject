<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	try
	{
		authenticatedUser = validateAccountChanges(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("customer.jsp");		// Successful login
	else
		response.sendRedirect("account.jsp");		// Failed change - redirect back to login page with a message 
%>


<%!
	String validateAccountChanges(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = 	request.getParameter("email");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String city = request.getParameter("city");
		String state = request.getParameter("state");
		String postalCode = request.getParameter("postalCode");
		String country = request.getParameter("country");
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");
		String resStr = null;
		try 
			{	
				String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
				String uid = "SA";
				String pw = "YourStrong@Passw0rd";	
				Connection con = DriverManager.getConnection(url, uid, pw);
				Statement stmt = con.createStatement();
				
				//con.setAutoCommit(false);
				String sql = "SELECT * FROM customer WHERE userid = userId";
				PreparedStatement pstmt = con.prepareStatement(sql);
				ResultSet rst = pstmt.executeQuery();
				ResultSet rst = stmt.executeQuery(sql);
				sql = "Insert " + " " + firstName+ " " + lastName+  " " + email+  " " + phone +
				  " " + address +  " " + state +  " " + postalCode +  " " + country +  " " + 
				  userId + " " + password + "into customer";
				rst = stmt.executeQuery(sql);
				rst = stmt.executeQuery("Select count(*) from customer");
				int rowAfter = rst.getInt(1);
				
		if(firstName == null || firstName.length() == 0)
		{	
			firstName = rst.getString(2);	
		}	
		if(lastName == null || lastName.length() == 0)
		{
			lastName = rst.getString(3);	
		}
		if(email == null || email.length() == 0)
		{
			email = rst.getString(4);	;
		}
		if(phone == null || phone.length() == 0)
		{
			phone = rst.getString(5);	
		}
		if(city == null || city.length() == 0)
		{
			city = rst.getString(7);	
		}
		if(state == null || state.length() == 0)
		{
			state = rst.getString(8);	
		}
		if(postalCode == null || postalCode.length() == 0)
		{
			city = rst.getString(9);	
		}
		if(country == null || country.length() == 0)
		{
			city = rst.getString(10);	
		}
		if(userId == null || userId.length() == 0)
		{
			city = rst.getString(11);	
		}
		if(password == null || password.length() == 0)
		{
			city = rst.getString(12);	
		}

		sql = "Select count(*) from customer";
		rst = stmt.executeQuery(sql);
			sql = "Insert " + " " + firstName+ " " + lastName+  " " + email+  " " + phone +
				  " " + address +  " " + state +  " " + postalCode +  " " + country +  " " + 
				  userId + " " + password + "into customer";
			rst = stmt.executeQuery(sql);
				
			} 
			catch (SQLException ex) {
				out.println(ex);
			}
			finally
			{
				closeConnection();
			} 		

		return firstName;
	} 
%>
