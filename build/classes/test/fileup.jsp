<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%
	out.println("id:" + request.getParameter("id") + "<br>");
	out.println("desc:" + request.getParameter("desc") + "<br>");
	out.println("image:" + request.getParameter("image") + "<br>");
	out.println("<hr>");
	
	InputStreamReader isr = new InputStreamReader(request.getInputStream(), "UTF-8");
	BufferedReader br = new BufferedReader(isr);
	String line;
	while((line = br.readLine()) != null) {
		out.println(line + " ");
	}
%>

