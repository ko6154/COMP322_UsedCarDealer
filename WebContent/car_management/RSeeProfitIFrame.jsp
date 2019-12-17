<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>거래내역</title>
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

		String query = "select sum(v.price) from buy_car b, post p, vehicle v, maker mk "
				+ " where " + maker + year + month
				+ " b.post = p.pid and p.vid = v.vid  and v.mid = mk.mid group by mk.mname";
		pstmt = conn.prepareStatement(query);
		rs = pstmt.executeQuery();
		out.println("<table border=\"1\">");
		ResultSetMetaData rsmd = rs.getMetaData();
		int cnt = rsmd.getColumnCount();

		out.println("<th>매출액(원)</th>");

		while (rs.next()) {
			out.println("<tr>");
			out.println("<td>" + rs.getString(1) + "</td>");
			out.println("</tr>");
		}
	%>
	<br>
	<br>

</body>
</html>