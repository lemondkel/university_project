<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.json.simple.*" %>
<% 
	request.setCharacterEncoding("UTF-8");
	
	try {
		String id = request.getAttribute("id").toString(), name = request.getAttribute("name").toString();
		String originalId = request.getAttribute("originalId").toString();
		
		// database insertion logic
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
		Statement st = conn.createStatement();
		
		String sql = "UPDATE user SET id='" + id + "', name='" + name + "' where id='" + originalId + "'" ;
		st.executeUpdate(sql);
		
		st.close();
		conn.close();
		
	} catch(Exception ex) {
		ex.printStackTrace();
	}
%>