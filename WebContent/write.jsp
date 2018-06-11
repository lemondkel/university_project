<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%
	request.setCharacterEncoding("UTF-8");

	ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory());
	sfu.setSizeMax(16 * 1024 * 1024);
	sfu.setHeaderEncoding("UTF-8");

	try {
		String id = null, desc = null, title = null;
		JSONArray images = new JSONArray();

		List items = sfu.parseRequest(request);
		Iterator iter = items.iterator();
		while (iter.hasNext()) {
			FileItem item = (FileItem) iter.next();
			if (item.isFormField()) {
				String name = item.getFieldName();
				String value = item.getString("UTF-8").trim();

				if (name.equals("id")) {
					id = value;
				} else if (name.equals("desc")) {
					desc = value;
				} else if (name.equals("title")) {
					title = value;
				}
				System.out.println(name + ": " + value);
			} else {
				if (id == null) continue;

				// initialze the path to save the image file
				String path = application.getRealPath(File.separator) + "/usrimg";
				(new File(path)).mkdirs();

				String filename = item.getName();

				// extract only the file name from the given file path  
				int idx = filename.lastIndexOf("\\");
				if (idx >= 0) {
					filename = filename.substring(idx + 1);
				}
				path += "/" + filename;

				// save the image with the given path
				byte[] data = item.get();
				FileOutputStream fos = new FileOutputStream(path);
				fos.write(data);
				fos.close();

				images.add(filename);

				System.out.println("image: " + filename);
			}
		}

		// create an JSON object for the database insertion
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("id", id);
		jsonobj.put("desc", desc);
		jsonobj.put("images", images);

		// database insertion logic
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
		Statement st = conn.createStatement();

		String sql = "INSERT INTO feed(id, jsonobj, title) VALUES('" + id + "', '" + jsonobj.toJSONString() + "', '" + title + "')";
		st.executeUpdate(sql);

		out.println("OK");

		st.close();
		conn.close();

	} catch (Exception ex) {
		ex.printStackTrace();
	}
%>