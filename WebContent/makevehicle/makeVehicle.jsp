<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR" import="View.Search, java.sql.*"  %>
<!DOCTYPE html>
<html>
<head>
    <title>������� �� ���� ȭ��</title>
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
    
        
        // ��� ��ư Ŭ���� ������ ��� ȭ������ �̵� 
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
    
    function whenSuccess(resdata){	//ajax return ������
        $("#ajaxReturn").html(resdata);
        console.log(resdata);
    }

    function whenError(){
        alert("Error");
    }
  </script>
    
  
    
    <script>
    function goFirstForm() {
    	location.replace("../login/login.html")		/// ������ ��� �������� �̵�
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

	    changed_MID = langSelect.options[langSelect.selectedIndex].value;	// �������� �ٲ� ���� select

	    document.getElementById(changed_MID).style.display = "block";		// �ٲ� �������� ���� ǥ��
	    document.getElementById(before_MKchange).style.display = "none";	// �ٲ���� �������� ���� ����
	    
	    before_MKchange = changed_MID;
	    
	    Update_True();
	  }
	
	function change_dm(){
		on = 2;
	    var langSelect = document.getElementById("MD"+changed_MID);
	    var changed_MDID = langSelect.options[langSelect.selectedIndex].value;	// �������� �ٲ� ���θ��� select
	    
	    
	    document.getElementById(changed_MDID).style.display = "block";			// �ٲ� ���θ��� ǥ��
	    if(before_MDchange != "null")
	   	 document.getElementById(before_MDchange).style.display = "none";		// �ٲ���� ���θ��� ����
		
	    before_MDchange = changed_MDID;
	    Update_True();
	}
	
	
    </script>
    
    <script>
    function updateDB()					// db�� ������Ʈ�ϴ� �Լ�
    {
    }
    </script>
    
</head>
<jsp:useBean id="DB" class="View.DB" scope = "application"/>
<jsp:setProperty name = "DB" property="*"/>

<body>
        <br><br>
        <b><font size="6" color="gray">������� �� ����</font></b>
        <br><br><br>
        
       
        <form method="post" action="registVehicle.jsp" 
                name="carInfo" >
            <table>
                <tr>
                    <td class="title">������ȣ</td>
                    <td>
                        <input type="text" id="vid" name="vid" maxlength="8" onChange="callAjax();" >
                        <a id="ajaxReturn"></a>
                    </td>
                </tr>
                <tr>
                    <td class="title">������</td>
                    <td>
                    <%
					//�˻��ϱ�	
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
                    <td class="title">��</td>
                    <td>
                    <%
                    for (String model_name : search.GetModel()){
					out.println(model_name);
					}%>
                    </td>
                </tr>
                <tr>
                    <td class="title">���θ�</td>
                    <td><%
                    for (String dm_name : search.GetDModel()){
					out.println(dm_name);
					}%>
                    </td>
                </tr>
                <tr>
                    <td class="title">���</td>
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
                    <td class="title">���</td>
                    <td>
                     <input type="radio" id="transmission" name="transmission" value="TMMN0001" checked>�ڵ�
                     <input type="radio" id="transmission" name="transmission" value="TMAT0002" >����
                     <input type="radio" id="transmission" name="transmission" value="TMDC0003" >DCT
                    </td>
                </tr>
                <tr>
                    <td class="title">����</td>
                    <td>
                    	<input type="date" name="caryear" value="xxx" min="yyy" max="zzz">
                    </td>
                </tr>
                   
                    
                <tr>
                    <td class="title">����Ÿ�</td>
                    <td>
                    <input type="text" id="mileage" name="mileage"  maxlength="6" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
					</td>
                </tr>
               <tr>
                    <td class="title">����</td>
                    <td>
                    <input type="text" id="price" name="price"  maxlength="10" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
					</td>
                </tr>
                <tr>
                    <td class="title">����</td>
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
                            <option value="null">����</option>
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
                    <input type="radio" id="coating" name="coating" value="N" checked>�Ϲ�
                     <input type="radio" id="coating" name="coating" value="Y" >����
                    </td>
                </tr>
                <tr>
                    <td class="title">����</td>
                    <td>
                    <select id="fuel1" name="fuel1">
                            <option value="FUGS0001">���ָ�</option>
                            <option value="FUDI0002" >����</option>
                            <option value="FUEL0003" >����</option>
                            <option value="FULP0004" >LPG</option>
                            <option value="FUHY0005" >����</option>
                    </select>
                    / <select id="fuel2" name="fuel2">
                            <option value="null">����</option>
                            <option value="FUEL0003" >����</option>
                            <option value="FULP0004" >LPG</option>
                            <option value="FUHY0005" >����</option>
                    </select>
					</td>
                </tr>
            </table>
            <input id="True_Maker" name="True_Maker" style="display:none" value=""/>
            <input id="True_Model" name="True_Model" style="display:none" value=""/>
            <input id="True_DModel" name="True_DModel" style="display:none" value=""/>
            <br>
            <!--<input type="button" value="����" onclick="updateDB()">-->  
            <input type="submit" value="���">  
            <input type="button" value="���" onclick="goFirstForm()">
        </form>
</body>

</html>
