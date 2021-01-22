<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;
		
		if(username == null || (username.length() == 0)){

				session.setAttribute("loginMessage"," Vaild user name needed "  +username );
				return null;
		}
		if( password == null || (password.length() == 0)){
				session.setAttribute("loginMessage","Password empty"  +username );
				return null;
		}

		if(session.getAttribute("authenticatedUser") != null){
			session.setAttribute("loginMessage","Already logged in as"  +username );
			return null;
		}
		
		

		

		try 
		{	
			String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";	
			Connection con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();
			
			//con.setAutoCommit(false);
			
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String sql = "Select firstName, lastName, userId, password from customer";
			ResultSet rst = stmt.executeQuery(sql);
			while(rst.next())
			{
				if (rst.getString(3).equalsIgnoreCase(username) && rst.getString(4).equals(password)){
					retStr = rst.getString(3);
				}
				
			}

						
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>
