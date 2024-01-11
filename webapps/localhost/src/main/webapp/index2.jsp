<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>변수와 메서드 선언</title>
</head>
<body>
	<%--변수 및 메서드 선언 --%>
	<%!
		int a;
		int b;
		
		public int sum(int a, int b){
			return a + b;
		}
	%>
	
	<!-- html 주석 -->
	<%
		/*
			jsp 여러줄 주석
		*/
	%>
	<%//jsp 한줄 주석 %>
	<%--자바코드 삽입 --%>
	<% 
		a = 10;
		b = 20;
		out.println(sum(a, b));
	%>
	
	<h1>선언문의 멤버변수 호출</h1>
	<%
		String name = team + "안녕하세요";
	%>
	<%!
		String team = "jsp";
	
		String msg1;
		int msg2;
	%>
	
	<h3>출력되는 결과는 <%=name %></h3>
	<br />
	<h3>표현식을 이용한 메서드 결과 출력</h3>
	<%
		a = 50;
		b = 20;
	%>
	<h4>메서드 결과는 : <%=sum(a, b) %></h4>
	<h4>msg1 값은 : <%=msg1 %></h4>
	<h4>msg2 값은 : <%=msg2 %></h4>
</body>
</html>