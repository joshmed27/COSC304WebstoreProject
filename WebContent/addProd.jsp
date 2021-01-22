<%@ page import="java.sql.*,java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
<title>Add New Product</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>
<div>

<h1>Add a New Product</h1>

<br>
<form name="MyForm" method=post action="addProd.jsp">
<table>
<tr>
	<td><div>Product Name</div></td>
	<td><input class="in_table" type="text" name="name"></td>
</tr>
<tr>
	<td><div>Product Price</div></td>
	<td><input class="in_table" type="text" name="price"></td>
</tr>
<tr>
	<td><div>Product Description</div></td>
	<td><input class="in_table" type="text" name="desc"></td>
</tr>
<tr>
	<td><div>Category ID</div></td>
	<td><input class="in_table" type="text" name="cid"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Add Product">
</form>
</div>

<%
String id, name, price, imageURL, image, desc, cid; 
if(request.getParameterMap().containsKey("name"))
	name = request.getParameter("name");
else name = "";
if(request.getParameterMap().containsKey("price"))
	price = request.getParameter("price");
else price = "";
if(request.getParameterMap().containsKey("desc"))
	desc = request.getParameter("desc");
else desc = "";
if(request.getParameterMap().containsKey("cid"))
	cid = request.getParameter("cid");
else cid = "";

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
if(name!="" && price!="" && desc!="" && cid!="") {
	String sql = "INSERT INTO product(productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
	try (Connection con = DriverManager.getConnection(url, uid, pw);) {		
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setString(2, price);
		pstmt.setString(3, desc);
		pstmt.setString(4, cid);
		pstmt.executeUpdate();
		out.println("Added product to database successfully!");
	}
	catch (SQLException ex) { 	
		out.println("Error! Try again."); 
	}
	// Close connection (done by try with resourses)
}
else {
	out.println("<p>Try adding a product</p>");
}

%>

</body>
</html>