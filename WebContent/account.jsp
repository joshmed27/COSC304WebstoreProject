<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>
<h1>Customer Information<nav class="navigation">
	<a href="account.jsp">Account Changes</a>
</nav></h1>
<form name="MyForm" method=post action="validateAccountChanges.jsp"></form>
<table>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try (Connection con = DriverManager.getConnection(url, uid, pw);) {	

// TODO: Print Customer information
String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid FROM customer WHERE userid = '"+userName+"'";
PreparedStatement pstmt = con.prepareStatement(sql);
ResultSet rst = pstmt.executeQuery();


rst.next();

out.println("<tr><th>User ID</th><td>"+ rst.getString(11)+"</td><td><input class='in_table' type='text' name='userId'></td></tr>");
out.println("<tr><th>First Name</th><td>"+ rst.getString(2)+"</td><td><input class='in_table' type='text' name='firstName'></td></tr></tr>");
out.println("<tr><th>Last Name</th><td>"+ rst.getString(3)+"</td><td><input class='in_table' type='text' name='lastName'></td></tr></tr>");
out.println("<tr><th>Email</th><td>"+ rst.getString(4)+"</td><td><input class='in_table' type='text' name='email'></td></tr>");
out.println("<tr><th>Phone</th><td>"+ rst.getString(5)+"</td><td><input class='in_table' type='text' name='phone'></td></tr>");
out.println("<tr><th>Address</th><td>"+ rst.getString(6)+"</td><td><input class='in_table' type='text' name='address'></td></tr>");
out.println("<tr><th>City</th><td>"+ rst.getString(7)+"</td><td><input class='in_table' type='text' name='city'></td></tr>");
out.println("<tr><th>State</th><td>"+ rst.getString(8)+"</td><td><input class='in_table' type='text' name='ctate'></td></tr>");
out.println("<tr><th>Postal Code</th><td>"+ rst.getString(9)+"</td><td><input class='in_table' type='text' name='postalCode'></td></tr>");
out.println("<tr><th>Country</th><td>"+ rst.getString(10)+"</td><td><input class='in_table' type='text' name='country'></td></tr>");
out.println("<tr><th>Password</th><td>*****</td><td><input type='password' class='in_table' name='password'></td></tr>");

}
catch (Exception e)
{
    out.print(e);
} 
// Make sure to close connection (done by try with resources)
%>
</table>
<br>
<div><input type="submit" name="Submit2" value="Change info"></div>
</form>
</body>
</html>
