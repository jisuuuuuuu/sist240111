<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%
   boolean connection = false;
   Connection conn = null;
   
   String driver = "oracle.jdbc.driver.OracleDriver";
   String url = "jdbc:oracle:thin:@localhost:1521:xe";
   
   try{
      Class.forName(driver);
      conn = DriverManager.getConnection(url, "c##sistuser", "1234");
      connection = true;
      System.out.println("DB 연결 성공");
   }
   catch(Exception e){
      connection = false;
      System.out.println("DB 연결 실패");
      e.printStackTrace();
   }
   finally{
      if(conn != null)
         conn.close();
   }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>db_jdbc.jsp</title>
</head>
<body>
<%
   if(connection == true){
%>      
   <h2>DB연결에 성공하였습니다.</h2>
<%
   }
   else{
%>
   <h2>DB연결에 실패하였습니다.</h2>
<%
   }
%>
</body>
</html>