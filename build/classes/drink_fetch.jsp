<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("id");

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
	Statement st = conn.createStatement();

	String sql = "SELECT no, jsonobj FROM info WHERE type = 0 ORDER BY no DESC LIMIT 10";
	ResultSet rs = st.executeQuery(sql);

	// generate the result in the form of the JSON array
	String list = "[";
	int cnt = 0;
	while (rs.next()) {
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = null;
		try {
			try {
				jsonObject = (JSONObject) jsonParser.parse(rs.getString("jsonobj"));
				jsonObject.put("no", rs.getString("no"));
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		if (++cnt > 1) list += ", ";
		list += jsonObject.toJSONString();
	}
	list += "]";

	out.print(list);

	rs.close();
	st.close();
	conn.close();
%>