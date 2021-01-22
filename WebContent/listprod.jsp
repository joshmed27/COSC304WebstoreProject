<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang = "en">
<head>
<title>Not Not Steam</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>
<h1>Search for products</h1>

<div class="form-content">
<form method="get" action="listprod.jsp">
<select class="categoryName" name="categoryName">
	<option value="All" selected>All</option>
	<option value="Action">Action</option>
	<option value="RPG">RPG</option>
	<option value="Indie">Indie</option>
	<option value="Sports">Sports</option>
	<option value="Simulation">Simulation</option>
	<option value="MMO">MMO</option>
	<option value="Strategy">Strategy</option>
	<option value="Racing">Racing</option>
</select>
<input type="text" name="productName" size="50" placeholder="Search...">
<p>(Leave blank for all products)</p>
<input type="submit" value="Submit"><input type="reset" value="Reset"> 
</form>
</div>

<%
String name;
String cat;
// Get product name to search for
if(request.getParameterMap().containsKey("productName"))
	name = request.getParameter("productName");
else name = "";
if(request.getParameterMap().containsKey("categoryName")) {
	cat = request.getParameter("categoryName");
	if(cat.equals("All"))
		cat = "";
}
else cat = "";

//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
String sql = "";

if(name == "" && cat == "") {
	sql = "SELECT P.productId, productName, productPrice FROM product AS P LEFT JOIN orderproduct AS OP ON P.productId=OP.productId LEFT JOIN ordersummary AS OS ON OP.orderId=OS.orderId GROUP BY P.productId, productName, productPrice ORDER BY COUNT(P.productId)";
}
else if(name == "" && cat != "") {
	sql = "SELECT productId, productName, productPrice FROM product P JOIN category C ON P.categoryId = C.categoryId AND categoryName = ?";
}
else if(name != "" && cat == "") {
	sql = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE ?";
}
else if(name != "" && cat != "") {
	sql = "SELECT productId, productName, productPrice FROM product P JOIN category C ON P.categoryId = C.categoryId WHERE productName LIKE ? AND categoryName = ?";
}

try (Connection con = DriverManager.getConnection(url, uid, pw);) 
{		
	PreparedStatement pstmt = con.prepareStatement(sql);
	
	if(name == "" && cat == "") {
		out.println("<h2>All Products</h2>");
	}
	else if(name == "" && cat != "") {
		pstmt.setString(1, cat);
		out.println("<h2>Products in category '"+cat+"'</h2>");
	}
	else if(name != "" && cat == "") {
		pstmt.setString(1, "%"+name+"%");
		out.println("<h2>Products containing '"+name+"'</h2>");
	}
	else if(name != "" && cat != "") {
		pstmt.setString(1, "%"+name+"%");
		pstmt.setString(2, cat);
		out.println("<h2>Products containing '"+name+"' in category '"+cat+"'</h2>");
	}
	
	ResultSet rst = pstmt.executeQuery();
	// Print out the ResultSet
	if(rst.next())
		out.println("<table><tr><th></th><th>Product Name</th><th>Price</th></tr>");
	do {	// For each order in the ResultSet
		// For each product create a link of the form
		// addcart.jsp?id=productId&name=productName&price=productPrice
		String urlAdd = String.format("\"addcart.jsp?id=%s&name=%s&price=%.2f\"", rst.getString(1), rst.getString(2), rst.getDouble(3));
		String urlProd = String.format("\"product.jsp?id=%s\"", rst.getString(1));
		out.println("<tr><td><a href = "+urlAdd+">Add to Cart</a></td><td><a href = "+urlProd+">"+rst.getString(2)+
			"</a></a></td><td>"+String.format("$%.2f", rst.getDouble(3))+"</td></tr>");
	} while(rst.next());
	out.println("</table>");
}
catch (SQLException ex) { 	
	out.println(ex); 
}
// Close connection (done by try with resourses)

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>
