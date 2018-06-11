<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
	out.println(session.getAttribute("id"));
				
	System.out.println("Check.session: " + session.getAttribute("id"));
%>