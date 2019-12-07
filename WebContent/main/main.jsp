<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	String ID = (String)session.getAttribute("ID"); String auth = (String)session.getAttribute("auth"); 
	
	out.print("<div align = 'left'>"+ ID +" 님 환영합니다." + "</div>");
	
	//개인정보 보여주기
	
	out.print("<div align = 'right'><a href = '../login/logout.jsp'> 로그아웃 </a></div>");
	
%>
<hr>

<%@ page import="View.Search" %>

<%
	//검색하기	
	Search search = new Search();
	out.println("<form action = \"../search/search.jsp\" method = \"POST\">");
	out.println("<select name = 'maker'");
	   
	for (String mname : search.GetMaker() ){
		out.println(mname);
	}
	out.println("</select>");
	
	
%>
</body>
</html>