<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%@include file="index0110_T.jsp" %>
<h1>중앙에 사용합니다.</h1>
<%
	int i = 1;
	while(true)
	{
		out.println(i + "번째 줄입니다.<br />");
		i++;
		
		if(i > 5)
			break;
	}
%>
<%@include file="index0110_B.jsp" %>
</body>
</html>