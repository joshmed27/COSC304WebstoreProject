<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	try
	{
		authenticatedUser = validateNewCustomer(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("createCustomer.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateNewCustomer(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
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
		 
		if(firstName == null || firstName.length() == 0)
		{	
			session.setAttribute("loginMessage2","First name invaild");
			return null;		
		}	
		else if(lastName == null || lastName.length() == 0)
		{
			session.setAttribute("loginMessage2","Last name invaild");
			return null;
		}
		else if(email == null || email.length() == 0)
		{
			session.setAttribute("loginMessage2","Email invaild");
			return null;
		}
		else if(phone == null || phone.length() == 0)
		{
			session.setAttribute("loginMessage2","phone invaild");
			return null;
		}
		else if(city == null || city.length() == 0)
		{
			session.setAttribute("loginMessage2","city invaild");
			return null;
		}
		else if(state == null || state.length() == 0)
		{
			session.setAttribute("loginMessage2","state invaild");
			return null;
		}
		else if(postalCode == null || postalCode.length() == 0)
		{
			session.setAttribute("loginMessage2","postal code invaild");
			return null;
		}
		else if(country == null || country.length() == 0)
		{
			session.setAttribute("loginMessage2","country invaild");
			return null;
		}
		else if(userId == null || userId.length() == 0)
		{
			session.setAttribute("loginMessage2","userId invaild");
			return null;
		}
		else if(password == null || password.length() == 0)
		{
			session.setAttribute("loginMessage2","password invaild");
			return null;
		}
		
		else
			resStr = firstName;
	
		try 
			{	
				String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
				String uid = "SA";
				String pw = "YourStrong@Passw0rd";	
				Connection con = DriverManager.getConnection(url, uid, pw);
				Statement stmt = con.createStatement();
				
				//con.setAutoCommit(false);
				String sql = "Select count(*) from customer";
				ResultSet rst = stmt.executeQuery(sql);
				int row = rst.getInt(1);
				sql = "Insert " + " " + firstName+ " " + lastName+  " " + email+  " " + phone +
				  " " + address +  " " + state +  " " + postalCode +  " " + country +  " " + 
				  userId + " " + password + "into customer";
				rst = stmt.executeQuery(sql);
				rst = stmt.executeQuery("Select count(*) from customer");
				int rowAfter = rst.getInt(1);
				
				if (row == rowAfter){
					session.setAttribute("loginMessage","oops");
					return null;
				}
			} 
			catch (SQLException ex) {
				out.println(ex);
			}
			finally
			{
				closeConnection();
			}			

		if(resStr != null)
		{	
			session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",resStr);
		}


		return firstName;
	} 
%>
