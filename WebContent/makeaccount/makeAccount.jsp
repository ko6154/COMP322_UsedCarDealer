<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!--import JDBC package -->
<%@ page language="java" import="java.text.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>회원가입</title>
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
	
	int error = 0; 				// 입력에 대한 문제가 없는 경우
	
	String sql = "INSERT INTO ACCOUNT VALUES ('";
	
	String name = request.getParameter("name"); 
    if(name == "")
    {
    	name = "";
    }
    
    String address = request.getParameter("address");
    if(address == "")
    {
    	address = "";
    }
    
    String birth = request.getParameter("birthday");
    if(birth == "")
    {
    	birth = "''";
    }
    else
    {
    	birth = "TO_DATE('"+ birth +"','YYYY-MM-DD')";
    }
    
    String tell1 = request.getParameter("phone1");
    String tell2 = request.getParameter("phone2");
    String tell3 = request.getParameter("phone3");
    if(tell2 == "" || tell3 == "")
    {
    	tell1 = "";
    }
    else
    {
    	tell1 = tell1 + '-' + tell2 + '-' + tell3;
    }
    
    String job = request.getParameter("job");
    if(job == "")
    {
    	job = "";
    }
    
	sql = sql + request.getParameter("id") + "','" + request.getParameter("password")  + "','"+ name 
			+ "','" + request.getParameter("gender") + "','" + address + "'," + birth 
			+ ",'" + tell1 + "','" + job + "','C')";
	System.out.println(sql);
	int n = 0;
	%>
	<script>
	<%if(name == "")
	   {
	      error++;
	   %>
	      alert('이름을 입력해주십시오.');
	      history.back();
	   <%}
	   else if(tell1 == "")
	   {  
	      error++;
	      %>
	      alert('전화번호를 입력해주십시오.');
	      history.back();
	   <%}%>
	</script>
	<%	
	if(error == 0)
	{
		try {
			pstmt = conn.prepareStatement(sql);
			n = pstmt.executeUpdate();
			//conn.commit();
			if(pstmt!=null) pstmt.close();
			if(conn!=null) conn.close();
	
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	%>
	<script>
	if(<%=n%> > 0) {
		alert('회원가입이 완료되었습니다.');
		location.href = "../login/login.html";
	} else {
		alert('회원가입에 실패했습니다.');
		history.back();
	}
	<% } %>
	</script>
</body>
</html>