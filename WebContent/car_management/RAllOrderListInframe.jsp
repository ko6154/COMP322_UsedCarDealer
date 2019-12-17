<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>�ŷ�����</title>
</head>
<body>
<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<%
	Connection conn = DB.getConn();
	
	ResultSet rs;
	PreparedStatement pstmt;
	
%>
<%

		String maker, year, month;

		if (request.getParameter("maker").equals("every")) {
			maker = " ";
		} else {
			maker = "mk.mid = '" + request.getParameter("maker") + "' and ";
		}
		System.out.println(maker);

		if (request.getParameter("year").equals("every")) {
			year = " ";
		} else {
			year = "EXTRACT(year FROM (b.Sold_date)) = '" + request.getParameter("year") + "' and ";
		}
		System.out.println(year);

		if (request.getParameter("month").equals("every")) {
			month = " ";
		} else {
			month = "EXTRACT(month FROM (b.Sold_date)) = '" + request.getParameter("month") + "' and ";
		}
		System.out.println(month);

		String query = "select v.vid, p.title, mk.mname, md.model_name, dm.dm_name, b.sold_date from buy_car b, post p, vehicle v, detailed_model dm, model md, maker mk "
				+ " where " + maker + year + month
				+ " b.post = p.pid and p.vid = v.vid and v.dm_id = dm.dm_id and v.model_id = md.model_id and v.mid = mk.mid order by sold_date desc";
		pstmt = conn.prepareStatement(query);
		rs = pstmt.executeQuery();
		out.println("<table border=\"1\">");
		ResultSetMetaData rsmd = rs.getMetaData();
		int cnt = rsmd.getColumnCount();

		out.println("<th>������ȣ</th>");
		out.println("<th>�Խñ�</th>");
		out.println("<th>������</th>");
		out.println("<th>��</th>");
		out.println("<th>���θ�</th>");
		out.println("<th>���� ��¥</th>");

		while (rs.next()) {
			out.println("<tr>");
			out.println("<td>" + rs.getString("VID") + "</td>");
			out.println("<td>" + rs.getString("TITLE") + "</td>");
			out.println("<td>" + rs.getString("MNAME") + "</td>");
			out.println("<td>" + rs.getString("model_name") + "</td>");
			out.println("<td>" + rs.getString("dm_name") + "</td>");
			out.println("<td>" + rs.getDate("SOLD_DATE") + "</td>");
			out.println("</tr>");
		}
	%>
	<br>
	<br>

</body>
</html>