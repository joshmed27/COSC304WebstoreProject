<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>


<%@ include file="header.jsp" %>
<div>
<h1>Please Login to System</h1>

<br>
<form name="MyForm" method=post action="validateLogin.jsp">
<table>
<tr>
	<td><div>Username:</div></td>
	<td><input class="in_table" type="text" name="username"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div>Password:</div></td>
	<td><input class="in_table" type="password" name="password" size=10 maxlength="10"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Log In">
</form>

</div>

<%
// TODO: Display user name that is logged in (or nothing if not logged in)
session = request.getSession(true);
if(session.getAttribute("authenticatedUser") != null) {
    out.println("<h3 align=\"center\"> "+"Already logged in as "+session.getAttribute("authenticatedUser").toString()+". Please logout first.</h3>");
}	
%>

</body>
</html>

