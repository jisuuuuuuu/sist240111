<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>jsp 실습</title>
</head>
<body>
	<%!
		int a;
		String msgA;
	%>
	
	<%
		int b = 30;
		String msgB = "jsp sample";
	%>
	<%=b + " : " + msgB %><p />
	<%=application.getRealPath("/") %>
	
	<br />
	
	<h2>표현식 sample</h2>
	<%!
		String name[] = {"Java", "JSP", "html", "javascript"};
	%>
	<table border='1' width="200">
	<%
		for(int i = 0; i < name.length; i++)
		{
	%>
			<tr><td><%=i %>
			<td><%=name[i] %></td>
			</tr>
	<%
		}
	%>
	</table>
	
	<br /><br />
	<h3>jsp sample2</h3>
	<%
		java.util.Date date = new java.util.Date();
		int hour = date.getHours();
		int aa = 10;
		int bb = 15;
	%>
	<%!
		public int operation(int a, int b)
		{
			return a > b ? a: b;
		}
	%>
	
	지금은 오전인지 오후인지 알려주세요.? <%=(hour < 12) ? "오전" : "오후"%><p />
	aa와 bb 중 큰 값은 ? <%=operation(aa, bb) %>
	
	<br /><br />
	<h3>주석 종류</h3>
	<!-- html주석이고 브라우저에서 보이는 주석 -->
	<%--
		jsp에서만 보이고 브라우저 '소스보기'에서는 보이지 않는주석
	 --%>
	 <!-- <%=msgB%>html주석으로 브라우저에서 msgB값이 보이는 주석 -->
	 <%=msgB/*소스보기에서 안보임.*/ %><br />
</body>
</html>



















