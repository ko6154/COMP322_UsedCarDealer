<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!--import JDBC package -->
<%@ page language="java" import="java.text.*, java.sql.* , java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>회원가입</title>
</head>
<body>
<h2></h2>
<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<%
	Connection conn = DB.getConn();
	
	ResultSet rs;
	PreparedStatement pstmt;
	ResultSetMetaData rsmd;
%>
<%
	int count = 0; 				// 입력에 대한 문제가 없는 경우
	
	String countsql = "SELECT COUNT(*) FROM POST";
	pstmt = conn.prepareStatement(countsql);
	rs = pstmt.executeQuery();
	while (rs.next())
		count = rs.getInt("count(*)");
	
	count ++;
	
	Calendar cal = Calendar.getInstance();
	 
	int year = cal.get ( cal.YEAR );
	int month = cal.get ( cal.MONTH ) + 1 ;
	int date = cal.get ( cal.DATE ) ;
	
	String countS = Integer.toString(count);
	String vid = request.getParameter("vid");
	String title = request.getParameter("title");
	String day = Integer.toString(year) + "-" + Integer.toString(month) + "-" + Integer.toString(date);
	
	
	String sql = "INSERT INTO POST VALUES ('PO100" + countS + "','" + vid + "','" 
	+ title + "','knu',TO_DATE('"+ day +"','YYYY-MM-DD'),'v')";
	System.out.println(sql);
	try{
	pstmt = conn.prepareStatement(sql);
	pstmt.executeUpdate();
	conn.commit();
	%>
	<script>
	alert('게시글 등록에 성공하였습니다.');
	location.replace("../car_management/CarManagement.html");
	</script>
	<%
	} catch (SQLException es)
	{
		%>
		<script>
		alert('게시글 등록에 실패하였습니다.');
		history.back();
		</script>
		<%
	}
	%>
</body>
</html>