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
</head>
<body>

  <div class="mypage-container">
    <!-- 헤더 -->
    <div class="page-header">
      <h1>회원정보 수정</h1>
      <p>회원님의 정보를 확인하고 수정할 수 있습니다</p>
    </div>

    <!-- 메시지 영역 -->
    <div class="content-area">
      <div id="messageBox" class="message"></div>

      <!-- 기본 정보 (읽기 전용) -->
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
		<!-- 닉네임 -->
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

      <!-- 수정 가능한 정보 -->
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

      <!-- 비밀번호 변경 -->
      <div class="info-section">
        <h2 class="section-title">보안</h2>
        
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
                <small style="color: #666; font-size: 0.85rem;">8~20자, 영문+숫자+특수문자 조합</small>
              </div>

              <div class="form-group">
                <label>새 비밀번호 확인</label>
                <input type="password" id="confirmPassword" placeholder="새 비밀번호를 다시 입력하세요" required>
              </div>

              <div class="password-buttons">
                <button type="button" class="btn btn-save" onclick="changePassword()">비밀번호 변경</button>
                <button type="button" class="btn btn-cancel" onclick="togglePasswordForm()">취소</button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- 회원탈퇴 -->
      <div class="danger-zone">
        <h3>⚠️ 회원 탈퇴</h3>
        <p>회원 탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다.</p>
        <button class="btn btn-delete" onclick="deleteAccount()">회원 탈퇴</button>
      </div>
    </div>
  </div>
  <div id="customModal" class="modal-overlay" style="display:none;">
  <div class="modal-box">
    <p id="modalMessage">메시지 내용</p>
    <button class="modal-btn" onclick="closeModal()">확인</button>
  </div>
</div>
</body>
<script>
const contextPath = '${pageContext.request.contextPath}';

// 페이지 로드 시 생년월일 포맷팅
document.addEventListener('DOMContentLoaded', function() {
  formatBirthDate();
});


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
    // 입력 필드 초기화
    document.getElementById('changePasswordForm').reset();
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
    alert('모든 필드를 입력해주세요.');
    return;
  }
  
  const pwPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,20}$/;
  if (!pwPattern.test(newPw)) {
    alert('비밀번호는 8~20자, 영문+숫자+특수문자 조합이어야 합니다.');
    return;
  }
  
  if (newPw !== confirmPw) {
    alert('새 비밀번호가 일치하지 않습니다.');
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
      alert(data.message || '비밀번호 변경에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('비밀번호 변경 오류:', err);
    alert('오류가 발생했습니다. 다시 시도해주세요.');
  });
}

function showModal(message) {
	  document.getElementById('modalMessage').textContent = message;
	  document.getElementById('customModal').style.display = 'flex';
	}

	// 🔥 모달 닫기
	function closeModal() {
	  document.getElementById('customModal').style.display = 'none';
	}

// 회원 탈퇴
function deleteAccount() {
  if (!confirm('정말로 회원 탈퇴를 하시겠습니까?\n탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다.')) {
    return;
  }
  
  const password = prompt('비밀번호를 입력하여 본인 확인을 해주세요:');
  
  if (!password) {
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
      alert('회원 탈퇴가 완료되었습니다.');
      window.location.href = contextPath + '/';
    } else {
      alert(data.message || '회원 탈퇴에 실패했습니다.');
    }
  })
  .catch(err => {
    console.error('회원 탈퇴 오류:', err);
    alert('오류가 발생했습니다. 다시 시도해주세요.');
  });
}
</script>

</html>