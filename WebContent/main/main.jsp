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
	
	out.print("<div align = 'left'>"+ ID +" �� ȯ���մϴ�." + "</div>");
	
	//�������� �����ֱ�
	
	out.print("<div align = 'right'><a href = '../login/logout.jsp'> �α׾ƿ� </a></div>");
	
%>
<hr>

<%@ page import="View.Search" %>

<%
	//�˻��ϱ�	
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