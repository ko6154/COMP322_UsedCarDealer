<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!--import JDBC package -->
<%@ page language="java" import="java.text.*, java.sql.* , java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>ȸ������</title>
</head>
<body>
<h2></h2>
<%String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "knu";
	String pass = "comp322";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
	Connection conn = null;
	PreparedStatement pstmt = null;
	Statement stmt = null;
	ResultSet rs;
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);  
	
	int count = 0; 				// �Է¿� ���� ������ ���� ���
	
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
	
	try{
	pstmt = conn.prepareStatement(sql);
	pstmt.executeUpdate();
	%>
	<script>
	alert('�Խñ� ��Ͽ� �����Ͽ����ϴ�.');
	location.replace("../car_management/CarManagement.html");
	</script>
	<%
	} catch (SQLException es)
	{
		%>
		<script>
		alert('�Խñ� ��Ͽ� �����Ͽ����ϴ�.');
		history.back();
		</script>
		<%
	}
	%>
</body>
</html>