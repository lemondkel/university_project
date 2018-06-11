<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	request.setCharacterEncoding("UTF-8");

	String searchStr = request.getParameter("searchStr") == null ? "" : request.getParameter("searchStr");
	String type = request.getParameter("type") != null ? request.getParameter("type") : "0";
	int paging = request.getParameter("paging") == null ? 1 : Integer.parseInt(request.getParameter("paging"));
	System.out.println(searchStr);

	String id = request.getParameter("uid");
	String pass = request.getParameter("upass");

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
	Statement st = conn.createStatement();

	String sql = "select count(*) as totalCount from info WHERE type = " + type;
	ResultSet rs = st.executeQuery(sql);
	int totalCount = 0;

	if (rs.next()) {
		totalCount = rs.getInt("totalCount");
	}
	System.out.println("모든글수:" + totalCount);
%>

<html>
<head>
	<meta charset="UTF-8"/>
	<meta name=viewport content="width=device-width, initial-scale=1, user-scalable=0">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
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

		.form input[type=text] {
			float: center;
			width: 40%;
			margin-bottom: -100px;
			margin-left: 450;
			padding: 30px;
			box-sizing: border-box;
			border: 1px solid #DDD;
			border-radius: 20px;
		}

		.form input[type=submit] {
			float: center;
			width: 6%;
			margin-bottom: -100px;
			padding: 30px;
			box-sizing: border-box;
			text-align: center;
			color: white;
			background-color: #36D;
			border: none;
			border-radius: 20px;
			cursor: pointer;
		}

		.form h1 {
			margin-top: 200px;
			margin-left: 600;
		}

		.search_tab {
			float: left;
			width: 100%;
			margin-top: 150px;
			text-align: center;
			margin-bottom: 50px;
		}

		.tab-area {
			max-width: 500px;
			margin: 0 auto 0 440px;
		}

		.tab-area span {
			width: 49%;
			display: inline-block;
			font-size: 24px;
			border-radius: 10px;
			padding: 10px 0;
			cursor: pointer;
		}

		.tab-area span.active {
			background: #ddd;
		}

		.tab-area span:hover {
			background: #EEE;
		}

		.search_result {
			float: left;
			width: 100%;
			margin-top: 50px;
			text-align: center;
			margin-bottom: 200px;
		}

		.search_item {
			max-width: 500px;
			margin: 0 auto 0 440px;
		}

		.search_item h3 {
			text-align: left;
			margin: 10px 0;
			font-size: 20px;
			cursor: pointer;
		}

		.search_item h3:hover {
			opacity: 0.7;
		}

		.search_item div .left {
			height: 200px;
			background: #999;
			background-size: 100% auto;
			width: 48%;
			margin-right: 2%;
			display: inline-block;
			vertical-align: top;
			background-position: center center;
		}

		.search_item div .right {
			height: 200px;
			width: 48%;
			display: inline-block;
			vertical-align: top;
		}

		.right-top {
			text-align: left;
			font-weight: 700;
		}

		.right-bottom {
			bottom: -25px;
			position: relative;
			top: 80px;
			text-align: left;
		}

		.right-bottom span {
			border: 1px solid #666;
			border-radius: 7px;
			padding: 7px 20px;
			display: inline-block;
			margin: 5px;
		}

		#paging-div {
			margin: 30px 0;
		}

	</style>
</head>
<body>
<div id="header-area" class="section">
	<div class="navicon" onclick="showMenu()"></div>
	<h3>안전한 음료 정보</h3>
	<div class="pen" onclick="writeNew()"></div>
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
	<form name="search" method="POST" action="search_result.jsp">
		<div class="form">
			<h1>안전한 드링크 정보</h1>
			<div class="can" onclick="home()"></div>
			<input type="text" name="searchStr" placeholder="검색어 입력" value="<%=searchStr%>">
			<input type="hidden" name="type" value="<%=type%>">
			<input type="submit" value="검색">
		</div>
	</form>
</div>

<%
	String isDrink = type.equals("0") ? "class=\"active\"" : "";
	String isChemical = type.equals("1") ? "class=\"active\"" : "";
%>

<div class="search_tab">
	<div class="tab-area">
		<span <%=isDrink%> onclick="searchTab(1)">음료수정보</span>
		<span <%=isChemical%> onclick="searchTab(2)">화학물정보</span>
	</div>
</div>

<div class="search_result">
	<%

		String sql2 = "SELECT * FROM info WHERE (jsonobj like '%" + searchStr
				+ "%' or title like '%" + searchStr + "%') AND type = " + type + " ORDER BY `no` DESC LIMIT " + ((paging - 1) * 2) + ", 2";
		rs = st.executeQuery(sql2);
		int i = 0;
		JSONParser jsonParser = new JSONParser();
		while (true) {
			if (rs.next()) {
				JSONObject jsonObject = (JSONObject) jsonParser.parse(rs.getString("jsonobj"));
				String imagesStr = jsonObject.get("images").toString();
				imagesStr = imagesStr.replaceAll("[\\[\\](){}\"]", "");
				List<String> images = Arrays.asList(imagesStr.split(","));
				List<String> material = Arrays.asList(rs.getString("material").split(","));
				List<String> hashtag = Arrays.asList(rs.getString("hashtag").split(","));
	%>
	<div class="search_item">
		<h3 onclick="goDetail(<%=rs.getString("no")%>)"><%=rs.getString("title")%>
		</h3>
		<div>
			<div class="left" style="background-image:url('usrimg/<%=images.get(0)%>')"></div>
			<div class="right">
				<div class="right-top">
					<span>성분 : </span>
					<%
						for (int j = 0; j < material.size(); j++) {
					%>
					<a href="#"><%=material.get(j)%>
					</a>&nbsp;
					<%
						}
					%>
				</div>
				<div class="right-bottom">
					<%
						for (int j = 0; j < hashtag.size(); j++) {
					%>
					<span>#<%=hashtag.get(j)%></span>&nbsp;
					<%
						}
					%>
				</div>
			</div>
		</div>
	</div>
	<%
	} else if (i == 0 && !(rs.next())) {
	%>
	검색결과가 존재하지 않습니다.
	<%
			break;
		} else {
			break;
		}
	%>
	<%
			i++;
		}
	%>

	<div id="paging-div">
		<%
			int countList = 2;
			int countPage = 5;
			int totalPage = totalCount / countList;

			if (totalCount % countList > 0) {
				totalPage++;
			}

			if (totalPage < paging) {
				paging = totalPage;
			}

			int startPage = ((paging - 1) / 10) * 10 + 1;
			int endPage = startPage + countPage - 1;

			if (endPage > totalPage) {
				endPage = totalPage;
			}

			if (startPage > 1) {
		%>
		<a href="search_result.jsp?paging=1">처음</a>
		<%
			}
			if (paging > 1) {
		%>
		<a href="search_result.jsp?paging=<%=(paging - 1)%>">이전</a>
		<%
			}

			for (int iCount = startPage; iCount <= endPage; iCount++) {
				if (iCount == paging) {
		%>
		<b>
			<%=iCount%>
		</b>
		<%
		} else {
		%>
		<%=iCount%>
		<%
				}
			}

			if (paging < totalPage) {
		%>
		<a href="search_result.jsp?paging=<%=(paging + 1)%>">다음</a>
		<%
			}
			if (endPage < totalPage) {
		%>
		<a href="search_result.jsp?paging=<%=totalPage%>">끝</a>
		<%
			}
		%>

	</div>
</div>

<div id="footer-area" class="section">
	Copyright: safedrinking.com, 2018
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
		window.location.href = "main.jsp";
	}

	function drink() {
		window.location.href = "drink_main.jsp";
	}

	function chemical() {
		window.location.href = "chemical_main.jsp";
	}

	function infomain() {
		window.location.href = "infomain.html";
	}

	function qna() {
		window.location.href = 'qna.jsp';
	}

	function notice() {
		window.location.href = "notice.html";
	}

	function goDetail(number) {
		window.location.href = 'detail_board.jsp?no=' + number;
	}

	function logout() {
		if (confirm("로그아웃 하시겠습니까?") == true) {
			AJAX.call("logout.jsp", null, function (data) {
				window.location.href = "login.html";
			});
		}
	}

	function writeNew() {
		window.location.href = "write.html";
	}

	function searchTab(number) {
		switch (number) {
			case 1:
				$('input[name=type]').val(0);
				break;
			case 2:
				$('input[name=type]').val(1);
				break;
		}
		$('form[name=search]').submit();
	}


</script>