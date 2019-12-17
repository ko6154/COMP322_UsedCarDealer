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
%><%
 String vid = request.getParameter("vid");
 String valid = "";
 String sql = "SELECT count(*) FROM VEHICLE WHERE VID = '" + vid + "'";
 
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
	  valid = "차량 정보를 수정합니다.";}// 중복된 id가 있으면
  else{
	  %>
	  </a><a style="color:lime">
	  <%
	  valid = "차량 정보를 등록합니다.";
  }
  
 HashMap<String,String> map = new HashMap<String,String>();
	map.put("vid",valid);
%>
  
  
  <%=map.get("vid")%></a>

</p>
</body>
</html>