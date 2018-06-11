<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	request.setCharacterEncoding("UTF-8");
	
	try {
		System.out.println(request.getParameter("id"));
		int id = Integer.parseInt(request.getParameter("id"));
		
		// database insertion logic
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
		Statement st = conn.createStatement();
		
		String sql = "DELETE FROM feed where no=" + id;
		st.execute(sql);
		
		st.close();
		conn.close();
		
	} catch(Exception ex) {
		ex.printStackTrace();
	}
%>
zxczxc