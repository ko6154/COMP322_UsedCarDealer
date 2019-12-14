<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>비밀번호수정</title>
</head>
<body>
<form action = "RChangePassComplete.jsp" method = "POST">
	<script>
		function isSame() {
			if (pw.value != '' && pwc.value != '') {
				if ((pw.value) == (pwc.value)) {
					document.getElementById('same').innerHTML = '비밀번호가 일치합니다.';
					document.getElementById('same').style.color = 'blue';
				} else {
					document.getElementById('same').innerHTML = '비밀번호가 일치하지 않습니다.';
					document.getElementById('same').style.color = 'red';
				}
			}

		}
	</script>
	<table>
		<tr height="30">
			<td width="15%">현재 비밀번호</td>
			<td><input type="password" name="nowPw" id="npw"></td>
		</tr>
		<tr height="7"></tr>
		<tr height="30">
			<td width="15%">새 비밀번호</td>
			<td><input type="password" name="UserPW" id="pw"
				onchange="isSame()"></td>
		</tr>
		<tr height="30">
			<td width="15%">비밀번호 확인</td>
			<td><input type="password" name="UserPWcheck" id="pwc" onchange="isSame()">&nbsp<span id="same"></span></td>
		</tr>
	</table>

	<br>
	<br>
	<input type='submit' value='수정'>
	<input type='button' value='취소' onclick='history.back();'>
</form>
</body>
</html>