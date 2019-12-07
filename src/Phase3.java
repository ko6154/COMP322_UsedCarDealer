
/**************************************************
 * Copyright (c) 2019 KNU DKE Lab. To Present
 * All rights reserved. 
 **************************************************/
// import JDBC package
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Scanner;

public class Phase3 {
	public static final String URL = "jdbc:oracle:thin:@localhost:1600:xe";
	public static final String USER_KNU = "knu";
	public static final String USER_PASSWD = "comp322";
	public static final String TABLE_NAME = "TEST";

	public static Scanner scanner;
	private static String ID = "";
	private static String pwd = "";
	private static String auth = "";

	public static void main(String[] args) throws SQLException {
		Connection conn = null; // Connection object
		Statement stmt = null; // Statement object
		String sql = ""; // an SQL statement

		scanner = new Scanner(System.in);
		int command = 0;
		int res;
		ResultSet rs;
		ResultSetMetaData rsmd;
		String data = "";
		ArrayList<String> Menu = new ArrayList<>();

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

		while (true) {

			// 로그인
			boolean login_flag = false;

			while (!login_flag) {

				System.out.println("MENU");
				System.out.println("로그인 : 1 \t회원가입 : 2\t종료 : 3");

				switch (command = Integer.parseInt(scanner.nextLine())) {

				// 로그인
				case 1:
					System.out.println("로그인");

					System.out.print("ID : ");
					ID = scanner.nextLine();

					System.out.print("PASSWORD : ");
					pwd = scanner.nextLine();

					int valid = 0;

					sql = "SELECT count(*), auth from account where id = '" + ID + "' AND password = '" + pwd
							+ "' group by auth";
					// System.out.println(sql);
					try {
						rs = stmt.executeQuery(sql);

						while (rs.next()) {
							valid = rs.getInt(1);
							auth = rs.getString(2);
						}
						rs.close();
					} catch (SQLException ex2) {
						System.err.println("sql error = " + ex2.getMessage());
						System.exit(1);
					}

					// 로그인 결과 확인
					if (valid != 1) {
						System.out.println("Unvalid ID");

						// command 입력을 다시 받는다
						command = 0;
					} else { // valid 할 경우 그대로 놔두면 로그인 while문 을 종료함
						System.out.println("로그인 성공");
						login_flag = true;
					}
					break;
				// 회원가입
				case 2:
					MakeAccount(conn, stmt);
					break;
				// 프로그램 종료
				case 3:
					System.exit(0);
					break;

				}
			}

			// 메뉴화면
			while (login_flag) {

				if (auth.equals("C")) {// 고객 메뉴
					System.out.println("MENU");
					System.out.println("마이페이지: 1 \t차량 검색: 2\t종료 : 3");
				}

				if (auth.equals("M")) {// 관리자 메뉴
					System.out.println("MENU");
					System.out.println("마이페이지: 1 \t차량 검색: 2\t종료 : 3\t차량관리 : 4");
				}

				switch (command = scanner.nextInt()) {

				case 1:
					if (MyPage(conn, stmt) == -1) {
						login_flag = false;
						scanner.nextLine();
					}
					break;

				// 차량 검색
				case 2:
					while (command != 0) {
						System.out.println("MENU");
						System.out.println("매물 확인: 1 \t제조사별 검색: 2\t이름 검색 : 3\t조건 검색: 4\t 뒤로 가기: 0");

						switch (command = scanner.nextInt()) {
						// 매물 보기
						case 1:

							Menu = GetPost(conn, stmt);
							Buy_Car(conn, stmt, Menu);
							break;

						// 제조사 검색
						case 2:

							Menu = GetMaker(conn, stmt);
							Buy_Car(conn, stmt, Menu);
							break;

						// 이름 검색
						case 3:

							Menu = GetName(conn, stmt);
							Buy_Car(conn, stmt, Menu);
							break;

						// 조건 검색
						case 4:
							Menu = search_detail(conn, stmt);
							Buy_Car(conn, stmt, Menu);
							break;

						// 메인 메뉴
						case 5:
							command = 0;
							break;

						// 종료
						case 6:
							System.exit(0);
							break;

						}

					}

					break;

				// 종료
				case 3:
					System.exit(0);
					break;

				// 관리자일 경우 차량 관리
				case 4:
					while (command != 0) {
						System.out.println("MENU");
						System.out.println(
								"매물 등록: 1\t정보 수정: 2\t 연료, 색상 수정: 3\t비공개 설정 : 4\t모든 거래내역 확인: 5\t 매출액 확인: 6\t 뒤로 가기: 0");

						switch (command = scanner.nextInt()) {
						// 매물 보기
						case 1:

							MakeVehicle(conn, stmt);
							break;

						// 정보수정
						case 2:
							ChangeVehicle(conn, stmt);

							break;

						case 3:
							ChangeColorFuel(conn, stmt);
							break;

						// 비공개 설정
						case 4:
							invalidationPost(conn, stmt);

							break;

						// 거래내역 확인
						case 5:
							AllOrderList(conn, stmt);
							break;

						// 매출액 확인
						case 6:
							see_profit(conn, stmt);
							break;

						}
						break;

					}

				}

			}

		}
	}

	public static void see_profit(Connection conn, Statement stmt) throws SQLException {

		String sql = "";
		String command;
		ResultSet rs;

		System.out.println("매출액 확인\n1 : 월별\t2연도별 : \t3 : 제조사별");

		scanner.nextLine();
		command = scanner.nextLine();

		switch (Integer.parseInt(command)) {

		case 1:

			System.out.print("월 입력 : ");

			sql = "select sum(price) from buy_car, post, vehicle where EXTRACT(month from sold_date) = '"
					+ scanner.nextLine() + "'  AND post.pid = buy_car.post AND post.vid = vehicle.vid";
			break;

		case 2:
			System.out.print("연도 입력 : (ex 2015)");
			sql = "select sum(price) from buy_car, post, vehicle where EXTRACT(year from sold_date) = '"
					+ scanner.nextLine() + "'  AND post.pid = buy_car.post AND post.vid = vehicle.vid";
			break;

		case 3:

			System.out.println("제조사 목록");

			sql = "select mname from maker";
			rs = stmt.executeQuery(sql);

			while (rs.next()) {

				String MNAME = rs.getString(1);

				System.out.print(MNAME + "\t");

			}
			System.out.println("");

			System.out.println("제조사 입력 : ");
			sql = "select sum(price) from buy_car, post, vehicle, maker where maker.mname = '" + scanner.nextLine()
					+ "' AND maker.mid = vehicle.mid AND post.pid = buy_car.post AND post.vid = vehicle.vid";

			break;

		}

		rs = stmt.executeQuery(sql);

		while (rs.next())
			System.out.println(rs.getString(1));

	}

	public static ArrayList<String> search_detail(Connection conn, Statement stmt) throws SQLException {

		ArrayList<String> SResult = new ArrayList<>();
		ArrayList<String> opt = new ArrayList<>();

		String sql;
		String command;
		ResultSet rs;

		scanner.nextLine();

		System.out.println("카테고리 선택. 여러개 선택 가능합니다(ex 1 3 4)\n" + "1 : 차종\t2 : 색\t3 : 연료\t4 : 변속기\tCC : 5");
		command = scanner.nextLine();
		for (String c : command.split(" ")) {

			switch (Integer.parseInt(c)) {

			case 1:

				sql = "select cname from category";

				rs = stmt.executeQuery(sql);
				System.out.println("category list:");
				while (rs.next())
					System.out.print(rs.getString(1) + "\t");

				System.out.println("");

				rs.close();
				opt.add("cname = '" + scanner.nextLine() + "'");

				break;

			case 2:

				sql = "select distinct color_name from color";

				rs = stmt.executeQuery(sql);
				System.out.println("color list:");
				while (rs.next())
					System.out.print(rs.getString(1) + "\t");

				System.out.println("공백으로 구분. (ex Yellow Green)");

				String color = scanner.nextLine();

				String color_q = "";
				for (String col : color.split(" ")) {

					color_q += "color_name = '" + col + "' OR ";
				}
				opt.add(color_q.substring(0, color_q.length() - 3));

				rs.close();

				break;

			case 3:
				sql = "select fname from fuel";

				rs = stmt.executeQuery(sql);
				System.out.println("fuel list:");
				while (rs.next())
					System.out.print(rs.getString(1) + "\t");

				System.out.println("공백으로 구분. 최대 2개까지 (ex Disel Electric)");

				String fuel = scanner.nextLine();

				String fuel_q = "";
				for (String col : fuel.split(" ")) {

					fuel_q += "fname = '" + col + "' AND ";
				}
				opt.add(fuel_q.substring(0, fuel_q.length() - 4));

				rs.close();
				break;

			case 4:
				sql = "select tname from transmission";

				rs = stmt.executeQuery(sql);
				System.out.println("transmission list:");
				while (rs.next())
					System.out.print(rs.getString(1) + "\t");

				System.out.println("");

				opt.add("tname = '" + scanner.nextLine() + "'");

				rs.close();
				break;

			case 5:
				sql = "select cc from engine_displacement";

				rs = stmt.executeQuery(sql);
				System.out.println("engine displacement list:");
				while (rs.next())
					System.out.print(rs.getString(1) + "\t");

				System.out.println("");

				opt.add("vehicle.CC = '" + scanner.nextLine() + "'");

				rs.close();
				break;

			}
		}

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

	public static void Buy_Car(Connection conn, Statement stmt, ArrayList<String> Menu) {

		ResultSet rs;
		String command;
		int index;
		String sql = "";

		// 결과물이 없을 경우 종료
		if (Menu.size() == 0)
			return;

		// 모델 세부사항 확인
		while (true) {
			System.out.println("세부사항을 보고싶은 검색 결과 번호를 선택하세요(exit : 0) : ");
			command = scanner.nextLine();
			while (command.equals(""))
				command = scanner.nextLine();

			if (Integer.parseInt(command) == 0)
				break;

			index = Integer.parseInt(command);
			sql = "select vehicle.vid, color_name, CC, TNAME, MODEL_YEAR, MILEAGE from post, vehicle, transmission, color, seems where post.pid = '"
					+ Menu.get(index - 1)
					+ "' AND post.vid = vehicle.vid AND vehicle.tid = transmission.tid AND seems.vid = vehicle.vid AND seems.color_id = color.color_id";

			try {
				rs = stmt.executeQuery(sql);
				String output = "";
				String colors = "";
				while (rs.next()) {

					String vid = rs.getString(1);
					String color = rs.getString(2);
					String CC = rs.getString(3);
					String Tname = rs.getString(4);
					String MODEL_YEAR = rs.getString(5).substring(0, 10);
					String MILEAGE = rs.getString(6);

					output = vid + "\t" + CC + "\t" + Tname + "\t" + MODEL_YEAR + "\t" + MILEAGE;
					colors = colors + color + "\t";

				}
				System.out.println(output.substring(0, 9) + colors + output.substring(9));
				rs.close();
			} catch (SQLException ex2) {
				System.err.println("sql error = " + ex2.getMessage());
				System.exit(1);
			}

		}

		System.out.println("구매하고싶은 차량의 번호를 선택하세요(exit : 0): ");
		command = scanner.nextLine();

		while (command.equals(""))
			command = scanner.nextLine();
		if (Integer.parseInt(command) == 0) {
			return;
		}

		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
		Date time = new Date();

		String now = format1.format(time);

		index = Integer.parseInt(command);
		// 차량 구매
		if (Integer.parseInt(command) == 0)
			return;
		else
			sql = "INSERT into buy_car values('" + ID + "', '" + Menu.get(index - 1) + "', to_date('" + now
					+ "', 'yyyy-mm-dd'))";

		try {
			stmt.executeQuery(sql);
			System.out.println("구매 완료");

			sql = "UPDATE POST SET valid = 'u' where pid = '" + Menu.get(index - 1) + "'";
			stmt.executeQuery(sql);
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	public static ArrayList<String> GetName(Connection conn, Statement stmt) throws SQLException {

		ArrayList<String> SResult = new ArrayList<>();

		String sql;
		ResultSet rs;

		String model;
		String dmodel = "";
		scanner.nextLine();
		int no = 1;

		System.out.println("모델 이름을 입력하세요");
		model = scanner.nextLine();
		System.out.println("세부모델 이름을 입력하세요(공란 가능)");
		dmodel = scanner.nextLine();

		if (dmodel.equals(""))// 세부모델을 넣지 않았을 경우
			sql = "select title, MODEL_NAME, DM_NAME, price, U_ID, U_DATE, pid from model, detailed_model, vehicle, post where vehicle.vid = post.vid AND vehicle.DM_ID = detailed_model.DM_ID AND vehicle.MODEL_ID = model.MODEL_ID AND valid = 'v' AND MODEL_NAME = '"
					+ model + "'";

		else// 세부 모델을 넣은 경우
			sql = "select title, MODEL_NAME, DM_NAME, price, U_ID, U_DATE, pid from model, detailed_model, vehicle, post where vehicle.vid = post.vid AND vehicle.DM_ID = detailed_model.DM_ID AND vehicle.MODEL_ID = model.MODEL_ID AND valid = 'v' AND MODEL_NAME = '"
					+ model + "' AND DM_NAME = '" + dmodel + "'";

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

				SResult.add(pid);
				System.out.println(Integer.toString(no) + " : " + title + "\t" + MNAME + "\t" + DMNAME + "\t"
						+ Integer.toString(price) + "\t" + U_ID + "\t" + U_DATE);
				no++;

			}
			rs.close();
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}

		return SResult;
	}

	public static ArrayList<String> GetPost(Connection conn, Statement stmt) throws SQLException {

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

				SResult.add(pid);
				System.out.println(Integer.toString(no) + " : " + title + "\t" + MNAME + "\t" + DMNAME + "\t"
						+ Integer.toString(price) + "\t" + U_ID + "\t" + U_DATE);
				no++;
			}
			rs.close();
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}
		return SResult;
	}

	public static ArrayList<String> GetMaker(Connection conn, Statement stmt) {

		ArrayList<String> SResult = new ArrayList<>();
		ResultSet rs;
		scanner.nextLine();
		int no = 1;

		System.out.println("제조사 목록");

		String sql = "select mname from maker";

		try {
			rs = stmt.executeQuery(sql);

			while (rs.next()) {

				String MNAME = rs.getString(1);

				System.out.print(MNAME + "\t");

			}
			System.out.println("");
			rs.close();
		} catch (SQLException ex2) {
			System.err.println("sql error = " + ex2.getMessage());
			System.exit(1);
		}

		System.out.println("제조사 : ");
		String Maker = scanner.nextLine();

		sql = "select title, MODEL_NAME, DM_NAME, price, U_ID, U_DATE, pid "
				+ "from model, detailed_model, vehicle, post, maker " + "where vehicle.vid = post.vid "
				+ "AND vehicle.DM_ID = detailed_model.DM_ID AND vehicle.MODEL_ID = model.MODEL_ID AND valid = 'v' "
				+ "AND vehicle.mid = maker.mid AND maker.mname = '" + Maker + "'";

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

				SResult.add(pid);
				System.out.println(Integer.toString(no) + " : " + title + "\t" + MNAME + "\t" + DMNAME + "\t"
						+ Integer.toString(price) + "\t" + U_ID + "\t" + U_DATE);
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

	public static void MakeAccount(Connection conn, Statement stmt) throws SQLException {
		// 입력값 길이에 따른 insert문 error 처리

		Scanner data = new Scanner(System.in);
		String ID;
		String temp;
		int count = 0; // 필수 입력 항목 몇개 입력했는지 확인
		int valid = 0; // 아이디가 이미 존재하는지 확인
		ResultSet rs;
		String sql = "Select * from account where ID ='";
		String new_account = "INSERT INTO ACCOUNT VALUES (";

		System.out.println("(*표시 항목은 필수 항목입니다.)\n*계정을 입력하시오.");
		ID = data.nextLine();
		if (ID != null) {
			count++;
		}
		new_account = AppendAccount(new_account, ID, 1);

		System.out.println("*비밀번호를 입력하시오.");
		temp = data.nextLine();
		if (temp != null) {
			count++;
		}
		new_account = AppendAccount(new_account, temp, 1);

		System.out.println("*이름을 입력하시오.");
		temp = data.nextLine();
		if (temp != null) {
			count++;
		}
		new_account = AppendAccount(new_account, temp, 1);

		System.out.println("성별을 입력하시오. M / F");
		temp = data.nextLine();
		new_account = AppendAccount(new_account, temp, 1);

		System.out.println("주소를 입력하시오.");
		temp = data.nextLine();
		new_account = AppendAccount(new_account, temp, 1);

		System.out.println("생년월일를 입력하시오. (ex 2000-01-01)");
		temp = data.nextLine();
		if (temp.equals(""))
			new_account = AppendAccount(new_account, temp, 1);
		else
			new_account = AppendAccount(new_account, temp, 2);

		System.out.println("*전화번호를 입력하시오. (ex 010-0000-0000)");
		temp = data.nextLine();
		if (temp != null) {
			count++;
		}
		new_account = AppendAccount(new_account, temp, 1);

		System.out.println("직업을 입력하시오.");
		temp = data.nextLine();
		new_account = AppendAccount(new_account, temp, 3);

		if (count != 4) {
			System.out.println("필수 입력 정보를 다 입력하지 않으셨습니다.");
		}
		sql = sql + ID + "'";
		rs = stmt.executeQuery(sql);
		while (rs.next()) {
			valid = rs.getRow();
		}
		rs.close();
		if (valid != 0) {
			System.out.println("이미 존재하는 ID입니다.");
		} else {
			try {
				stmt.executeUpdate(new_account);
				conn.commit();
				System.out.println("회원가입이 완료되었습니다.");
			} catch (Exception e) {
				System.out.println("회원가입에 실패했습니다. 다시 입력해주십시오.");
			}
		}
	}

	public static String AppendAccount(String raw, String data, int mode) {
		switch (mode) {
		case 1:
			raw = raw + "'" + data + "',"; // 일반 입력 및 DATE 값이 NULL인 경우
			return raw;
		case 2:
			raw = raw + "TO_DATE('" + data + "','YYYY-MM-DD'),"; // DATE 입력
			return raw;
		case 3:
			raw = raw + "'" + data + "','C')"; // 마지막 입력 정보
			return raw;
		default:
			return raw;
		}
	}

	static int MyPage(Connection conn, Statement stmt) {
		int command = 0;
		Scanner scanner = new Scanner(System.in);

		while (true) {
			System.out.println("회원 정보 수정: 1\t 비밀번호 수정: 2\t 거래 내역 확인: 3\t 회원 탈퇴: 4\t 뒤로가기: 0");
			switch (command = scanner.nextInt()) {
			case 1:
				ChangeInfo(conn, stmt);
				break;

			case 2:
				ChangePass(conn, stmt);
				break;

			case 3:
				Orderlist(conn, stmt);
				break;

			case 4:
				if (withdrawID(conn, stmt) == 1) {
					return -1;
				} else {
					break;
				}
			case 0:
				return 0;
			}

		}

	}

	static void ChangeInfo(Connection conn, Statement stmt) {
		String sql;
		int command = 0;
		Scanner scanner = new Scanner(System.in);
		ResultSet rs;
		String data = "";

		while (true) {
			sql = "SELECT * FROM ACCOUNT WHERE ID = '" + ID + "'";
			System.out.println(sql);
			try {
				rs = stmt.executeQuery(sql);
				System.out.println("이름       성별         주소                전화번호         직업      생년월일");
				System.out.println("==================================================");
				rs.next();
				System.out.println(rs.getString("Name") + " " + rs.getString("Sex") + "   " + rs.getString("Address")
						+ " " + rs.getString("Tell_num") + " " + rs.getString("Job") + " " + rs.getDate("Birth"));
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			System.out.println("이름: 1\t 성별: 2\t 주소: 3\t 전화번호: 4\t 직업: 5\t 생년월일: 6\t 뒤로 가기: 0");
			switch (command = scanner.nextInt()) {

			// 이름
			case 1:
				System.out.print("이름을 입력하세요: ");
				data = scanner.next();
				System.out.println("");
				sql = "UPDATE ACCOUNT SET NAME = " + "'" + data + "'" + "where id = " + "'" + ID + "'";
				break;

			// 성별
			case 2:
				System.out.print("성별을 입력하세요: ");

				while (true) {
					data = scanner.next();
					System.out.println("");

					if (data.equals("M") || data.equals("F")) {
						break;
					} else {
						System.out.println("잘못 입력하셨습니다.");
					}
				}
				sql = "UPDATE ACCOUNT SET SEX = " + "'" + data + "'" + "where id = " + "'" + ID + "'";
				break;

			// 주소
			case 3:
				System.out.print("주소를 입력하세요: ");
				data = scanner.next();
				System.out.println("");
				sql = "UPDATE ACCOUNT SET ADDRESS = " + "'" + data + "'" + "where id = " + "'" + ID + "'";
				break;

			// 전화번호
			case 4:
				System.out.print("전화번호를 입력하세요(010-****-****): ");
				/*
				 * while(true) { data = scanner.next(); if(true) { break; } }
				 */
				data = scanner.next();
				System.out.println("");
				sql = "UPDATE ACCOUNT SET Tell_num = " + "'" + data + "'" + "where id = " + "'" + ID + "'";
				break;
			// 직업
			case 5:
				System.out.print("직업을 입력하세요: ");
				data = scanner.next();
				System.out.println("");
				sql = "UPDATE ACCOUNT SET Job = " + "'" + data + "'" + "where id = " + "'" + ID + "'";
				break;

			case 6:
				System.out.print("생년월일을 입력하세요.(yyyy-mm-dd): ");
				data = scanner.next();
				String bdate = "TO_DATE(" + "'" + data + "', 'yyyy-mm-dd')";
				System.out.println("");
				sql = "UPDATE ACCOUNT SET Birth = " + "'" + data + "'" + "where id = " + "'" + ID + "'";
				break;
			case 0:
				return;

			}

			try {
				stmt.executeUpdate(sql);
				conn.commit();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println(command + "회원정보 변경 에러");
			}
			System.out.println("변경되었습니다.");

		}
	}

	static void ChangePass(Connection conn, Statement stmt) {
		String tempPass;
		Scanner scanner = new Scanner(System.in);

		while (true) {
			System.out.print("현재 비밀번호: ");
			tempPass = scanner.next();
			if (tempPass.equals(pwd)) {
				break;
			} else {
				System.out.println("비밀번호가 잘못되었습니다.");
			}
		}

		while (true) {
			System.out.print("새 비밀번호(~20자): ");
			tempPass = scanner.next();
			if (tempPass.length() <= 20) {
				pwd = tempPass;
				break;
			} else {
				System.out.println("비밀번호를 다시 입력하세요.");
			}
		}

		while (true) {
			System.out.print("비밀번호 확인: ");
			tempPass = scanner.next();
			if (tempPass.equals(pwd)) {
				break;
			} else {
				System.out.println("비밀번호가 잘못되었습니다. 다시 입력하세요.");
			}
		}

		String sql = "update account SET password = " + "'" + pwd + "'" + "where id = " + "'" + ID + "'";

		try {
			stmt.executeUpdate(sql);
			System.out.println("비밀번호가 변경되었습니다.");
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("비밀번호 변경 실패");
			e.printStackTrace();
		}

		return;

	}

	static void Orderlist(Connection conn, Statement stmt) {
		String sql = "SELECT * FROM BUY_CAR where buyer = '" + ID + "' order by SOLD_DATE desc";

		try {
			ResultSet rs = stmt.executeQuery(sql);
			System.out.println("BUYER    POST     SOLD_DATE");
			System.out.println("-------- -------- ---------");
			while (rs.next()) {
				System.out.println(rs.getString("BUYER") + " " + rs.getString("POST") + " " + rs.getDate("Sold_date"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("거래내역확인에러");
			e.printStackTrace();
		}

		return;
	}

	static int withdrawID(Connection conn, Statement stmt) {
		String sql;
		ResultSet rs;
		int ManagerCount = 0;
		if (auth.equals("M") || auth.equals("m")) {
			sql = "select count(*) from account where auth = 'M'";
			try {
				rs = stmt.executeQuery(sql);
				rs.next();
				ManagerCount = rs.getInt(1);
				System.out.println(ManagerCount);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			if (ManagerCount == 1) {
				System.out.println(" 탈퇴할 수 없는 관리자 계정입니다.");
				return 0;
			}

		}

		sql = "DELETE FROM account where id = '" + ID + "'";
		try {
			stmt.executeUpdate(sql);
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("탈퇴 에러");
			e.printStackTrace();
		}

		return 1;

	}

	static void invalidationPost(Connection conn, Statement stmt) {
		String vid, sql, y;
		Scanner scanner = new Scanner(System.in);

		while (true) {
			System.out.print("비공개 할 차량 번호를 입력하세요: (뒤로 가기: 0)");
			vid = scanner.next();

			if (vid.equals("0")) {
				return;
			}

			sql = "SELECT * FROM POST WHERE VID = '" + vid + "'";
			try {
				ResultSet rs = stmt.executeQuery(sql);
				System.out
						.println("PID      VID      TITLE                User_ID              Upload_DATE Validation");
				System.out
						.println("-------- -------- -------------------- -------------------- ----------- ----------");
				while (rs.next()) {
					System.out.println(rs.getString("PID") + " " + rs.getString("VID") + " " + rs.getString("Title")
							+ " " + rs.getString("U_ID") + " " + rs.getDate("U_DATE") + " " + rs.getString("valid"));
				}
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			System.out.print("비공개 하시겠습니까?(y/n)");
			y = scanner.next();
			if (y.equals("y") || y.equals("Y") || y.equals("\n")) {
				break;
			}
		}

		sql = "update POST SET valid = " + "'u'" + "where VID = " + "'" + vid + "'";

		try {
			stmt.executeUpdate(sql);
			System.out.println("비공개 처리 되었습니다.: " + vid);
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("비공개처리하는거 바꾸는거 에러남");
			e.printStackTrace();
		}

		return;
	}

	public static void ChangeVehicle(Connection conn, Statement stmt) throws SQLException {
		Scanner data = new Scanner(System.in);
		int command = 1;
		int number;
		String VID, DMID, ModelID, MID, temp;
		int valid = 0; // VID가 이미 존재하는지 확인
		ResultSet rs;
		String sql = "Select * from VEHICLE where VID ='";

		while (command != 0) {
			System.out.println("수정 항목을 선택하시오. ");
			System.out.println("모델 수정: 1 \t출력 수정: 2 \t변속기 수정: 3 \t구입일 수정: 4 \tMileage수정 : 5 \t가격 수정 : 6 \t");
			command = data.nextInt();
			System.out.println("VID를 입력하시오. ");
			data.nextLine(); // Buffer 비우기
			VID = data.nextLine(); // VID 입력 받기
			sql = sql + VID + "'";
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				valid = rs.getRow();
			}
			rs.close();
			if (valid != 1) // VID 검증
			{
				System.out.println("존재하지 않는 VID입니다.");
				return;
			}

			switch (command) {

			case 1:
				System.out.println("*MID(제조사)를 입력하시오.");
				rs = stmt.executeQuery("select MID , Mname from MAKER");
				while (rs.next()) {
					System.out.println(rs.getString("MID") + "\t" + rs.getString("Mname"));
				}
				MID = data.nextLine();
				System.out.println("*Model_ID(모델)를 입력하시오.");
				rs = stmt.executeQuery("Select Model_ID , Model_name from Model where MID = '" + MID + "'");
				while (rs.next()) {
					System.out.println(rs.getString("Model_ID") + "\t" + rs.getString("Model_name"));
				}
				ModelID = data.nextLine();
				System.out.println("*DM_ID(세부 모델)를 입력하시오. ");
				rs = stmt.executeQuery("Select DM_ID , DM_name from Detailed_model where MODEL_ID = '" + ModelID + "'");
				while (rs.next()) {
					System.out.println(rs.getString("DM_ID") + "\t" + rs.getString("DM_name"));
				}
				DMID = data.nextLine();
				try {
					rs = stmt.executeQuery("Select CID from Detailed_model where DM_ID = '" + DMID + "'");
					while (rs.next())
						stmt.executeUpdate(
								"UPDATE vehicle SET MID = '" + MID + "', MODEL_ID = '" + ModelID + "', DM_ID = '" + DMID
										+ "', CID = '" + rs.getString("CID") + "' Where VID = '" + VID + "'");
					conn.commit();
					System.out.println("차량 정보 수정이 완료되었습니다. ");
				} catch (Exception e) {
					System.out.println("차량 정보 변경에 실패하였습니다.");
				}
				break;
			case 2:
				System.out.println("*출력(CC)을 선택하시오. 1500 - 3500 (500 단위)");
				temp = data.nextLine();
				try {
					stmt.executeUpdate("UPDATE vehicle SET CC = '" + temp + "' where VID = '" + VID + "'");
					conn.commit();
					System.out.println("차량 정보 수정이 완료되었습니다. ");
				} catch (Exception e) {
					System.out.println("차량 정보 변경에 실패하였습니다.");
				}
				break;
			case 3:
				System.out.println("*변속기를 선택하시오. 1.Manual 2.Auto 3.DCT");
				number = data.nextInt();
				try {
					if (number == 1) {
						stmt.executeUpdate("UPDATE vehicle SET TID = 'TMMN0001' where VID ='" + VID + "'");
						conn.commit();
						System.out.println("차량 정보 수정이 완료되었습니다. ");
					} else if (number == 2) {
						stmt.executeUpdate("UPDATE vehicle SET TID = 'TMAT0002' where VID ='" + VID + "'");
						conn.commit();
						System.out.println("차량 정보 수정이 완료되었습니다. ");
					} else if (number == 3) {
						stmt.executeUpdate("UPDATE vehicle SET TID = 'TMDC0003' where VID ='" + VID + "'");
						conn.commit();
						System.out.println("차량 정보 수정이 완료되었습니다. ");
					} else {
						System.out.println("1 - 3 의 숫자를 입력해주십시오. ");
					}
				} catch (Exception e) {
					System.out.println("차량 정보 변경에 실패하였습니다.");
				}
				break;
			case 4:
				System.out.println("*구입일를 입력하시오. (예시: 2010-01-01)");
				temp = data.nextLine();
				try {
					stmt.executeUpdate("UPDATE vehicle SET Model_year = TO_DATE('" + temp
							+ "','YYYY-MM-DD') where VID ='" + VID + "'");
					conn.commit();
					System.out.println("차량 정보 수정이 완료되었습니다. ");
				} catch (Exception e) {
					System.out.println("차량 정보 변경에 실패하였습니다.");
				}
				break;
			case 5:
				System.out.println("* Mileage를 입력하시오.");
				number = data.nextInt();
				if (number < 10000000) {
					stmt.executeUpdate("UPDATE vehicle SET Mileage =" + number + "where VID = '" + VID + "'");
					conn.commit();
					System.out.println("차량 정보 수정이 완료되었습니다. ");
				} else {
					System.out.println("숫자가 너무 큽니다.");
				}
				break;
			case 6:
				System.out.println("* Price를 입력하시오.");
				number = data.nextInt();
				try {
					stmt.executeUpdate("UPDATE vehicle SET price =" + number + "where VID = '" + VID + "'");
					conn.commit();
					System.out.println("차량 정보 수정이 완료되었습니다. ");
				} catch (Exception e) {
					System.out.println("차량 정보 변경에 실패하였습니다.");
				}
				break;
			}
			break;
		}
	}

	public static void MakeVehicle(Connection conn, Statement stmt) throws SQLException {
		// error 처리에 대한 부분 X
		Scanner data = new Scanner(System.in);
		String VID, DMID, ModelID, MID, temp;
		int valid = 0; // VID가 이미 존재하는지 확인
		ResultSet rs;
		int number;
		String sql = "Select * from VEHICLE where VID ='";
		String new_vehicle = "INSERT INTO VEHICLE VALUES (";

		System.out.println("(*표시 항목은 필수 항목입니다.)\n*VID를 입력하시오.");
		VID = data.nextLine(); // VID 입력 받기
		sql = sql + VID + "'";
		rs = stmt.executeQuery(sql);
		while (rs.next()) {
			valid = rs.getRow();
		}
		rs.close();
		if (valid != 0) {
			System.out.println("이미 존재하는 VID입니다.");
			return;
		}
		new_vehicle = AppendAccount(new_vehicle, VID, 1);
		System.out.println("*MID(제조사)를 입력하시오.");
		rs = stmt.executeQuery("select MID , Mname from MAKER");
		while (rs.next()) {
			System.out.println(rs.getString("MID") + "\t" + rs.getString("Mname"));
		}
		MID = data.nextLine();
		System.out.println("*Model_ID(모델)를 입력하시오.");
		rs = stmt.executeQuery("Select Model_ID , Model_name from Model where MID = '" + MID + "'");
		while (rs.next()) {
			System.out.println(rs.getString("Model_ID") + "\t" + rs.getString("Model_name"));
		}
		ModelID = data.nextLine();
		System.out.println("*DM_ID(세부 모델)를 입력하시오. ");
		rs = stmt.executeQuery("Select DM_ID , DM_name from Detailed_model where MODEL_ID = '" + ModelID + "'");
		while (rs.next()) {
			System.out.println(rs.getString("DM_ID") + "\t" + rs.getString("DM_name"));
		}
		DMID = data.nextLine();
		new_vehicle = AppendAccount(new_vehicle, DMID, 1);
		new_vehicle = AppendAccount(new_vehicle, ModelID, 1);
		new_vehicle = AppendAccount(new_vehicle, MID, 1);
		rs = stmt.executeQuery("Select CID from Detailed_model where DM_ID = '" + DMID + "'");
		while (rs.next())
			new_vehicle = AppendAccount(new_vehicle, rs.getString("CID"), 1);
		System.out.println("*출력(CC)을 선택하시오. 1500 - 3500 (500 단위)");
		temp = data.nextLine();
		new_vehicle = AppendAccount(new_vehicle, temp, 1);
		System.out.println("*변속기를 선택하시오. 1.Manual 2.Auto 3.DCT");
		number = data.nextInt();
		if (number == 1) {
			new_vehicle = AppendAccount(new_vehicle, "TMMN0001", 1);
		} else if (number == 2) {
			new_vehicle = AppendAccount(new_vehicle, "TMAT0002", 1);
		} else if (number == 3) {
			new_vehicle = AppendAccount(new_vehicle, "TMDC0003", 1);
		}
		System.out.println("*구입일를 입력하시오. (예시: 2010-01-01)");
		data.nextLine(); // buffer clear
		temp = data.nextLine(); // Data 값 입력
		new_vehicle = AppendAccount(new_vehicle, temp, 2);
		System.out.println("* Mileage를 입력하시오. (최대 6자리)");
		number = data.nextInt();
		new_vehicle = new_vehicle + number;
		System.out.println("* Price를 입력하시오.");
		number = data.nextInt();
		new_vehicle = new_vehicle + "," + number + ")";
		try {
			stmt.executeUpdate(new_vehicle);
			conn.commit();
			System.out.println("차량등록이 완료되었습니다.");
		} catch (Exception e) {
			System.out.println("차량등록에 실패하였습니다.");
			System.out.println("다시 등록해주십시오.");
			return;
		}

		////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////

	}

	public static void ChangeColorFuel(Connection conn, Statement stmt) throws SQLException {
		String VID, temp;
		int number;
		char Coating;
		int fuel_count = 0; // 가솔린 디젤 등록 방지
		int valid = 0;
		Scanner data = new Scanner(System.in);
		ResultSet rs;

		System.out.println("변경할 차량의 VID를 입력하시오.");
		VID = data.nextLine();
		rs = stmt.executeQuery("Select * from VEHICLE where VID ='" + VID + "'");
		while (rs.next()) {
			valid = rs.getRow();
		}
		if (valid != 1) // VID 검증
		{
			System.out.println("존재하지 않는 VID입니다.");
			return;
		}

		System.out.println("변경할 항목을 입력하시오. (기존 데이터는 지워집니다.)\n 연료 : 1 \t색상 : 2");
		number = data.nextInt();

		switch (number) {
		case 1:
			stmt.executeQuery("Delete From Fuse where VID = '" + VID + "'");
			conn.commit();
			System.out.println("연료를 입력합니다. 일반 : 1 , 하이브리드 : 2");
			number = data.nextInt();
			data.nextLine(); // buffer free
			if (number == 1 || number == 2) // 1 , 2가 아니면 오류
			{
				fuel_count = 0;
				while (number != 0) {
					System.out.println("*연료를 입력하시오. ");
					rs = stmt.executeQuery("Select FID , FNAME from FUEL");
					while (rs.next()) {
						System.out.println(rs.getString("FID") + "\t" + rs.getString("FNAME"));
					}
					temp = data.nextLine();

					if (temp.equals("FUGS0001") || temp.contentEquals("FUDI0002")) {
						fuel_count++;
					}
					if (fuel_count == 2) {
						System.out.println("가솔린과 디젤은 같이 입력할 수 없습니다.");
						return;
					}
					try {
						stmt.executeUpdate("INSERT INTO FUSE VALUES ('" + temp + "', '" + VID + "')");
						conn.commit();
						System.out.println("연료 등록에 성공했습니다.");
					} catch (Exception e) {
						System.out.println("연료 등록에 실패하였습니다. 다시 입력해주십시오.");
						return;
					}
					number--;
				}
			} else {
				System.out.println("연료 입력 오류 !! 1 , 2 중에 선택하십시오.");
				return;
			}
			break;

		case 2:
			stmt.executeQuery("Delete From seems where VID = '" + VID + "'");
			conn.commit();
			System.out.println("색상을 입력합니다. 일반 : 1 , 투톤 : 2");
			number = data.nextInt();
			data.nextLine(); // buffer free
			if (number == 1 || number == 2) // 1 , 2가 아니면 오류
			{
				while (number != 0) {
					System.out.println("*차량 색상을 입력하시오. ");
					rs = stmt.executeQuery("Select Distinct Color_Name from Color");
					while (rs.next()) {
						System.out.println(rs.getString("Color_Name"));
					}

					temp = data.nextLine();
					System.out.println("코팅 여부 확인 (Y/N). ");
					Coating = data.next().charAt(0);
					if (Coating == 'Y' || Coating == 'y') {
						try {
							rs = stmt.executeQuery(
									"Select COLOR_ID from COLOR where color_name = '" + temp + "' and Coating = 'Y'");
							rs.next();
							try {
								stmt.executeUpdate(
										"INSERT INTO seems VALUES ('" + rs.getString("Color_ID") + "', '" + VID + "')");
								conn.commit();
								System.out.println("색상 등록에 성공했습니다.");
							} catch (Exception e) {
								System.out.println("색상 등록에 실패하였습니다. 다시 입력해주십시오.");
								return;
							}
						} catch (Exception e) {
							System.out.println("색상 등록에 실패하였습니다. 다시 입력해주십시오.");
							return;
						}
					} else {
						rs = stmt.executeQuery(
								"Select COLOR_ID from COLOR where color_name = '" + temp + "' and Coating = 'N'");
						rs.next();
						stmt.executeUpdate(
								"INSERT INTO seems VALUES ('" + rs.getString("Color_ID") + "', '" + VID + "')");
						conn.commit();
						System.out.println("색상 등록에 성공했습니다.");
					}
					number--;
					data.nextLine(); // buffer free
				}
			} else {
				System.out.println("색상 입력 오류 !! 1 , 2 중에 선택하십시오.");
				return;
			}
			rs.close();
			break;
		}
	}

	public static void AllOrderList(Connection conn, Statement stmt) {
		Scanner scanner = new Scanner(System.in);
		int condition;
		String sql, data;

		while (true) {
			System.out.print("검색할 조건을 선택하세요: ");
			System.out.println("월: 1\t연도: 2\t제조사: 3\t뒤로가기: 0");
			condition = scanner.nextInt();
			switch (condition) {
			case 1:
				System.out.print("월을 입력하세요: ");
				data = scanner.next();
				sql = "SELECT * FROM BUY_CAR where EXTRACT(month FROM (Sold_date)) = '" + data
						+ "' order by SOLD_DATE desc";
				try {
					ResultSet rs = stmt.executeQuery(sql);
					System.out.println("BUYER    POST     SOLD_DATE");
					System.out.println("-------- -------- ---------");
					while (rs.next()) {
						System.out.println(
								rs.getString("BUYER") + " " + rs.getString("POST") + " " + rs.getDate("Sold_date"));
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					System.out.println("거래내역확인에러1");
					e.printStackTrace();
				}
				break;
			case 2:
				System.out.print("연도를 입력하세요: ");
				data = scanner.next();
				sql = "SELECT * FROM BUY_CAR where EXTRACT(year FROM (Sold_date)) = '" + data
						+ "' order by SOLD_DATE desc";
				try {
					ResultSet rs = stmt.executeQuery(sql);
					System.out.println("BUYER    POST     SOLD_DATE");
					System.out.println("-------- -------- ---------");
					while (rs.next()) {
						System.out.println(
								rs.getString("BUYER") + " " + rs.getString("POST") + " " + rs.getDate("Sold_date"));
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					System.out.println("거래내역확인에러2");
					e.printStackTrace();
				}
				break;
			case 3:
				try {
					ResultSet rs = stmt.executeQuery("SELECT * from MAKER");
					System.out.println("MID      NAME     COUNTRY  ");
					System.out.println("-------- -------- ---------");
					while (rs.next()) {
						System.out.println(
								rs.getString("MID") + " " + rs.getString("MNAME") + "\t" + rs.getString("MCOUNTRY"));
					}

					System.out.print("제조사의 이름를 입력하세요: ");
					data = scanner.next();
					sql = "select * from buy_car where post in (select p.pid from post p, vehicle v, maker m where m.mname = '"
							+ data + "' and m.mid = v.mid and p.vid = v.vid) order by sold_date desc";
					rs = stmt.executeQuery(sql);
					System.out.println("BUYER    POST     SOLD_DATE");
					System.out.println("-------- -------- ---------");
					while (rs.next()) {
						System.out.println(
								rs.getString("BUYER") + " " + rs.getString("POST") + " " + rs.getDate("Sold_date"));
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					System.out.println("거래내역확인에러3");
					e.printStackTrace();
				}
				break;
			case 0:
				return;
			}
		}
	}
}