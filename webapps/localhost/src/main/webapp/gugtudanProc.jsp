<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	int dan = Integer.parseInt(request.getParameter("dan"));
	int i;
%>
<h1>구구단 : <%=dan %>단</h1>
<%
	for(i=1; i<=9; i++)
	{
%>	
		<%=dan + " * " + i + " = " + dan*i %><br />
<%
	}
%>
</body>
</html>