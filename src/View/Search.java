package View;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;


public class Search {
	public static final String URL = "jdbc:oracle:thin:@localhost:1600:xe";
	public static final String USER_KNU = "knu";
	public static final String USER_PASSWD = "comp322";
	public static final String TABLE_NAME = "TEST";

	
	private static Connection conn;
	private static Statement stmt;
	
	private static ArrayList<String> MID = new ArrayList<>();
	private static ArrayList<String> MODEL_ID = new ArrayList<>();
	
	public Search() {
		try {
			// Load a JDBC driver for Oracle DBMS
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// Get a Connection object
			System.out.println("Success!");
		} catch (ClassNotFoundException e) {
			System.err.println("error = " + e.getMessage());
			System.exit(1);
		}

		// Make a connection
		try {
			conn = DriverManager.getConnection(URL, USER_KNU, USER_PASSWD);
		} catch (SQLException ex) {
			System.err.println("Cannot get a connection: " + ex.getMessage());
			System.exit(1);
		}
		try {
			conn.setAutoCommit(false); // auto-commit disabled
			// Create a statement object
			stmt = conn.createStatement();

		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}
	}

	public ArrayList<String> GetMaker() {

		ArrayList<String> SResult = new ArrayList<>();
		ResultSet rs;
		

		String sql = "select mid, mname from maker";
		
		try {
			rs = stmt.executeQuery(sql);

			while (rs.next()) {
				MID.add(rs.getString(1));
				SResult.add("<option value = \"" + MID.get(MID.size() - 1) + "\">"+rs.getString(2)+"</option>");
			}
			
			rs.close();
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}

		return SResult;
	}
	
	public ArrayList<String> GetModel() {

		ArrayList<String> SResult = new ArrayList<>();
		ResultSet rs;
		
		for(String mid : MID) {
			String sql = "select distinct model_id, model_name from model, maker where model.mid = '" + mid + "'";
			
			SResult.add("<div id = '"+ mid +"' style = 'display:none'><select id = 'MD" + mid + "'  onchange = 'change_dm()'><option disabled selected value value = ''> -- select an option -- </option>");
			
			try {
				rs = stmt.executeQuery(sql);
				
				while (rs.next()) {
					MODEL_ID.add(rs.getString(1));
					SResult.add("<option value = \"" + MODEL_ID.get(MODEL_ID.size() - 1) + "\">"+rs.getString(2)+"</option>");
				}
				
				rs.close();
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
				System.exit(1);
			}
			
			SResult.add("</select></div>");
		}
		
		return SResult;
	}
	
	public ArrayList<String> GetDModel() {

		ArrayList<String> SResult = new ArrayList<>();
		ResultSet rs;
		
		for(String dm : MODEL_ID) {
			String sql = "select distinct DM_ID, DM_NAME from detailed_model where model_id = '" + dm + "'";
			
			SResult.add("<div id = '"+ dm +"' style = 'display:none'><select id = DM"+ dm + "><option disabled selected value value = ''> -- select an option -- </option>");
			
			try {
				rs = stmt.executeQuery(sql);
				
				while (rs.next()) {
					SResult.add("<option value = \"" + rs.getString(1) + "\">"+rs.getString(2)+"</option>");
				}
				
				rs.close();
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
				System.exit(1);
			}
			 
			SResult.add("</select></div>");
		}	
		
		return SResult;
	}
	
	public static ArrayList<String> GetPost(){

		ArrayList<String> SResult = new ArrayList<>();
		String sql;
		ResultSet rs;
		int no = 1;

		sql = "select title, MODEL_NAME, DM_NAME, price, U_ID, U_DATE, pid "
				+ "from model, detailed_model, vehicle, post "
				+ "where vehicle.vid = post.vid AND vehicle.DM_ID = detailed_model.DM_ID AND vehicle.MODEL_ID = model.MODEL_ID AND valid = 'v' order by U_ID";

		try {
			rs = stmt.executeQuery(sql);

			while (rs.next()) {

				String title = rs.getString(1);
				String MNAME = rs.getString(2);
				String DMNAME = rs.getString(3);
				int price = rs.getInt(4);
				String U_ID = rs.getString(5);
				String U_DATE = rs.getString(6).substring(0, 10);
				String pid = rs.getString(7);

				
				SResult.add("<td>"+Integer.toString(no) + " : <a href = '../view/view.jsp?id=" + pid + "'>" + title + "</a></td><td>" + MNAME + "</td><td>" + DMNAME + "</td><td>"
						+ Integer.toString(price) + "</td><td>" + U_ID + "</td><td>" + U_DATE + "</td>");
				no++;
			}
			rs.close();
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}
		return SResult;
	}
	
	public ArrayList<String> GetPostMaker(String maker) {

		ArrayList<String> SResult = new ArrayList<>();
		ResultSet rs;
		int no = 1;
		String sql;

		sql = "select title, MODEL_NAME, DM_NAME, price, U_ID, U_DATE, pid "
				+ "from model, detailed_model, vehicle, post, maker " + "where vehicle.vid = post.vid "
				+ "AND vehicle.DM_ID = detailed_model.DM_ID AND vehicle.MODEL_ID = model.MODEL_ID AND valid = 'v' "
				+ "AND vehicle.mid = maker.mid AND maker.mid = '" + maker + "'";

		try {
			rs = stmt.executeQuery(sql);

			while (rs.next()) {

				String title = rs.getString(1);
				String MNAME = rs.getString(2);
				String DMNAME = rs.getString(3);
				int price = rs.getInt(4);
				String U_ID = rs.getString(5);
				String U_DATE = rs.getString(6).substring(0, 10);
				String pid = rs.getString(7);

				SResult.add("<td>"+Integer.toString(no) + " : <a href = '../view/view.jsp?id=" + pid + "'>" + title + "</a></td><td>" + MNAME + "</td><td>" + DMNAME + "</td><td>"
						+ Integer.toString(price) + "</td><td>" + U_ID + "</td><td>" + U_DATE + "</td>");
				no++;
			}
			System.out.println("");
			rs.close();
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}

		return SResult;

	}
	
	public ArrayList<String> GetName(String model, String dmodel) throws SQLException {

		ArrayList<String> SResult = new ArrayList<>();

		String sql;
		ResultSet rs;

		int no = 1;


		if (dmodel.equals(""))// 세부모델을 넣지 않았을 경우
			sql = "select title, MODEL_NAME, DM_NAME, price, U_ID, U_DATE, pid from model, detailed_model, vehicle, post where vehicle.vid = post.vid AND vehicle.dm_id = detailed_model.dm_id AND vehicle.model_id = model.model_id AND vehicle.MODEL_ID = '"
					+ model + "' AND valid = 'v'";

		else// 세부 모델을 넣은 경우
			sql = "select title, MODEL_NAME, DM_NAME, price, U_ID, U_DATE, pid from model, detailed_model, vehicle, post where vehicle.vid = post.vid AND vehicle.dm_id = detailed_model.dm_id AND vehicle.model_id = model.model_id AND vehicle.MODEL_ID = '"
					+ model + "' AND vehicle.DM_ID = '" + dmodel + "' AND valid = 'v'";

		try {
			rs = stmt.executeQuery(sql);

			while (rs.next()) {

				String title = rs.getString(1);
				String MNAME = rs.getString(2);
				String DMNAME = rs.getString(3);
				int price = rs.getInt(4);
				String U_ID = rs.getString(5);
				String U_DATE = rs.getString(6).substring(0, 10);
				String pid = rs.getString(7);

				SResult.add("<td>"+Integer.toString(no) + " : <a href = '../view/view.jsp?id=" + pid + "'>" + title + "</a></td><td>" + MNAME + "</td><td>" + DMNAME + "</td><td>"
						+ Integer.toString(price) + "</td><td>" + U_ID + "</td><td>" + U_DATE + "</td>");
				no++;

			}
			rs.close();
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}

		return SResult;
	}
	
	public ArrayList<String> View(String PID) {
		
		ArrayList<String> SResult = new ArrayList<>();
		
		ResultSet rs;
		String command;
		String sql = "";

		// 모델 세부사항 확인
		sql = "select vehicle.vid, color_name, CC, TNAME, MODEL_YEAR, MILEAGE from post, vehicle, transmission, color, seems where post.pid = '"
				+ PID
				+ "' AND post.vid = vehicle.vid AND vehicle.tid = transmission.tid AND seems.vid = vehicle.vid AND seems.color_id = color.color_id";

		try {
			rs = stmt.executeQuery(sql);
			String output = "";
			String colors = "";
			String output2 = "";
			while (rs.next()) {

				String vid = rs.getString(1);
				String color = rs.getString(2);
				String CC = rs.getString(3);
				String Tname = rs.getString(4);
				String MODEL_YEAR = rs.getString(5).substring(0, 10);
				String MILEAGE = rs.getString(6);

				output = "<td>"+ vid + "</td>";
				output2 = "<td>" + CC + "</td><td>" + Tname + "</td><td>" + MODEL_YEAR + "</td><td>" + MILEAGE;
				colors = "<td>" + colors + color + "</td>";

			}
			SResult.add(output + colors + output2);
			rs.close();
			
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}

		return SResult;
	}
	public boolean Buy_Car(String ID, String pid) {

		
		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
		Date time = new Date();

		String now = format1.format(time);

		String sql = "INSERT into buy_car values('" + ID + "', '" + pid + "', to_date('" + now
					+ "', 'yyyy-mm-dd'))";

		try {
			stmt.executeQuery(sql);
			System.out.println("구매 완료");

			sql = "UPDATE POST SET valid = 'u' where pid = '" + pid + "'";
			stmt.executeQuery(sql);
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public ArrayList<String> detail_view() throws SQLException {
		
		String sql;
		ResultSet rs;
		
		ArrayList<String> SResult = new ArrayList<>();

		sql = "select cname from category";

		rs = stmt.executeQuery(sql);
		SResult.add("<select name = 'category'><option disabled selected value value = ''> -- select an option -- </option>");
		while (rs.next())
			SResult.add("<option value = \"" + rs.getString(1) +"\">"+rs.getString(1) + "</option>");

		rs.close();
		SResult.add("</select>");
		
		sql = "select distinct color_name from color";

		rs = stmt.executeQuery(sql);
		SResult.add("<select name = 'color'><option disabled selected value value = ''> -- select an option -- </option>");
		while (rs.next())
			SResult.add("<option value = \"" + rs.getString(1) +"\">"+rs.getString(1) + "</option>");

		rs.close();
		SResult.add("</select>");

		sql = "select fname from fuel";

		rs = stmt.executeQuery(sql);
		SResult.add("<select name = 'fuel'><option disabled selected value value = ''> -- select an option -- </option>");
		while (rs.next())
			SResult.add("<option value = \"" + rs.getString(1) +"\">"+rs.getString(1) + "</option>");

		rs.close();
		SResult.add("</select>");

		sql = "select tname from transmission";

		rs = stmt.executeQuery(sql);
		SResult.add("<select name = 'transmission'><option disabled selected value value = ''> -- select an option -- </option>");
		while (rs.next())
			SResult.add("<option value = \"" + rs.getString(1) +"\">"+rs.getString(1) + "</option>");

		rs.close();
		SResult.add("</select>");
		
		sql = "select cc from engine_displacement";

		rs = stmt.executeQuery(sql);
		SResult.add("<select name = 'engine'><option disabled selected value value = ''> -- select an option -- </option>");
		while (rs.next())
			SResult.add("<option value = \"" + rs.getString(1) +"\">"+rs.getString(1) + "</option>");

		rs.close();
		SResult.add("</select>");
		
		return SResult;
	}
	public ArrayList<String> search_detail() throws SQLException {
		
		String sql;
		ResultSet rs;
		
		ArrayList<String> SResult = new ArrayList<>();
		ArrayList<String> opt = new ArrayList<>();

		

		sql = "select distinct title, model_name, dm_name, price, U_ID, U_DATE, pid from (((((((seems join (post join vehicle on post.vid = vehicle.vid) on seems.vid = post.vid) join color on seems.color_id = color.color_id) join category on category.cid = vehicle.cid) join fuse on fuse.vid = vehicle.vid) join transmission on transmission.tid = vehicle.tid) join fuel on fuel.fid = fuse.fid) join model on model.model_id = vehicle.model_id) join detailed_model on detailed_model.dm_id = vehicle.dm_id where ";
		for (String row : opt) {
			sql += row + " AND ";
		}

		sql = sql.substring(0, sql.length() - 4);

		rs = stmt.executeQuery(sql);

		int no = 1;

		while (rs.next()) {
			String title = rs.getString(1);
			String MNAME = rs.getString(2);
			String DMNAME = rs.getString(3);
			int price = rs.getInt(4);
			String U_ID = rs.getString(5);
			String U_DATE = rs.getString(6).substring(0, 10);
			String pid = rs.getString(7);

			SResult.add(pid);

			System.out.println(Integer.toString(no) + " : " + title + "\t" + MNAME + "\t" + DMNAME + "\t"
					+ Integer.toString(price) + "\t" + U_ID + "\t" + U_DATE);
			no++;

		}

		return SResult;

	}
}
