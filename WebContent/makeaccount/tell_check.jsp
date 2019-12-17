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

 String tell1 = request.getParameter("tell1");
 String tell2 = request.getParameter("tell2");
 String tell3 = request.getParameter("tell3");
 if(tell1 == "" || tell2 == "" || tell3 == "")
 {
 	  tell1 = "";
 }
 else
 {
	 tell1 = tell1+ '-' + tell2 +'-'+tell3;
 }
 String valid = "";
 String sql = "SELECT count(*) FROM ACCOUNT WHERE TELL_NUM = '" + tell1+"'";
 
 pstmt = conn.prepareStatement(sql);
 rs = pstmt.executeQuery();
 int count = 0;

 rsmd = rs.getMetaData();

	while (rs.next()) {
		count = rs.getInt(1);
	}
  //System.out.println(count);
  rs.close();
  


  if(count != 0 || tell1.equals("")) {
	  %>
	  <a style="color:red">
	  <%
	  valid = "사용 불가능한 전화번호입니다.";}// 중복된 전화번호가 있으면
  else{
	  %>
	  </a><a style="color:lime">
	  <%
	  valid = "사용가능한 전화번호입니다.";
  }
  
 HashMap<String,String> map = new HashMap<String,String>();
	map.put("id",valid);
%>
  
  
  <%=map.get("id")%></a>

</p>
</body>
</html>