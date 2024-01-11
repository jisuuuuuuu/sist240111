<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%!
		int i = 0;
	
	%>
	<%
		request.setCharacterEncoding("UTF-8");
	
		String msg1 = request.getParameter("msg");
		int num = Integer.parseInt(request.getParameter("number"));
		while(i < num)
		{
	%>
			<b><%=msg1 %></b><p/>
	<%
			i++;
		}
	%>
</body>
</html>