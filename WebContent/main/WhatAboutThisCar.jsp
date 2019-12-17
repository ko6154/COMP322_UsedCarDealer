<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>거래내역</title>
</head>
<body>
	<jsp:useBean id="DB" class="View.DB" scope="application" />
	<jsp:setProperty name="DB" property="*" />

	<%
		Connection conn = DB.getConn();

		ResultSet rs;
		PreparedStatement pstmt;
	%>

	<table>
		<tr align="center">
			<td>이런 차는 어때요?</td>
		</tr>
		<tr>
			<td>차량 번호</td>
			<td>색상</td>
			<td>연료</td>
			<td>배기량</td>
			<td>변속기</td>
			<td>연식</td>
			<td>주행거리</td>
		</tr>

		<tr>
			<%
				String query = "select sex from account where id ='" + session.getAttribute("ID") + "'";
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				rs.next();
				String sex = rs.getString("sex");
				System.out.println(sex);
				if (sex == null) {
					out.println("<td>input all your inforamtion.</td>");
				} else {
					query = "select v.vid, c.color_name, v.CC, t.TNAME, v.MODEL_YEAR, v.MILEAGE, fl.fname, p.pid from vehicle v, post p, transmission t, color c, seems s, fuse fs, fuel fl"
							+ " where rownum = 1 and v.model_id in (select model_id from (select v.model_id, count(*) SP from vehicle v, buy_car b, account a, post p where a.id = b.buyer and a.sex = '"
							+ sex + "' and b.post = p.pid and v.vid = p.vid group by v.model_id ORDER BY SP DESC)"
							+ " where rownum = 1) and v.vid = p.vid and p.valid = 'v'"
							+ " and v.tid = t.tid AND s.vid = v.vid AND s.color_id = c.color_id and fs.vid = v.vid and fs.fid = fl.fid "
							+ " order by p.u_date desc";

					try {
						pstmt = conn.prepareStatement(query);
						rs = pstmt.executeQuery();
						String output = "";
						ArrayList<String> colors = new ArrayList<>();
						ArrayList<String> fuels = new ArrayList<>();
						String output2 = "";

						while (rs.next()) {

							String vid = rs.getString(1);
							String color = rs.getString(2);
							String CC = rs.getString(3);
							String Tname = rs.getString(4);
							String MODEL_YEAR = rs.getString(5).substring(0, 10);
							String MILEAGE = rs.getString(6);
							String fuel = rs.getString(7);
							String pid = rs.getString(8);

							output = "<td>" + "<a href = '../view/view.jsp?id=" + pid + "'>" + vid +  "</a>"+"</td>";
							output2 = "<td>" + CC + "</td><td>" + Tname + "</td><td>" + MODEL_YEAR + "</td><td>" + MILEAGE;
							if (!colors.contains(color))
								colors.add(color);

							if (!fuels.contains(fuel))
								fuels.add(fuel);
						}

						out.println(output + "<td>" + colors.toString() + "</td>" + "<td>" + fuels.toString() + "</td>"
								+ output2);
						rs.close();

					} catch (SQLException ex2) {
						System.err.println("sql error = " + ex2.getMessage());
						System.exit(1);
					}
				}
			%>

		</tr>

		<tr>
			<%
				query = "select vehicle.vid, color_name, CC, TNAME, MODEL_YEAR, MILEAGE, fname, pid from post, vehicle, transmission, color, seems, fuse, fuel where rownum = 1"
						+ " AND post.vid = vehicle.vid AND vehicle.tid = transmission.tid AND seems.vid = vehicle.vid AND seems.color_id = color.color_id and fuse.vid = vehicle.vid and fuse.fid = fuel.fid"
						+ " ORDER BY post.U_date asc";
			try {
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				String output = "";
				ArrayList<String> colors = new ArrayList<>();
				ArrayList<String> fuels = new ArrayList<>();
				String output2 = "";

				while (rs.next()) {

					String vid = rs.getString(1);
					String color = rs.getString(2);
					String CC = rs.getString(3);
					String Tname = rs.getString(4);
					String MODEL_YEAR = rs.getString(5).substring(0, 10);
					String MILEAGE = rs.getString(6);
					String fuel = rs.getString(7);
					String pid = rs.getString(8);

					output = "<td>" + "<a href = '../view/view.jsp?id=" + pid + "'>" + vid +  "</a>"+"</td>";
					output2 = "<td>" + CC + "</td><td>" + Tname + "</td><td>" + MODEL_YEAR + "</td><td>" + MILEAGE;
					if (!colors.contains(color))
						colors.add(color);

					if (!fuels.contains(fuel))
						fuels.add(fuel);
				}

				out.println(output + "<td>" + colors.toString() + "</td>" + "<td>" + fuels.toString() + "</td>"
						+ output2);
				rs.close();

			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
				System.exit(1);
			}
			%>
		</tr>

		<tr>
			<%
				query = "select vehicle.vid, color_name, CC, TNAME, MODEL_YEAR, MILEAGE, fname, pid from post, vehicle, transmission, color, seems, fuse, fuel where rownum = 1"
						+ " AND post.vid = vehicle.vid AND vehicle.tid = transmission.tid AND seems.vid = vehicle.vid AND seems.color_id = color.color_id and fuse.vid = vehicle.vid and fuse.fid = fuel.fid"
						+ " ORDER BY post.U_date desc";
			try {
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				String output = "";
				ArrayList<String> colors = new ArrayList<>();
				ArrayList<String> fuels = new ArrayList<>();
				String output2 = "";

				while (rs.next()) {

					String vid = rs.getString(1);
					String color = rs.getString(2);
					String CC = rs.getString(3);
					String Tname = rs.getString(4);
					String MODEL_YEAR = rs.getString(5).substring(0, 10);
					String MILEAGE = rs.getString(6);
					String fuel = rs.getString(7);
					String pid = rs.getString(8);

					output = "<td>" + "<a href = '../view/view.jsp?id=" + pid + "'>" + vid +  "</a>"+"</td>";
					output2 = "<td>" + CC + "</td><td>" + Tname + "</td><td>" + MODEL_YEAR + "</td><td>" + MILEAGE;
					if (!colors.contains(color))
						colors.add(color);

					if (!fuels.contains(fuel))
						fuels.add(fuel);
				}

				out.println(output + "<td>" + colors.toString() + "</td>" + "<td>" + fuels.toString() + "</td>"
						+ output2);
				rs.close();

			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
				System.exit(1);
			}
			%>




		</tr>


	</table>

</body>
</html>