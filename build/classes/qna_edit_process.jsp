<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.parser.ParseException" %>
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
		String id = null, desc = null, no = null, title = null;
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
				} else if (name.equals("no")) {
					no = value;
				} else if (name.equals("title")) {
					title = value;
				}
				System.out.println(name + ": " + value);
			} else {
				if (id == null)
					continue;

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

		String sql = "SELECT jsonobj FROM qna WHERE no = " + no;
		ResultSet rs = st.executeQuery(sql);
		if (rs.next()) {
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObject = (JSONObject) jsonParser.parse(rs.getString("jsonobj"));

			try {
				try {
					jsonObject = (JSONObject) jsonParser.parse(rs.getString("jsonobj"));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			String imagesStr = jsonObject.get("images").toString();
			imagesStr = imagesStr.replaceAll("[\\[\\](){}\"]", "");
			List<String> imagesList = Arrays.asList(imagesStr.split(","));

			if (!imagesList.toString().equals("[]"))
				images.addAll(0, imagesList);
		}

		// create an JSON object for the database insertion
		JSONObject jsonobj = new JSONObject();
		jsonobj.put("id", id);
		jsonobj.put("desc", desc);
		jsonobj.put("images", images);

		System.out.println("-------------" + no);

		sql = "UPDATE qna SET jsonobj='" + jsonobj.toJSONString() + "', title='" + title + "' WHERE no=" + no;
		st.executeUpdate(sql);

		out.println("OK");

		st.close();
		conn.close();

	} catch (Exception ex) {
		ex.printStackTrace();
	}
%>