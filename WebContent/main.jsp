<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	request.setCharacterEncoding("UTF-8");

	int paging = request.getParameter("paging") == null ? 1 : Integer.parseInt(request.getParameter("paging"));
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

		#paging-div {
			margin-bottom: 100px;
			float: left;
			margin-top: 20px;
			text-align: center;
			width: 100%;
		}
	</style>
</head>
<body>
<div id="header-area" class="section">
	<div class="navicon" onclick="showMenu()"></div>
	<h3>음료 Taste 평가</h3>
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
	<div class="page-msg">
		<div class="desc">작성글이 존재하지 않습니다.</div>
	</div>
	<div id="--feed-list" class="section"></div>
	<div id="paging-div">
		<input type="hidden" id="paging" value="<%=paging%>"/>
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

	function start(id) {
		var params = "id=" + id + "&paging=" + $('#paging').val();
		AJAX.call("fetch.jsp", params, function (data) {
			var list = JSON.parse(data.trim());
			console.log(list);

			if (list.length > 0) {
				$(".page-msg").css("display", "none");
				showFeeds(list);
			}
		});

		AJAX.call("fetch_paging.jsp", params, function (data) {
				var totalCount = parseInt(JSON.parse(data.trim()));
				var countList = 5; // 페이지당 아이템 표시 개수
				var countPage = 5; // 페이지 넘버 표시할 개수
				var totalPage = totalCount / countList;
				var paging = parseInt($('#paging').val());
				var pagingDiv = $('#paging-div');

				if (totalCount % countList > 0) {
					totalPage++;
				}

				if (totalPage < paging) {
					paging = totalPage;
				}

				var startPage = ((paging - 1) / 10) * 10 + 1;
				var endPage = startPage + countPage - 1;

				if (endPage > totalPage) {
					endPage = totalPage;
				}

				if (startPage > 1) {
					pagingDiv.append('<a href="main.jsp?paging=1">처음</a>');
				}
				if (paging > 1) {
					pagingDiv.append('<a href="main.jsp?paging=' + (paging - 1) + '">이전</a>');
				}

				for (var iCount = startPage; iCount <= endPage; iCount++) {
					if (iCount == paging) {
						pagingDiv.append('<b>' + iCount + '</b>');
					} else {
						pagingDiv.append(iCount);
					}
				}

				if (paging < totalPage) {
					pagingDiv.append('<a href="main.jsp?paging=' + (paging + 1) + '">다음</a>');
				}
				if (endPage < totalPage) {
					pagingDiv.append('<a href="main.jsp?paging=' + (totalPage) + '">끝</a>');
				}
			}
		);
	}

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

	function showFeeds(list) {
		var str = "";
		for (var i = 0; i < list.length; i++) {
			console.log(list[i]);
			str += showFeed(list[i]);
		}
		$("#--feed-list").html(str);

		AJAX.call("session.jsp", null, function (data) {
			var id = data.trim();
			console.log(id);

			for (var i = 0; i < list.length; i++) {
				var listId = $("#--feed-list").children('.feed')[i].children[0].children[1].innerText;
				if (id === listId) {
					$("#--feed-list").children('.feed')[i].children[0].innerHTML += "<div class='board_button'>" + "<button type='button' onclick='editBoard(this)'>수정하기</button> <button type='button' onclick='deleteBoard(this)'>삭제하기</button>" + "</div>";
				}
			}
		});
	}

	function editBoard(target) {
		if (confirm("해당 게시물을 수정하시겠습니까?") == true) {
			var id = $(target).parents('.feed').attr('data-id');
			window.location.href = 'edit.jsp?no=' + id;
		}
	}

	function deleteBoard(target) {
		if (confirm("해당 게시물을 삭제하시겠습니까?") == true) {
			var id = $(target).parents('.feed').attr('data-id');
			$.ajax({
				url: 'delete_taste.jsp',
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

	function showFeed(feed) {
		var str = "<div class='feed' data-id=" + feed.no + ">";

		str += "<div class='author'>";
		str += "<div class='photo'></div>";
		str += "<div class='name'>" + feed.id + "</div>";
		str += "</div>";

		str += "<p>" + feed.desc + "</p>";

		var images = feed.images;
		if (images.length == 1) {
			str += "<div class='section'>";
			str += "<div class='image' style='background-image: url(\"" + getUrl(feed, 0) + "\")'></div>";
			str += "</div>";
		}
		else if (images.length == 2) {
			str += "<div class='grid-50'>";
			str += "<div class='image' style='background-image: url(\"" + getUrl(feed, 0) + "\")'></div>";
			str += "</div>";
			str += "<div class='grid-50'>";
			str += "<div class='image' style='background-image: url(\"" + getUrl(feed, 1) + "\")'></div>";
			str += "</div>";
		}
		else if (images.length == 3) {
			str += "<div class='grid-66'>";
			str += "<div class='image' style='background-image: url(\"" + getUrl(feed, 0) + "\")'></div>";
			str += "</div>";
			str += "<div class='grid-33'>";
			str += "<div class='image' style='background-image: url(\"" + getUrl(feed, 1) + "\")'></div>";
			str += "</div>";
			str += "<div class='grid-33'>";
			str += "<div class='image' style='background-image: url(\"" + getUrl(feed, 2) + "\")'></div>";
			str += "</div>";
		}

		str += "</div>";
		return str;
	}

	function getUrl(feed, index) {
		return "usrimg/" + feed.images[index];
	}
</script>