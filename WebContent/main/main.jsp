<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<script>
	var before_MKchange = "MKHD0001";
	var before_MDchange = "null";
	var changed_MID;
	var on = 0;
	function deepCopy(obj) {
		if (obj === null || typeof(obj) !== "object") {
			return obj;
		}
		    
		let copy = {};
		for(let key in obj) {
			copy[key] = deepCopy(obj[key]);
		}
		return copy;
	}

	function changed(){
	    var langSelect = document.getElementById("maker");
	    
	    changed_MID = langSelect.options[langSelect.selectedIndex].value;
	    
	    document.getElementById(changed_MID).style.display = "block";
	    document.getElementById(before_MKchange).style.display = "none";
	    before_MKchange = deepCopy(changed_MID);
	    
	    if (on == 2)
	   {
	    	change_dm();
	    	on = 1;
	   }
	}
	
	function change_dm(){
		on = 2;
	    var langSelect = document.getElementById("MD"+changed_MID);
	    var changed_MDID = langSelect.options[langSelect.selectedIndex].value;
	    
	    alert(changed_MDID+"/"+before_MDchange);
	    
	    document.getElementById(changed_MDID).style.display = "block";
	    document.getElementById(before_MDchange).style.display = "none";
	    
	    before_MDchange = deepCopy(changed_MDID);
	    
	}
	
	function send(){
	    
	   	if(before_MDchange == "null"){
	   		location.replace("../search/search.jsp?maker="+before_MKchange);	
	    }
	    
	   	else if (on == 1){
	   		location.href("../search/search.jsp?maker="+before_MKchange+"&model="+before_MDchange);
		}
		else if(on == 2){
			var langSelect = document.getElementById("DM"+before_MDchange);
		    var DMID = langSelect.options[langSelect.selectedIndex].value;
		    location.href("../search/search.jsp?maker="+before_MKchange+"&model="+before_MDchange+"&d_model="+DMID);
		}
	}
</script>
<title>Main</title>
</head>
<body>
<%
	String ID = (String)session.getAttribute("ID");
	String auth = (String)session.getAttribute("AUTH"); 
	
	out.print("<div align = 'left'>"+ ID +" 님 환영합니다." + "</div>");
	
	
	//개인정보 보여주기
	out.print("<div align = 'right'><a href = '../mypage/MyPage.html'> 마이페이지 </a></div>");
	out.print("<div align = 'right'><a href = '../login/logout.jsp'> 로그아웃 </a></div>");
	if(auth.equals("M")) {
		out.print("<div align = 'right'><a href = '../car_management/CarManagement.html' style='color:red'> 관리자페이지 </a></div>");
	}
%>
<hr>
<div id = 'null' style = 'display:none'></div>
<%@ page import="View.Search" %>

<%
	//검색하기	
	Search search = new Search();
	out.println("<form action = \"../search/search.jsp\" method = \"GET\">");
	out.println("<select id = 'maker' onchange='changed()'>");
	   
	for (String mname : search.GetMaker() ){
		out.println(mname);
	}
	out.println("</select>");
	
	for (String model_name : search.GetModel()){
		out.println(model_name);
	}
	
	for (String dm_name : search.GetDModel()){
		out.println(dm_name);
	}
	out.println("</form>");
	out.println("<button onclick = 'send()'>검색</button>");
	
	//세부사항 검색
	
	out.println("<form action = \"../search/detail_search.jsp\" method = \"POST\">");
	for (String detail : search.detail_view()){
		out.println(detail);
	}
	out.println("<input type = \"submit\" value = \"검색\">");
	out.println("</form>");
	
%>

<hr>
매물<br>
<table>

<%
	
	for (String post : search.GetPost()){
		out.println("<tr>");
		out.println(post);
		out.println("</tr>");
	}	

%>
</table>

</body>
</html>