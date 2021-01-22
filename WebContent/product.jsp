<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html lang = "en">
<head>
<title>Not Not Steam - Product Information</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");
int productId = 0;
if(request.getParameterMap().containsKey("id")) {
    String prodId = request.getParameter("id");
    productId = Integer.parseInt(prodId);
}
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Make the connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
String sql = "SELECT productName, productPrice, productImageURL, productImage, productDesc FROM product WHERE productId = ?";

try (Connection con = DriverManager.getConnection(url, uid, pw);) {		
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, productId);	
    ResultSet rst = pstmt.executeQuery();
	// Print out the ResultSet
    if(rst.next()) {
        out.println("<h2>" + rst.getString(1) + "</h2>");
        // TODO: If there is a productImageURL, display using IMG tag
        if(rst.getString(3) != null) {
            String urlImage = String.format("\"%s\"", rst.getString(3));
            out.println("<img src = "+urlImage+"/>");
        }
        // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
        if(rst.getBinaryStream(4) != null) {
            String urlImg = "displayImage.jsp?id=" + productId;
            out.println("<img src = "+urlImg+" />");
        }
        out.println("<div style='color: white;'><h3> Game Description: \n" + rst.getString(5) + "<h3><div>");
        out.println("<br><p>Product ID: " + productId + "</p><p>Price: " + String.format("$%.2f", rst.getDouble(2)) + "</p>");
        
        //REVIEWS FEATURE
        String urlReview = String.format("\"prodReview.jsp?id=%s\"", productId);
        out.println("<div><button><a href = " + urlReview + ">Add a Review</a></button></div>");

        // TODO: Add links to Add to Cart and Continue Shopping
        String urlAdd = String.format("\"addcart.jsp?id=%s&name=%s&price=%.2f\"", productId, rst.getString(1), rst.getDouble(2));
        out.println("<div><button><a href = "+urlAdd+">Add to Cart</a></button></div>");
        out.println("<div><button><a href='listprod.jsp'>Continue Shopping</a></button></div>");
        
    }
}
catch (SQLException ex) { 	
	out.println(ex); 
}
// Close connection (done by try with resourses)
%>

</body>
</html>

