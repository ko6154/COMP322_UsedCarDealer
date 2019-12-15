<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page language="java" import="java.text.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>login</title>
</head>
<body>
<%
	String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "knu";
	String pass = "comp322";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
	Connection conn = null;
	Statement stmt = null;
	
	String sql = "";
	ResultSet rs;
	PreparedStatement pstmt;
	ResultSetMetaData rsmd;
	int count;
	
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);
%>
<%
	int valid = 0;
	String auth = "";
	
	sql = "SELECT count(*), auth from account where id = '" + request.getParameter("ID") + "' AND password = '" + request.getParameter("PWD")
			+ "' group by auth";
	//out.println(sql);
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	rsmd = rs.getMetaData();

	while (rs.next()) {
		valid = rs.getInt(1);
		auth = rs.getString(2);
	}
	
	if (valid != 1) {
		out.println("<script>alert(\"정확하지 않은 입력입니다.\"); history.back();</script>");
		
	} else { // valid 할 경우 그대로 놔두면 로그인 while문 을 종료함
		out.println("<script>alert(\"로그인 성공.\"); location.replace(\"../main/main.jsp\")</script>");
		session.setAttribute("ID", request.getParameter("ID"));
		session.setAttribute("AUTH", auth);
	}
	
	
%>
  
</body>
</html>