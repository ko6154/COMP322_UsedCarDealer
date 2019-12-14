<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page language="java" import="java.text.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title></title>
</head>
<body>
<h2>검색 결과</h2>
<hr>
<%@ page import="View.Search" %>
<table>
<%
	Search search = new Search();

	String model = request.getParameter("model");
	String d_model = request.getParameter("d_model");
	String maker = request.getParameter("maker");
	
	if(model == null){
		for (String output : search.GetPostMaker(maker)){
			out.println("<tr>");
			out.println(output);
			out.println("</tr>");
		}
			
	}
	
	else if(d_model == null){
		for(String output : search.GetName(model, "")){
			out.println("<tr>");
			out.println(output);
			out.println("</tr>");
		}
			
	}
	else{
		for (String output: search.GetName(model, d_model)){
			out.println("<tr>");
			out.println(output);
			out.println("</tr>");
		}
	}

%>
</table>
</body>
</html>