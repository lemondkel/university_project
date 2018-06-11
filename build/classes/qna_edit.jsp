<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>

<%
	request.setCharacterEncoding("UTF-8");

	int no = Integer.parseInt(request.getParameter("no"));

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
	Statement st = conn.createStatement();

	String sql = "SELECT title, jsonobj FROM qna WHERE no = " + no;
	ResultSet rs = st.executeQuery(sql);
%>

<html>
<head>
	<meta name=viewport content="width=device-width, initial-scale=1, user-scalable=0">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<link rel="stylesheet" href="common.css">
	<title>My Social Network</title>
	<style>
		.form {
			float: left;
			width: 100%;
			padding: 30px 16px;
			box-sizing: border-box;
		}

		.form input[type=submit] {
			float: left;
			width: 100%;
			margin: 25px 0px;
			padding: 10px;
			box-sizing: border-box;
			text-align: center;
			color: black;
			background-color: #E6E6E6;
			border: none;
			border-radius: 20px;
		}

		.form textarea {
			float: left;
			width: 100%;
			padding: 10px 15px;
			line-height: 1.5em;
			background-color: white;
			border: 1px solid #ddd;
			border-radius: 10px;
			outline: none;
		}

		.form .button {
			float: right;
			margin: 15px 0;
			padding: 3px 16px;
			background-color: white;
			text-align: center;
			font-size: 0.9em;
			color: black;
			border: 1px solid #E6E6E6;
			border-radius: 30px;
			cursor: pointer;
		}

		.image-pane {
			float: left;
			width: 100%;
		}

		.title_input {
			width: 100%;
			padding: 10px 15px;
			line-height: 1.5em;
			background-color: white;
			border: 1px solid #ddd;
			border-radius: 10px;
			outline: none;
			margin-bottom: 10px;
		}
	</style>
</head>
<body>

<%
	JSONParser jsonParser = new JSONParser();
	JSONObject jsonObject = null;
	String desc = "";
	String title = "";
	List<String> images = new ArrayList<String>();
	if (rs.next()) {
		try {
			try {
				jsonObject = (JSONObject) jsonParser.parse(rs.getString("jsonobj"));
				title = rs.getString("title");
			} catch (ParseException e) {
				e.printStackTrace();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		desc = jsonObject.get("desc").toString();
		String imagesStr = jsonObject.get("images").toString();
		imagesStr = imagesStr.replaceAll("[\\[\\](){}\"]", "");
		images = Arrays.asList(imagesStr.split(","));
	}
%>

<div id="header-area" class="section">
	<div class="back" onclick="history.back()"></div>
	<h3>글쓰기</h3>
</div>
<div id="contents-area" class="section">
	<div class="form">
		<input class="title_input" type="text" placeholder="제목을 입력해주세요." name="title" value="<%=title%>"/>
		<textarea id="--desc" class="form-mtxt" rows=5 placeholder="나누고자 하는 이야기를 올려보세요."><%=desc%></textarea>
		<div class="button" onclick="openImage()">사진추가</div>
		<div id="--img-pane" class="image-pane">

			<%
				for (int i = 0; i < images.size(); i++) {
			%>
			<div id="--photo-<%=i%>">
				<div id="--photo-pane-<%=i%>" class="grid-50">
					<div id="--photo-img-<%=i%>" class="image"
						 style="background-image: url('usrimg/<%=images.get(i)%>')">

					</div>
				</div>
			</div>
			<%
				}
			%>

		</div>

		<input type="submit" value="작성글을 수정합니다." onclick="edit(<%=request.getParameter("no")%>)">
	</div>
</div>
<div id="footer-area" class="section">
	Copyright: MySNS.com, 2018
</div>
</body>
</html>

<script src="js/jquery-1.12.0.min.js"></script>
<script src="js/core.js"></script>
<script type="text/javascript">
	$(document).ready(function () {
		AJAX.call("session.jsp", null, function (data) {
			var id = data.trim();
			if (id == "null") {
				window.location.href = "login.html";
			}
			else {
				start(id);
			}
		});
	});

	var pagectx = {};
	function start(id) {
		ImageUploader.init("#--img-pane");
		pagectx.id = id;
	}

	function openImage() {
		ImageUploader.open();
	}

	function edit(no) {
		if (check() == false) return;

		// make the HTTP request in a form of the "Form data"
		var params = new FormData();
	params.append("id", pagectx.id);
		params.append("no", no);
		params.append("desc", $("#--desc").val().trim());
		params.append("title", $('.title_input').val());

		var images = ImageUploader.get();
		for (var i = 0; i < images.length; i++) {
			params.append("image", images[i]);
		}

		AJAX.formCall("edit_board.jsp", params, function (data) {
			alert("작성글을 수정하였습니다.");
			history.back();
		});
	}

	function check() {
		var pass = $("#--desc").val().trim();
		if (pass == "") {
			alert("나누고자 하는 글을 입력해주세요.");
			return false;
		}
		return true;
	}
</script>