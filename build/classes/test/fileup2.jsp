<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%
	ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory());
	sfu.setSizeMax(16 * 1024 * 1024);
	sfu.setHeaderEncoding("UTF-8"); 
	
	List items = sfu.parseRequest(request);
	Iterator iter = items.iterator();
	
	while(iter.hasNext()) {
		FileItem item = (FileItem) iter.next();
		if (item.isFormField()) {
			out.println(item.getFieldName() + ": " + item.getString("UTF-8") + "<br>"); 
		}
		else {
			out.println(item.getFieldName() + ": " + item.getName() + "<br>");
			// item.get() to retrieve multimedia contents
		}
	}
%>

