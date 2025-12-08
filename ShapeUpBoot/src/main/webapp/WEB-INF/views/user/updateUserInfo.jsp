<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원정보 수정 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/updateUserInfo.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/mypage.css">
  
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>
  <!-- ========== 쪽지함 알림 시스템 ========== -->
  <div class="notification-container">
    <button class="notification-icon-btn" id="notificationIconBtn">
      📬
      <span class="notification-badge" id="notificationBadge" style="display: none;">0</span>
    </button>
    
    <div class="notification-dropdown" id="notificationDropdown">
      <div class="notification-header">
        <div class="notification-title">
          <span>📬</span>
          <span>권한 신청 알림</span>
        </div>
        <button class="notification-close-btn" id="notificationCloseBtn">✕</button>
      </div>
      
      <div class="notification-list" id="notificationList">
        <div class="notification-empty">
          <div class="notification-empty-icon">📭</div>
          <div>알림이 없습니다</div>
        </div>
      </div>
    </div>
  </div>

  <div class="mypage-container">
    <!-- 헤더 -->
    <div class="page-header">
      <h1>사용자 정보</h1>
      <p>회원님의 정보를 확인하고 수정할 수 있습니다</p>
    </div>

    <!-- 메시지 영역 -->
    <div class="content-area">
      <div id="messageBox" class="message"></div>

      <!-- 탭 메뉴 -->
      <div class="tab-menu">
        <a href="${pageContext.request.contextPath}/user/updateUserInfo" class="tab-button active">
          <span class="tab-icon">👤</span>사용자 정보
        </a>
        <a href="${pageContext.request.contextPath}/user/accountManage" class="tab-button">
          <span class="tab-icon">⚙️</span>계정 관리
        </a>
        <a href="${pageContext.request.contextPath}/user/userInterest" class="tab-button">
          <span class="tab-icon">⭐</span>관심사 설정
        </a>
        <a href="${pageContext.request.contextPath}/user/settingGoal" class="tab-button">
          <span class="tab-icon">🎯</span>목표 설정
        </a>
      </div>

      <!-- 사용자 정보 콘텐츠 -->
      
      <!-- 프로필 이미지 섹션 -->
      <div class="info-section">
        <h2 class="section-title">프로필 이미지</h2>
        
        <div class="profile-image-container">
          <div class="profile-image-wrapper">
            <img id="profileImagePreview" 
                 src="${not empty profileImage ? pageContext.request.contextPath.concat(profileImage.imgPath).concat('/').concat(profileImage.imgRename) : pageContext.request.contextPath.concat('/resources/img/default-profile.png')}" 
                 alt="프로필 이미지"
                 class="profile-image">
            <div class="profile-image-overlay" onclick="document.getElementById('profileImageInput').click()">
              <span>📷</span>
              <span>변경</span>
            </div>
          </div>
          
          <div class="profile-image-actions">
            <input type="file" 
                   id="profileImageInput" 
                   accept="image/jpeg,image/png,image/jpg" 
                   style="display: none;" 
                   onchange="previewProfileImage(this)">
            <button class="btn btn-edit" onclick="document.getElementById('profileImageInput').click()">
              이미지 선택
            </button>
            <button class="btn btn-save" id="uploadProfileBtn" style="display: none;" onclick="uploadProfileImage()">
              저장
            </button>
            <button class="btn btn-cancel" id="cancelProfileBtn" style="display: none;" onclick="cancelProfileImage()">
              취소
            </button>
            <c:if test="${not empty profileImage}">
              <button class="btn btn-delete" onclick="deleteProfileImage()">
                삭제
              </button>
            </c:if>
          </div>
          
          <div class="profile-image-info">
            <small>JPG, PNG 파일만 가능 (최대 5MB)</small>
          </div>
        </div>
      </div>

      
      <!-- 기본 정보 섹션 -->
      <div class="info-section">
        <h2 class="section-title">기본 정보</h2>

        <div class="info-group">
          <div class="info-label">아이디</div>
          <div class="info-value readonly">${user.userId}</div>
        </div>

        <div class="info-group">
          <div class="info-label">이름</div>
          <div class="info-value readonly">${user.userName}</div>
        </div>

        <!-- 유저 구분 (권한 추가 및 포기 버튼 포함) -->
        <div class="info-group">
          <div class="info-label">유저 구분</div>
          <div class="user-type-wrapper">
            <div class="info-value readonly" id="userTypeDisplay"></div>
            <div class="permission-buttons" id="permissionButtonsContainer">
              <!-- 대기 중인 신청이 없을 때 -->
              <div id="normalButtons">
                <button class="btn btn-request-permission" onclick="openPermissionSelect()">권한 신청</button>
                <c:if test="${user.userType != 'USER'}">
                  <button class="btn btn-revoke-permission" onclick="openRevokePermissionModal()">권한 포기</button>
                </c:if>
              </div>
              
              <!-- 대기 중인 신청이 있을 때 -->
              <div id="pendingButtons" style="display: none;">
                <div class="pending-status">
                  <span class="pending-badge">⏳ 승인 대기중</span>
                  <span class="pending-type" id="pendingRequestType"></span>
                </div>
                <button class="btn btn-cancel-request" onclick="cancelPendingRequest()">신청 취소</button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 닉네임 (편집 가능) -->
        <div class="info-group">
          <div class="info-label">닉네임</div>
        
          <!-- 현재 표시되는 닉네임 -->
          <div class="info-value" id="nicknameDisplay">${user.userNickname}</div>
        
          <!-- 수정 폼 -->
          <div class="edit-form" id="nicknameEditForm">
            <input type="text" id="nicknameInput" value="${user.userNickname}" placeholder="닉네임을 입력하세요">
            <input type="hidden" id="userNo" value="${user.userNo}">
            <button class="btn btn-save" onclick="saveNickname()">저장</button>
            <button class="btn btn-cancel" onclick="cancelEdit('nickname')">취소</button>
          </div>
        
          <!-- 수정 버튼 영역 -->
          <div class="info-actions" id="nicknameActions">
            <button class="btn btn-edit" onclick="editField('nickname')">수정</button>
          </div>
        </div>

        <div class="info-group">
          <div class="info-label">생년월일</div>
          <div class="info-value readonly" id="birthDateDisplay"></div>
        </div>

        <div class="info-group">
          <div class="info-label">나이</div>
          <div class="info-value readonly">${user.userAge}세</div>
        </div>

        <div class="info-group">
          <div class="info-label">가입일</div>
          <div class="info-value readonly">
            <fmt:formatDate value="${user.createdAt}" pattern="yyyy년 MM월 dd일"/>
          </div>
        </div>
      </div>


      <!-- 연락처 정보 섹션 -->
      <div class="info-section">
        <h2 class="section-title">연락처 정보</h2>

        <!-- 이메일 -->
        <div class="info-group">
          <div class="info-label">이메일</div>
          <div class="info-value readonly" id="emailDisplay">${user.userEmail}</div>
        </div>

        <!-- 전화번호 -->
        <div class="info-group">
          <div class="info-label">전화번호</div>
          <div class="info-value" id="phoneDisplay">${user.userPhone}</div>
          <div class="edit-form" id="phoneEditForm">
            <input type="tel" id="phoneInput" value="${user.userPhone}" placeholder="010-1234-5678">
            <button class="btn btn-save" onclick="savePhone()">저장</button>
            <button class="btn btn-cancel" onclick="cancelEdit('phone')">취소</button>
          </div>
          <div class="info-actions" id="phoneActions">
            <button class="btn btn-edit" onclick="editField('phone')">수정</button>
          </div>
        </div>
      </div>

      <!-- 게시물, 매칭 관리 -->
      <div class="info-section">
        <h2 class="board-title">내가 쓴 게시물</h2>

        <div class="board-section">
          <c:choose>
            <c:when test="${not empty cList}">
              <c:forEach var="comunityList" items="${cList}">
                <a href="/community/detail?boardNo=${comunityList.communityNo}">
                  <div class="board-card">
                    <div class="board-top-left">
                      <div class="card-top">
                        <c:choose>
                          <c:when test="${comunityList.communityType eq 'success'}">
                            <span class="board-category-success">성공 후기</span>
                          </c:when>
                          <c:when test="${comunityList.communityType eq '일상/소통'}">
                            <span class="board-category">${comunityList.communityType}</span>
                          </c:when>
                          <c:when test="${comunityList.communityType eq '운동질문'}">
                            <span class="board-category-question">${comunityList.communityType}</span>
                          </c:when>
                          <c:when test="${comunityList.communityType eq '운동꿀팁'}">
                            <span class="board-category-tip">${comunityList.communityType}</span>
                          </c:when>
                          <c:when test="${comunityList.communityType eq '식단/영양'}">
                            <span class="board-category-diet">${comunityList.communityType}</span>
                          </c:when>
                          <c:when test="${comunityList.communityType eq '운동인증'}">
                            <span class="board-category-workout">${cLcomunityListist.communityType}</span>
                          </c:when>
                        </c:choose>
                        <span class="card-title">${comunityList.communityTitle}</span>
                      </div>
                      <div class="card-footer">
                        <span class="nick-name">${comunityList.userNickName}</span>
                        <span class="created-Date">${comunityList.createdDay}</span>
                        <span class="viewCount">조회 ${comunityList.viewCount}</span>
                      </div>
                    </div>
                    <div class="board-top-right">
                      <div class="board-comment">
                        <span class="comment">${comunityList.commentCount}</span>
                        <span class="comment-txt">댓글</span>
                      </div>
                    </div>
                  </div>
                </a>
              </c:forEach>
            </c:when>
              <c:otherwise>
                <div style="width:100%; height: 10vh; display:flex; align-items:center; justify-content:center; flex-direction: column; gap:10px">
                  <span class="material-symbols-outlined" style="font-size:50px; color:#aaa; font-weight: 500;">error</span>
                  <p style="margin-top:10px; font-size:1rem; font-weight: 500; color:#aaa;">작성한 댓글이 없습니다.</p>    
                </div>
              </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- 댓글 관리 -->
      <div class="info-section">
          <h2 class="section-title">내가 쓴 댓글</h2>

          <div class="board-section">
            <c:choose>
              <c:when test="${not empty cmList}">
                <c:forEach var="cmList" items="${cmList}">
                  <a href="/community/detail?boardNo=${cmList.communityNo}">
                    <div class="board-card">
                      <div class="board-top-left">
                        <div class="card-top">
                          <span class="card-title">${cmList.commentContent}</span>
                        </div>
                        <div class="card-footer">
                          <span class="created-Date">${cmList.createdDay}</span>
                        </div>
                      </div>
                      <div class="board-top-right">
                        <button class="commentdelete" data-comment-no="${cmList.commentNo}">삭제</button>
                      </div>
                    </div>
                  </a>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <div style="width:100%; height: 10vh; display:flex; align-items:center; justify-content:center; flex-direction: column; gap:10px">
                  <span class="material-symbols-outlined" style="font-size:50px; color:#aaa; font-weight: 500;">error</span>
                  <p style="margin-top:10px; font-size:1rem; font-weight: 500; color:#aaa;">작성한 댓글이 없습니다.</p>    
                </div>
              </c:otherwise>  
            </c:choose>
          </div>
      </div>
      <!-- 매칭 관리 -->
      <div class="info-section">
        <h2 class="board-title">내가 쓴 매칭</h2>

        <div class="board-section">
          <c:choose>
            <c:when test="${not empty mList}">
              <c:forEach var="mList" items="${mList}"> 

              <div class="matching-card">
                <div class="matching-card-top">
                  <div class="card-info">
                    <span class="board-category">${mList.activityName}</span>
                    <span class="card-title">${mList.matchingTitle}</span>
                    <span class="created-day">작성일: ${mList.createdDate}</span>
                  </div>
                  <div class="setting">
                    <button class="matchingDelete" data-matching-no="${mList.matchingNo}">삭제</button>
                  </div>
                </div>
                <div class="card-partner-type">
                  <span class="matchingContent">${mList.matchingContent}</span>
                </div>
                <div class="matching-footer">
                  <div class="matching-location">
                      <i class="fa-solid fa-location-dot"></i>
                      <span>${mList.matchingLocation}</span>
                  </div>
                  <div class="matching-time">
                      <i class="fa-solid fa-clock"></i>
                      <span>${mList.matchingTime}</span>
                  </div>
                  <div class="matching-day">
                      <i class="fa-solid fa-calendar-days"></i>
                      <span>${mList.matchingDate}</span>
                  </div>
                  <div class="matching-money">
                      <i class="fa-solid fa-wallet"></i>
                      <span>${mList.matchingPrice}</span>
                  </div>
                  <div class="matching-user">
                      <i class="fa-solid fa-users"></i>
                      <span>${mList.applicationCount}/${mList.matchingUserCount} 명</span>
                  </div>
                </div>
              </div>

            </c:forEach>
            </c:when>
              <c:otherwise>
                <div style="width:100%; height: 10vh; display:flex; align-items:center; justify-content:center; flex-direction: column; gap:10px">
                  <span class="material-symbols-outlined" style="font-size:50px; color:#aaa; font-weight: 500;">error</span>
                  <p style="margin-top:10px; font-size:1rem; font-weight: 500; color:#aaa;">작성한 매칭이 없습니다.</p>    
                </div>
              </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- 신청한 매칭 -->
      <div class="info-section">
        <h2 class="board-title">내가 신청한 매칭</h2>

        <div class="board-section">
          <c:choose>
            <c:when test="${not empty aList}">
              <c:forEach var="aList" items="${aList}"> 

              <div class="matching-card">
                <div class="matching-card-top">
                  <div class="card-info">
                    <c:choose>
                      <c:when test="${aList.matchingType eq 'NOMAL'}">
                        <span class="board-category-user">유저매칭</span>
                      </c:when>
                      <c:otherwise>
                        <span class="board-category-trainer">트레이너</span>
                      </c:otherwise>
                    </c:choose>
                    <span class="card-title">${aList.matchingTitle}</span>
                    <span class="created-day">신청 날짜: ${aList.applyDay}</span>
                  </div>
                  <div class="setting">
                    <c:choose>
                      <c:when test="${aList.matchingStatus eq '마감'}">
                        <button class="reviewWrite" 
                                data-matching-no="${aList.matchingNo}" 
                                data-user-no="${userNo}"
                                onclick="reviewWrite(this);">
                          리뷰쓰러가기
                        </button>
                      </c:when>
                      <c:otherwise>
                        <button class="matchingCancel"  type="button" data-matching-num="${aList.matchingNo}">취소</button>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
                <div class="card-partner-type">
                  <span class="matchingContent">${aList.matchingContent}</span>
                </div>
                <div class="matching-footer">
                  <div class="matching-location">
                      <i class="fa-solid fa-location-dot"></i>
                      <span>${aList.matchingLocation}</span>
                  </div>
                  <div class="matching-time">
                      <i class="fa-solid fa-clock"></i>
                      <span>${aList.matchingTime}</span>
                  </div>
                  <div class="matching-day">
                      <i class="fa-solid fa-calendar-days"></i>
                      <span>${aList.matchingDate}</span>
                  </div>
                  <div class="matching-money">
                      <i class="fa-solid fa-wallet"></i>
                      <span>${aList.matchingPrice}</span>
                  </div>
                  <div class="matching-user">
                      <i class="fa-solid fa-users"></i>
                      <span>${aList.applicationCount}/${aList.matchingUserCount} 명</span>
                  </div>
                </div>
              </div>

            </c:forEach>
            </c:when>
              <c:otherwise>
                <div style="width:100%; height: 10vh; display:flex; align-items:center; justify-content:center; flex-direction: column; gap:10px">
                  <span class="material-symbols-outlined" style="font-size:50px; color:#aaa; font-weight: 500;">error</span>
                  <p style="margin-top:10px; font-size:1rem; font-weight: 500; color:#aaa;">작성한 매칭이 없습니다.</p>    
                </div>
              </c:otherwise>
          </c:choose>
        </div>
      </div>
      <!-- 보안 설정 섹션 -->
      <div class="info-section">
        <h2 class="section-title">보안 설정</h2>
        
        <div class="password-section">
          <div class="info-group" style="border-bottom: none;">
            <div class="info-label">비밀번호</div>
            <div class="info-value">••••••••</div>
            <div class="info-actions">
              <button type="button" class="btn btn-edit" id="showPasswordFormBtn" onclick="togglePasswordForm()">변경</button>
            </div>
          </div>

          <div class="password-form" id="passwordForm">
            <form id="changePasswordForm">
              <div class="form-group">
                <label>현재 비밀번호</label>
                <input type="password" id="currentPassword" placeholder="현재 비밀번호를 입력하세요" required>
              </div>

              <div class="form-group">
                <label>새 비밀번호</label>
                <input type="password" id="newPassword" placeholder="새 비밀번호를 입력하세요" required>
                <small style="color: #666; font-size: 0.85rem;">8~20자, 영문+숫자+특수문자(@$!%*#?&) 조합</small>
                <span id="newPasswordValidMsg" class="validation-msg"></span>
              </div>

              <div class="form-group">
                <label>새 비밀번호 확인</label>
                <input type="password" id="confirmPassword" placeholder="새 비밀번호를 다시 입력하세요" required>
                <span id="confirmPasswordMsg" class="validation-msg"></span>
              </div>

              <div class="password-buttons">
                <button type="button" class="btn btn-save" onclick="changePassword()">비밀번호 변경</button>
                <button type="button" class="btn btn-cancel" onclick="togglePasswordForm()">취소</button>
              </div>
            </form>
          </div>
        </div>
      </div>

    </div>
  </div>

  <!-- 기본 모달 -->
  <div id="customModal" class="modal-overlay" style="display:none;">
    <div class="modal-box">
      <p id="modalMessage">메시지 내용</p>
      <button class="modal-btn" onclick="closeModal()">확인</button>
    </div>
  </div>

  <!-- 권한 선택 모달 -->
  <div id="permissionSelectModal" class="permission-select-modal">
    <div class="permission-select-box">
      <h3 class="permission-select-title">추가로 신청할 권한을 선택하세요</h3>
      <div class="permission-options">
        <div class="permission-option" onclick="openRequestForm('STADIUM_MANAGER')">
          <div class="permission-option-title">🏟️ 시설 관리자</div>
          <div class="permission-option-desc">체육시설을 관리하고 운영합니다</div>
        </div>
        <div class="permission-option" onclick="openRequestForm('TRAINER')">
          <div class="permission-option-title">💪 트레이너</div>
          <div class="permission-option-desc">회원들에게 운동 지도를 제공합니다</div>
        </div>
      </div>
      <div style="text-align: center;">
        <button class="btn-close" onclick="closePermissionSelect()">취소</button>
      </div>
    </div>
  </div>

  <!-- 권한 포기 모달 -->
  <div id="revokePermissionModal" class="permission-select-modal">
    <div class="permission-select-box">
      <h3 class="permission-select-title">⚠️ 권한 포기</h3>
      <p style="text-align: center; color: #666; margin-bottom: 20px;">
        포기할 권한을 선택하세요.<br>
        <strong>권한을 포기하면 일반 사용자로 전환됩니다.</strong>
      </p>
      <div class="permission-options">
        <c:if test="${user.userType == 'STADIUM_MANAGER' || user.userType == 'TRAINER'}">
          <div class="permission-option revoke-option" onclick="revokePermission()">
            <div class="permission-option-title" id="currentPermissionTitle"></div>
            <div class="permission-option-desc">현재 권한을 포기하고 일반 사용자로 전환</div>
          </div>
        </c:if>
      </div>
      <div style="text-align: center;">
        <button class="btn-close" onclick="closeRevokePermissionModal()">취소</button>
      </div>
    </div>
  </div>

  <!-- 시설 관리자 신청 폼 모달 -->
  <div id="stadiumManagerFormModal" class="request-form-modal">
    <div class="request-form-box">
      <h3 class="request-form-title">🏟️ 시설 관리자 권한 신청</h3>
      <form id="stadiumManagerForm" enctype="multipart/form-data">
        <input type="hidden" name="requestType" value="STADIUM_MANAGER">
        
        <div class="form-field">
          <label>시설명<span class="required">*</span></label>
          <input type="text" name="businessName" required placeholder="운영하시는 시설명을 입력하세요">
        </div>
        
        <div class="form-field">
          <label>사업자등록번호<span class="required">*</span></label>
          <input type="text" name="businessNumber" required placeholder="000-00-00000" maxlength="12">
          <div class="hint">하이픈(-)을 포함하여 입력하세요</div>
        </div>
        
        <div class="form-field">
          <label>신청 사유</label>
          <textarea name="requestReason" required placeholder="신청 사유를 작성해주세요"></textarea>
        </div>
        
        <div class="form-field">
          <label>증빙 서류<span class="required">*</span></label>
          <input type="file" name="attachmentFile" id="stadiumFile" required accept="image/*,.pdf" onchange="previewFile('stadium')">
          <div class="hint">사업자등록증 또는 시설 운영 증명 서류 (이미지 또는 PDF, 최대 10MB)</div>
          <div id="stadiumFilePreview" class="file-preview"></div>
        </div>
        
        <div class="form-buttons">
          <button type="button" class="btn-submit" onclick="submitRequest('stadium')">신청하기</button>
          <button type="button" class="btn-close" onclick="closeRequestForm('stadium')">취소</button>
        </div>
      </form>
    </div>
  </div>

  <!-- 트레이너 신청 폼 모달 -->
  <div id="trainerFormModal" class="request-form-modal">
    <div class="request-form-box">
      <h3 class="request-form-title">💪 트레이너 권한 신청</h3>
      <form id="trainerForm" enctype="multipart/form-data">
        <input type="hidden" name="requestType" value="TRAINER">
        
        <div class="form-field">
          <label>자격증 종류<span class="required">*</span></label>
          <input type="text" name="certificateType" required placeholder="예: 생활체육지도사 2급, 건강운동관리사">
        </div>
        
        <div class="form-field">
          <label>자격증 번호<span class="required">*</span></label>
          <input type="text" name="certificateNumber" required placeholder="자격증에 기재된 번호를 입력하세요">
        </div>
        
        <div class="form-field">
          <label>활동 기간<span class="required">*</span></label>
          <input type="text" name="career" required placeholder="예: 5년, 3년 6개월, 2년" maxlength="100">
          <div class="hint">트레이너로 활동한 총 기간을 입력해주세요</div>
        </div>
        
        <div class="form-field">
          <label>상세 경력<span class="required">*</span></label>
          <textarea name="careerDetail" required placeholder="상세 경력을 작성해주세요&#10;예: 2020.01 ~ 2023.12 ○○ 헬스장 트레이너&#10;     - 1:1 PT 지도 (100회 이상)&#10;     - 그룹 레슨 진행&#10;&#10;     2024.01 ~ 현재 △△ 피트니스 센터 수석 트레이너&#10;     - 신입 트레이너 교육 담당&#10;     - 운동 프로그램 기획" rows="6"></textarea>
          <div class="hint">근무 기간, 근무처, 담당 업무 등을 자세히 작성해주세요</div>
        </div>
        
        <div class="form-field">
          <label>신청 사유</label>
          <textarea name="requestReason" placeholder="신청 사유를 작성해주세요"></textarea>
        </div>
        
        <div class="form-field">
          <label>증빙 서류<span class="required">*</span></label>
          <input type="file" name="attachmentFile" id="trainerFile" required accept="image/*,.pdf" onchange="previewFile('trainer')">
          <div class="hint">자격증 사본 (이미지 또는 PDF, 최대 10MB)</div>
          <div id="trainerFilePreview" class="file-preview"></div>
        </div>
        
        <div class="form-buttons">
          <button type="button" class="btn-submit" onclick="submitRequest('trainer')">신청하기</button>
          <button type="button" class="btn-close" onclick="closeRequestForm('trainer')">취소</button>
        </div>
      </form>
    </div>
  </div>

  <!-- 리뷰 모달 -->
  <div id="reviewModal" class="request-form-modal">
    <div class="review-wrapper">
      <h3 class="reivew-title">리뷰를 작성해주세요</h3>
      <span class="label">리뷰 별점</span>
      <div class="review-btn-wrapper">
        <span class="star" data-value="1">
            <i class="fa-regular fa-star" style="color: #FFD43B;"></i>
        </span>
        <span class="star" data-value="2">
            <i class="fa-regular fa-star" style="color: #FFD43B;"></i>
        </span>
        <span class="star" data-value="3">
            <i class="fa-regular fa-star" style="color: #FFD43B;"></i>
        </span>
        <span class="star" data-value="4">
            <i class="fa-regular fa-star" style="color: #FFD43B;"></i>
        </span>
        <span class="star" data-value="5">
            <i class="fa-regular fa-star" style="color: #FFD43B;"></i>
        </span>    
      </div>
      <div class="form-group">
        <label for="reviewContent">리뷰 내용</label>
        <textarea name="reviewContent" id="reviewContent" placeholder="리뷰를 작성해주세요."></textarea>
      </div>
      <div class="btn-row">
        <button type="button" class="saveBtn">저장</button>
        <button type="button" class="cancelBtn">취소</button>
      </div>
    </div>
  </div>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script>

const contextPath = '${pageContext.request.contextPath}';
let pendingRequest = null;
let selectedProfileFile = null;
let originalProfileImageSrc = '';

// ========== 프로필 이미지 관련 함수 ==========
function previewProfileImage(input) {
  if (input.files && input.files[0]) {
    const file = input.files[0];
    const fileSize = file.size / 1024 / 1024; // MB
    
    // 파일 크기 체크 (5MB)
    if (fileSize > 5) {
      showModal('파일 크기는 5MB를 초과할 수 없습니다.');
      input.value = '';
      return;
    }
    
    // 파일 형식 체크
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png'];
    if (!allowedTypes.includes(file.type)) {
      showModal('JPG, PNG 파일만 업로드 가능합니다.');
      input.value = '';
      return;
    }
    
    selectedProfileFile = file;
    
    // 미리보기
    const reader = new FileReader();
    reader.onload = function(e) {
      const preview = document.getElementById('profileImagePreview');
      originalProfileImageSrc = preview.src; // 원본 저장
      preview.src = e.target.result;
    };
    reader.readAsDataURL(file);
    
    // 버튼 표시 변경
    document.getElementById('uploadProfileBtn').style.display = 'inline-block';
    document.getElementById('cancelProfileBtn').style.display = 'inline-block';
  }
}

function uploadProfileImage() {
  if (!selectedProfileFile) {
    showModal('선택된 파일이 없습니다.');
    return;
  }
  
  const formData = new FormData();
  formData.append('profileImage', selectedProfileFile);
  
  fetch(contextPath + '/user/uploadProfileImage', {
    method: 'POST',
    body: formData
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      showModal('프로필 이미지가 변경되었습니다.');
      selectedProfileFile = null;
      document.getElementById('uploadProfileBtn').style.display = 'none';
      document.getElementById('cancelProfileBtn').style.display = 'none';
      document.getElementById('profileImageInput').value = '';
      
      // 페이지 새로고침 또는 삭제 버튼 표시
      setTimeout(() => {
        location.reload();
      }, 1000);
    } else {
      showModal(data.message || '프로필 이미지 변경에 실패했습니다.');
      cancelProfileImage();
    }
  })
  .catch(err => {
    console.error('프로필 이미지 업로드 오류:', err);
    showModal('오류가 발생했습니다. 다시 시도해주세요.');
    cancelProfileImage();
  });
}

function cancelProfileImage() {
  const preview = document.getElementById('profileImagePreview');
  preview.src = originalProfileImageSrc || contextPath + '/resources/img/default-profile.png';
  
  document.getElementById('profileImageInput').value = '';
  selectedProfileFile = null;
  
  document.getElementById('uploadProfileBtn').style.display = 'none';
  document.getElementById('cancelProfileBtn').style.display = 'none';
}

function deleteProfileImage() {
  if (!confirm('프로필 이미지를 삭제하시겠습니까?')) {
    return;
  }
  
  fetch(contextPath + '/user/deleteProfileImage', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    }
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      showModal('프로필 이미지가 삭제되었습니다.');
      setTimeout(() => {
        location.reload();
      }, 1000);
    } else {
      showModal(data.message || '프로필 이미지 삭제에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('프로필 이미지 삭제 오류:', err);
    showModal('오류가 발생했습니다. 다시 시도해주세요.');
  });
}

// ========== 쪽지함 알림 시스템 ==========
(function() {
  // 알림 목록 로드 (DB 기반)
  window.loadNotifications = function() {
    fetch(contextPath + '/api/notifications/recent?limit=5', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    })
    .then(res => res.json())
    .then(data => {
      const items = data.items || [];
      updateNotificationBadge(items.length);
      renderNotificationList(items);
    })
    .catch(err => {
      console.error('알림 로드 오류:', err);
    });
  };

  function updateNotificationBadge(count) {
    const badge = document.getElementById('notificationBadge');
    if (count > 0) {
      badge.textContent = count;
      badge.style.display = 'flex';
    } else {
      badge.style.display = 'none';
    }
  }

  function renderNotificationList(notifications) {
    const listContainer = document.getElementById('notificationList');
    
    if (!notifications || notifications.length === 0) {
      listContainer.innerHTML = `
        <div class="notification-empty">
          <div class="notification-empty-icon">📭</div>
          <div>알림이 없습니다</div>
        </div>
      `;
      return;
    }
    
    listContainer.innerHTML = '';
    
    notifications.forEach(notification => {
      const item = createNotificationItem(notification);
      listContainer.appendChild(item);
    });
  }

  function createNotificationItem(notification) {
    const item = document.createElement('div');
    item.className = 'notification-item unread';
    item.onclick = () => markAsRead(notification.notiNo, notification.linkPath);
    
    const typeText = notification.type === 'ROLE' ? '권한 신청' : (notification.type === 'CONTACT' ? '문의 답변' : notification.type);
    let statusHTML = '<div class="notification-status approved">🔔 알림</div>';
    let messageHTML = '<div class="notification-message"><strong>' + (notification.title || typeText) + '</strong><br>' + (notification.message || '') + '</div>';
    
    let timeHTML = '';
    if (notification.createdAt) {
      const date = new Date(notification.createdAt);
      if (!isNaN(date.getTime())) {
        timeHTML = '<div class="notification-time">' + formatNotificationDate(date) + '</div>';
      }
    }
    
    item.innerHTML = statusHTML + messageHTML + timeHTML;
    return item;
  }

  function formatNotificationDate(date) {
    const now = new Date();
    const diff = now - date;
    
    const minutes = Math.floor(diff / 60000);
    const hours = Math.floor(diff / 3600000);
    const days = Math.floor(diff / 86400000);
    
    if (minutes < 1) return '방금 전';
    if (minutes < 60) return minutes + '분 전';
    if (hours < 24) return hours + '시간 전';
    if (days < 7) return days + '일 전';
    
    return date.toLocaleDateString('ko-KR');
  }

  function toggleDropdown() {
    const dropdown = document.getElementById('notificationDropdown');
    const isOpening = !dropdown.classList.contains('show');
    
    dropdown.classList.toggle('show');
    
    if (isOpening) {
        const badge = document.getElementById('notificationBadge');
        if (badge) {
          badge.classList.add('hidden');
        }
      }
  }

  function markAsRead(notiNo, linkPath) {
    fetch(contextPath + '/api/notifications/read', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ notiNo: notiNo })
    })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        updateNotificationBadge(0);
        toggleDropdown();
        loadNotifications();
        if (linkPath) {
          window.location.href = linkPath;
        }
      }
    })
    .catch(err => {
      console.error('알림 확인 오류:', err);
    });
  }

  // DOM 로드 완료 후
  document.addEventListener('DOMContentLoaded', function() {
    // 이벤트 리스너 등록
    const iconBtn = document.getElementById('notificationIconBtn');
    if (iconBtn) {
      iconBtn.addEventListener('click', toggleDropdown);
    }
    
    const closeBtn = document.getElementById('notificationCloseBtn');
    if (closeBtn) {
      closeBtn.addEventListener('click', toggleDropdown);
    }
    
    // 외부 클릭 시 닫기
    document.addEventListener('click', function(event) {
      const container = document.querySelector('.notification-container');
      const dropdown = document.getElementById('notificationDropdown');
      
      if (!container.contains(event.target) && dropdown && dropdown.classList.contains('show')) {
        dropdown.classList.remove('show');
      }
    });
    
    // 알림 로드
    loadNotifications();
  });
})();

// ========== 기존 기능들 ==========

// 페이지 로드 시
document.addEventListener('DOMContentLoaded', function() {
  formatBirthDate();
  displayUserType();
  checkPendingRequest();
  
  // 비밀번호 검증 리스너
  const newPasswordInput = document.getElementById('newPassword');
  const confirmPasswordInput = document.getElementById('confirmPassword');
  
  if (newPasswordInput) {
    newPasswordInput.addEventListener('input', function() {
      validateNewPassword();
      if (confirmPasswordInput.value.length > 0) {
        checkPasswordMatch();
      }
    });
  }
  
  if (confirmPasswordInput) {
    confirmPasswordInput.addEventListener('input', function() {
      checkPasswordMatch();
    });
  }
});

// 대기 중인 신청 확인
function checkPendingRequest() {
  fetch(contextPath + '/user/checkPendingRequest', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  })
  .then(res => res.json())
  .then(data => {
    if (data.hasPending) {
      pendingRequest = data.request;
      showPendingStatus(data.request);
    } else {
      showNormalButtons();
    }
  })
  .catch(err => {
    console.error('대기 중인 신청 확인 오류:', err);
    showNormalButtons();
  });
}

function showPendingStatus(request) {
  document.getElementById('normalButtons').style.display = 'none';
  document.getElementById('pendingButtons').style.display = 'flex';
  
  const typeText = request.requestType === 'STADIUM_MANAGER' ? '시설 관리자' : '트레이너';
  document.getElementById('pendingRequestType').textContent = typeText + ' 신청';
}

function showNormalButtons() {
  document.getElementById('normalButtons').style.display = 'flex';
  document.getElementById('pendingButtons').style.display = 'none';
}

function cancelPendingRequest() {
  if (!pendingRequest) {
    showModal('취소할 신청이 없습니다.');
    return;
  }
  
  if (!confirm('정말로 신청을 취소하시겠습니까?')) {
    return;
  }
  
  fetch(contextPath + '/user/cancelRequest', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'requestNo=' + encodeURIComponent(pendingRequest.requestNo)
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      showModal('신청이 취소되었습니다.');
      pendingRequest = null;
      showNormalButtons();
    } else {
      showModal(data.message || '신청 취소에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('신청 취소 오류:', err);
    showModal('오류가 발생했습니다. 다시 시도해주세요.');
  });
}

function displayUserType() {
  const userType = '${user.userType}';
  const userTypeDisplay = document.getElementById('userTypeDisplay');
  const currentPermissionTitle = document.getElementById('currentPermissionTitle');
  
  let displayText = '';
  let permissionTitle = '';
  
  switch(userType) {
    case 'USER':
      displayText = '일반 사용자';
      break;
    case 'STADIUM_MANAGER':
      displayText = '시설 관리자';
      permissionTitle = '🏟️ 시설 관리자 권한';
      break;
    case 'TRAINER':
      displayText = '트레이너';
      permissionTitle = '💪 트레이너 권한';
      break;
    default:
      displayText = userType;
  }
  
  userTypeDisplay.textContent = displayText;
  if (currentPermissionTitle) {
    currentPermissionTitle.textContent = permissionTitle;
  }
}
/* 리뷰 */
document.addEventListener("DOMContentLoaded", () => {
    
    // --- [중요] 전역 변수 선언 (함수들끼리 공유하기 위함) ---
    let currentMatchingNo = null;
    let currentUserNo = null;
    let starValue = '0'; 
    let isSubmitting = false; // 중복 저장 방지용 안전장치

    // --- 1. 모달 열기 (HTML의 onclick="reviewWrite(this)"에서 호출됨) ---
    window.reviewWrite = function(button) {
        currentMatchingNo = button.dataset.matchingNo;
        currentUserNo = button.dataset.userNo;

        // 모달 열 때 값 초기화
        starValue = '0';
        document.querySelector("#reviewContent").value = '';
        isSubmitting = false; // 저장 잠금 해제
        resetStars();

        document.querySelector("#reviewModal").style.display = "flex";
    };

    // --- 2. 별점 초기화 함수 (모양만 초기화) ---
    function resetStars() {
        document.querySelectorAll(".star i").forEach(icon => {
            icon.classList.remove("fa-solid");
            icon.classList.add("fa-regular");
        });
    }

    // --- 3. 별점 클릭 이벤트 (여기에 저장 로직이 있으면 절대 안 됨!) ---
    // 오직 "별 색깔 바꾸기"와 "점수 변수(starValue) 담기"만 수행
    document.querySelectorAll(".star").forEach((star, index) => {
        star.addEventListener("click", () => {
            // 점수 저장
            starValue = star.dataset.value;

            // UI 업데이트 (모두 지우고 -> 해당 인덱스까지 채우기)
            let stars = document.querySelectorAll(".star");
            
            // 1) 싹 지우기
            stars.forEach(s => {
                let icon = s.querySelector("i");
                icon.classList.remove("fa-solid");
                icon.classList.add("fa-regular");
            });

            // 2) 클릭한 곳까지 채우기
            for (let i = 0; i <= index; i++) {
                let icon = stars[i].querySelector("i");
                icon.classList.remove("fa-regular");
                icon.classList.add("fa-solid");
            }
            
            // console.log("현재 별점:", starValue); // 확인용
        });
    }); 
    // ▲ 위에서 forEach가 끝났습니다. 저장 버튼은 이 괄호 밖에서 만들어야 합니다.

    
    // --- 4. [저장 버튼] 클릭 이벤트 (반복문 밖, 독립적으로 존재) ---
    const saveBtn = document.querySelector(".saveBtn");
    
    if(saveBtn) {
        // onclick을 사용하여 기존에 혹시 쌓였을 이벤트를 덮어씌움 (안전함)
        saveBtn.onclick = function() {
          // (1) 이미 저장 중이면 함수 종료 (더블클릭/중복저장 방지)
          if (isSubmitting) return;

          // (2) 별점 선택 안했으면 경고
          if (starValue === '0' || starValue === '') {
              Swal.fire({ 
                  icon: 'warning', 
                  title: '별점을 선택해주세요!', 
                  confirmButtonText: '확인',
                  customClass: {
                      popup: 'success-popup',
                      title: 'success-title',
                      text: 'success-text',
                      confirmButton: 'success-button'
                  }
              });
              return;
          }

          // (3) 저장 시작 (잠금 걸기)
          isSubmitting = true; 

          const data = {
              matchingNo: currentMatchingNo,
              userNo: currentUserNo,
              reviewContent: document.querySelector("#reviewContent").value,
              reviewType: starValue,
          };
          console.log(data)
          fetch("/review", { 
              method: "post",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify(data)
          })
          .then(res => res.json())
          .then(result => {
            if (result > 0) {
                Swal.fire({
                  icon: 'success',
                  title: '리뷰 작성완료!',
                  confirmButtonText: '확인',
                  customClass: {
                      popup: 'success-popup',
                      title: 'success-title',
                      text: 'success-text',
                      confirmButton: 'success-button'
                  },
                  didClose: () => {
                    location.reload();
                  }
                })
            } else {
                Swal.fire({
                  icon:'error',
                  title: '리뷰 작성 실패..ㅠ',
                  text: '다시 시도 해주세요.',
                  confirmButtonText: '확인',
                  customClass: {
                      popup: 'error-popup',
                      title: 'error-title',
                      text: 'error-text',
                      confirmButton: 'error-button'
                  }
              });
                isSubmitting = false; // 실패 시 잠금 해제
            }
        })
        .catch(err => {
            Swal.fire({
              icon:'error',
              title: '리뷰 작성 실패..ㅠ',
              text: err,
              confirmButtonText: '확인',
              customClass: {
                  popup: 'error-popup',
                  title: 'error-title',
                  text: 'error-text',
                  confirmButton: 'error-button'
              }
            })
            isSubmitting = false; // 에러 시 잠금 해제
        });
      };
    }

    // --- 5. [취소 버튼] ---
    const cancelBtn = document.querySelector(".cancelBtn");
    if(cancelBtn) {
        cancelBtn.addEventListener("click", () => {
            document.querySelector("#reviewModal").style.display = "none";
        });
    }
});

function openPermissionSelect() {
  document.getElementById('permissionSelectModal').style.display = 'flex';
}

function closePermissionSelect() {
  document.getElementById('permissionSelectModal').style.display = 'none';
}

function openRevokePermissionModal() {
  document.getElementById('revokePermissionModal').style.display = 'flex';
}

function closeRevokePermissionModal() {
  document.getElementById('revokePermissionModal').style.display = 'none';
}

function revokePermission() {
  if (!confirm('정말로 권한을 포기하시겠습니까?\n권한 포기 시 일반 사용자로 전환되며, 재신청이 필요합니다.')) {
    return;
  }
  
  fetch(contextPath + '/user/revokePermission', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      showModal('권한이 포기되었습니다.\n일반 사용자로 전환되었습니다.');
      closeRevokePermissionModal();
      setTimeout(() => {
        location.reload();
      }, 1500);
    } else {
      showModal(data.message || '권한 포기에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('권한 포기 오류:', err);
    showModal('오류가 발생했습니다. 다시 시도해주세요.');
  });
}

function openRequestForm(type) {
  closePermissionSelect();
  
  if (type === 'STADIUM_MANAGER') {
    document.getElementById('stadiumManagerFormModal').style.display = 'flex';
  } else if (type === 'TRAINER') {
    document.getElementById('trainerFormModal').style.display = 'flex';
  }
}

function closeRequestForm(type) {
  if (type === 'stadium') {
    document.getElementById('stadiumManagerFormModal').style.display = 'none';
    document.getElementById('stadiumManagerForm').reset();
    document.getElementById('stadiumFilePreview').style.display = 'none';
  } else if (type === 'trainer') {
    document.getElementById('trainerFormModal').style.display = 'none';
    document.getElementById('trainerForm').reset();
    document.getElementById('trainerFilePreview').style.display = 'none';
  }
}

function previewFile(type) {
  const fileInput = document.getElementById(type + 'File');
  const preview = document.getElementById(type + 'FilePreview');
  
  if (fileInput.files && fileInput.files[0]) {
    const file = fileInput.files[0];
    const fileSize = (file.size / 1024 / 1024).toFixed(2);
    
    if (fileSize > 10) {
      showModal('파일 크기는 10MB를 초과할 수 없습니다.');
      fileInput.value = '';
      preview.style.display = 'none';
      return;
    }
    
    preview.innerHTML = '📎 ' + file.name + ' (' + fileSize + 'MB)';
    preview.style.display = 'block';
  }
}

function submitRequest(type) {
  const formId = type === 'stadium' ? 'stadiumManagerForm' : 'trainerForm';
  const form = document.getElementById(formId);
  const formData = new FormData(form);
  
  if (type === 'stadium') {
    const businessNumber = formData.get('businessNumber');
    const businessNumberPattern = /^\d{3}-\d{2}-\d{5}$/;
    
    if (!businessNumberPattern.test(businessNumber)) {
      showModal('사업자등록번호 형식이 올바르지 않습니다. (예: 000-00-00000)');
      return;
    }
  }
  
  const fileInput = document.getElementById(type + 'File');
  if (!fileInput.files || !fileInput.files[0]) {
    showModal('증빙 서류를 첨부해주세요.');
    return;
  }
  
  if (!confirm('권한 신청을 제출하시겠습니까?\n관리자 승인 후 권한이 부여됩니다.')) {
    return;
  }
  
  fetch(contextPath + '/user/requestPermission', {
    method: 'POST',
    body: formData
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      showModal('권한 신청이 완료되었습니다.\n관리자 승인 후 권한이 부여됩니다.');
      closeRequestForm(type);
      setTimeout(() => {
        checkPendingRequest();
      }, 500);
    } else {
      showModal(data.message || '권한 신청에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('권한 신청 오류:', err);
    showModal('오류가 발생했습니다. 다시 시도해주세요.');
  });
}

function validateNewPassword() {
  const newPassword = document.getElementById('newPassword').value;
  const newPasswordValidMsg = document.getElementById('newPasswordValidMsg');
  const currentPassword = document.getElementById('currentPassword').value;
  
  if (newPassword.length === 0) {
    newPasswordValidMsg.textContent = '';
    window.isNewPasswordValid = false;
    return;
  }
  
  const pwPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$/;
  
  if (!pwPattern.test(newPassword)) {
    let errorMsg = '❌ ';
    
    if (newPassword.length < 8) {
      errorMsg += '8자 이상 입력해주세요. ';
    } else if (newPassword.length > 20) {
    } else if (newPassword.length > 20) {
      errorMsg += '20자 이하로 입력해주세요. ';
    }
    if (!/[A-Za-z]/.test(newPassword)) {
      errorMsg += '영문 포함 필수. ';
    }
    if (!/\d/.test(newPassword)) {
      errorMsg += '숫자 포함 필수. ';
    }
    if (!/[@$!%*#?&]/.test(newPassword)) {
      errorMsg += '특수문자(@$!%*#?&) 포함 필수. ';
    }
    
    newPasswordValidMsg.textContent = errorMsg;
    newPasswordValidMsg.style.color = 'red';
    window.isNewPasswordValid = false;
  } else if (currentPassword && newPassword === currentPassword) {
    newPasswordValidMsg.textContent = '❌ 현재 비밀번호와 동일합니다.';
    newPasswordValidMsg.style.color = 'red';
    window.isNewPasswordValid = false;
  } else {
    newPasswordValidMsg.textContent = '✅ 사용 가능한 비밀번호입니다.';
    newPasswordValidMsg.style.color = 'green';
    window.isNewPasswordValid = true;
  }
}

function checkPasswordMatch() {
  const newPassword = document.getElementById('newPassword').value;
  const confirmPassword = document.getElementById('confirmPassword').value;
  const confirmPasswordMsg = document.getElementById('confirmPasswordMsg');
  
  if (confirmPassword.length === 0) {
    confirmPasswordMsg.textContent = '';
    window.isPasswordMatched = false;
    return;
  }
  
  if (newPassword === confirmPassword) {
    confirmPasswordMsg.textContent = '✅ 비밀번호가 일치합니다.';
    confirmPasswordMsg.style.color = 'green';
    window.isPasswordMatched = true;
  } else {
    confirmPasswordMsg.textContent = '❌ 비밀번호가 일치하지 않습니다.';
    confirmPasswordMsg.style.color = 'red';
    window.isPasswordMatched = false;
  }
}

function saveNickname() {
  const nickname = document.getElementById('nicknameInput').value.trim();
  const userNo = document.getElementById('userNo').value;

  if (!nickname) {
    showModal('닉네임을 입력해주세요.');
    return;
  }

  if (nickname.length < 2 || nickname.length > 12) {
    showModal('닉네임은 2~12자만 가능합니다.');
    return;
  }

  fetch(contextPath + '/user/updateNickname', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body:
      'userNo=' + encodeURIComponent(userNo) +
      '&nickname=' + encodeURIComponent(nickname)
  })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        document.getElementById('nicknameDisplay').textContent = nickname;
        cancelEdit('nickname');
        showModal('닉네임이 변경되었습니다.', 'success');
      } else {
        showModal(data.message || '닉네임 변경에 실패했습니다.');
      }
    })
    .catch(err => {
      console.error('닉네임 변경 오류:', err);
      showModal('오류가 발생했습니다. 다시 시도해주세요.');
    });
}

function formatBirthDate() {
  const serialNo = '${user.userSerialNo}';
  
  if (serialNo && serialNo.length >= 7) {
    const birthPart = serialNo.substring(0, 6);
    const genderDigit = serialNo.charAt(7);
    
    let year = parseInt(birthPart.substring(0, 2));
    const month = birthPart.substring(2, 4);
    const day = birthPart.substring(4, 6);
    
    if (genderDigit === '1' || genderDigit === '2') {
      year += 1900;
    } else if (genderDigit === '3' || genderDigit === '4') {
      year += 2000;
    }
    
    const formatted = year + '년 ' + month + '월 ' + day + '일';
    document.getElementById('birthDateDisplay').textContent = formatted;
  }
}

function showMessage(message, type) {
  const messageBox = document.getElementById('messageBox');
  messageBox.textContent = message;
  messageBox.className = 'message ' + type;
  
  setTimeout(() => {
    messageBox.className = 'message';
  }, 3000);
}

function editField(field) {
  document.getElementById(field + 'Display').style.display = 'none';
  document.getElementById(field + 'Actions').style.display = 'none';
  document.getElementById(field + 'EditForm').classList.add('active');
}

function cancelEdit(field) {
  document.getElementById(field + 'Display').style.display = 'block';
  document.getElementById(field + 'Actions').style.display = 'flex';
  document.getElementById(field + 'EditForm').classList.remove('active');
}

function saveEmail() {
  const email = document.getElementById('emailInput').value.trim();
  
  if (!email) {
    alert('이메일을 입력해주세요.');
    return;
  }
  
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailPattern.test(email)) {
    alert('올바른 이메일 형식이 아닙니다.');
    return;
  }
  
  fetch(contextPath + '/user/updateEmail', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'email=' + encodeURIComponent(email)
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      document.getElementById('emailDisplay').textContent = email;
      cancelEdit('email');
      showMessage('이메일이 변경되었습니다.', 'success');
    } else {
      alert(data.message || '이메일 변경에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('이메일 변경 오류:', err);
    alert('오류가 발생했습니다. 다시 시도해주세요.');
  });
}

function savePhone() {
  const phone = document.getElementById('phoneInput').value.trim();
  
  if (!phone) {
    alert('전화번호를 입력해주세요.');
    return;
  }
  
  const phonePattern = /^01[0-9]-[0-9]{3,4}-[0-9]{4}$/;
  if (!phonePattern.test(phone)) {
    alert('전화번호 형식이 올바르지 않습니다. (예: 010-1234-5678)');
    return;
  }
  
  fetch(contextPath + '/user/updatePhone', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'phone=' + encodeURIComponent(phone)
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      document.getElementById('phoneDisplay').textContent = phone;
      cancelEdit('phone');
      showMessage('전화번호가 변경되었습니다.', 'success');
    } else {
      alert(data.message || '전화번호 변경에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('전화번호 변경 오류:', err);
    alert('오류가 발생했습니다. 다시 시도해주세요.');
  });
}

function togglePasswordForm() {
  const form = document.getElementById('passwordForm');
  const btn = document.getElementById('showPasswordFormBtn');
  
  if (form.classList.contains('active')) {
    form.classList.remove('active');
    btn.textContent = '변경';
    document.getElementById('changePasswordForm').reset();
    document.getElementById('newPasswordValidMsg').textContent = '';
    document.getElementById('confirmPasswordMsg').textContent = '';
    window.isNewPasswordValid = false;
    window.isPasswordMatched = false;
  } else {
    form.classList.add('active');
    btn.textContent = '취소';
  }
}

function changePassword() {
  const currentPw = document.getElementById('currentPassword').value;
  const newPw = document.getElementById('newPassword').value;
  const confirmPw = document.getElementById('confirmPassword').value;
  
  if (!currentPw || !newPw || !confirmPw) {
    showModal('모든 필드를 입력해주세요.');
    return;
  }
  
  const pwPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$/;
  if (!pwPattern.test(newPw)) {
    showModal('비밀번호는 8~20자, 영문+숫자+특수문자 조합이어야 합니다.');
    return;
  }
  
  if (newPw !== confirmPw) {
    showModal('새 비밀번호가 일치하지 않습니다.');
    return;
  }

  if (currentPw === newPw) {
    showModal('현재 비밀번호와 새 비밀번호가 동일합니다.');
    return;
  }
  
  fetch(contextPath + '/user/updatePassword', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'currentPassword=' + encodeURIComponent(currentPw) + 
          '&newPassword=' + encodeURIComponent(newPw)
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      showModal('비밀번호가 성공적으로 변경되었습니다.');
      togglePasswordForm();
      showMessage('비밀번호가 변경되었습니다.', 'success');
    } else {
      showModal(data.message || '비밀번호 변경에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('비밀번호 변경 오류:', err);
    showModal('오류가 발생했습니다. 다시 시도해주세요.');
  });
}

function showModal(message) {
  document.getElementById('modalMessage').textContent = message;
  document.getElementById('customModal').style.display = 'flex';
}

function closeModal() {
  document.getElementById('customModal').style.display = 'none';
}

document.addEventListener("DOMContentLoaded", () => {
  /* 댓글 삭제 */
  document.querySelectorAll(".commentdelete").forEach(btn => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();
      const commentNo = btn.getAttribute("data-comment-no");
        Swal.fire({
          title: '해당 댓글을 삭제하시겠습니까?',
          showCancelButton: true,
          cancelButtonText: "취소",
          confirmButtonText: "삭제",
          customClass: {
            popup: 'success-popup',
            title: 'success-title',
            confirmButton: 'success-button',
            cancelButton: 'cancel-button'
          }
      }).then((result)=> {
        if(result.isConfirmed) {
          fetch("/comment/delete?commentNo=" + commentNo, {
            method: 'delete',
            headers: {"Content-Type":"application/json"}
          })
          .then(res => res.json())
          .then(result => {
            if(result > 0) {
              Swal.fire({
                icon: 'success',
                title: '삭제 완료!',
                confirmButtonText: '확인',
                customClass: {
                  popup: 'success-popup',
                  title: 'success-title',
                  confirmButton: 'success-button',
                }
              }).then(() => {
                location.reload();
              });
            } else {
              Swal.fire({
                icon:'error',
                title: '삭제 실패..ㅠ',
                text: '다시 시도 해주세요.',
                confirmButtonText: '확인',
                customClass: {
                  popup: 'error-popup',
                  title: 'error-title',
                  text: 'error-text',
                  confirmButton: 'error-button'
                }
              });
            }
          })
          .catch(err => {
            Swal.fire({
                icon:'error',
                title: '오류가 발생하였습니다.',
                text: err,
                confirmButtonText: '확인',
                customClass: {
                    popup: 'error-popup',
                    title: 'error-title',
                    text: 'error-text',
                    confirmButton: 'error-button'
                }
            });
          })
        }
      })
    })
  
    document.querySelectorAll(".matchingDelete").forEach(matching => {
      matching.addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        const matchingNo = matching.getAttribute("data-matching-no");
  
        Swal.fire({
          title: '해당 매칭을 삭제하시겠습니까?',
          showCancelButton: true,
          cancelButtonText: "취소",
          confirmButtonText: "삭제",
          customClass: {
            popup: 'success-popup',
            title: 'success-title',
            confirmButton: 'success-button',
            cancelButton: 'cancel-button'
          }
        }).then((result)=> {
          if(result.isConfirmed) {
            fetch("/matching/delete?matchingNo=" + matchingNo, {
              method: 'delete',
              headers: {"Content-Type":"application/json"}
            })
            .then(res => res.json())
            .then(result => {
              if(result > 0) {
                Swal.fire({
                  icon: 'success',
                  title: '삭제 완료!',
                  confirmButtonText: '확인',
                  customClass: {
                    popup: 'success-popup',
                    title: 'success-title',
                    confirmButton: 'success-button',
                  }
                }).then(() => {
                  location.reload();
                });
              } else {
                Swal.fire({
                  icon:'error',
                  title: '삭제 실패..ㅠ',
                  text: '다시 시도 해주세요.',
                  confirmButtonText: '확인',
                  customClass: {
                    popup: 'error-popup',
                    title: 'error-title',
                    text: 'error-text',
                    confirmButton: 'error-button'
                  }
                });
              }
            })
            .catch(err => {
              Swal.fire({
                  icon:'error',
                  title: '오류가 발생하였습니다.',
                  text: err,
                  confirmButtonText: '확인',
                  customClass: {
                      popup: 'error-popup',
                      title: 'error-title',
                      text: 'error-text',
                      confirmButton: 'error-button'
                  }
              });
            })
          }
        })
      })
    })
  
    document.querySelectorAll(".matchingCancel").forEach(cancel => {
      cancel.addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        const matchingNo = cancel.getAttribute("data-matching-num");
        const userNo = "${userNo}"
  
        Swal.fire({
            title: '매칭 예약을 취소하겠습니까?',
            showCancelButton: true,
            cancelButtonText: "아니오",
            confirmButtonText: "예",
            customClass: {
              popup: 'success-popup',
              title: 'success-title',
              confirmButton: 'success-button',
              cancelButton: 'cancel-button'
            }
        }).then((result)=> {
          if(result.isConfirmed) {
            fetch(`/apply/cancel?matchingNo=\${matchingNo}&userNo=\${userNo}`, {
              method: 'delete',
              headers: {"Content-Type":"application/json"}
            })
            .then(res => res.json())
            .then(result => {
              if(result > 0) {
                Swal.fire({
                  icon: 'success',
                  title: '취소 완료!',
                  confirmButtonText: '확인',
                  customClass: {
                    popup: 'success-popup',
                    title: 'success-title',
                    confirmButton: 'success-button',
                  }
                }).then(() => {
                  location.reload();
                });
              } else {
                Swal.fire({
                  icon:'error',
                  title: '삭제 실패..ㅠ',
                  text: '다시 시도 해주세요.',
                  confirmButtonText: '확인',
                  customClass: {
                    popup: 'error-popup',
                    title: 'error-title',
                    text: 'error-text',
                    confirmButton: 'error-button'
                  }
                });
              }
            })
            .catch(err => {
              Swal.fire({
                  icon:'error',
                  title: '오류가 발생하였습니다.',
                  text: err,
                  confirmButtonText: '확인',
                  customClass: {
                      popup: 'error-popup',
                      title: 'error-title',
                      text: 'error-text',
                      confirmButton: 'error-button'
                  }
              });
            })
          }
        })
      })
    })
  })
})
</script>
</html>
