<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>계정 관리 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/updateUserInfo.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/mypage.css">
  
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/header.jsp"/>
  <div class="mypage-container">
    <!-- 헤더 -->
    <div class="page-header">
      <h1>계정 관리</h1>
      <p>계정 설정을 관리할 수 있습니다</p>
    </div>

    <!-- 메시지 영역 -->
    <div class="content-area">
      <div id="messageBox" class="message"></div>

      <!-- 탭 메뉴 -->
      <div class="tab-menu">
        <a href="${pageContext.request.contextPath}/user/updateUserInfo" class="tab-button">
          <span class="tab-icon">👤</span>사용자 정보
        </a>
        <a href="${pageContext.request.contextPath}/user/accountManage" class="tab-button active">
          <span class="tab-icon">⚙️</span>계정 관리
        </a>
        <a href="${pageContext.request.contextPath}/user/userInterest" class="tab-button">
          <span class="tab-icon">⭐</span>관심사 설정
        </a>
      </div>

      <!-- 계정 관리 콘텐츠 -->
      <div class="info-section">
        <h2 class="section-title">계정 관리</h2>
        
        <!-- 회원 정보 요약 -->
        <div class="info-group">
          <div class="info-label">가입일</div>
          <div class="info-value readonly">
            <fmt:formatDate value="${user.createdAt}" pattern="yyyy년 MM월 dd일"/>
          </div>
        </div>

        <div class="info-group">
          <div class="info-label">계정 상태</div>
          <div class="info-value readonly" style="color: #4CAF50; font-weight: 600;">활성</div>
        </div>

        <hr style="margin: 30px 0; border: none; border-top: 2px solid #e0e0e0;">

        <!-- 회원탈퇴 -->
        <div class="danger-zone">
          <h3>⚠️ 회원 탈퇴</h3>
          <p>회원 탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다.</p>
          
          <div style="background-color: #fff3cd; border: 1px solid #ffc107; border-radius: 8px; padding: 20px; margin: 20px 0;">
            <h4 style="margin-top: 0; color: #856404;">탈퇴 시 삭제되는 정보</h4>
            <ul style="margin: 10px 0; padding-left: 20px; color: #856404; font-size: 0.95rem; line-height: 1.8;">
              <li>작성한 게시글 및 댓글이 모두 삭제됩니다</li>
              <li>운동 기록 및 식단 기록이 모두 삭제됩니다</li>
              <li>보유한 포인트 및 쿠폰이 소멸됩니다</li>
              <li>구독 정보가 모두 삭제됩니다</li>
              <li>개인 정보 및 계정 정보가 영구 삭제됩니다</li>
            </ul>
          </div>

          <div style="background-color: #f8d7da; border: 1px solid #dc3545; border-radius: 8px; padding: 20px; margin: 20px 0;">
            <h4 style="margin-top: 0; color: #721c24;">⚠️ 주의사항</h4>
            <ul style="margin: 10px 0; padding-left: 20px; color: #721c24; font-size: 0.95rem; line-height: 1.8;">
              <li>탈퇴 후 <strong>30일간 재가입이 불가능</strong>합니다</li>
              <li>탈퇴한 계정의 정보는 <strong>복구할 수 없습니다</strong></li>
              <li>진행 중인 결제나 환불이 있다면 먼저 처리해주세요</li>
              <li>탈퇴 시 이메일 인증이 필요할 수 있습니다</li>
            </ul>
          </div>

          

          <div style="text-align: center; margin-top: 30px;">
            <button class="btn btn-delete" onclick="deleteAccount()" style="font-size: 1.1rem; padding: 15px 40px;">
              회원 탈퇴
            </button>
            <p style="margin-top: 15px; color: #999; font-size: 0.9rem;">
              탈퇴를 원하지 않으시면 <a href="${pageContext.request.contextPath}/user/updateUserInfo" style="color: #4CAF50; text-decoration: underline;">사용자 정보</a>로 돌아가세요
            </p>
          </div>
        </div>
      </div>

    </div>
  </div>

  <!-- 모달 -->
  <div id="customModal" class="modal-overlay" style="display:none;">
    <div class="modal-box">
      <p id="modalMessage">메시지 내용</p>
      <button class="modal-btn" onclick="closeModal()">확인</button>
    </div>
  </div>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>

<script>
const contextPath = '${pageContext.request.contextPath}';

function showModal(message) {
  document.getElementById('modalMessage').textContent = message;
  document.getElementById('customModal').style.display = 'flex';
}

function closeModal() {
  document.getElementById('customModal').style.display = 'none';
}

// 회원 탈퇴
function deleteAccount() {
  if (!confirm('정말로 회원 탈퇴를 하시겠습니까?\n\n탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다.\n\n이 작업은 되돌릴 수 없습니다.')) {
    return;
  }
  
  const password = prompt('비밀번호를 입력하여 본인 확인을 해주세요:');
  
  if (!password) {
    showModal('비밀번호를 입력해야 탈퇴가 가능합니다.');
    return;
  }
  
  // 최종 확인
  if (!confirm('마지막 확인입니다.\n\n정말로 탈퇴하시겠습니까?')) {
    return;
  }
  
  // 서버에 회원 탈퇴 요청
  fetch(contextPath + '/user/deleteAccount', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: 'password=' + encodeURIComponent(password)
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      alert('회원 탈퇴가 완료되었습니다.\n\n그동안 ShapeUp을 이용해주셔서 감사합니다.');
      window.location.href = contextPath + '/';
    } else {
      showModal(data.message || '회원 탈퇴에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('회원 탈퇴 오류:', err);
    showModal('오류가 발생했습니다. 다시 시도해주세요.');
  });
}
</script>

</html>