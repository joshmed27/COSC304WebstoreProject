<h1><nav class="navigation">
	<div><img src = "img/home.png" width="400" height="200" alt="Not Not Steam Home"/></div>
	<a href="index.jsp">Home</a>
	<a href="listprod.jsp">Products</a>
	<a href="showcart.jsp">Cart</a>
</nav></h1>
<%
// TODO: Display user name that is logged in (or nothing if not logged in)
session = request.getSession(true);
if(session.getAttribute("authenticatedUser") != null){
	out.println("<h2> "+"Logged in is as "+session.getAttribute("authenticatedUser").toString()+"</h2>");
}
%>
<hr>
