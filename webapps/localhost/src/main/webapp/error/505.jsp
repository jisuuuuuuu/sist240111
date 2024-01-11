<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String message = exception.getMessage();
	String oMessage = exception.toString();
%>
<h1>error message</h1>
에러 메세지 : <b><%=message %></b><br />
에러 클레스명과 에러 메세지 : <b><%=oMessage %></b>
</body>
</html>