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
<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<table>
<img src = 'img.png' width='50%' height='50%'></img>
<tr><td>���� ��ȣ</td> <td>���� </td> <td>��ⷮ</td> <td>���ӱ�</td> <td>����</td> <td>����Ÿ�</td></tr>
<%
	//�˻��ϱ�	
	Search search = new Search(DB.getConn());
	   
	for (String output : search.View(request.getParameter("id")) ){
		out.println("<tr>");
		out.println(output);
		out.println("</tr>");
	}
			
%>
</table>

<%
out.println("<form action='buy.jsp' method = 'GET'> <input type = 'hidden' name = 'pid' value = '"+ request.getParameter("id")+"'>");
%>
<input type = 'submit' value = '����'>
</form>
</body>
</html>