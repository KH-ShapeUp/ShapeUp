
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f8f8f8;
            margin: 0;
        }

        .container {
            max-width: 1200px;
            margin: 20px auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
            padding: 0 20px;
        }
        
        .tab-menu {
            display: flex;
            border-bottom: 2px solid #e0e0e0;
            background: #fafafa;
            margin: 0 -20px;
            padding: 0 20px;
            gap: 12px;
            overflow-x: auto;
            scrollbar-width: none;
        }
        .tab-menu::-webkit-scrollbar { display: none; }
        
        .tab-item {
            flex: 1 0 160px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            color: #999;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
            position: relative;
            white-space: nowrap;
        }
        
        .tab-item:hover {
            background: #f0f0f0;
            color: #333;
        }
        
        .tab-item.active {
            color: #8b7fc7;
            border-bottom-color: #8b7fc7;
            background: white;
        }
        
        .content-area {
            padding: 40px 0;
            min-height: 500px;
        }
        
        .content-section { display: none; }
        .content-section.active { display: block; }
        
        .section-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 30px;
            color: #333;
        }
        
        .profile-section {
            display: flex;
            gap: 30px;
            margin-bottom: 40px;
            padding: 30px;
            background: #fafafa;
            border-radius: 8px;
        }
        
        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            flex-shrink: 0;
            text-align: center;
            padding: 8px;
        }
        
        .profile-info { flex: 1; }
        
        .info-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #e0e0e0;
            gap: 12px;
        }
        
        .info-label {
            width: 100px;
            color: #666;
            font-weight: 500;
        }
        
        .info-value {
            color: #333;
            flex: 1;
        }
        
        .edit-btn-container {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .btn-edit {
            padding: 10px 20px;
            background: linear-gradient(135deg, #9b8fd9, #7c6fc7);
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            white-space: nowrap;
        }
        
        .btn-edit:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            padding: 10px 20px;
            background: white;
            color: #8b7fc7;
            border: 1px solid #8b7fc7;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-secondary:hover { background: #f8f8f8; }
        
        .contract-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 20px;
            background: white;
            transition: all 0.3s;
        }
        
        .contract-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        
        .contract-status {
            display: inline-block;
            padding: 6px 12px;
            background: #e8e4f8;
            color: #8b7fc7;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .contract-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
        }
        
        .contract-location {
            color: #8b7fc7;
            font-weight: 500;
            font-size: 14px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
        }
        
        .agent-info {
            background: #fafafa;
            padding: 20px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        
        .agent-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
            gap: 10px;
        }
        .agent-row:last-child { border-bottom: none; }
        
        .agent-label { color: #666; font-size: 14px; font-weight: 500; }
        .agent-value { color: #333; font-weight: 600; }
        .btn-chat {
            display: inline-block;
            padding: 8px 16px;
            background: #8b7fc7;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-chat:hover { background: #7c6fc7; }
        
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            background: white;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        
        .card-image {
            width: 100%;
            height: 150px;
            background: #e0e0e0;
            border-radius: 4px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            overflow: hidden;
        }
        .card-image img { width: 100%; height: 100%; object-fit: cover; border-radius: 4px; }
        
        .card-title { font-size: 16px; font-weight: 600; margin-bottom: 8px; color: #333; }
        .card-desc { font-size: 14px; color: #666; display: flex; gap: 6px; flex-wrap: wrap; align-items: center; }
        
        .list-item {
            display: flex;
            justify-content: space-between;
            padding: 20px;
            border-bottom: 1px solid #eee;
            transition: all 0.3s;
            gap: 12px;
        }
        .list-item:hover { background: #fafafa; }
        
        .list-title { font-weight: 600; color: #333; }
        .list-date { color: #999; font-size: 14px; }
        
        .status-badge {
            font-weight: 500;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 13px;
            text-align: right;
        }
        .status-complete { color: #2c5ff5; background: #e8f1ff; }
        .status-pending { color: #ff6b6b; background: #ffe8e8; }
        
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }
        .modal.active { display: flex; }
        
        .modal-content {
            background: white;
            padding: 40px;
            border-radius: 8px;
            max-width: 500px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
        }
        .modal-title { font-size: 20px; font-weight: 600; margin-bottom: 25px; color: #333; }
        
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 14px; font-weight: 500; color: #333; margin-bottom: 8px; }
        .form-input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-input:focus {
            outline: none;
            border-color: #8b7fc7;
            box-shadow: 0 0 0 3px rgba(139, 127, 199, 0.1);
        }
        
        .modal-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn-save {
            flex: 1;
            padding: 12px;
            background: linear-gradient(135deg, #9b8fd9, #7c6fc7);
            color: white;
            border: none;
            border-radius: 4px;
            font-weight: 500;
            cursor: pointer;
        }
        
        .btn-cancel {
            flex: 1;
            padding: 12px;
            background: #f0f0f0;
            color: #333;
            border: none;
            border-radius: 4px;
            font-weight: 500;
            cursor: pointer;
        }
        
        /* 문의 탭 */
        .inquiry-tab {
            padding: 12px 24px;
            background: transparent;
            border: none;
            border-bottom: 3px solid transparent;
            font-size: 15px;
            font-weight: 500;
            color: #999;
            cursor: pointer;
            transition: all 0.3s;
            white-space: nowrap;
        }
        .inquiry-tab:hover { color: #333; }
        .inquiry-tab.active { color: #8b7fc7; border-bottom-color: #8b7fc7; }

        @media (max-width: 1024px) {
            .container { margin: 12px; padding: 0 16px; }
            .tab-item { padding: 16px; }
            .content-area { padding: 32px 0; }
        }

        @media (max-width: 768px) {
            .profile-section { flex-direction: column; align-items: flex-start; padding: 24px; }
            .info-row { flex-direction: column; align-items: flex-start; }
            .agent-row { flex-direction: column; align-items: flex-start; }
            .list-item { flex-direction: column; align-items: flex-start; }
            .contract-card { padding: 20px; }
            .tab-item { flex: 1 0 auto; }
            .card-grid { grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); }
        }

        @media (max-width: 480px) {
            .container { padding: 0 12px; }
            .tab-item { font-size: 14px; padding: 12px 10px; }
            .section-title { font-size: 20px; }
            .contract-card { padding: 16px; }
            .modal-content { padding: 28px; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/header.jsp"/>

    <div class="container">
        <div class="tab-menu">
            <div class="tab-item active" data-tab="mypage">마이페이지</div>
            <div class="tab-item" data-tab="contract">계약 현황</div>
            <div class="tab-item" data-tab="wishlist">찜매물</div>
            <div class="tab-item" data-tab="inquiries">문의 내역</div>
        </div>
        
        <div class="content-area">
            <div class="content-section active" id="mypage">
                <div class="section-title">마이페이지</div>
                <div class="profile-section">
                    <div class="profile-image">프로필 사진
                        <!--
                        <c:choose>
                            <c:when test="${not empty user.profileImage}">
                                <img src="${pageContext.request.contextPath}${user.profileImage}" alt="프로필" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                            </c:when>
                            <c:otherwise>프로필 사진</c:otherwise>
                        </c:choose>
                        -->
                    </div>
                    <div class="profile-info">
                        <div class="info-row">
                            <div class="info-label">아이디</div>
                            <div class="info-value">${user.userId != null ? user.userId : 'user_123'}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">이름</div>
                            <div class="info-value">${user.userName != null ? user.userName : '홍길동'}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">나이</div>
                            <div class="info-value">${user.userAge != null ? user.userAge : '34'}세</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">성별</div>
                            <div class="info-value">${user.userGender == 'M' ? '남성' : (user.userGender == 'F' ? '여성' : '선택 안함')}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">연락처</div>
                            <div class="info-value">${user.userPhone != null ? user.userPhone : '010-1234-5678'}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">이메일</div>
                            <div class="info-value">${user.userEmail != null ? user.userEmail : 'example@email.com'}</div>
                        </div>
                        <div class="edit-btn-container">
                            <button class="btn-edit" onclick="openEditModal()">회원 정보 수정</button>
                            <button class="btn-secondary" onclick="confirmDelete()">회원 탈퇴</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="content-section" id="contract">
                <div class="section-title">계약 현황</div>

                <c:choose>
                    <c:when test="${not empty contractedProperties}">
                        <c:forEach var="property" items="${contractedProperties}">
                            <div class="contract-card">
                                <div class="contract-status" style="background: #e8f1ff; color: #2c5ff5;">계약 완료</div>
                                <div class="contract-title">${property.propertyName}</div>
                                <div class="contract-location"><i class="fa-solid fa-location-dot"></i> ${property.roadAddress}</div>

                                <div class="agent-info">
                                    <div class="agent-row">
                                        <div class="agent-label">매물번호</div>
                                        <div class="agent-value">#${property.propertyNo}</div>
                                    </div>
                                    <div class="agent-row">
                                        <div class="agent-label">매물 유형</div>
                                        <div class="agent-value">
                                            <c:choose>
                                                <c:when test="${property.propertyType eq 'ONEROOM'}">원룸</c:when>
                                                <c:when test="${property.propertyType eq 'TWOROOM'}">투룸</c:when>
                                                <c:when test="${property.propertyType eq 'THREEROOM'}">쓰리룸</c:when>
                                                <c:when test="${property.propertyType eq 'OFFICETEL'}">오피스텔</c:when>
                                                <c:otherwise>${property.propertyType}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="agent-row">
                                        <div class="agent-label">가격</div>
                                        <div class="agent-value">
                                            <c:if test="${property.deposit > 0}">보증금 ${property.deposit}만원</c:if>
                                            <c:if test="${property.monthlyRent > 0}"> / 월세 ${property.monthlyRent}만원</c:if>
                                        </div>
                                    </div>
                                    <div class="agent-row">
                                        <div class="agent-label">계약일시</div>
                                        <div class="agent-value">
                                            <fmt:formatDate value="${property.contractAt}" pattern="yyyy년 MM월 dd일 HH:mm"/>
                                        </div>
                                    </div>
                                    <div class="agent-row">
                                        <div class="agent-label">중개사 ID</div>
                                        <div class="agent-value">${property.realtorId}</div>
                                    </div>
                                </div>

                                <button class="btn-edit" style="width: 100%; text-align: center;" onclick="location.href='${pageContext.request.contextPath}/property/${property.propertyNo}'">
                                    해당 매물 상세보기
                                </button>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; background: #fafafa; border-radius: 8px;">
                            <div style="font-size: 48px; margin-bottom: 20px; opacity: 0.5;">
                                <i class="fa-solid fa-house-user"></i>
                            </div>
                            <div style="font-size: 16px; font-weight: 600; color: #333; margin-bottom: 8px;">
                                계약된 매물이 없습니다
                            </div>
                            <div style="font-size: 14px; color: #999; margin-bottom: 20px;">
                                매물을 찾아보세요.
                            </div>
                            <button class="btn-edit" onclick="location.href='${pageContext.request.contextPath}/map'">
                                <i class="fa-solid fa-search"></i> 매물 찾아보기
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="content-section" id="wishlist">
                <div class="section-title">찜매물</div>
                <div class="card-grid">
                    <c:choose>
                        <c:when test="${not empty wishlist}">
                            <c:forEach var="property" items="${wishlist}">
                                <div class="card" onclick="location.href='${pageContext.request.contextPath}/property/${property.propertyNo}'">
                                    <div class="card-image">
                                        <c:choose>
                                            <c:when test="${not empty wImg}">
                                                <c:forEach var="img" items="${wImg}">
                                                    <c:if test="${img.propertyNo == property.propertyNo && img.imgOrder == 0}">
                                                        <img src="${pageContext.request.contextPath}${img.imgPath}" alt="${property.propertyName}">
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                매물 이미지
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
    
                                    <div class="card-title">${property.propertyName}</div>
                                    <div class="card-desc">
                                        <span>${property.contractArea}㎡</span>
                                        <span>|</span>
                                        <c:choose>
                                            <c:when test="${property.priceType eq '월세'}">
                                                <span>보증금 ${property.deposit} / 월세 ${property.monthlyRent}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span>매매가 ${property.deposit}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; background: #fafafa; border-radius: 8px;">
                                <div style="font-size: 48px; margin-bottom: 20px; opacity: 0.5;">
                                    <i class="fa-solid fa-heart"></i>
                                </div>
                                <div style="font-size: 16px; font-weight: 600; color: #333; margin-bottom: 8px;">
                                    찜한 매물이 없습니다
                                </div>
                                <div style="font-size: 14px; color: #999; margin-bottom: 20px;">
                                    마음에 드는 매물을 찜해보세요.
                                </div>
                                <button class="btn-edit" onclick="location.href='${pageContext.request.contextPath}/map'">
                                    <i class="fa-solid fa-search"></i> 매물 찾아보기
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
                        
            <div class="content-section" id="inquiries">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; gap: 12px; flex-wrap: wrap;">
                    <div class="section-title" style="margin-bottom: 0;">문의 내역</div>
                    <button class="btn-edit" onclick="location.href='${pageContext.request.contextPath}/inquiries/contact-admin'">
                        <i class="fa-solid fa-headset"></i> 관리자에게 문의하기
                    </button>
                </div>
                
                <div style="display: flex; gap: 10px; margin-bottom: 20px; border-bottom: 2px solid #e0e0e0; overflow-x: auto; scrollbar-width: none;">
                    <button class="inquiry-tab active" data-inquiry-type="all" onclick="switchInquiryTab('all')">전체 문의</button>
                    <button class="inquiry-tab" data-inquiry-type="admin" onclick="switchInquiryTab('admin')">관리자 문의</button>
                    <button class="inquiry-tab" data-inquiry-type="realtor" onclick="switchInquiryTab('realtor')">중개사 문의</button>
                </div>
                
                <c:choose>
                    <c:when test="${not empty inquiries}">
                        <c:forEach var="inquiry" items="${inquiries}">
                            <div class="list-item inquiry-item-wrapper" 
                                 data-inquiry-type="${inquiry.inquiryType}"
                                 data-created="${inquiry.createdAt.time}"
                                 style="cursor: pointer; align-items: flex-start;" 
                                 onclick="toggleInquiryDetail(this)">
                                <div style="flex: 1;">
                                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px; flex-wrap: wrap;">
                                        <div class="list-title">${inquiry.title}</div>
                                        
                                        <c:if test="${not empty inquiry.category}">
                                            <span style="padding: 4px 8px; background: #f0f0f0; color: #666; border-radius: 4px; font-size: 12px;">
                                                <c:choose>
                                                    <c:when test="${inquiry.category == 'VISIT'}">방문 문의</c:when>
                                                    <c:when test="${inquiry.category == 'PRICE'}">가격 문의</c:when>
                                                    <c:when test="${inquiry.category == 'CONTRACT'}">계약 문의</c:when>
                                                    <c:when test="${inquiry.category == 'ETC'}">기타</c:when>
                                                    <c:otherwise>${inquiry.category}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </c:if>
                                        
                                        <c:choose>
                                            <c:when test="${inquiry.inquiryType == 'ADMIN'}">
                                                <span style="padding: 4px 8px; background: #e0e7ff; color: #667eea; border-radius: 4px; font-size: 12px; font-weight: 600;">
                                                    <i class="fa-solid fa-user-shield"></i> 관리자
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="padding: 4px 8px; background: #c6f6d5; color: #22543d; border-radius: 4px; font-size: 12px; font-weight: 600;">
                                                    <i class="fa-solid fa-user-tie"></i> 중개사
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <c:if test="${inquiry.readYn == 'N'}">
                                            <span class="new-badge" style="padding: 4px 8px; background: #ff6b6b; color: white; border-radius: 4px; font-size: 11px; font-weight: 600;">
                                                NEW
                                            </span>
                                        </c:if>
                                    </div>
                                    
                                    <div class="list-date">
                                        <i class="fa-solid fa-calendar"></i>
                                        <fmt:formatDate value="${inquiry.createdAt}" pattern="yyyy.MM.dd HH:mm"/>
                                    </div>
                                    
                                    <c:if test="${inquiry.inquiryType == 'REALTOR'}">
                                        <c:if test="${not empty inquiry.realtorId}">
                                            <div style="margin-top: 8px; font-size: 13px; color: #666;">
                                                <i class="fa-solid fa-building"></i> 중개사 ${inquiry.realtorId}
                                                <span style="margin-left: 15px;">
                                                    <i class="fa-solid fa-user"></i> 회원 ${inquiry.userId}
                                                </span>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty inquiry.propertyId}">
                                            <div style="margin-top: 4px; font-size: 13px; color: #666;">
                                                <i class="fa-solid fa-home"></i> 매물 이름: ${inquiry.propertyName}
                                            </div>
                                        </c:if>
                                    </c:if>
                                    
                                    <div class="inquiry-detail" style="display: none; margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
                                        <div style="margin-bottom: 20px;">
                                            <div style="font-weight: 600; color: #333; margin-bottom: 10px; display: flex; align-items: center; gap: 8px;">
                                                <i class="fa-solid fa-comment-dots"></i> 문의 내용
                                            </div>
                                            <div style="color: #666; line-height: 1.8; white-space: pre-wrap; background: #f9f9f9; padding: 15px; border-radius: 6px;">${inquiry.content}</div>
                                        </div>
                                        
                                        <c:choose>
                                            <c:when test="${inquiry.status == 'ANSWERED'}">
                                                <div style="background: #e8f1ff; padding: 20px; border-radius: 8px; border-left: 4px solid #2c5ff5;">
                                                    <div style="display: flex; justify-content: space-between; margin-bottom: 12px; flex-wrap: wrap; gap: 8px;">
                                                        <div style="font-weight: 600; color: #2c5ff5; display: flex; align-items: center; gap: 8px;">
                                                            <i class="fa-solid fa-check-circle"></i> 
                                                            ${inquiry.inquiryType == 'ADMIN' ? '관리자' : '중개사'} 답변
                                                        </div>
                                                        <div style="font-size: 13px; color: #666;">
                                                            <i class="fa-solid fa-clock"></i>
                                                            <fmt:formatDate value="${inquiry.answeredAt}" pattern="yyyy.MM.dd HH:mm"/>
                                                        </div>
                                                    </div>
                                                    <div style="color: #333; line-height: 1.8; white-space: pre-wrap;">${inquiry.answer}</div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div style="background: #fff3cd; padding: 15px; border-radius: 6px; text-align: center; color: #856404; border: 1px solid #ffeaa7;">
                                                    <i class="fa-solid fa-hourglass-half"></i> 
                                                    ${inquiry.inquiryType == 'ADMIN' ? '관리자' : '중개사'}의 답변을 기다리고 있습니다.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 10px;">
                                    <div class="status-badge ${inquiry.status == 'ANSWERED' ? 'status-complete' : 'status-pending'}">
                                        ${inquiry.status == 'ANSWERED' ? '답변 완료' : '답변 대기'}
                                    </div>
                                    <button onclick="event.stopPropagation(); toggleInquiryDetail(this.closest('.list-item'))" 
                                            style="padding: 6px 12px; background: white; color: #8b7fc7; border: 1px solid #8b7fc7; border-radius: 4px; font-size: 12px; cursor: pointer; transition: all 0.3s;">
                                        <i class="fa-solid fa-chevron-down"></i> 자세히 보기
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <div id="no-admin-inquiry" style="display: none; text-align: center; padding: 60px 20px; background: #fafafa; border-radius: 8px;">
                            <div style="font-size: 48px; margin-bottom: 20px; opacity: 0.5;">
                                <i class="fa-solid fa-inbox"></i>
                            </div>
                            <div style="font-size: 16px; font-weight: 600; color: #333; margin-bottom: 8px;">
                                관리자 문의 내역이 없습니다
                            </div>
                            <div style="font-size: 14px; color: #999; margin-bottom: 20px;">
                                궁금한 사항이 있으면 관리자에게 문의해주세요.
                            </div>
                            <button class="btn-edit" onclick="location.href='${pageContext.request.contextPath}/inquiries/contact-admin'">
                                <i class="fa-solid fa-headset"></i> 관리자에게 문의하기
                            </button>
                        </div>
                        
                        <div id="no-realtor-inquiry" style="display: none; text-align: center; padding: 60px 20px; background: #fafafa; border-radius: 8px;">
                            <div style="font-size: 48px; margin-bottom: 20px; opacity: 0.5;">
                                <i class="fa-solid fa-inbox"></i>
                            </div>
                            <div style="font-size: 16px; font-weight: 600; color: #333; margin-bottom: 8px;">
                                중개사 문의 내역이 없습니다
                            </div>
                            <div style="font-size: 14px; color: #999;">
                                매물 상세 페이지에서 중개사에게 문의할 수 있습니다.
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 80px 20px; background: #fafafa; border-radius: 8px;">
                            <div style="font-size: 64px; margin-bottom: 20px; opacity: 0.5;">
                                <i class="fa-solid fa-comments"></i>
                            </div>
                            <div style="font-size: 20px; font-weight: 600; color: #333; margin-bottom: 12px;">
                                등록된 문의 내역이 없습니다
                            </div>
                            <div style="font-size: 14px; color: #999; margin-bottom: 30px;">
                                궁금한 사항이 있으면 관리자에게 문의해주세요.
                            </div>
                            <button class="btn-edit" onclick="location.href='${pageContext.request.contextPath}/inquiries/contact-admin'">
                                <i class="fa-solid fa-headset"></i> 관리자에게 문의하기
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <div class="modal" id="editModal">
        <div class="modal-content">
            <div class="modal-title">회원 정보 수정</div>

            <form action="${pageContext.request.contextPath}/mypage/update" method="post" id="updateForm">
               <input type="hidden" name="userId" value="${user.userId}">
                <div class="form-group">
                    <label class="form-label">이름</label>
                    <input type="text" name="userName" class="form-input" value="${user.userName != null ? user.userName : '홍길동'}" placeholder="이름을 입력하세요" required>
                </div>

                <div class="form-group">
                    <label class="form-label">나이</label>
                    <input type="number" name="userAge" class="form-input" value="${user.userAge != null ? user.userAge : '34'}" placeholder="나이를 입력하세요" required>
                </div>

                <div class="form-group">
                    <label class="form-label">성별</label>
                    <select name="userGender" class="form-input">
                        <option value="M" ${user.userGender == 'M' ? 'selected' : ''}>남성</option>
                        <option value="F" ${user.userGender == 'F' ? 'selected' : ''}>여성</option>
                        <option value="" ${empty user.userGender ? 'selected' : ''}>선택 안함</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">연락처</label>
                    <input type="tel" name="userPhone" class="form-input" value="${user.userPhone != null ? user.userPhone : '010-1234-5678'}" placeholder="연락처를 입력하세요" required>
                </div>

                <div class="form-group">
                    <label class="form-label">이메일</label>
                    <input type="email" name="userEmail" class="form-input" value="${user.userEmail != null ? user.userEmail : 'example@email.com'}" placeholder="이메일을 입력하세요" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">지역</label>
                    <input type="text" name="userRegion" class="form-input" value="${user.userRegion != null ? user.userRegion : '서울특별시'}" placeholder="거주 지역을 입력하세요">
                </div>
                
                <div class="form-group">
                    <label class="form-label">학교/직장</label>
                    <input type="text" name="userSchool" class="form-input" value="${user.userSchool != null ? user.userSchool : 'KH정보학교'}" placeholder="학교 또는 직장을 입력하세요">
                </div>

                <div class="modal-buttons">
                    <button type="button" class="btn-save" onclick="saveChanges()">저장하기</button>
                    <button type="button" class="btn-cancel" onclick="closeEditModal()">취소</button>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>

    <script>
        // 탭 네비게이션
        const tabs = document.querySelectorAll('.tab-item');
        const sections = document.querySelectorAll('.content-section');

        tabs.forEach(tab => {
            tab.addEventListener('click', function() {
                const targetTab = this.dataset.tab;

                tabs.forEach(t => t.classList.remove('active'));
                sections.forEach(s => s.classList.remove('active'));

                this.classList.add('active');
                document.getElementById(targetTab).classList.add('active');
            });
        });

        // 모달 기능
        function openEditModal() {
            document.getElementById('editModal').classList.add('active');
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
        }

        function saveChanges() {
            const form = document.getElementById('updateForm');

            if (!form.checkValidity()) {
                alert('모든 필드를 올바르게 입력해주세요.');
                return;
            }

            form.submit();
        }

        // 회원 탈퇴
        function confirmDelete() {
            if (confirm('정말 탈퇴하시겠습니까? 탈퇴 후에는 복구가 어렵습니다.')) {
                location.href = '${pageContext.request.contextPath}/mypage/delete';
            }
        }

        // 채팅 열기
        function openChat(contractId) {
            location.href = '${pageContext.request.contextPath}/chat/' + contractId;
        }

        // 모달 바깥 클릭 시 닫기
        document.getElementById('editModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeEditModal();
            }
        });
        
        // 문의 유형 필터 및 정렬
        function switchInquiryTab(type) {
            document.querySelectorAll('.inquiry-tab').forEach(tab => tab.classList.remove('active'));
            const selectedTab = document.querySelector('[data-inquiry-type="' + type + '"]');
            if (selectedTab) { selectedTab.classList.add('active'); }
            
            const inquiryItems = Array.from(document.querySelectorAll('.inquiry-item-wrapper'));
            const visibleItems = inquiryItems.filter(item => {
                const itemType = item.getAttribute('data-inquiry-type');
                if (type === 'all') {
                    item.style.display = 'flex';
                    return true;
                } else if (type === 'admin' && itemType === 'ADMIN') {
                    item.style.display = 'flex';
                    return true;
                } else if (type === 'realtor' && itemType === 'REALTOR') {
                    item.style.display = 'flex';
                    return true;
                }
                item.style.display = 'none';
                return false;
            });

            visibleItems.sort((a, b) => {
                const isANew = a.querySelector('.new-badge') !== null;
                const isBNew = b.querySelector('.new-badge') !== null;
                const timeA = parseInt(a.dataset.created, 10);
                const timeB = parseInt(b.dataset.created, 10);

                if (isANew && !isBNew) return -1;
                if (!isANew && isBNew) return 1;
                return timeB - timeA;
            });

            if (inquiryItems.length > 0) {
                const inquiryListContainer = inquiryItems[0].parentNode;
                if (inquiryListContainer) {
                    visibleItems.forEach(item => inquiryListContainer.appendChild(item));
                }
            }
            
            const noAdminMsg = document.getElementById('no-admin-inquiry');
            const noRealtorMsg = document.getElementById('no-realtor-inquiry');
            if (noAdminMsg) {
                noAdminMsg.style.display = (type === 'admin' && visibleItems.length === 0) ? 'block' : 'none';
            }
            if (noRealtorMsg) {
                noRealtorMsg.style.display = (type === 'realtor' && visibleItems.length === 0) ? 'block' : 'none';
            }
        }

        // 문의 상세보기 토글
        function toggleInquiryDetail(element) {
            const detailDiv = element.querySelector('.inquiry-detail');
            const button = element.querySelector('button');
            
            if (detailDiv.style.display === 'none' || detailDiv.style.display === '') {
                detailDiv.style.display = 'block';
                button.innerHTML = '<i class="fa-solid fa-chevron-up"></i> 접기';
            } else {
                detailDiv.style.display = 'none';
                button.innerHTML = '<i class="fa-solid fa-chevron-down"></i> 자세히 보기';
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            const activeTab = document.querySelector('.inquiry-tab.active');
            if (activeTab) {
                switchInquiryTab(activeTab.dataset.inquiryType);
            } else {
                switchInquiryTab('all');
            }
            
            const urlParams = new URLSearchParams(window.location.search);
            const tabParam = urlParams.get('tab');
            if (tabParam) {
                const targetTab = document.querySelector(`.tab-item[data-tab="${tabParam}"]`);
                if (targetTab) {
                    tabs.forEach(t => t.classList.remove('active'));
                    sections.forEach(s => s.classList.remove('active'));

                    targetTab.classList.add('active');
                    document.getElementById(tabParam).classList.add('active');
                    
                    if (tabParam === 'inquiries') {
                        const activeInquiryTab = document.querySelector('.inquiry-tab.active');
                        if(activeInquiryTab) {
                            switchInquiryTab(activeInquiryTab.dataset.inquiryType);
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
