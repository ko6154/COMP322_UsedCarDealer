<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Ȯ��</title>
</head>

<body>
<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<%
	Connection conn = DB.getConn();
	
	ResultSet rs;
	PreparedStatement pstmt;
	ResultSetMetaData rsmd;
%><%
		int res;
		String name = request.getParameter("name");
		String ftell = request.getParameter("former_tell");
		String ltell = request.getParameter("latter_tell");
		String address = request.getParameter("address");
		String job = request.getParameter("job");
		String sex = request.getParameter("sex");

		try {
			int ftellnum = Integer.parseInt(ftell);
			int ltellnum = Integer.parseInt(ltell);
		} catch (NumberFormatException e) {
			if(ftell != "" || ltell != ""){
	%>
	
	<script>
	var jbResult = alert('��ȭ��ȣ�� �߸��Է��ϼ̽��ϴ�.'); 
	document.write(jbResult);
	history.go(-1);
	</script>
	<%
			}
		}

		if (((ftell == "" && ltell == "") || (ftell != "" && ltell != ""  && ftell.length() == 4 && ltell.length() == 4))) {
			String sql;

			/*�̸� ������Ʈ*/
			if (name != "") {
				sql = "UPDATE ACCOUNT SET NAME = " + "'" + name + "'" + "where id = " + "'"
						+ session.getAttribute("ID") /*"knu"*/ + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}
			if (ftell != "" && ltell != "") {
				String tellnum = "010-" + ftell + "-" + ltell;
				sql = "UPDATE ACCOUNT SET Tell_num = " + "'" + tellnum + "'" + "where id = " + "'"
						+ session.getAttribute("ID") /*"knu"*/ + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}

			if (address != "") {
				sql = "UPDATE ACCOUNT SET address = " + "'" + address + "'" + "where id = " + "'"
						+ session.getAttribute("ID") /*"knu"*/ + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}

			if (sex != "") {
				sql = "UPDATE ACCOUNT SET sex = " + "'" + sex + "'" + "where id = " + "'"
						+ session.getAttribute("ID") /*"knu"*/ + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}
			
			if (job != "") {
				sql = "UPDATE ACCOUNT SET job = " + "'" + job + "'" + "where id = " + "'"
						+ session.getAttribute("ID") /*"knu"*/ + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}
	%>

	<script>
		var jbResult = alert('����Ǿ����ϴ�.');
		document.write(jbResult);
		history.go(-2);
	</script>

	<%
		} else {
	%>
	<script>
		var jbResult = alert('������ȣ�� �߸��Է��ϼ̽��ϴ�.');
		document.write(jbResult);
		history.back();
	</script>
	<%
		}
	%>
</body>
</html>