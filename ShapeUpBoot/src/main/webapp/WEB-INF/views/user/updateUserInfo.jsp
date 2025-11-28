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
      </div>

      <!-- 사용자 정보 콘텐츠 -->
      
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

      <hr class="section-divider">

      <!-- 연락처 정보 섹션 -->
      <div class="info-section">
        <h2 class="section-title">연락처 정보</h2>

        <!-- 이메일 -->
        <div class="info-group">
          <div class="info-label">이메일</div>
          <div class="info-value" id="emailDisplay">${user.userEmail}</div>
          <div class="edit-form" id="emailEditForm">
            <input type="email" id="emailInput" value="${user.userEmail}" placeholder="이메일을 입력하세요">
            <button class="btn btn-save" onclick="saveEmail()">저장</button>
            <button class="btn btn-cancel" onclick="cancelEdit('email')">취소</button>
          </div>
          <div class="info-actions" id="emailActions">
            <button class="btn btn-edit" onclick="editField('email')">수정</button>
          </div>
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

      <hr class="section-divider">

      <!-- 보안 설정 섹션 -->
      <div class="info-section">
        <h2 class="section-title">보안 설정</h2>
        
        <div class="password-section">
          <div class="info-group" style="border-bottom: none;">
            <div class="info-label">비밀번호</div>
            <div class="info-value">••••••••</div>
            <div class="info-actions">
              <button class="btn btn-edit" id="showPasswordFormBtn" onclick="togglePasswordForm()">변경</button>
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

  <!-- 모달 -->
  <div id="customModal" class="modal-overlay" style="display:none;">
    <div class="modal-box">
      <p id="modalMessage">메시지 내용</p>
      <button class="modal-btn" onclick="closeModal()">확인</button>
    </div>
  </div>

</body>

<script>
const contextPath = '${pageContext.request.contextPath}';

// 페이지 로드 시 생년월일 포맷팅 및 비밀번호 검증 리스너 추가
document.addEventListener('DOMContentLoaded', function() {
  formatBirthDate();
  
  // 새 비밀번호 입력 시 실시간 검증
  const newPasswordInput = document.getElementById('newPassword');
  const confirmPasswordInput = document.getElementById('confirmPassword');
  
  if (newPasswordInput) {
    newPasswordInput.addEventListener('input', function() {
      validateNewPassword();
      // 비밀번호 확인란에 값이 있으면 일치 여부도 체크
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

// 새 비밀번호 유효성 검사
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

// 비밀번호 확인 일치 여부 검사
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

// 생년월일 포맷팅 함수
function formatBirthDate() {
  const serialNo = '${user.userSerialNo}'; // 예: 990101-1
  
  if (serialNo && serialNo.length >= 7) {
    const birthPart = serialNo.substring(0, 6); // 990101
    const genderDigit = serialNo.charAt(7); // 1 또는 2
    
    let year = parseInt(birthPart.substring(0, 2));
    const month = birthPart.substring(2, 4);
    const day = birthPart.substring(4, 6);
    
    // 성별 구분자로 연도 판단 (1,2: 1900년대 / 3,4: 2000년대)
    if (genderDigit === '1' || genderDigit === '2') {
      year += 1900;
    } else if (genderDigit === '3' || genderDigit === '4') {
      year += 2000;
    }
    
    const formatted = year + '년 ' + month + '월 ' + day + '일';
    document.getElementById('birthDateDisplay').textContent = formatted;
  }
}

// 메시지 표시 함수
function showMessage(message, type) {
  const messageBox = document.getElementById('messageBox');
  messageBox.textContent = message;
  messageBox.className = 'message ' + type;
  
  setTimeout(() => {
    messageBox.className = 'message';
  }, 3000);
}

// 필드 수정 모드 전환
function editField(field) {
  document.getElementById(field + 'Display').style.display = 'none';
  document.getElementById(field + 'Actions').style.display = 'none';
  document.getElementById(field + 'EditForm').classList.add('active');
}

// 수정 취소
function cancelEdit(field) {
  document.getElementById(field + 'Display').style.display = 'block';
  document.getElementById(field + 'Actions').style.display = 'flex';
  document.getElementById(field + 'EditForm').classList.remove('active');
}

// 이메일 저장
function saveEmail() {
  const email = document.getElementById('emailInput').value.trim();
  
  if (!email) {
    alert('이메일을 입력해주세요.');
    return;
  }
  
  // 이메일 형식 검증
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailPattern.test(email)) {
    alert('올바른 이메일 형식이 아닙니다.');
    return;
  }
  
  // 서버에 이메일 업데이트 요청
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

// 전화번호 저장
function savePhone() {
  const phone = document.getElementById('phoneInput').value.trim();
  
  if (!phone) {
    alert('전화번호를 입력해주세요.');
    return;
  }
  
  // 전화번호 형식 검증
  const phonePattern = /^01[0-9]-[0-9]{3,4}-[0-9]{4}$/;
  if (!phonePattern.test(phone)) {
    alert('전화번호 형식이 올바르지 않습니다. (예: 010-1234-5678)');
    return;
  }
  
  // 서버에 전화번호 업데이트 요청
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

// 비밀번호 변경 폼 토글
function togglePasswordForm() {
  const form = document.getElementById('passwordForm');
  const btn = document.getElementById('showPasswordFormBtn');
  
  if (form.classList.contains('active')) {
    form.classList.remove('active');
    btn.textContent = '변경';
    // 입력 필드 및 검증 메시지 초기화
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

// 비밀번호 변경
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
</script>

</html>