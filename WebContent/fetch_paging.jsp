<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%
	request.setCharacterEncoding("UTF-8");

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
	Statement st = conn.createStatement();

	String sql = "SELECT count(*) as totalCount FROM feed";
	ResultSet rs = st.executeQuery(sql);

	int cnt = 0;
	while (rs.next()) {
		cnt = rs.getInt("totalCount");
	}

	out.print(cnt);

	rs.close();
	st.close();
	conn.close();
%>