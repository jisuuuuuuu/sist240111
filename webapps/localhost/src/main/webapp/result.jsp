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
	request.setCharacterEncoding("UTF-8");
	
	int coffee = Integer.parseInt(request.getParameter("coffee"));
	int su = Integer.parseInt((request.getParameter("su")));
	int money = Integer.parseInt((request.getParameter("money")));
	
	String menu;
	int dan;
	int total;
	int change;
	
	if(coffee == 1)
	{
		menu = "아메리카노";
		dan = 3000;
	}
	else if(coffee == 2)
	{
		menu = "카페라떼";
		dan = 3300;
	}
	else if(coffee == 3)
	{
		menu = "에스프레소";
		dan = 2500;
	}
	else
	{
		menu = "얼그레이";
		dan = 3500;
	}
	
	total = dan * su;
	change = money - total;
%>
<h1>주문계산 결과</h1>
<li><%="커피종류 : " + menu %></li>
<li><%="1개 가격 : " + dan %></li>
<li><%="수량 : " + su %></li>
<li><%="총 금액 : " + total %></li>
<li><%="입금액 : " + money %></li>
<li><%="거스름돈 : " + change %></li>
</body>
</html>