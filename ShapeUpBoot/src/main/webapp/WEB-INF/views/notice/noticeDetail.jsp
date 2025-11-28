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
<link rel="stylesheet" href="/resources/css/notice/noticeDetail.css" />
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

		<div class="detail-section">
			<div class="detail-header">
				<div class="detail-meta">
					<span class="badge ${notice.noticeCategory}">${notice.noticeCategory }</span> <span
						class="detail-title">${notice.noticeTitle }</span>
				</div>
				<div class="detail-info-right"> 
                    <span class="detail-view-count">조회수: ${notice.viewCount}</span>
                    <span class="detail-date">
                        <fmt:formatDate value="${notice.createdAt }" pattern="yyyy-MM-dd"/>
                    </span>
                </div>
			</div>

			<div class="detail-content">
				<div class="detail-image-placeholder"></div>
				<p>${notice.noticeContent }</p>
			</div>

			<div class="detail-buttons">
				<button class="btn-primary" onclick="location.href='/notice/list'">목록</button>
				<div class="right-buttons">
					<button class="btn-secondary" onclick="location.href='/notice/update?noticeNo=${noticeNo}'">수정</button>
					<button class="btn-secondary" onclick="if(confirm('정말 삭제하시겠습니까?')) {location.href='notice/delete?noticeNo=${notice.noticeNo}'}">삭제</button>
				</div>
			</div>
		</div>
	</div>

	<footer class="footer-placeholder"></footer>
</body>
</html>