<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	Logger logger = LogManager.getLogger("loginPro.jsp");

	HttpUtil.requestLogString(request, logger);
	
	String userId = HttpUtil.get(request, "userId");
	String userPwd = HttpUtil.get(request, "userPwd");
	String msg ="";
	String redirectUrl = "";
	
	User user = null;
	UserDao userDao = new UserDao();
	
	logger.debug("user Id : " + userId);
	logger.debug("user Pwd : " + userPwd);
	
	if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
	{
		user = userDao.userSelect(userId);
		
		if(user != null)
		{
			if(StringUtil.equals(userPwd, user.getUserPwd()))
			{
				if(StringUtil.equals(user.getStatus(), "Y"))
				{
					msg = "로그인 성공";
					redirectUrl = "/";
				}
				else
				{
					msg = "정지된 사용자 입니다.";
					redirectUrl = "/";
				}
			}
			else
			{
				msg ="비밀번호가 다릅니다.";
				redirectUrl = "/";
			}
		}
		else
		{
			msg ="아이디가 존재하지 않습니다.";
			redirectUrl = "/";
		}
	}
	else
	{//아이디나 비밀번호가 입력되지 않은 경우
		msg = "아이디나 비밀번호가 입력되지 않았습니다.";
		redirectUrl = "/";
	}
%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/include/head.jsp" %>

<script>
$(document).ready(function(){
	alert("<%=msg %>");
	location.href = "<%=redirectUrl %>";
});
</script>
</head>
<body>

</body>
</html>