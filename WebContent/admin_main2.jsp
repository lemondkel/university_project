<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("uid");
	String pass = request.getParameter("upass");

	int paging = request.getParameter("paging") == null ? 1 : Integer.parseInt(request.getParameter("paging"));

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mysns", "root", "1234");
	Statement st = conn.createStatement();

	String sql = "select count(*) as totalCount from user";
	ResultSet rs = st.executeQuery(sql);

	int totalCount = 0;

	if (rs.next()) {
		totalCount = rs.getInt("totalCount");
	}
%>

<html>
<head>
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

		table {
			width: 700px;
			text-align: left;
			border: 1px solid #666;
			padding: 10px;
			line-height: 30px;
			display: inline-block;
		}

		#paging-div {
			margin: 30px 0;
		}

		td {
			width: 25%;
		}

		tbody {
			width: 100%;
			display: inline-table;
		}
	</style>
</head>
<body>
<div id="header-area" class="section">
	<div class="navicon" onclick="showMenu()"></div>
	<h3>관리자 페이지</h3>
	<div class="pen" onclick="writeNew()"></div>
</div>
<div class="side-mnu">
	<div class="menu" onclick="home()">홈</div>
	<div class="menu" onclick="logout()">로그아웃</div>
	<div class="menu" onclick="hideMenu()">닫기</div>
</div>
<div id="contents-area" class="section">
	<form>
		<div class="form">
			<h1>관리자 페이지</h1>
			<div class="can" onclick="home()"></div>
		</div>
	</form>

	<div style="text-align: center;">
		<table>
			<tr>
				<th width='25%'>아이디</th>
				<th width='25%'>이름</th>
				<th width='25%'>가입일자</th>
				<th width='25%'>편집</th>
			</tr>

			<%

				String sql2 = "SELECT id, name, DATE_FORMAT(ts, '%Y-%m-%d') AS ts FROM user WHERE isAdmin!=1 LIMIT " + ((paging - 1) * 2) + ", 4";
				rs = st.executeQuery(sql2);
				int i = 0;
				while (rs.next()) {
			%>
			<tr>
				<td>
					<span><%out.print(rs.getString("id"));%></span>
					<input type='text' name='id' value="<%out.print(rs.getString("id"));%>" style='display: none;'/>
				</td>
				<td>
					<span><%out.print(rs.getString("name"));%></span>
					<input type='text' name='name' value="<%out.print(rs.getString("name"));%>" style='display: none;'/>
				</td>
				<td><%out.print(rs.getString("ts"));%></td>
				<td>
					<button type='button' class="edit" onclick='edit(this, "<%out.print(rs.getString("id"));%>")'>편집하기
					</button>
					<button type='button' class="editFinish"
							onclick='editFinish(this, "<%out.print(rs.getString("id"));%>")' style='display: none;'>변경하기
					</button>
					<button type='button' class="editFinish" onclick='cancel(this)' style='display: none;'>취소하기</button>
				</td>
			</tr>
			<%
					i++;
				}
			%>

		</table>

		<div id="paging-div">
			<%
				int countList = 4;
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
			<a href="admin_main2.jsp?paging=1">처음</a>
			<%
				}
				if (paging > 1) {
			%>
			<a href="admin_main2.jsp?paging=<%=(paging - 1)%>">이전</a>
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
			<a href="admin_main2.jsp?paging=<%=(paging + 1)%>">다음</a>
			<%
				}
				if (endPage < totalPage) {
			%>
			<a href="admin_main2.jsp?paging=<%=totalPage%>">끝</a>
			<%
				}
			%>
		</div>
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
				window.location.href = "admin_login.html";
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
		window.location.href = "admin_main2.jsp";
	}

	function infomain() {
		window.location.href = "infomain.html";
	}

	function qna() {
		window.location.href = 'qna.jsp';
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

	function writeNew() {
		window.location.href = "write.html";
	}

	function edit(target, id) {
		var buttonTd = $(target).parent();
		var idTd = $(target).parent().siblings().eq(0);
		var nameTd = $(target).parent().siblings().eq(1);

		buttonTd.children('.edit').hide();
		idTd.children('span').hide();
		nameTd.children('span').hide();
		idTd.children('input').show();
		nameTd.children('input').show();
		buttonTd.children('.editFinish').show();
		buttonTd.children('.cancel').show();
	}

	function cancel(target) {
		var buttonTd = $(target).parent();
		var idTd = $(target).parent().siblings().eq(0);
		var nameTd = $(target).parent().siblings().eq(1);

		buttonTd.children('.edit').show();
		idTd.children('span').show();
		nameTd.children('span').show();
		idTd.children('input').hide();
		nameTd.children('input').hide();
		buttonTd.children('.editFinish').hide();
		buttonTd.children('.cancel').hide();
	}

	function editFinish(target, id) {
		var buttonTd = $(target).parent();
		var idTd = $(target).parent().siblings().eq(0);
		var nameTd = $(target).parent().siblings().eq(1);

		var newId = idTd.children('input').val();
		var name = nameTd.children('input').val();

		var params = new FormData();
		params.append("id", newId);
		params.append("name", name);
		params.append("originalId", id);

		$.ajax({
			url: 'admin_edit_user.jsp',
			method: 'POST',
			data: {
				id: newId,
				name: name,
				originalId: id
			},
			success: function () {
				alert("성공적으로 회원정보가 변경되었습니다.");

				idTd.children('span').text(newId);
				nameTd.children('span').text(name);

				buttonTd.children('.edit').show();
				idTd.children('span').show();
				nameTd.children('span').show();
				idTd.children('input').hide();
				nameTd.children('input').hide();
				buttonTd.children('.editFinish').hide();
				buttonTd.children('.cancel').hide();

			}
		})
	}

</script>