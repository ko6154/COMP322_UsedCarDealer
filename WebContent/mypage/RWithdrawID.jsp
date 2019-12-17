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
	<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<%
	Connection conn = DB.getConn();
	
	ResultSet rs;
	PreparedStatement pstmt;
	ResultSetMetaData rsmd;
%><%
		
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