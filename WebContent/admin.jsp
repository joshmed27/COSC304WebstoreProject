<%@ page language="java" import="java.io.*,java.sql.*"%>
<%// TODO: Include files auth.jsp and jdbc.jsp %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>
<br><nav class="navigation">
	<a href="addProd.jsp">Add a New Product</a>
</nav>
<%
if((session.getAttribute("authenticatedUser") != null) && (session.getAttribute("authenticatedUser").toString().equalsIgnoreCase("bobby"))) {
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
        PreparedStatement pstmt = con.prepareStatement("SELECT CAST(orderDate AS DATE), SUM(totalAmount) FROM ordersummary GROUP BY CAST(orderDate AS DATE)");
        ResultSet rst = pstmt.executeQuery();
        out.println("<h1>Administrator Sales Report by Day</h1><table><tr><th>Order Date</th><th>Total Order Amount</th></tr>");
        while(rst.next()) {
            out.println("<tr><td>"+rst.getDate(1)+"</td><td>"+String.format("$%.2f", rst.getDouble(2))+"</td></tr>");
        }
        out.println("</table>");
        PreparedStatement pstmt2 = con.prepareStatement("SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid FROM customer");
        ResultSet rst2 = pstmt2.executeQuery();

        out.println("<br><br><h1>Customer List</h1><table><tr><th>ID</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone</th><th>Address</th><th>City</th><th>State</th><th>Postal Code</th><th>Country</th><th>User ID</th>");
        while(rst2.next()) {
            out.println("<tr><td>"+ rst2.getInt(1)+"<td>"+ rst2.getString(2)+"</td><td>"+ rst2.getString(3)+"</td><td>"+ rst2.getString(4)+"</td><td>"+ rst2.getString(5)+"</td><td>"+ rst2.getString(6)+"</td><td>"+ rst2.getString(7)+"</td><td>"+ rst2.getString(8)+"</td><td>"+ rst2.getString(9)+"</td><td>"+ rst2.getString(10)+"</td><td>"+ rst2.getString(11)+"</td></tr>");
        }
        out.println("</table>");
    }
    catch(SQLException ex) {
        out.println(ex);
    }
}
else {
    out.println("<p>Please log in using admin credentials to access the administrator portal</p>");
}
%>

</body>
</html>
