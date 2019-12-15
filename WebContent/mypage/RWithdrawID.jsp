<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>삭제하는 중입니다.</title>
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
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url, user, pass);
		
		int ManagerCount = 0;
		String auth = "";

		String query = "SELECT auth FROM ACCOUNT WHERE ID = '" + session.getAttribute("ID") /*"knu"*/ + "'"; 
		pstmt = conn.prepareStatement(query);
		rs = pstmt.executeQuery();
		rs.next();
		auth = rs.getString("auth");
		
		query = "select count(*) from account where auth = 'M'";
		pstmt = conn.prepareStatement(query);
		rs = pstmt.executeQuery();
		rs.next();
		ManagerCount = rs.getInt(1);
		
		if(auth.equals("M") && ManagerCount == 1){
			%>
			<script>
				var jbResult = alert('탈퇴할 수 없는 관리자 계정입니다.');
				document.write(jbResult);
				history.back();
			</script>
			<%
		}
		else{
			query =  "DELETE FROM account where id = '" + /*session.getAttribute("ID")*/ "knu" + "'";
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			
			%>
			<script>
				var jbResult = alert('탈퇴되었습니다.');
				document.write(jbResult);
				history.go(-1);
			</script>
			<%
		}
		
	%>
</body>
</html>