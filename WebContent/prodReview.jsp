<!DOCTYPE html>
<html>
<head>
<title>Not Not Steam - Product Review</title>
<link rel="stylesheet" href="css/styles.css">
</head>
<body>

<%@ include file="header.jsp" %>
<div>

<h1>Add a New Review To a Product</h1>

<br>
<form name="Review" method=post action="validateReview.jsp" id="reviewForm">
<table>
<tr>
	<td><div>Review Rating</div></td>
    <td>
        <input class="in_table" type="radio" id="5star" name="rating" value="45tar">
        <label for="5star">&#9733&#9733&#9733&#9733&#9733</label><br>
        <input class="in_table" type="radio" id="4star" name="rating" value="4star">
        <label for="4star">&#9733&#9733&#9733&#9733</label><br>
        <input class="in_table" type="radio" id="3star" name="rating" value="3star">
        <label for="3star">&#9733&#9733&#9733</label><br>
        <input class="in_table" type="radio" id="2star" name="rating" value="2star">
        <label for="2star">&#9733&#9733</label><br>
        <input class="in_table" type="radio" id="1star" name="rating" value="1star">
        <label for="1star">&#9733</label><br>
    </td>
</tr>
<tr>
	<td><div>Review</div></td>
	<td><textarea name="review" form="reviewForm" rows = "4" cols = "50"></textarea></td>
</table>
<input type="submit" name="productId" value="Enter Review">
<input class="submit" type="submit" name="submitReview" value="Enter Review">
</form>
</br>
</div>

</body>
</html>