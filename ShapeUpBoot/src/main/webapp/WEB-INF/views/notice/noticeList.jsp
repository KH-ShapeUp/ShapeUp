<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>공지사항 | ShapeUp</title>
<link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
<link rel="stylesheet" href="/resources/css/notice/noticeList.css" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/head.jsp"/>
	<jsp:include page="/WEB-INF/views/include/header.jsp"/>

	<div class="notice-top">
		<h1>공지사항</h1>
		<form class="notice-search notice-search--top" method="get" action="/notice/list">
			<input type="hidden" name="category" value="${param.category}"/>
			<div class="select-box">
				<select name="searchType">
					<option value="T" ${param.searchType eq 'T' ? 'selected' : ''}>제목</option>
					<option value="C" ${param.searchType eq 'C' ? 'selected' : ''}>내용</option>
					<option value="TC" ${param.searchType eq 'TC' ? 'selected' : ''}>제목+내용</option>
				</select>
				<span class="arrow">&#9662;</span>
			</div>
			<input type="text" name="searchKeyword" placeholder="검색어를 입력하세요" value="${param.searchKeyword}"/>
			<button type="submit" aria-label="검색" class="icon-search-btn"></button>
		</form>
	</div>

	<div class="notice-container">
		<div class="notice-page">
			<div class="notice-controls">
				<div class="notice-bar">
					<div class="notice-summary">
						${totalCount}건의 게시물이 있습니다.
					</div>
					<div class="notice-categories">
						<c:set var="currentCategory" value="${param.category}" />
						<a class="${empty currentCategory ? 'active' : ''}" href="/notice/list">전체</a>
						<a class="${currentCategory eq '공지사항' || currentCategory eq '공지' ? 'active' : ''}" href="/notice/list?category=공지">공지사항</a>
						<a class="${currentCategory eq '이벤트' ? 'active' : ''}" href="/notice/list?category=이벤트">이벤트</a>
						<a class="${currentCategory eq '제휴' || currentCategory eq '파트너' ? 'active' : ''}" href="/notice/list?category=제휴">제휴 / 협찬</a>
						<a class="${currentCategory eq '징계' ? 'active' : ''}" href="/notice/list?category=징계">징계</a>
					</div>
				</div>
			</div>

			<div class="notice-list">
				<c:set var="pageStart" value="${totalCount - (currentPage - 1) * 5}" />
				<c:forEach var="notice" items="${nList}" varStatus="status">
					<div class="notice-card" onclick="location.href='/notice/detail?noticeNo=${notice.noticeNo}'">
						<div class="notice-meta">
							<span class="pill pill-${notice.noticeCategory}">${notice.noticeCategory}</span>
							<span class="notice-date"><fmt:formatDate value="${notice.createdAt}" pattern="yyyy-MM-dd" /></span>
							<span class="notice-title">${notice.noticeTitle}</span>
						</div>
						<div class="notice-extra">
							<span class="notice-writer">${notice.userName != null ? notice.userName : '관리자'}</span>
							<span class="notice-views"><span class="icon-eye"></span> ${notice.viewCount}</span>
						</div>
					</div>
				</c:forEach>
				<c:if test="${empty nList}">
					<div class="notice-empty">등록된 공지사항이 없습니다.</div>
				</c:if>
			</div>

			<div class="notice-pagination">
				<c:set var="categoryParam" value="" />
				<c:if test="${not empty currentCategory}">
					<c:set var="categoryParam" value="${categoryParam}&category=${currentCategory}" />
				</c:if>
				<c:if test="${not empty param.searchKeyword}">
					<c:set var="categoryParam" value="${categoryParam}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}" />
				</c:if>

				<c:if test="${startNavi > 1}">
					<a class="page-btn" href="/notice/list?page=${startNavi - 1}${categoryParam}">이전</a>
				</c:if>
				<c:forEach begin="${startNavi}" end="${endNavi}" var="n">
					<a class="page-btn ${currentPage eq n ? 'active' : ''}" href="/notice/list?page=${n}${categoryParam}">${n}</a>
				</c:forEach>
				<c:if test="${endNavi < maxPage}">
					<a class="page-btn" href="/notice/list?page=${endNavi + 1}${categoryParam}">다음</a>
				</c:if>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>
