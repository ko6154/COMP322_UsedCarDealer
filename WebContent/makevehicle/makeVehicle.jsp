<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="View.Search, java.sql.*"  %>
<!DOCTYPE html>
<html>
<head>
    <title>차량등록 및 수정 화면</title>
    <meta charset="EUC-KR">
    <style type="text/css">
        table{
            margin-left:auto; 
            margin-right:auto;
            border:3px solid skyblue;
        }
        
        td{
            border:1px solid skyblue
        }
        
        .title{
            background-color:skyblue
        }
   </style>
 
    <script type="text/javascript">
    
        
        // 취소 버튼 클릭시 관리자 기능 화면으로 이동 
        function goFirstForm() {
            location.href="../login/login.html";
        }    
       
        
   </script>
    <script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script type="text/javascript">
    $(document).ready(function(){
      $("#id").change(function(){
          callAjax();
      });
    });

    function callAjax(){
        $.ajax({
	        type: "post",
	        url : "./vid_check.jsp",
	        data: {
       			vid:  $('#vid').val()
	        },
	        success: whenSuccess,
	        error: whenError
     	});
    }
    
    function whenSuccess(resdata){	//ajax return 성공후
        $("#ajaxReturn").html(resdata);
        console.log(resdata);
    }

    function whenError(){
        alert("Error");
    }
  </script>
    
  
    
    <script>
    function goFirstForm() {
    	location.replace("../login/login.html")		/// 관리자 기능 페이지로 이동
    }
    </script>
    
    <script>
    var before_MKchange = "MKHD0001";
	var before_MDchange = "null";
	var changed_MID;
	var on = 0;
	
	function Update_True() {
		var Maker = document.getElementById("True_Maker");
		var Model = document.getElementById("True_Model");
		var DModel = document.getElementById("True_DModel");
		var temp;
		
		
		var Select1 = document.getElementById("maker");
		temp = Select1.options[Select1.selectedIndex].value;
		Maker.value = temp;
		
		//alert("MID:"+changed_MID);
		var Select2 = document.getElementById("MD"+changed_MID);
		temp = Select2.options[Select2.selectedIndex].value;
		Model.value=temp;
		
		//alert("MDID:"+MDID);
		var Select3 = document.getElementById("DM"+before_MDchange);
		temp = Select3.options[Select3.selectedIndex].value;
		DModel.value=temp;
	}
	
    function changed(){
		on = 1;
	    var langSelect = document.getElementById("maker");

	    changed_MID = langSelect.options[langSelect.selectedIndex].value;	// 눌렀을때 바뀐 모델의 select

	    document.getElementById(changed_MID).style.display = "block";		// 바뀐 제조사의 모델을 표시
	    document.getElementById(before_MKchange).style.display = "none";	// 바뀌기전 제조사의 모델을 숨김
	    
	    before_MKchange = changed_MID;
	    
	    Update_True();
	  }
	
	function change_dm(){
		on = 2;
	    var langSelect = document.getElementById("MD"+changed_MID);
	    var changed_MDID = langSelect.options[langSelect.selectedIndex].value;	// 눌렀을때 바뀐 세부모델의 select
	    
	    
	    document.getElementById(changed_MDID).style.display = "block";			// 바뀐 세부모델을 표시
	    if(before_MDchange != "null")
	   	 document.getElementById(before_MDchange).style.display = "none";		// 바뀌기전 세부모델을 숨김
		
	    before_MDchange = changed_MDID;
	    Update_True();
	}
	
	
    </script>
    
    <script>
    function updateDB()					// db를 업데이트하는 함수
    {
    }
    </script>
    
</head>
<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<body>
        <br><br>
        <b><font size="6" color="gray">차량등록 및 수정</font></b>
        <br><br><br>
        
       
        <form method="post" action="registVehicle.jsp" 
                name="carInfo" >
            <table>
                <tr>
                    <td class="title">차량번호</td>
                    <td>
                        <input type="text" id="vid" name="vid" maxlength="8" onChange="callAjax();" >
                        <a id="ajaxReturn"></a>
                    </td>
                </tr>
                <tr>
                    <td class="title">제조사</td>
                    <td>
                    <%
					//검색하기	
					Search search = new Search(DB.getConn());
					out.println("<select id = 'maker' onchange='changed()'>");
					   
					for (String mname : search.GetMaker() ){
						out.println(mname);
					}
					out.println("</select>");
					%>
                    </td>
                </tr>
                <tr>
                    <td class="title">모델</td>
                    <td>
                    <%
                    for (String model_name : search.GetModel()){
					out.println(model_name);
					}%>
                    </td>
                </tr>
                <tr>
                    <td class="title">세부모델</td>
                    <td><%
                    for (String dm_name : search.GetDModel()){
					out.println(dm_name);
					}%>
                    </td>
                </tr>
                <tr>
                    <td class="title">출력</td>
                    <td>
                    <select id="CC" name="CC">
                    		<option value="1500">------</option>
                            <option value="1500">1500cc</option>
                            <option value="2000" >2000cc</option>
                            <option value="2500" >2500cc</option>
                            <option value="3000" >3000cc</option>
                            <option value="3500" >3500cc</option>
                    </select>
                    </td>
                </tr>
                <tr>
                    <td class="title">기어</td>
                    <td>
                     <input type="radio" id="transmission" name="transmission" value="TMMN0001" checked>자동
                     <input type="radio" id="transmission" name="transmission" value="TMAT0002" >수동
                     <input type="radio" id="transmission" name="transmission" value="TMDC0003" >DCT
                    </td>
                </tr>
                <tr>
                    <td class="title">연식</td>
                    <td>
                    	<input type="date" name="caryear" value="xxx" min="yyy" max="zzz">
                    </td>
                </tr>
                   
                    
                <tr>
                    <td class="title">주행거리</td>
                    <td>
                    <input type="text" id="mileage" name="mileage"  maxlength="6" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
					</td>
                </tr>
               <tr>
                    <td class="title">가격</td>
                    <td>
                    <input type="text" id="price" name="price"  maxlength="10" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
					</td>
                </tr>
                <tr>
                    <td class="title">색상</td>
                    <td>
                    <select id="color1" name="color1">
                            <option value="Gray">Gray</option>
                            <option value="Black" >Black</option>
                            <option value="White" >White</option>
                            <option value="Red" >Red</option>
                            <option value="Orange" >Orange</option>
                            <option value="Yellow" >Yellow</option>
                            <option value="Green" >Green</option>
                            <option value="Blue" >Blue</option>
                            <option value="Navy" >Navy</option>
                            <option value="Purple" >Purple</option>
                    </select>
                    / <select id="color2" name="color2">
                            <option value="null">없음</option>
                            <option value="Gray">Gray</option>
                            <option value="Black" >Black</option>
                            <option value="White" >White</option>
                            <option value="Red" >Red</option>
                            <option value="Orange" >Orange</option>
                            <option value="Yellow" >Yellow</option>
                            <option value="Green" >Green</option>
                            <option value="Blue" >Blue</option>
                            <option value="Navy" >Navy</option>
                            <option value="Purple" >Purple</option>
                    </select>
                    <input type="radio" id="coating" name="coating" value="N" checked>일반
                     <input type="radio" id="coating" name="coating" value="Y" >코팅
                    </td>
                </tr>
                <tr>
                    <td class="title">연료</td>
                    <td>
                    <select id="fuel1" name="fuel1">
                            <option value="FUGS0001">가솔린</option>
                            <option value="FUDI0002" >디젤</option>
                            <option value="FUEL0003" >전기</option>
                            <option value="FULP0004" >LPG</option>
                            <option value="FUHY0005" >수소</option>
                    </select>
                    / <select id="fuel2" name="fuel2">
                            <option value="null">없음</option>
                            <option value="FUEL0003" >전기</option>
                            <option value="FULP0004" >LPG</option>
                            <option value="FUHY0005" >수소</option>
                    </select>
					</td>
                </tr>
            </table>
            <input id="True_Maker" name="True_Maker" style="display:none" value=""/>
            <input id="True_Model" name="True_Model" style="display:none" value=""/>
            <input id="True_DModel" name="True_DModel" style="display:none" value=""/>
            <br>
            <!--<input type="button" value="가입" onclick="updateDB()">-->  
            <input type="submit" value="등록">  
            <input type="button" value="취소" onclick="goFirstForm()">
        </form>
</body>

</html>
