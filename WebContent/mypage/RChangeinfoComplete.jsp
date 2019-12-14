<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>확인</title>
</head>

<body>
	<%
		String serverIP = "155.230.36.61";
		String strSID = "orcl";
		String portNum = "1521";
		String user = "s2017111978";
		String pass = "2017111978";
		String url = "jdbc:oracle:thin:@" + serverIP + ":" + portNum + ":" + strSID;
		Connection conn = null;
		PreparedStatement pstmt;
		ResultSet rs;
		int res;
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url, user, pass);

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
	var jbResult = alert('전화번호를 잘못입력하셨습니다.'); 
	document.write(jbResult);
	history.go(-1);
	</script>
	<%
			}
		}

		if (((ftell == "" && ltell == "") || (ftell != "" && ltell != ""  && ftell.length() == 4 && ltell.length() == 4))) {
			String sql;

			/*이름 업데이트*/
			if (name != "") {
				sql = "UPDATE ACCOUNT SET NAME = " + "'" + name + "'" + "where id = " + "'"
						+ /*session.getAttribute("ID")*/ "knu" + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}
			if (ftell != "" && ltell != "") {
				String tellnum = "010-" + ftell + "-" + ltell;
				sql = "UPDATE ACCOUNT SET Tell_num = " + "'" + tellnum + "'" + "where id = " + "'"
						+ /*session.getAttribute("ID")*/ "knu" + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}

			if (address != "") {
				sql = "UPDATE ACCOUNT SET address = " + "'" + address + "'" + "where id = " + "'"
						+ /*session.getAttribute("ID")*/ "knu" + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}

			if (sex != "") {
				sql = "UPDATE ACCOUNT SET sex = " + "'" + sex + "'" + "where id = " + "'"
						+ /*session.getAttribute("ID")*/ "knu" + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}
			
			if (job != "") {
				sql = "UPDATE ACCOUNT SET job = " + "'" + job + "'" + "where id = " + "'"
						+ /*session.getAttribute("ID")*/ "knu" + "'";
				pstmt = conn.prepareStatement(sql);
				res = pstmt.executeUpdate(sql);
			}
	%>

	<script>
		var jbResult = alert('변경되었습니다.');
		document.write(jbResult);
		history.go(-2);
	</script>

	<%
		} else {
	%>
	<script>
		var jbResult = alert('전봐번호를 잘못입력하셨습니다.');
		document.write(jbResult);
		history.back();
	</script>
	<%
		}
	%>
</body>
</html>