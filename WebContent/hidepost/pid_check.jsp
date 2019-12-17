<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" import="java.text.*, java.sql.*"  %>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<html>
<head>
<title>JSP Example</title>
</head>
<body>
<p>
<%
	String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "knu";
	String pass = "comp322";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
	Connection conn = null;
	Statement stmt = null;
	
	ResultSet rs;
	PreparedStatement pstmt;
	ResultSetMetaData rsmd;
	
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);

 String pid = request.getParameter("pid");
 String valid = "";
 String sql = "SELECT count(*) FROM POST WHERE PID = '" + pid + "'";
 
 pstmt = conn.prepareStatement(sql);
 rs = pstmt.executeQuery();
 int count = 0;    
 rsmd = rs.getMetaData();

	while (rs.next()) {
		count = rs.getInt(1);
	}
  rs.close();
  conn.close();

  if(count != 0) {
	  %>
	  <a style="color:lime">
	  <%
	  valid = "존재하는 게시글입니다.";}// 중복된 id가 있으면
  else{
	  %>
	  </a><a style="color:red">
	  <%
	  valid = "존재하지 않는 게시글입니다.";
  }
  
 HashMap<String,String> map = new HashMap<String,String>();
	map.put("pid",valid);
%>
  
  
  <%=map.get("pid")%></a>

</p>
</body>
</html>