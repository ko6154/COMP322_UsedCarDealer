<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>��й�ȣ����</title>
</head>
<body>
<form action = "RChangePassComplete.jsp" method = "POST">
	<script>
		function isSame() {
			if (pw.value != '' && pwc.value != '') {
				if ((pw.value) == (pwc.value)) {
					document.getElementById('same').innerHTML = '��й�ȣ�� ��ġ�մϴ�.';
					document.getElementById('same').style.color = 'blue';
				} else {
					document.getElementById('same').innerHTML = '��й�ȣ�� ��ġ���� �ʽ��ϴ�.';
					document.getElementById('same').style.color = 'red';
				}
			}

		}
	</script>
	<table>
		<tr height="30">
			<td width="15%">���� ��й�ȣ</td>
			<td><input type="password" name="nowPw" id="npw"></td>
		</tr>
		<tr height="7"></tr>
		<tr height="30">
			<td width="15%">�� ��й�ȣ</td>
			<td><input type="password" name="UserPW" id="pw"
				onchange="isSame()"></td>
		</tr>
		<tr height="30">
			<td width="15%">��й�ȣ Ȯ��</td>
			<td><input type="password" name="UserPWcheck" id="pwc" onchange="isSame()">&nbsp<span id="same"></span></td>
		</tr>
	</table>

	<br>
	<br>
	<input type='submit' value='����'>
	<input type='button' value='���' onclick='history.back();'>
</form>
</body>
</html>