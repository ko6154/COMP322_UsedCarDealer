<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page language="java" import="java.text.*, java.sql.*" %>
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
	Connection conn = DB.getConn();
	
	ResultSet rs;
	PreparedStatement pstmt;
	ResultSetMetaData rsmd;
	
	String vid = request.getParameter("vid");
	String maker = request.getParameter("True_Maker");
	String model =  request.getParameter("True_Model");
	String detail =  request.getParameter("True_DModel");
	String cid = "";
	String caryear = request.getParameter("caryear");
	String mileage =  request.getParameter("mileage");
	String price =  request.getParameter("price");
	
	String vsql ="INSERT INTO VEHICLE VALUES ('";		// ���� ����� ���� sql��
	String csql ="INSERT INTO SEEMS VALUES ('";		// ���� ����� ���� sql��
	String fsql ="INSERT INTO FUSE VALUES ('";		// ���� ����� ���� sql��
	
	
	if(vid == "")
	{
		%>
		<script>
		alert('������ȣ�� �Է����ֽʽÿ�.');
		history.back();
		</script>
		<%
	}
	else if(maker == "")
	{
		%>
		<script>
		alert('�����縦 �������ֽʽÿ�.');
		history.back();
		</script>
		<%
	}
	else if(model == "")
	{
		%>
		<script>
		alert('���� �������ֽʽÿ�.');
		history.back();
		</script>
		<%
	}
	else if(detail == "")
	{
		%>
		<script>
		alert('���θ��� �������ֽʽÿ�.');
		history.back();
		</script>
		<%
	}
	else if(caryear == "")
	{
		%>
		<script>
		alert('������ �������ֽʽÿ�.');
		history.back();
		</script>
		<%
	}
	else if(mileage == "")
	{
		%>
		<script>
		alert('����Ÿ��� �Է����ֽʽÿ�.');
		history.back();
		</script>
		<%
	}
	else if(price == "")
	{
		%>
		<script>
		alert('������ �Է����ֽʽÿ�.');
		history.back();
		</script>
		<%
	}
	else 
	{
		
		String cidsql = "SELECT CID FROM DETAILED_MODEL WHERE DM_ID = '" + detail + "'";			// cid�� �޾ƿ��� ���� sql��
		String dropcar = "DELETE FROM VEHICLE WHERE VID = '" + vid + "'";
		
		pstmt = conn.prepareStatement(dropcar);
		pstmt.executeUpdate();
		
		
		pstmt = conn.prepareStatement(cidsql);
		rs = pstmt.executeQuery();
		while (rs.next())
			cid = rs.getString("CID");
		vsql = vsql + vid + "','" + detail + "','" + model + "','" + maker + "','" + cid + "'," + request.getParameter("CC")
		+ ",'" + request.getParameter("transmission") + "',TO_DATE('" + caryear + "','YYYY-MM-DD'),"+ mileage + "," + price + ")";

		try							// ���� ���
		{
			pstmt = conn.prepareStatement(vsql);
			pstmt.executeUpdate();
			%>
			<script>
			alert('������Ͽ� �����Ͽ����ϴ�.');
			</script>
			<%
			
			
			String color1 = request.getParameter("color1");
			String color2 = request.getParameter("color2");
			String coating = request.getParameter("coating");
			String fuel1 = request.getParameter("fuel1");
			String fuel2 = request.getParameter("fuel2");
			String coloridsql = "";
			String colorid = "";
			
			if(color2.equals("null")||color1.equals(color2))
			{
				coloridsql = "SELECT COLOR_ID FROM COLOR WHERE COATING = '" + coating + "' AND COLOR_NAME = '" + color1 + "'";
	
				pstmt = conn.prepareStatement(coloridsql);
				rs = pstmt.executeQuery();
				while (rs.next())
					colorid = rs.getString("COLOR_ID");
					
				csql = csql + colorid + "','" + vid + "')";
				pstmt = conn.prepareStatement(csql);
				pstmt.executeUpdate();
				%>
				<script>
				alert('�����Ͽ� �����Ͽ����ϴ�.');
				</script>
				<%
			}
			else
			{
				coloridsql = "SELECT COLOR_ID FROM COLOR WHERE COATING = '" + coating + "' AND COLOR_NAME = '" + color1 + "'";
	
				pstmt = conn.prepareStatement(coloridsql);
				rs = pstmt.executeQuery();
				while (rs.next())
					colorid = rs.getString("COLOR_ID");
					
				csql = csql + colorid + "','" + vid + "')";
				pstmt = conn.prepareStatement(csql);
				pstmt.executeUpdate();
				
				coloridsql = "SELECT COLOR_ID FROM COLOR WHERE COATING = '" + coating + "' AND COLOR_NAME = '" + color2 + "'";
				
				pstmt = conn.prepareStatement(coloridsql);
				rs = pstmt.executeQuery();
				while (rs.next())
					colorid = rs.getString("COLOR_ID");
				
				csql = "INSERT INTO SEEMS VALUES ('" + colorid + "','" + vid + "')";	
				pstmt = conn.prepareStatement(csql);
				pstmt.executeUpdate();
				%>
				<script>
				alert('�����Ͽ� �����Ͽ����ϴ�.');
				</script>
				<%
			}
	
			if(fuel2.equals("null")||fuel1.equals(fuel2))
			{
				fsql = fsql + fuel1 + "','" + vid + "')";
				pstmt = conn.prepareStatement(fsql);
				pstmt.executeUpdate();
				%>
				<script>
				alert('�����Ͽ� �����Ͽ����ϴ�.');
				</script>
				<%
			}
			else
			{
				fsql = fsql + fuel1 + "','" + vid + "')";
				pstmt = conn.prepareStatement(fsql);
				pstmt.executeUpdate();
				
				fsql = "INSERT INTO FUSE VALUES ('" + fuel2 + "','" + vid + "')";
				pstmt = conn.prepareStatement(fsql);
				pstmt.executeUpdate();
				
				%>
				<script>
				alert('�����Ͽ� �����Ͽ����ϴ�.');
				</script>
				<%
			}
		} catch (SQLException es) {
			%>
			<script>
			alert('������Ͽ� �����Ͽ����ϴ�.');
			history.back();
			</script>
			<%
		}
		
	}	
	%>
</body>
</html>