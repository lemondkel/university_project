<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("uid");
	String name = request.getParameter("uname");
	String pass = request.getParameter("upass");

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
	Statement st = conn.createStatement();
	
	String sql = "SELECT id FROM user WHERE id = '" + id + "'";
	ResultSet rs = st.executeQuery(sql);
	if (rs.next()) {
		out.print("EX");
	}
	else {
		sql = "INSERT INTO user(id, name, password) VALUES('" + id + "', '" + name + "', '" + pass + "')";
		st.executeUpdate(sql);
		
		out.print("OK");
	}
	
	rs.close();
	st.close();
	conn.close();
%>