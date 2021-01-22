<!DOCTYPE html>
<html>
<head>
<title>Create new customer</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>
<div>

<h1>Creating new customer</h1>

<%
//Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage2").toString()+"</p>");
%>
<br>
<form name="MyForm" method=post action="validateNewCustomer.jsp">
<table>
<tr>
	<td><div>First Name</div></td>
	<td><input class="in_table" type="text" name="firstName"></td>
</tr>
<tr>
	<td><div>Last Name</div></td>
	<td><input class="in_table" type="text" name="lastName"></td>
</tr>
<tr>
	<td><div>Email</div></td>
	<td><input class="in_table" type="text" name="email"></td>
</tr>
<tr>
	<td><div>Phone</div></td>
	<td><input class="in_table" type="text" name="phone"></td>
</tr>
<tr>
	<td><div>Address</div></td>
	<td><input class="in_table" type="text" name="address"></td>
</tr>
<tr>
	<td><div>City</div></td>
	<td><input class="in_table" type="text" name="city"></td>
</tr>
<tr>
	<td><div>State</div></td>
	<td><input class="in_table" type="text" name="state"></td>
</tr>
<tr>
	<td><div>Postal Code</div></td>
	<td><input class="in_table" type="text" name="postalCode"></td>
</tr>
<tr>
	<td><div>Country</div></td>
	<td><input class="in_table" type="text" name="country"></td>
</tr>
<tr>
	<td><div>User ID</div></td>
	<td><input class="in_table" type="text" name="userId" size=10 maxlength="10"></td>
</tr>
<tr>
	<td><div>Password</div></td>
	<td><input class="in_table" type="password" name="password" size=10 maxlength="10"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Create">
</form>

</div>
<%
// TODO: Display user name that is logged in (or nothing if not logged in)
session = request.getSession(true);
if(session.getAttribute("loginMessage") != null) {
    out.println("<h3 align=\"center\"> "+session.getAttribute("loginMessage").toString()+". Please logout first.</h3>");
}	
%>
<%
%>

</body>
</html>

