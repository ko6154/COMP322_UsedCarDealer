<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="java.util.*" import="java.text.*, java.sql.*"  %>
<!--import JDBC package -->
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>�������</title>
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
	String sql ="UPDATE POST SET VALID ='" + set + "' WHERE PID = '" + pid +"'";		// ���� ����� ���� sql��	
	String postsql = "SELECT count(*) FROM POST WHERE PID = '" + pid + "'";
	int count = 0;
	 
	if(pid == "")
	{
		%>
		<script>
		alert('�Խñ� ��ȣ�� �Է����ֽʽÿ�.');
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
			try							// ���� ����
			{
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
				%>
				<script>
				alert('������ �����߽��ϴ�.');
				history.back();
				</script>
				<%
			} catch (SQLException es) {
				%>
				<script>
				alert('���� ���濡 �����Ͽ����ϴ�.');
				history.back();
				</script>
				<%
			}
		}
		else
		{
			%>
			<script>
			alert('�����ϴ� �Խñ��� �Է����ֽʽÿ�.');
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