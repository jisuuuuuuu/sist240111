<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>request 사용예제</h1>
<%
	request.setCharacterEncoding("UTF-8");
	String name = request.getParameter("name");
	String num = request.getParameter("num");
	String gender = request.getParameter("gender");
	String major = request.getParameter("major");
	
	String msg;
	
	if(gender.equals("man"))
	{
		msg = "남자";
	}
	else
	{
		msg = "여자";
	}
%>
이름 : <%=name %> <br />
학번 : <%=num %> <br />
성별 : <%=msg %> <br />
전공 : <%=major %> <br />
</body>
</html>









