<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>공지사항</title>
<link rel="stylesheet" href="/resources/css/notice/noticeList.css" />
<style>
/* CSS 파일이 분리되지 않은 경우 여기에 스타일을 포함할 수 있습니다. */
/* 아래에 제공된 CSS 내용을 여기에 복사하여 붙여넣으셔도 됩니다. */
</style>
</head>
<body>
	<header class="header-placeholder"></header>

	<div class="container">
		<div class="top-section">
			<h1 class="page-title">공지사항</h1>

			<div class="logo-area">
				<img src="" alt="ShapeUp 로고" />
			</div>
		</div>

		<form class="search-section">
			<input type="text" placeholder="검색어를 입력하세요" />        
			<button class="search-btn" type="submit">검색</button>
			     
		</form>

		<div class="category-section">
			<div class="left-content">
				<span class="total-count">총 ${totalCount}건</span>
				<div class="category-list">
					<a href="#" class="active">전체</a> <a href="#">공지</a> <a href="#">이벤트</a>
					<a href="#">제휴</a> <a href="#">징계</a>
				</div>
			</div>

			<a href="/notice/insert"><button class="write-btn">글쓰기</button></a>
		</div>

		<div class="notice-table-wrapper">
			<table class="notice-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>분류</th>
						<th class="title-col">제목</th>
						<th>날짜</th>
						<th>작성자</th>
						<th>조회</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="notice" items="${nList }">
						<tr>
							<td>${notice.noticeNo }</td>
							<td><span class="badge ${notice.category }">${notice.category }</span></td>
							<td class="title-col">{notice.noticeTitle }</td>
							<td>${notice.createAt }</td>
							<td>관리자</td>
							<td>${notice.viewCount }</td>
						</tr>
					</c:forEach>
					<c:if test="${empty nList }">
						<tr>
							<td colspan="6">등록된 공지사항이 없습니다</td>
						</tr>
					</c:if>
				</tbody>
			</table>
		</div>

		<div class="pagination">
			<a href="#">&lt;</a> <a href="#" class="current">1</a> <a href="#">2</a>
			<a href="#">3</a> <a href="#">4</a> <a href="#">5</a> <a href="#">6</a>
			<a href="#">7</a> <a href="#">8</a> <a href="#">9</a> <a href="#">10</a>
			<a href="#">&gt;</a>
		</div>
	</div>

	<footer class="footer-placeholder"></footer>
</body>
</html>