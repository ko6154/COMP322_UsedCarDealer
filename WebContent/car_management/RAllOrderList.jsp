<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>거래내역</title>
<%@ page import="View.Search"%>

<script>
	function changeIframeUrl(url)

	{
		document.getElementById("ListHere").src = url;

	}
</script>

<base = target="_self">

</head>
<body>
	<%
		Search mklist = new Search();

		out.println("<form action = \"RAllOrderListInframe.jsp\" method = \"GET\" target = \"ListHere\">");
		out.println("<select name = 'maker'>");
		out.println("<option value = 'every' selected>모두선택</option>");

		for (String mname : mklist.GetMaker()) {
			out.println(mname);
		}

		out.println("</select>");
	%>

	<select name='year'>
		<option value='every' selected>모두 선택</option>
		<option value='2017'>2017년</option>
		<option value='2018'>2018년</option>
		<option value='2019'>2019년</option>


	</select>

	<%
		out.println("<select name = 'month'>");
		out.println("<option value = 'every' selected>모두 선택</option>");

		for (int i = 1; i < 13; i++) {
			out.println("<option value = " + i + ">" + i + "월</option>");
		}

		out.println("</select>");
	%>

	<input type='submit' value='검색'></input>
	</form>
	<br>
	<br>

	<iframe width="600" height="300" scrolling="yes" id="ListHere"></iframe>




</body>
</html>