<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<%!
		String msg;
	%>
	<%
		request.setCharacterEncoding("UTF-8");
	
		String name = request.getParameter("name");
		String color = request.getParameter("color");
		
		/*첫번째 연습
		if(color.equals("blue"))
		{
			msg = "파란색";
		}
		else if(color.equals("red"))
		{
			msg ="빨간색";
		}
		else if(color.equals("orange"))
		{
			msg = "오렌지색";
		}
		else
		{
			color = "white";
			msg = "기타";
		}
		*/
		//두번째 연습
		if(color.equals("etc"))
			color = "white";
	%>
</head>
<body bgcolor=<%=color %>>
	<h3>if~else 연습용</h3>
	<!-- 첫번째 연습용 
	<b><%=name %></b>이 좋아하는 색은 <b><%=msg %></b>입니다.
	-->
	<!-- 두번째 연습용 -->
	<%
		if(color.equals("blue"))
		{
			msg = "파란색";
	%>
			<b><%=name %></b>이 좋아하는 색은 <b><%=msg %></b>입니다.
	<% 
		}
		else if(color.equals("red"))
		{
			msg ="빨간색";
	%>
			<b><%=name %></b>이 좋아하는 색은 <b><%=msg %></b>입니다.
			
	<%
		}
		else if(color.equals("orange"))
		{
			msg = "오렌지색";
	%>
			<b><%=name %></b>이 좋아하는 색은 <b><%=msg %></b>입니다.
	<%
		}
		else
		{
			msg = "기타";
	%>
			<b><%=name %></b>이 좋아하는 색은 <b><%=msg %></b>입니다.
	<%
		}
	%>
</body>
</html>













