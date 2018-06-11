<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%
	request.setCharacterEncoding("UTF-8");

	ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory());
	sfu.setSizeMax(16 * 1024 * 1024);
	sfu.setHeaderEncoding("UTF-8");

	// database insertion logic
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
	Statement st = conn.createStatement();

	try {
		String id = null, desc = null, no = null;
		JSONArray answers = new JSONArray();

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
				} else if (name.equals("no")) {
					no = value;
				}
				System.out.println(name + ": " + value);
			} else {
				if (id == null)
					continue;
			}
		}

		JSONObject jsonObject = new JSONObject();
		jsonObject.put("id", id);
		jsonObject.put("desc", desc);

		answers.add(jsonObject);
		String originalId = "";
		String originalDesc = "";
		JSONArray images = new JSONArray();
		String sql = "SELECT jsonobj FROM qna WHERE no = " + no;
		ResultSet rs = st.executeQuery(sql);
		if (rs.next()) {
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject2 = (JSONObject) jsonParser.parse(rs.getString("jsonobj"));

			String answersStr = jsonObject2.get("answers").toString();
			originalDesc = jsonObject2.get("desc").toString();
			images = (JSONArray) jsonObject2.get("images");
			originalId = jsonObject2.get("id").toString();
			JSONArray jsonArray = (JSONArray) jsonParser.parse(answersStr);
			if (!jsonArray.toString().equals("[]")) {
				for (int i = jsonArray.size() - 1; i >= 0; i--) {
					answers.add(0, jsonArray.get(i));
				}
			}
		}

		// create an JSON object for the database insertion
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("id", originalId);
		jsonobj.put("desc", originalDesc);
		jsonobj.put("answers", answers);
		jsonobj.put("images", images);

		System.out.println("-------------" + no);

		sql = "UPDATE qna SET jsonobj='" + jsonobj.toJSONString() + "' WHERE no=" + no;
		st.executeUpdate(sql);

		out.println("OK");

		st.close();
		conn.close();

	} catch (Exception ex) {
		ex.printStackTrace();
	}
%>