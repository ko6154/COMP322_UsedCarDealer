<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>ȸ����������</title>
</head>
<body>
<form action = "RChangeinfoComplete.jsp" method = "POST">
<%String serverIP = "155.230.36.61";
   String strSID = "orcl";
   String portNum = "1521";
   String user = "s2017111978";
   String pass = "2017111978";
   String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
   Connection conn = null;
   PreparedStatement pstmt;
   ResultSet rs;
   Class.forName("oracle.jdbc.driver.OracleDriver");
   conn = DriverManager.getConnection(url,user,pass);  
   
   String query = "SELECT * FROM ACCOUNT WHERE ID = '" + session.getAttribute("ID") /*"knu"*/ + "'";
   pstmt = conn.prepareStatement(query);
   rs = pstmt.executeQuery();
   out.println("<table border=\"1\">");
   ResultSetMetaData rsmd = rs.getMetaData();
   int cnt = rsmd.getColumnCount();
   
   out.println("<th>"+rsmd.getColumnName(3)+"</th>");
   out.println("<th>"+rsmd.getColumnName(4)+"</th>");
   out.println("<th>"+rsmd.getColumnName(5)+"</th>");
   out.println("<th>"+rsmd.getColumnName(6)+"</th>");
   out.println("<th>"+rsmd.getColumnName(7)+"</th>");
   out.println("<th>"+rsmd.getColumnName(8)+"</th>");
   
   while(rs.next())
   {
      out.println("<tr>");
      out.println("<td>"+rs.getString("Name")+"</td>");
      out.println("<td>"+rs.getString("Sex")+"</td>");
      out.println("<td>"+rs.getString("Address")+"</td>");
      out.println("<td>"+rs.getDate("Birth")+"</td>");
      out.println("<td>"+rs.getString("Tell_num")+"</td>");
      out.println("<td>"+rs.getString("Job")+"</td>");
 
      out.println("</tr>");
   }
   out.println("</table>");   
   out.println("<br></br>" + "�̸�:    " + "<input type = 'text' name = 'name'>");
   out.println("<br></br>" + "����:    " + "<select name = 'sex'><option value='' selected>�����ϼ���</option> <option value = 'M' select>��</option> <option value = 'F' select>��</option></select>");
   out.println("<br></br>" + "�ּ�:    " + "<input type = 'text' name = 'address'>");
   out.println("<br></br>" + "��ȭ��ȣ: " + "010 - <input type = 'text' name = 'former_tell' maxlength = '4' onKeyup='this.value=this.value.replace(/[^0-9]/g,'');'> - <input type = 'text' name = 'latter_tell' maxlength = '4' onKeyup='this.value=this.value.replace(/[^0-9]/g,'');'<br>");
   out.println("<br></br>" + "����:    " + "<input type = 'text' name = 'job'>");
   %>
   
   <br><br><input type = 'submit' value = '����'>
   <input type = 'button' value = '���' onclick='history.back();'>
   
   </form>
</body>
</html>