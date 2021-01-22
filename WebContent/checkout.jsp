<html>
<head>
<title>Not Not Steam Checkout</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>
<h1>Enter your customer and payment information to complete the transaction:</h1>

<form method="get" action="order.jsp">
<table>
<tr><td>Customer ID:</td><td><input type="text" name="customerId" size="20"></td></tr>
<tr><td>Password:</td><td><input type="password" name="password" size="20"></td></tr>
<tr><td>Address:</td><td><input type="text" name="address" size="20"></td></tr>
<tr><td>City:</td><td><input type="text" name="city" size="20"></td></tr>
<tr><td>State:</td><td><input type="text" name="state" size="20"></td></tr>
<tr><td>Postal Code:</td><td><input type="text" name="postalCode" size="20"></td></tr>
<tr><td>Country:</td><td><input type="text" name="country" size="20"></td></tr>


<tr><td>Payment Type:</td><td><input type="text" name="paymentType" size="20"></td></tr>
<tr><td>Payment Number:</td><td><input type="text" name="paymentNumber" size="20"></td></tr>
<tr><td>Payment Expiry Date:</td><td><input type="date" name="paymentExpiryDate" size="20"></td></tr>
<tr><td><input type="submit" value="Submit"></td><td><input type="reset" value="Reset"></td></tr>
</table>
</form>

</body>
</html>

