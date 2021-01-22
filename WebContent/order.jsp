<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang = "en">
<head>
<title>Not Not Steam Order Processing</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>
<h1>Your order summary</h1>
<% 
// Get customer id
String customId = "", password = "", address = "", city = "", state = "", postalCode = "",country = "", paymentType = "", paymentNumber="", paymentExpiryDate="s";
if(request.getParameterMap().containsKey("customerId"))
	customId = request.getParameter("customerId");
if(request.getParameterMap().containsKey("password"))
	password = request.getParameter("password");
if(request.getParameterMap().containsKey("address"))
	address = request.getParameter("address");
if(request.getParameterMap().containsKey("city"))
	city = request.getParameter("city");
if(request.getParameterMap().containsKey("state"))
	state = request.getParameter("state");
if(request.getParameterMap().containsKey("postalCode"))
	postalCode = request.getParameter("postalCode");
if(request.getParameterMap().containsKey("country"))
	country = request.getParameter("country");
if(request.getParameterMap().containsKey("paymentType"))
	paymentType = request.getParameter("paymentType");
if(request.getParameterMap().containsKey("paymentNumber"))
	paymentNumber = request.getParameter("paymentNumber");
if(request.getParameterMap().containsKey("paymentExpiryDate"))
	paymentExpiryDate = request.getParameter("paymentExpiryDate");
int custId = 0;
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}
// Make connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

try (Connection con = DriverManager.getConnection(url, uid, pw);) 
{		
	PreparedStatement pstmt = con.prepareStatement("SELECT MAX(customerId) FROM customer");
	ResultSet rst = pstmt.executeQuery();
	rst.next();
	boolean isNum = true;
	try {
		custId = Integer.parseInt(customId);
	} catch(Exception e) {
		isNum = false;
		out.println("<p>Invalid customer ID. <p>Please return to the previous page and try again.</p></p>");
	}
	if(isNum && custId != 0 && !(rst.getInt(1) >= custId)) {
		out.println("<p>Invalid customer ID. <p>Please return to the previous page and try again.</p></p>");
	}
	else if(isNum && productList == null || productList.isEmpty()) {
		out.println("<p>Shopping cart is empty. <p>Please return to the main page and add items to the cart before checkout.</p></p>");
	}	
	else if(isNum) {
		custId= Integer.parseInt(customId);
		//Password and shipping validation
		String sqlPass = "SELECT customerId FROM customer WHERE customerId = ? AND password = ? AND address = ? AND city = ? AND state = ? AND postalCode = ? AND country = ?";
		PreparedStatement pstmtPass = con.prepareStatement(sqlPass);			
		pstmtPass.setInt(1, custId);
		pstmtPass.setString(2, password);
		pstmtPass.setString(3, address);
		pstmtPass.setString(4, city);
		pstmtPass.setString(5, state);
		pstmtPass.setString(6, postalCode);
		pstmtPass.setString(7, country);
		ResultSet rstPass = pstmtPass.executeQuery();
		if(!rstPass.next()){
			out.println("<p>Your customer information is incorrect <p>Please go to the previous page and try again.</p></p>");
		}
		else {
			custId= Integer.parseInt(customId);
			String sql = "INSERT INTO ordersummary (customerId, orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement pstmt2 = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
			pstmt2.setInt(1, custId);
			Calendar cal = Calendar.getInstance(); 
			pstmt2.setTimestamp(2, new java.sql.Timestamp(cal.getTimeInMillis()));
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			double total = 0;
			while (iterator.hasNext()) { 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
				total += (pr * qty);
			}
			// Update total amount for order record
			pstmt2.setString(3, String.format("%.2f", total));
			// Update shipping information for order record
			pstmt2.setString(4, address);
			pstmt2.setString(5, city);
			pstmt2.setString(6, state);
			pstmt2.setString(7, postalCode);
			pstmt2.setString(8, country);
			// Save order information to database
			pstmt2.executeUpdate();
			ResultSet keys = pstmt2.getGeneratedKeys();
			keys.next();
			int orderId = keys.getInt(1);
			
			// Insert each item into OrderProduct table using OrderId from previous INSERT

			String sqlop = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
			PreparedStatement pstmt3 = con.prepareStatement(sqlop);			
			iterator = productList.entrySet().iterator();
			out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
			while (iterator.hasNext()) { 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String prodId = (String) product.get(0);
				int productId = Integer.parseInt(prodId);
				String name = (String) product.get(1);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
				pstmt3.setInt(1, orderId);
				pstmt3.setInt(2, productId);
				pstmt3.setInt(3, qty);
				pstmt3.setString(4, String.format("%.2f", pr));
				// Save order information to database
				pstmt3.executeUpdate();
				// Print out order summary
				out.println("<tr><td>"+productId+"</td><td>"+name+
					"</td><td>"+qty+"</td><td>"+String.format("$%.2f", pr)+
					"</td><td>"+String.format("$%.2f", (pr * qty))+"</td></tr>");
			}

			// Insert payment method information

			String sqlpm = "INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES (?, ?, ?, ?)";
			PreparedStatement pstmt4 = con.prepareStatement(sqlpm);		
			pstmt4.setString(1, paymentType);	
			pstmt4.setString(2, paymentNumber);  

			//Timestamp expiryDate = Timestamp.valueOf(paymentExpiryDate);	
			
    		java.sql.Date date=java.sql.Date.valueOf(paymentExpiryDate);
			pstmt4.setDate(3, date);
			pstmt4.setInt(4, custId);


			pstmt4.executeUpdate();

			// Update total amount for order record
			out.println("<tr><td colspan = '4' class = 'tdright'>Order Total</td><td>"+
				String.format("$%.2f", total)+"</td></tr></table>");

			out.println("<table><tr><td>Payment Type</td><td>"+paymentType+"</td></tr>");
			out.println("<tr><td>Payment Number</td><td>"+paymentNumber+"</td></tr>");
			out.println("<tr><td>Payment Expiry Date</td><td>"+paymentExpiryDate+"</td></tr></table>");

			
		
			// Clear cart if order placed successfully
			session.setAttribute("productList", new HashMap<String, ArrayList<Object>>());
			
			out.println("<p class = 'just-below'>Order completed and will be shipped soon.</p>");
			out.println("<p>Your order reference number is " + orderId + ".</p>");
			PreparedStatement pstmt5 = con.prepareStatement("SELECT firstName, lastName FROM customer WHERE customerId = ?");
			pstmt5.setInt(1, custId);
			ResultSet rst5 = pstmt5.executeQuery();
			rst5.next();
			out.println("<p>Shipping to Customer Number: " + custId + "; Name: " + rst5.getString(1) + " " + rst5.getString(2) + "</p>");
		}
	}
}
catch (SQLException e) { 	
	out.println(e);
}
// Close connection (done by try with resourses)

%>

<div><button><a href="listprod.jsp">Continue Shopping</a></button></div>
</BODY>
</HTML>
