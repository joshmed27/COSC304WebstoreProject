<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Not Not Steam Shipment Processing</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
// TODO: Get order id
String ordId = "";
if(request.getParameterMap().containsKey("orderId")) {
	ordId = request.getParameter("orderId");
}
int orderId = 0;

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

try (Connection con = DriverManager.getConnection(url, uid, pw);) {		
	// TODO: Check if valid order id
	PreparedStatement pstmt = con.prepareStatement("SELECT MAX(OS.orderId) FROM ordersummary OS JOIN orderproduct OP ON OS.orderId = OP.orderId");
	ResultSet rst = pstmt.executeQuery();
	if(rst.next()) {
		boolean isNum = true;
		try {
			orderId = Integer.parseInt(ordId);
		} catch(Exception e) {
			isNum = false;
			out.println("<p>Invalid order ID. <p>Please return to the previous page and try again.</p></p>");
		}
		if(isNum && orderId != 0 && !(rst.getInt(1) >= orderId)) {
			out.println("<p>Invalid order ID. <p>Please return to the previous page and try again.</p></p>");
		}
		else {
			// TODO: Start a transaction (turn-off auto-commit)
			con.setAutoCommit(false);

			// TODO: Retrieve all items in order with given id
			PreparedStatement pstmt2 = con.prepareStatement("SELECT productId, quantity FROM ordersummary OS JOIN orderproduct OP ON OS.orderId = OP.orderId WHERE OS.orderId = ?");
			pstmt2.setInt(1, orderId);
			ResultSet rst2 = pstmt2.executeQuery();
			con.commit();
			int count = 0, currInven = -1;
			boolean success = true;
			while(rst2.next()) {
				count++;
				// TODO: For each item verify sufficient quantity available in warehouse 1.
				PreparedStatement pstmt3 = con.prepareStatement("SELECT quantity FROM productinventory WHERE warehouseId = 1 AND productId = ?");
				pstmt3.setInt(1, rst2.getInt(1));
				ResultSet rst3 = pstmt3.executeQuery();
				rst3.next();
				currInven = rst3.getInt(1);
				// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
				if(currInven >= rst2.getInt(2)) {
					PreparedStatement pstmt4 = con.prepareStatement("UPDATE productinventory SET quantity = ? WHERE productId = ?");
					pstmt4.setInt(1, (currInven - rst2.getInt(2)));
					pstmt4.setInt(2, rst2.getInt(1));
					pstmt4.executeUpdate();
					con.commit();
					out.println("<p>Ordered product: "+rst2.getInt(1)+", Oty: "+rst2.getInt(2)+", Previous inventory: "+currInven+", New inventory: "+(currInven - rst2.getInt(2))+"</p>");
				}
				else {
					out.println("<p>Insufficient inventory for product ID: " + rst2.getInt(1) + "</p>");
					success = false;
					con.rollback();
				}
			}
			// TODO: Create a new shipment record.
			if(success) {
				PreparedStatement pstmt5 = con.prepareStatement("INSERT INTO shipment (shipmentDate, warehouseId) VALUES (?, 1)");
				pstmt5.setDate(1, java.sql.Date.valueOf(java.time.LocalDate.now()));
				pstmt5.executeUpdate();
				con.commit();
			}
			else {
				out.println("<p>Shipment not done.</p>");
			}
		}
	}
	// TODO: Auto-commit should be turned back on
	con.commit();
	con.setAutoCommit(true);
}
catch (SQLException ex) { 	
	out.println(ex); 
}
// Close connection (done by try with resourses)
%>

<div><button><a href='shop.html'>Back to Main Page</a></button></div>

</body>
</html>
