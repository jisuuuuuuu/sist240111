<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>단을 입력하시오.</h1>
<form name="form" method="post" action="gugtudanProc.jsp">
	<input type="number" name="dan" min="2" max="9">
	<input type="submit" value="보내기">
</form>
</body>
</html>