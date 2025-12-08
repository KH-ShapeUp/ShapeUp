<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>공지사항 상세</title>
<link rel="stylesheet" href="<c:url value='/resources/css/notice/noticeDetail.css'/>" />
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/head.jsp"/>
	<jsp:include page="/WEB-INF/views/include/header.jsp"/>

	<main class="notice-main">
		<div class="notice-wrapper">
			<div class="notice-top-view">
				<div class="notice-top-row">
					<div class="notice-pill ${notice.noticeCategory}">${notice.noticeCategory}</div>
					<div class="notice-meta">
						<span class="meta-date"><fmt:formatDate value="${notice.createdAt}" pattern="yyyy-MM-dd"/></span>
						<span class="meta-view">조회 ${notice.viewCount}</span>
					</div>
				</div>
				<h1 class="notice-title">${notice.noticeTitle}</h1>
			</div>

			<c:set var="bannerImg">
				<c:choose>
					<c:when test="${notice.noticeCategory eq '이벤트'}">/resources/img/notice-top-img/notice_event.png</c:when>
					<c:when test="${notice.noticeCategory eq '공지' || notice.noticeCategory eq '공지사항'}">/resources/img/notice-top-img/notice_notice.png</c:when>
					<c:when test="${notice.noticeCategory eq '제휴' || notice.noticeCategory eq '파트너'}">/resources/img/notice-top-img/notice_sponser.png</c:when>
					<c:when test="${notice.noticeCategory eq '징계'}">/resources/img/notice-top-img/notice_ban.png</c:when>
					<c:otherwise>/resources/img/notice-top-img/notice_notice.png</c:otherwise>
				</c:choose>
			</c:set>
				<img src="${bannerImg}" alt="${notice.noticeCategory} 배너" class="notice-banner-img" />

			<c:if test="${not empty notice.images}">
				<div class="notice-hero-list">
					<c:forEach var="image" items="${notice.images}">
						<div class="notice-hero-image">
							<img src="${image.imgPath}" alt="공지 이미지" />
						</div>
					</c:forEach>
				</div>
			</c:if>

			<div class="notice-content" style="white-space: pre-line;" >
				${notice.noticeContent}
			</div>

			<div class="notice-actions">
				<c:set var="prevNo" value="${empty prevNoticeNo ? param.prevNo : prevNoticeNo}" />
				<c:set var="nextNo" value="${empty nextNoticeNo ? param.nextNo : nextNoticeNo}" />
				<button class="btn-primary" onclick="location.href='/notice/list'">목록</button>
				<c:choose>
					<c:when test="${not empty prevNo}">
						<button class="btn-secondary" onclick="location.href='/notice/detail?noticeNo=${prevNo}'">이전</button>
					</c:when>
					<c:otherwise>
						<button class="btn-secondary disabled" disabled>이전</button>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${not empty nextNo}">
						<button class="btn-secondary" onclick="location.href='/notice/detail?noticeNo=${nextNo}'">다음</button>
					</c:when>
					<c:otherwise>
						<button class="btn-secondary disabled" disabled>다음</button>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</main>

	<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>
