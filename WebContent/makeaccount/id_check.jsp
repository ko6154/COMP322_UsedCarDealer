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
<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<%
	Connection conn = DB.getConn();
	
	ResultSet rs;
	PreparedStatement pstmt;
	ResultSetMetaData rsmd;
%>
<%
 String id = request.getParameter("id");
 String valid = "";
 String sql = "SELECT count(*) FROM ACCOUNT WHERE ID = '" + id + "'";
 
 pstmt = conn.prepareStatement(sql);
 rs = pstmt.executeQuery();
 int count = 0;    
 rsmd = rs.getMetaData();

	while (rs.next()) {
		count = rs.getInt(1);
	}
  //System.out.println(count);
  rs.close();
  

  if(count != 0) {
	  %>
	  <a style="color:red">
	  <%
	  valid = "이미 존재하는 ID입니다.";}// 중복된 id가 있으면
  else{
	  %>
	  </a><a style="color:lime">
	  <%
	  valid = "사용가능한 ID입니다.";
  }
  
 HashMap<String,String> map = new HashMap<String,String>();
	map.put("id",valid);
%>
  
  
  <%=map.get("id")%></a>

</p>
</body>
</html>