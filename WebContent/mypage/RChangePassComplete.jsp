<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
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
		String query = "SELECT password FROM ACCOUNT WHERE ID = '" + session.getAttribute("ID") /*"knu"*/ + "'";
		pstmt = conn.prepareStatement(query);
		rs = pstmt.executeQuery();
		rs.next();
		String nowpass = rs.getString(1);

		if (!(nowpass.equals(request.getParameter("nowPw")))) {
	%>
	<script>
		var jbResult = alert('비밀번호가 틀렸습니다.');
		document.write(jbResult);
		history.go(-1);
	</script>
	<%
		}

		else if (!(request.getParameter("UserPW").equals(request.getParameter("UserPWcheck")))) {
	%>
	<script>
		var jbResult = alert('비밀번호가 일치하지 않습니다.');
		document.write(jbResult);
		history.go(-1);
	</script>
	<%
		} 
		
		else if(nowpass.equals(request.getParameter("UserPW"))){
			%>
			<script>
				var jbResult = alert('다른 비밀번호를 입력하세요.');
				document.write(jbResult);
				history.go(-1);
			</script>
			<%
		}
		else {

			query = "UPDATE ACCOUNT SET password = " + "'" + request.getParameter("UserPW") + "'" + "where id = "
					+ "'" + /*session.getAttribute("ID")*/ "knu" + "'";
			pstmt = conn.prepareStatement(query);
			int res = pstmt.executeUpdate(query);
	%>
	<script>
		var jbResult = alert('비밀번호가 변경되었습니다.');
		document.write(jbResult);
		history.go(-2);
	</script>
	<%
		}
	%>


</body>
</html>