<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	request.setCharacterEncoding("UTF-8");

	int no = Integer.parseInt(request.getParameter("no"));

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
	Statement st = conn.createStatement();

	String sql = "SELECT id, title, jsonobj FROM info WHERE no = " + no;
	ResultSet rs = st.executeQuery(sql);
%>

<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="common.css">
	<title>Safe Drinking</title>
	<style>
		.page-msg {
			display: table;
			float: left;
			width: 100%;
			height: calc(100% - 90px);
		}

		.page-msg .desc {
			display: table-cell;
			text-align: center;
			vertical-align: middle;
		}

		.side-mnu {
			z-index: 10;
			position: fixed;
			overflow: hidden;
			left: -200px;
			top: 0;
			width: 200px;
			height: 100%;
			background-color: #eee;
			border-right: 1px solid #fff;
			transition: all 0.5s ease-out;
		}

		.side-mnu .menu {
			padding: 15px 20px;
			background-color: #f4f4f4;
			font-size: 1.0em;
			border-bottom: 1px solid #ddd;
			cursor: pointer;
		}
	</style>
</head>
<body>

<%
	JSONParser jsonParser = new JSONParser();
	JSONObject jsonObject = null;
	String desc = "";
	String title = "";
	String id = "";
	List<String> images = new ArrayList<String>();
	if (rs.next()) {
		id = rs.getString("id");
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
	<div class="navicon" onclick="showMenu()"></div>
	<h3>상세화면</h3>
</div>
<div class="side-mnu">
	<div class="menu" onclick="home()">홈</div>
	<div class="menu" onclick="notice()">공지사항</div>
	<div class="menu" onclick="taste()">Taste 평가</div>
	<div class="menu" onclick="drink()">음료수정보</div>
	<div class="menu" onclick="chemical()">화학물정보</div>
	<div class="menu" onclick="infomain()">About Us</div>
	<div class="menu" onclick="qna()">QnA</div>
	<div class="menu" onclick="logout()">로그아웃</div>
	<div class="menu" onclick="hideMenu()">닫기</div>
</div>
<div id="contents-area" class="section">
	<div class="page-msg" style="display: none;">
		<div class="desc">작성글이 존재하지 않습니다.</div>
	</div>
	<div id="--feed-list" class="section">
		<div class="feed" data-id="<%=no%>">
			<div class="author">
				<div class="photo"></div>
				<div class="name"><%=id%>
				</div>
				<%

				%>
				<div class="board_button">
					<button type="button" onclick="editBoard(this)">수정하기</button>
					<button type="button" onclick="deleteBoard(this)">삭제하기</button>
				</div>
				<%

				%>
			</div>
			<p><%=desc%></p>
			<%
				for (int i = 0; i < images.size(); i++) {
			%>
			<div class="grid-50">
				<div class="image" style="background-image: url('usrimg/<%=images.get(i)%>')"></div>
			</div>
			<%
				}
			%>
		</div>
	</div>
</div>
<div id="footer-area" class="section">
	Copyright: safedrinking.com, 2018
</div>


<script src="js/jquery-1.12.0.min.js"></script>
<script src="js/core.js"></script>
<script type="text/javascript">
	$(document).ready(function () {
		AJAX.call("session.jsp", null, function (data) {
			var id = data.trim();
			if (id == "null") {
				window.location.href = "login.html";
			}
		});
	});

	function showMenu() {
		$(".side-mnu").css("left", 0);
	}

	function hideMenu() {
		$(".side-mnu").css("left", "-200px");
	}

	function home() {
		window.location.href = "main2.html";
	}

	function taste() {
		window.location.href = "main.html";
	}

	function drink() {
		window.location.href = "drink_main.html";
	}

	function chemical() {
		window.location.href = "chemical_main.html";
	}

	function infomain() {
		window.location.href = "infomain.html";
	}

	function qna() {
		window.location.href = 'qna.html';
	}

	function notice () {
		window.location.href = "notice.html";
	}

	function logout() {
		if (confirm("로그아웃 하시겠습니까?") == true) {
			AJAX.call("logout.jsp", null, function (data) {
				window.location.href = "login.html";
			});
		}
	}

	function editBoard(target) {
		if (confirm("해당 게시물을 수정하시겠습니까?") == true) {
			var id = $(target).parents('.feed').attr('data-id');
			window.location.href = 'info_edit.jsp?no=' + id;
		}
	}

	function deleteBoard(target) {
		if (confirm("해당 게시물을 삭제하시겠습니까?") == true) {
			var id = $(target).parents('.feed').attr('data-id');
			$.ajax({
				url: 'delete_board.jsp',
				method: 'GET',
				data: {
					id: id
				},
				success: function () {
					alert("삭제가 완료되었습니다.");
					$(target).parent().parent().parent().remove();
				}
			})
		}
	}
</script>
</body>
</html>