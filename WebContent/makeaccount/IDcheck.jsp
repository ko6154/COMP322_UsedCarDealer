<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!--import JDBC package -->
<%@ page language="java" import="java.text.*, java.sql.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
    <title>���̵� �ߺ� üũ</title>
    
    <style type="text/css">
        #wrap {
            width: 490px;
            text-align :center;
            margin: 0 auto 0 auto;
        }
        
        #chk{
            text-align :center;
        }
        
        #cancelBtn{
            visibility:visible;
        }
        
        #useBtn{
             visibility:hidden;
        }
 
   </style>
    
    <script type="text/javascript">
        
        
        // ȸ������â�� ���̵� �Է¶��� ���� �����´�.
        function pValue(){
            document.getElementById("userId").value = opener.document.userInfo.id.value;
        }
        
        // ���̵� �ߺ�üũ
        function idCheck(){
 
            var id = document.getElementById("userId").value;
 
            if (!id) {
                alert("���̵� �Է����� �ʾҽ��ϴ�.");
                return false;
            } 
            else if((id < "0" || id > "9") && (id < "A" || id > "Z") && (id < "a" || id > "z")){ 
                alert("�ѱ� �� Ư�����ڴ� ���̵�� ����Ͻ� �� �����ϴ�.");
                return false;
            }
            else
            {
                String query = "Select COUNT(*) from  ACCOUNT WHERE ID = '"+id+"'"
                pstmt = conn.prepareStatement(query);
            	rs = pstmt.executeQuery();
            	out.println("<table border=\"1\">");
            	rsmd = rs.getMetaData();
            	cnt = rsmd.getColumnCount();
            	for( i =1; i<= cnt; i++)
            	{
            		out.println("<th>"+rsmd.getColumnName(i)+"</th>");
            	}
            	while(rs.next())
            	{
            		out.println("<tr>");
            		out.println("<td>"+rs.getString(1)+"</td>");
            		out.println("</tr>");
            	}
            	out.println("</table>");
            }
        }
        
        function callback(){
            if(httpRequest.readyState == 4){
                // ������� �����´�.
                var resultText = httpRequest.responseText;
                if(resultText == 0){
                    alert("����Ҽ����� ���̵��Դϴ�.");
                    document.getElementById("cancelBtn").style.visibility='visible';
                    document.getElementById("useBtn").style.visibility='hidden';
                    document.getElementById("msg").innerHTML ="";
                } 
                else if(resultText == 1){ 
                    document.getElementById("cancelBtn").style.visibility='hidden';
                    document.getElementById("useBtn").style.visibility='visible';
                    document.getElementById("msg").innerHTML = "��� ������ ���̵��Դϴ�.";
                }
            }
        }
        
        // ����ϱ� Ŭ�� �� �θ�â���� �� ���� 
        function sendCheckValue(){
            // �ߺ�üũ ����� idCheck ���� �����Ѵ�.
            opener.document.userInfo.idDuplication.value ="idCheck";
            // ȸ������ ȭ���� ID�Է¶��� ���� ����
            opener.document.userInfo.id.value = document.getElementById("userId").value;
            
            if (opener != null) {
                opener.chkForm = null;
                self.close();
            }    
        }    
   </script>
    
</head>
<body onload="pValue()">
<%String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "knu";
	String pass = "comp322";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
	Connection conn = null;
	PreparedStatement pstmt;
	ResultSet rs;
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url,user,pass);  %>
<div id="wrap">
    <br>
    <b><font size="4" color="gray">���̵� �ߺ�üũ</font></b>
    <hr size="1" width="460">
    <br>
    <div id="chk">
        <form id="checkForm">
            <input type="text" name="idinput" id="userId">
            <input type="button" value="�ߺ�Ȯ��" onclick="idCheck()">
        </form>
        <div id="msg"></div>
        <br>
        <input id="cancelBtn" type="button" value="���" onclick="window.close()"><br>
        <input id="useBtn" type="button" value="����ϱ�" onclick="sendCheckValue()">
    </div>
</div>    
</body>
</html>
