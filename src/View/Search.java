package View;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;


public class Search {
	public static final String URL = "jdbc:oracle:thin:@localhost:1600:xe";
	public static final String USER_KNU = "knu";
	public static final String USER_PASSWD = "comp322";
	public static final String TABLE_NAME = "TEST";

	
	private static Connection conn;
	private static Statement stmt;
	
	private static String MID;
	
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
				MID = rs.getString(1);
				SResult.add("<option value = \"" + MID + "\">"+rs.getString(2)+"</option>");
			}
			
			rs.close();
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}

		return SResult;
	}
}
