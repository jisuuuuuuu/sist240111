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

	String season = request.getParameter("season");
	String fruit = request.getParameter("fruit");
	String id = (String)session.getAttribute("idKey");
	
	String sessionId = session.getId();		//JSP컨테이너에서 클라이언트 구분을 위해 고유한 값을 넘겨줌.
	
	int time = session.getMaxInactiveInterval();		//setsetMaxInactiveInterval(val)로 지정된 값 반환. 없을 경우 기본 1800(초)
	
	if(id != null)
	{
%>
		<h1>session 유지 연습용</h1>
		<b><%=id %></b>가 좋아하는 계절은 <b><%=season %></b>이고, 좋아하는 과일은 <%=fruit %> 입니다.<p />
		세션 id : <%=sessionId %><p/>
		세션 유지 시간 : <%=time %>초 입니다. <p />
<%	
		
		session.invalidate();		//session객체 종료
	}
	else
	{
		out.println("세션이 종료되어 연결이 끊어졌습니다.");
	}
%>
</body>
</html>