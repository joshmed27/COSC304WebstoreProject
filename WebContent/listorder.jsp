<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang = "en">
<head>
<title>Not Not Steam Order List</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>
<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try {	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e) {
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try ( Connection con = DriverManager.getConnection(url, uid, pw);
      Statement stmt = con.createStatement();) 
{		
	// Write query to retrieve all order summary records
	ResultSet rst = stmt.executeQuery("SELECT orderId, orderDate, OS.customerId, firstName, lastName, totalAmount FROM ordersummary AS OS JOIN customer AS C ON OS.customerId = C.customerId");	
	
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	PreparedStatement pstmt = con.prepareStatement("SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?");
	
	// Print out the order summary information
	out.println("<table class = 'orders'><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
	while(rst.next()) {	// For each order in the ResultSet
		out.println("<tr><td>"+rst.getInt(1)+"</td><td>"+rst.getString(2)+
			"</td><td>"+rst.getInt(3)+"</td><td>"+rst.getString(4)+" "+
			rst.getString(5)+"</td><td>"+String.format("$%.2f", rst.getDouble(6))+
			"</td></tr><tr><td colspan = '5'>");
		
		pstmt.setInt(1, rst.getInt(1));
		ResultSet rst2 = pstmt.executeQuery();
		out.println("<table class = 'products'><tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
		while(rst2.next()) {	// For each product in the order
			// Write out product information 
			out.println("<tr><td>"+rst2.getInt(1)+"</td><td>"+rst2.getInt(2)+
				"</td><td>"+String.format("$%.2f", rst2.getDouble(3))+"</td></tr>");
		}
		out.println("</table></td></tr>");
	}
	out.println("</table>");
}
catch (SQLException ex) { 	
	out.println("No orders exits!"); 
}
// Close connection (done by try with resourses)
%>

</body>
</html>
