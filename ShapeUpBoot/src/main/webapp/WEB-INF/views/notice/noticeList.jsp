<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
			<select name="searchType" class="search-select">
				<option value="T" ${param.searchType eq 'T' ? 'selected' : ''}>제목</option>
				<option value="C" ${param.searchType eq 'C' ? 'selected' : ''}>내용</option>
				<option value="TC" ${param.searchType eq 'TC' ? 'selected' : ''}>제목+내용</option>
			</select> <input type="text" name="searchKeyword" placeholder="검색어를 입력하세요"
				value="${param.searchKeyword}" />

			<c:if test="${not empty currentCategory}">
				<input type="hidden" name="category" value="${currentCategory}" />
			</c:if>

			<button class="search-btn" type="submit">검색</button>
		</form>

		<div class="category-section">
			<div class="left-content">
				<span class="total-count">총 ${totalCount}건</span>
				<c:set var="currentCategory" value="${param.category }" />
				<div class="category-list">
					<a href="/notice/list"
						class="${empty currentCategory ? 'active' : ''}">전체</a> <a
						href="/notice/list?category=공지"
						class="${currentCategory eq '공지' ? 'active' : ''}">공지</a> <a
						href="/notice/list?category=이벤트"
						class="${currentCategory eq '이벤트' ? 'active' : ''}">이벤트</a> <a
						href="/notice/list?category=제휴"
						class="${currentCategory eq '제휴' ? 'active' : ''}">제휴</a> <a
						href="/notice/list?category=징계"
						class="${currentCategory eq '징계' ? 'active' : ''}">징계</a>
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
					<c:set var="pageStart"
						value="${totalCount - (currentPage - 1) * 5}" />

					<c:forEach var="notice" items="${nList}" varStatus="status">
						<tr onclick="location.href='/notice/detail?noticeNo=${notice.noticeNo}'">
							<td>${pageStart - status.index}</td>
							<td><span class="badge ${notice.noticeCategory }">${notice.noticeCategory }</span></td>
							<td class="title-col">${notice.noticeTitle }</td>
							<td><fmt:formatDate value="${notice.createdAt }"
									pattern="yyyy-MM-dd" /></td>
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
			<c:set var="categoryParam" value="" />
			<c:if test="${not empty currentCategory }">
				<c:set var="categoryParam"
					value="${categoryParam }&category=${currentCategory }" />
			</c:if>

			<c:if test="${startNavi > 1 }">
				<a href="/notice/list?page=${startNavi - 1 }${categoryParam}">&lt;</a>
			</c:if>

			<c:if test="${not empty param.searchKeyword}">
				<c:set var="categoryParam"
					value="${categoryParam}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}" />
			</c:if>
			<c:forEach begin="${startNavi }" end="${endNavi }" var="n">
				<a href="/notice/list?page=${n }${categoryParam}"
					class="page-btn <c:if test="${currentPage eq n }">active</c:if>">${n }</a>
			</c:forEach>

			<c:if test="${endNavi < maxPage }">
				<a href="/notice/list?page=${endNavi + 1 }${categoryParam }">&gt;</a>
			</c:if>
		</div>
	</div>

	<footer class="footer-placeholder"></footer>
</body>
</html>