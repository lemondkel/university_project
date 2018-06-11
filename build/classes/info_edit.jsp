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

	String sql = "SELECT title, jsonobj, material, hashtag FROM info WHERE no = " + no;
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

		.material_input, .hashtag_input {
			width: 30%;
			padding: 10px 15px;
			line-height: 1.5em;
			background-color: white;
			border: 1px solid #ddd;
			border-radius: 10px;
			outline: none;
			margin-bottom: 10px;
		}

		.material_button, .hashtag_button {
			padding: 10px 15px;
			line-height: 1.5em;
			background-color: aliceblue;
			border: 1px solid #ddd;
			border-radius: 10px;
			outline: none;
			margin-bottom: 10px;
			cursor: pointer;
		}

		.material_button:hover, .hashtag_button:hover {
			opacity: 0.8;
			background-color: #3366DD;
		}

		#material_area, #hashtag_area {
			margin: 20px 0;
		}

		#material_area span, #hashtag_area span {
			border: 1px solid #666;
			border-radius: 7px;
			padding: 7px 30px;
			display: inline-block;
			margin: 5px;
		}

		i.delete {
			display: inline-block;
			position: absolute;
			font-size: 10px;
			font-style: normal;
			cursor: pointer;
		}

		i.delete:hover {
			opacity: 0.7;
		}
	</style>
</head>
<body>

<%
	JSONParser jsonParser = new JSONParser();
	JSONObject jsonObject = null;
	String desc = "";
	String title = "";
	String material = "";
	String hashtag = "";
	List<String> images = new ArrayList<String>();
	List<String> materials = new ArrayList<String>();
	List<String> hashtags = new ArrayList<String>();
	if (rs.next()) {
		try {
			try {
				jsonObject = (JSONObject) jsonParser.parse(rs.getString("jsonobj"));
				title = rs.getString("title");
				material = rs.getString("material");
				hashtag = rs.getString("hashtag");
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
		materials = Arrays.asList(material.split(","));
		hashtags = Arrays.asList(hashtag.split(","));
	}
%>

<div id="header-area" class="section">
	<div class="back" onclick="history.back()"></div>
	<h3>글쓰기</h3>
</div>
<div id="contents-area" class="section">
	<div class="form">
		<input class="title_input" type="text" placeholder="제목을 입력해주세요." name="title" value="<%=title%>"/>
		<div>
			<input class="material_input" type="text" placeholder="성분을 입력해주세요." name="material"/>
			<button class="material_button" type="button" onclick="addMaterial()">추가</button>
		</div>
		<div id="material_area">
			<%
				for (int i = 0; i < materials.size(); i++) {
			%>
			<span><b class="material_name"><%=materials.get(i)%></b><i class="delete" onclick="deleteMaterial(this)">삭제</i></span>
			<%
				}
			%>
		</div>

		<div>
			<input class="hashtag_input" type="text" placeholder="해쉬태그를 입력해주세요." name="hashtag"/>
			<button class="hashtag_button" type="button" onclick="addHashtag()">추가</button>
		</div>
		<div id="hashtag_area">
			<%
				for (int i = 0; i < hashtags.size(); i++) {
			%>
			<span><b class="hashtag_name"><%=hashtags.get(i)%></b><i class="delete" onclick="deleteHashtag(this)">삭제</i></span>
			<%
				}
			%>
		</div>

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

	function addMaterial() {
		var materialInput = $(".material_input");
		var materialName = materialInput.val();
		materialInput.val("");

		var html = '<span><b class="material_name">' + materialName + '</b><i class="delete" onclick="deleteMaterial(this)">삭제</i></span>';

		$('#material_area').append(html);
	}


	function addHashtag() {
		var hashtagInput = $(".hashtag_input");
		var hashtagName = hashtagInput.val();
		hashtagInput.val("");

		var html = '<span>#<b class="hashtag_name">' + hashtagName + '</b><i class="delete" onclick="deleteHashtag(this)">삭제</i></span>';

		$('#hashtag_area').append(html);
	}

	function deleteHashtag(target) {
		if (confirm("이 해쉬태그를 삭제하시겠습니까?") == true) {
			$(target).parent().remove();
		}
	}

	function deleteMaterial(target) {
		if (confirm("이 성분을 삭제하시겠습니까?") == true) {
			$(target).parent().remove();
		}
	}

	function edit(no) {
		if (check() == false) return;

		// make the HTTP request in a form of the "Form data"
		var params = new FormData();
		var materialList = $("#material_area").children("span").children('b').map(function(){return $(this).text();}).get().toString();
		var hashtagList = $("#hashtag_area").children("span").children('b').map(function(){return $(this).text();}).get().toString();
		params.append("id", pagectx.id);
		params.append("no", no);
		params.append("desc", $("#--desc").val().trim());
		params.append("material", materialList);
		params.append("hashtag", hashtagList);
		params.append("title", $('.title_input').val());

		var images = ImageUploader.get();
		for (var i = 0; i < images.length; i++) {
			params.append("image", images[i]);
		}

		AJAX.formCall("info_edit_process.jsp", params, function (data) {
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