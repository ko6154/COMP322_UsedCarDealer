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

<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<%
	DB.setConn();
	Connection conn = DB.getConn();
	String sql = "";
	ResultSet rs;
	PreparedStatement pstmt;
	ResultSetMetaData rsmd;
%>
<%
	int valid = 0;
	String auth = "";
	
	sql = "SELECT count(*), auth from account where id = '" + request.getParameter("ID") + "' AND password = '" + request.getParameter("PWD")
			+ "' group by auth";
	
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	rsmd = rs.getMetaData();
	
	while (rs.next()) {
		valid = rs.getInt(1);
		auth = rs.getString(2);
	}
	
	if (valid != 1) {
		out.println("<script>alert(\"��Ȯ���� ���� �Է��Դϴ�.\"); history.back();</script>");
		
	} else { // valid �� ��� �״�� ���θ� �α��� while�� �� ������
		session.setAttribute("ID", request.getParameter("ID"));
		session.setAttribute("AUTH", auth);
		out.println("<script>alert(\"�α��� ����.\"); location.replace(\"../main/main.jsp\")</script>");
	}
	
	
%>
  
</body>
</html>