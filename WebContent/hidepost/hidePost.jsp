<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.util.*" import="java.text.*, java.sql.*"  %>
<!--import JDBC package -->
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>차량등록</title>
</head>
<body>
<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<%
	DB.setConn();
	Connection conn = DB.getConn();
	
	ResultSet rs;
	PreparedStatement pstmt;
	ResultSetMetaData rsmd;
%>
<%
	
	String pid = request.getParameter("pid");
	String set = request.getParameter("valid");
	String sql ="UPDATE POST SET VALID ='" + set + "' WHERE PID = '" + pid +"'";		// 차량 등록을 위한 sql문	
	String postsql = "SELECT count(*) FROM POST WHERE PID = '" + pid + "'";
	int count = 0;
	 
	if(pid == "")
	{
		%>
		<script>
		alert('게시글 번호를 입력해주십시오.');
		history.back();
		</script>
		<%
	}
	else
	{
		 pstmt = conn.prepareStatement(postsql);
		 rs = pstmt.executeQuery();    
		 rsmd = rs.getMetaData();

			while (rs.next()) {
				count = rs.getInt(1);
			}
		if(count != 0) 
		{
			try							// 정보 변경
			{
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
				%>
				<script>
				alert('설정을 변경했습니다.');
				history.back();
				</script>
				<%
			} catch (SQLException es) {
				%>
				<script>
				alert('설정 변경에 실패하였습니다.');
				history.back();
				</script>
				<%
			}
		}
		else
		{
			%>
			<script>
			alert('존재하는 게시글을 입력해주십시오.');
			history.back();
			</script>
			<%
		}
		if(pstmt!=null) pstmt.close();
		if(conn!=null) conn.close();
	}	
	%>
</body>
</html>