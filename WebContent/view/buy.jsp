<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<%@ page import="View.Search" %>
<body>
<%
	String ID = (String)session.getAttribute("ID");
	String pid = request.getParameter("pid");
	
	Search search = new Search();
	System.out.println(ID);
	System.out.println(pid);
	if(search.Buy_Car(ID, pid))
		out.println("<script>alert('���� �Ϸ�'); location.replace('../main/main.jsp');</script>");
	else
		out.println("<script>alert('���� ����'); history.back();</script>");
%>
</body>
</html>