<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/user/signupInsertInfo.css">
</head>
<body>
<main class="signup-container">

  <section class="right-panel">
   		<a href ="/">
	        <img src="${pageContext.request.contextPath}/resources/img/main_logo.png" alt="Logo" width="180px">
      	</a>

    <div class="tab-menu">
      <h3>회원가입</h3>
    </div>

    <div class="step-bar">
      <div class="step completed">
        <div class="circle">1</div>
        <p>약관 동의</p>
      </div>
      <div class="line"></div>
      <div class="step active">
        <div class="circle">2</div>
        <p>정보 입력</p>
      </div>
      <div class="line"></div>
      <div class="step">
        <div class="circle">3</div>
        <p>가입 완료</p>
      </div>
    </div>

    <div class="signup-box">
      <h2>정보 입력</h2>
      <p class="sub-text">필수 정보를 입력해주세요</p>

      <%-- 에러 메시지 표시 --%>
      <% 
        String error = request.getParameter("error");
        if (error != null) {
          String errorMsg = "";
          switch(error) {
            case "password": errorMsg = "비밀번호가 일치하지 않습니다."; break;
            case "duplicateId": errorMsg = "이미 사용 중인 아이디입니다."; break;
            case "duplicateNickname": errorMsg = "이미 사용 중인 닉네임입니다."; break;
            case "emailNotVerified": errorMsg = "이메일 인증을 완료해주세요."; break;
            case "session": errorMsg = "세션이 만료되었습니다. 다시 시도해주세요."; break;
            case "exception": errorMsg = "오류가 발생했습니다. 다시 시도해주세요."; break;
          }
          if (!errorMsg.isEmpty()) {
      %>
        <div style="color: red; background-color: #ffe6e6; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
          <%= errorMsg %>
        </div>
      <% 
          }
        } 
      %>

      <form id="signupForm" action="<%=request.getContextPath()%>/user/signupInsertInfo" method="post">

        <%-- 이름 --%>
        <div class="form-group">
          <label>이름</label>
          <input type="text" name="name" required>
        </div>

        <%-- 닉네임 --%>
        <div class="form-group">
          <label>닉네임</label>
          <div class="field-inline">
            <input type="text" name="nickname" id="nicknameInput" required>
            <button type="button" class="check-btn" onclick="checkNickname()">중복 확인</button>
          </div>
          <span id="nicknameMsg" class="validation-msg"></span>
        </div>

        <%-- 아이디 --%>
        <div class="form-group">
          <label>아이디</label>
          <div class="field-inline">
            <input type="text" name="userid" id="useridInput" required>
            <button type="button" class="check-btn" onclick="checkUserId()">중복 확인</button>
          </div>
          <span id="useridMsg" class="validation-msg"></span>
        </div>

        <%-- 비밀번호 --%>
        <div class="form-group">
          <label>비밀번호</label>
          <input type="password" name="password" id="passwordInput" required>
          <p class="hint-text">8자 이상, 영문/숫자/특수문자 조합<br>
          사용 가능한 특수문자: <strong>@ $ ! % * # ? &</strong></p>
          <span id="passwordSpecialMsg" class="validation-msg"></span>
        </div>
        <div class="form-group">
          <label>비밀번호 확인</label>
          <input type="password" name="password2" id="password2Input" required>
          <span id="passwordMsg" class="validation-msg"></span>
        </div>

        <%-- 이메일 --%>
        <div class="form-group">
          <label>이메일</label>
          <div class="field-inline email-box">
            <input type="text" name="emailId" id="emailIdInput" placeholder="이메일 아이디" required>
            <span>@</span>
            <input type="text" name="emailDomain" id="emailDomainInput" placeholder="직접 입력" required>

            <select id="emailDomainSelect" class="email-domain-select">
              <option value="">직접 입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
              <option value="kakao.com">kakao.com</option>
            </select>

            <button type="button" id="sendEmailBtn" class="check-btn">인증번호 발송</button>
          </div>

          <div class="email-verify-area" style="margin-top:8px;">
            <input type="text" id="emailCodeInput" placeholder="인증번호 입력" style="width:160px;">
            <button type="button" id="verifyEmailBtn" class="check-btn">인증 확인</button>
            <span id="emailVerifyMsg" class="validation-msg"></span>
          </div>
        </div>

        <%-- 생년월일 + 성별 --%>
        <div class="form-group">
          <label>생년월일 및 성별</label>
          <div class="birth-box">
            <input type="text" name="birthDate" id="birthDateInput" placeholder="YYMMDD" maxlength="6" required>
            <span class="dash">-</span>
            <input type="text" name="genderDigit" id="genderDigitInput" placeholder="" maxlength="1" class="gender-digit" required>
            <span class="dots">● ● ● ● ● ●</span>
          </div>
          <p class="hint-text">생년월일 6자리와 주민등록번호 뒷자리 첫 번째 숫자를 입력하세요 (1,2,3,4)</p>
        </div>

        <%-- 전화번호 --%>
        <div class="form-group">
          <label>전화번호</label>
          <div class="field-inline">
            <input type="text" placeholder="010-1234-5678" name="phone" id="phoneInput" required>
          </div>
        </div>

        <div class="button-area">
          <button type="button" class="btn cancel">취소</button>
          <button type="submit" class="btn next">다음</button>
        </div>
      </form>

    </div>
  </section>
</main>

<script>
const contextPath = '<%=request.getContextPath()%>';

// 상태 변수들
let isUserIdChecked = false;
let isNicknameChecked = false;
let isUserIdAvailable = false;
let isNicknameAvailable = false;
let isEmailVerified = false;        // 이메일 인증 상태 추가
let verifiedEmail = '';             // 인증된 이메일 주소 저장

function getFullEmail() {
  const id = document.getElementById('emailIdInput').value.trim();
  const domain = document.getElementById('emailDomainInput').value.trim();
  return id && domain ? id + '@' + domain : '';
}

// 이메일 인증 상태 초기화 함수
function resetEmailVerification() {
  isEmailVerified = false;
  verifiedEmail = '';
  document.getElementById('emailVerifyMsg').textContent = '';
  document.getElementById('emailCodeInput').value = '';
}

// 이메일 아이디 입력 변경 시 인증 상태 초기화
document.getElementById('emailIdInput').addEventListener('input', function() {
  resetEmailVerification();
});

// 이메일 도메인 직접 입력 변경 시 인증 상태 초기화
document.getElementById('emailDomainInput').addEventListener('input', function() {
  resetEmailVerification();
});

// 이메일 도메인 선택
document.getElementById("emailDomainSelect").addEventListener("change", function() {
  const domainInput = document.getElementById("emailDomainInput");
  
  // 인증 상태 초기화
  resetEmailVerification();
  
  if (this.value === "") {
    domainInput.value = "";
    domainInput.readOnly = false;
  } else {
    domainInput.value = this.value;
    domainInput.readOnly = true;
  }
});

// 이메일 인증번호 발송
document.getElementById('sendEmailBtn').addEventListener('click', function() {
  const email = getFullEmail();
  const msgSpan = document.getElementById('emailVerifyMsg');
  msgSpan.textContent = '';

  if (!email) { 
    alert('이메일을 정확히 입력해주세요.'); 
    return; 
  }

  // 이메일 형식 검증
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailPattern.test(email)) {
    alert('올바른 이메일 형식이 아닙니다.');
    return;
  }

  // 인증 상태 초기화 (새로 발송하므로)
  isEmailVerified = false;
  verifiedEmail = '';

  fetch(contextPath + '/user/sendEmailCode', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'email=' + encodeURIComponent(email)
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      alert('인증번호를 발송했습니다. 이메일을 확인해주세요.');
      msgSpan.textContent = '인증번호가 발송되었습니다. (5분 내 입력)';
      msgSpan.style.color = '#666';
    } else {
      alert(data.message || '인증번호 발송에 실패했습니다.');
    }
  })
  .catch(err => { 
    console.error(err); 
    alert('메일 전송 중 오류가 발생했습니다.'); 
  });
});

// 이메일 인증번호 확인
document.getElementById('verifyEmailBtn').addEventListener('click', function() {
  const email = getFullEmail();
  const code = document.getElementById('emailCodeInput').value.trim();
  const msgSpan = document.getElementById('emailVerifyMsg');

  if (!email) { 
    alert('이메일을 입력해주세요.'); 
    return; 
  }
  if (!code) { 
    alert('인증번호를 입력해주세요.'); 
    return; 
  }

  fetch(contextPath + '/user/verifyEmailCode', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'email=' + encodeURIComponent(email) + '&code=' + encodeURIComponent(code)
  })
  .then(res => res.json())
  .then(data => {
    if (data.success) {
      isEmailVerified = true;
      verifiedEmail = email;
      msgSpan.style.color = 'green';
      msgSpan.textContent = '✓ 이메일 인증이 완료되었습니다.';
    } else {
      isEmailVerified = false;
      verifiedEmail = '';
      msgSpan.style.color = 'red';
      msgSpan.textContent = '✗ ' + (data.message || '인증에 실패했습니다.');
    }
  })
  .catch(err => { 
    console.error(err); 
    alert('인증 확인 중 오류가 발생했습니다.'); 
  });
});

// 비밀번호 특수문자 체크
document.getElementById('passwordInput').addEventListener('input', function() {
  const allowedSpecial = /[@$!%*#?&]/;
  const allSpecial = /[^A-Za-z0-9]/g;
  const specials = this.value.match(allSpecial);
  const msgSpan = document.getElementById('passwordSpecialMsg');
  
  if (!specials) { 
    msgSpan.textContent = ''; 
    return; 
  }
  
  const invalid = specials.filter(ch => !allowedSpecial.test(ch));
  if (invalid.length > 0) {
    msgSpan.textContent = '✗ 사용할 수 없는 특수문자가 포함되어 있습니다: ' + invalid.join(' ');
    msgSpan.style.color = 'red';
  } else {
    msgSpan.textContent = '';
  }
});

// 비밀번호 확인 실시간 체크
document.getElementById('password2Input').addEventListener('input', function() {
  const password = document.getElementById('passwordInput').value;
  const msgSpan = document.getElementById('passwordMsg');
  
  if (this.value === '') { 
    msgSpan.textContent = ''; 
    return; 
  }
  
  if (password === this.value) { 
    msgSpan.textContent = '✓ 비밀번호가 일치합니다.'; 
    msgSpan.style.color = 'green'; 
  } else { 
    msgSpan.textContent = '✗ 비밀번호가 일치하지 않습니다.'; 
    msgSpan.style.color = 'red'; 
  }
});

// 아이디 입력 시 중복확인 상태 초기화
document.getElementById('useridInput').addEventListener('input', function() {
  isUserIdChecked = false;
  isUserIdAvailable = false;
  document.getElementById('useridMsg').textContent = '';
});

// 닉네임 입력 시 중복확인 상태 초기화
document.getElementById('nicknameInput').addEventListener('input', function() {
  isNicknameChecked = false;
  isNicknameAvailable = false;
  document.getElementById('nicknameMsg').textContent = '';
});

// 아이디 중복 확인
function checkUserId() {
  const userid = document.getElementById('useridInput').value.trim();
  const msgSpan = document.getElementById('useridMsg');
  
  if (!userid) { 
    alert('아이디를 입력해주세요.'); 
    return; 
  }
  
  const idPattern = /^[a-zA-Z0-9]{4,20}$/;
  if (!idPattern.test(userid)) { 
    msgSpan.textContent = '✗ 4~20자의 영문, 숫자만 사용 가능합니다.'; 
    msgSpan.style.color = 'red'; 
    return; 
  }

  fetch(contextPath + '/user/checkUserId', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'userid=' + encodeURIComponent(userid)
  })
  .then(res => res.json())
  .then(isDuplicate => {
    isUserIdChecked = true;
    if (isDuplicate) { 
      msgSpan.textContent = '✗ 이미 사용 중인 아이디입니다.'; 
      msgSpan.style.color = 'red'; 
      isUserIdAvailable = false; 
    } else { 
      msgSpan.textContent = '✓ 사용 가능한 아이디입니다.'; 
      msgSpan.style.color = 'green'; 
      isUserIdAvailable = true; 
    }
  })
  .catch(err => {
    console.error(err); 
    alert('중복 확인 중 오류가 발생했습니다.'); 
  });
}

// 닉네임 중복 확인
function checkNickname() {
  const nickname = document.getElementById('nicknameInput').value.trim();
  const msgSpan = document.getElementById('nicknameMsg');
  
  if (!nickname) { 
    alert('닉네임을 입력해주세요.'); 
    return; 
  }
  
  const nicknamePattern = /^[가-힣a-zA-Z0-9]{2,20}$/;
  if (!nicknamePattern.test(nickname)) { 
    msgSpan.textContent = '✗ 2~20자의 한글, 영문, 숫자만 사용 가능합니다.'; 
    msgSpan.style.color = 'red'; 
    return; 
  }

  fetch(contextPath + '/user/checkNickname', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'nickname=' + encodeURIComponent(nickname)
  })
  .then(res => res.json())
  .then(isDuplicate => {
    isNicknameChecked = true;
    if (isDuplicate) { 
      msgSpan.textContent = '✗ 이미 사용 중인 닉네임입니다.'; 
      msgSpan.style.color = 'red'; 
      isNicknameAvailable = false; 
    } else { 
      msgSpan.textContent = '✓ 사용 가능한 닉네임입니다.'; 
      msgSpan.style.color = 'green'; 
      isNicknameAvailable = true; 
    }
  })
  .catch(err => {
    console.error(err); 
    alert('중복 확인 중 오류가 발생했습니다.'); 
  });
}

// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
  if (confirm('회원가입을 취소하시겠습니까?')) {
    window.location.href = contextPath + '/';
  }
});

// Form 제출 검증
document.getElementById('signupForm').addEventListener('submit', function(e) {
  
  // 1. 아이디 중복 확인 체크
  if (!isUserIdChecked || !isUserIdAvailable) { 
    e.preventDefault(); 
    alert('아이디 중복 확인을 해주세요.'); 
    return false; 
  }
  
  // 2. 닉네임 중복 확인 체크
  if (!isNicknameChecked || !isNicknameAvailable) { 
    e.preventDefault(); 
    alert('닉네임 중복 확인을 해주세요.'); 
    return false; 
  }

  // 3. 비밀번호 일치 체크
  const password = document.getElementById('passwordInput').value;
  const password2 = document.getElementById('password2Input').value;
  if (password !== password2) { 
    e.preventDefault(); 
    alert('비밀번호가 일치하지 않습니다.'); 
    return false; 
  }

  // 4. 비밀번호 규칙 체크
  const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
  if (!passwordPattern.test(password)) { 
    e.preventDefault(); 
    alert('비밀번호는 8자 이상, 영문/숫자/특수문자를 모두 포함해야 합니다.'); 
    return false; 
  }

  // 5. 이메일 인증 체크
  if (!isEmailVerified) { 
    e.preventDefault(); 
    alert('이메일 인증을 완료해주세요.'); 
    return false; 
  }
  
  // 6. 인증된 이메일과 현재 입력된 이메일이 같은지 확인
  const currentEmail = getFullEmail();
  if (verifiedEmail !== currentEmail) {
    e.preventDefault();
    alert('이메일이 변경되었습니다. 다시 인증해주세요.');
    return false;
  }

  // 7. 생년월일 체크
  const birthDate = document.getElementById('birthDateInput').value;
  if (birthDate.length !== 6 || !/^\d{6}$/.test(birthDate)) { 
    e.preventDefault(); 
    alert('생년월일 6자리를 정확히 입력해주세요.'); 
    return false; 
  }

  // 8. 성별 숫자 체크
  const genderDigit = document.getElementById('genderDigitInput').value;
  if (!/^[1-4]$/.test(genderDigit)) { 
    e.preventDefault(); 
    alert('주민등록번호 뒷자리 첫 번째 숫자(1~4)를 입력해주세요.'); 
    return false; 
  }

  return true;
});
</script>

<style>
.validation-msg { 
  display: block; 
  font-size: 0.85em; 
  margin-top: 5px; 
  font-weight: 500; 
}
</style>

</body>
</html>