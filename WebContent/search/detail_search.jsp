<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%@ page import="View.Search" %>
<table>
<tr><td>����</td><td>��</td><td>���θ�</td><td>����</td><td>����</td><td>�� �����</td></tr>
<%
	Search search = new Search();
	
	for(String result:search.search_detail(request.getParameter("category"), request.getParameterValues("color"), request.getParameterValues("fuel"), request.getParameter("transmission"), request.getParameter("engine"))){
		out.println("<tr>");
		out.println(result);
		out.println("</tr>");
	}
%>
</table>
</body>
</html>