<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page language="java" import="java.text.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>차량등록</title>
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
	
	String vsql ="INSERT INTO VEHICLE VALUES ('";		// 차량 등록을 위한 sql문
	String csql ="INSERT INTO SEEMS VALUES ('";		// 색상 등록을 위한 sql문
	String fsql ="INSERT INTO FUSE VALUES ('";		// 연료 등록을 위한 sql문
	
	
	if(vid == "")
	{
		%>
		<script>
		alert('차량번호를 입력해주십시오.');
		history.back();
		</script>
		<%
	}
	else if(maker == "")
	{
		%>
		<script>
		alert('제조사를 선택해주십시오.');
		history.back();
		</script>
		<%
	}
	else if(model == "")
	{
		%>
		<script>
		alert('모델을 선택해주십시오.');
		history.back();
		</script>
		<%
	}
	else if(detail == "")
	{
		%>
		<script>
		alert('세부모델을 선택해주십시오.');
		history.back();
		</script>
		<%
	}
	else if(caryear == "")
	{
		%>
		<script>
		alert('연식을 선택해주십시오.');
		history.back();
		</script>
		<%
	}
	else if(mileage == "")
	{
		%>
		<script>
		alert('주행거리를 입력해주십시오.');
		history.back();
		</script>
		<%
	}
	else if(price == "")
	{
		%>
		<script>
		alert('가격을 입력해주십시오.');
		history.back();
		</script>
		<%
	}
	else 
	{
		
		String cidsql = "SELECT CID FROM DETAILED_MODEL WHERE DM_ID = '" + detail + "'";			// cid를 받아오기 위한 sql문
		String dropcar = "DELETE FROM VEHICLE WHERE VID = '" + vid + "'";
		
		pstmt = conn.prepareStatement(dropcar);
		pstmt.executeUpdate();
		
		
		pstmt = conn.prepareStatement(cidsql);
		rs = pstmt.executeQuery();
		while (rs.next())
			cid = rs.getString("CID");
		vsql = vsql + vid + "','" + detail + "','" + model + "','" + maker + "','" + cid + "'," + request.getParameter("CC")
		+ ",'" + request.getParameter("transmission") + "',TO_DATE('" + caryear + "','YYYY-MM-DD'),"+ mileage + "," + price + ")";

		try							// 차량 등록
		{
			pstmt = conn.prepareStatement(vsql);
			pstmt.executeUpdate();
			%>
			<script>
			alert('차량등록에 성공하였습니다.');
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
				alert('색상등록에 성공하였습니다.');
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
				alert('색상등록에 성공하였습니다.');
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
				alert('연료등록에 성공하였습니다.');
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
				alert('연료등록에 성공하였습니다.');
				</script>
				<%
			}
		} catch (SQLException es) {
			%>
			<script>
			alert('차량등록에 실패하였습니다.');
			history.back();
			</script>
			<%
		}
		
	}	
	%>
</body>
</html>