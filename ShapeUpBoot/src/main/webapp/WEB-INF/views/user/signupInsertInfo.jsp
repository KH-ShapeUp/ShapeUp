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
    <div class="logo">
      <img src="<%=request.getContextPath()%>/resources/img/main_logo.png" alt="" width="180px">
    </div>

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

      <!-- 에러 메시지 표시 -->
      <% 
        String error = request.getParameter("error");
        if (error != null) {
          String errorMsg = "";
          switch(error) {
            case "password": errorMsg = "비밀번호가 일치하지 않습니다."; break;
            case "duplicateId": errorMsg = "이미 사용 중인 아이디입니다."; break;
            case "duplicateNickname": errorMsg = "이미 사용 중인 닉네임입니다."; break;
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

        <!-- 이름 -->
        <div class="form-group">
          <label>이름</label>
          <input type="text" name="name" required>
        </div>

        <!-- 닉네임 -->
        <div class="form-group">
          <label>닉네임</label>
          <div class="field-inline">
            <input type="text" name="nickname" id="nicknameInput" required>
            <button type="button" class="check-btn" onclick="checkNickname()">중복 확인</button>
          </div>
          <span id="nicknameMsg" class="validation-msg"></span>
        </div>

        <!-- 아이디 -->
        <div class="form-group">
          <label>아이디</label>
          <div class="field-inline">
            <input type="text" name="userid" id="useridInput" required>
            <button type="button" class="check-btn" onclick="checkUserId()">중복 확인</button>
          </div>
          <span id="useridMsg" class="validation-msg"></span>
        </div>

        <!-- 비밀번호 -->
        <div class="form-group">
          <label>비밀번호</label>
          <input type="password" name="password" id="passwordInput" required>
          <p class="hint-text">8자 이상, 영문/숫자/특수문자 조합</p>
        </div>
        <div class="form-group">
          <label>비밀번호 확인</label>
          <input type="password" name="password2" id="password2Input" required>
          <span id="passwordMsg" class="validation-msg"></span>
        </div>

        <!-- 이메일 -->
        <div class="form-group">
          <label>이메일</label>
          <div class="field-inline email-box">
            <input type="text" name="emailId" placeholder="이메일 아이디" required>
            <span>@</span>
            <input type="text" name="emailDomain" id="emailDomainInput" placeholder="직접 입력" required>

            <select id="emailDomainSelect" class="email-domain-select">
              <option value="">직접 입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
              <option value="kakao.com">kakao.com</option>
            </select>

            <button type="button" class="check-btn">인증번호 발송</button>
          </div>
        </div>

        <!-- 생년월일 + 성별 -->
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

        <!-- 전화번호 -->
        <div class="form-group">
          <label>전화번호</label>
          <div class="field-inline">
            <input type="text" placeholder="010-1234-5678" name="phone" id="phoneInput" required>
            <button type="button" class="check-btn">인증번호 발송</button>
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

// 중복 체크 완료 여부
let isUserIdChecked = false;
let isNicknameChecked = false;
let isUserIdAvailable = false;
let isNicknameAvailable = false;

// 이메일 도메인 선택
document.getElementById("emailDomainSelect").addEventListener("change", function() {
  const domainInput = document.getElementById("emailDomainInput");
  if (this.value === "") {
    domainInput.value = "";
    domainInput.readOnly = false;
  } else {
    domainInput.value = this.value;
    domainInput.readOnly = true;
  }
});

// 생년월일 숫자만 입력
document.getElementById('birthDateInput').addEventListener('input', function() {
  this.value = this.value.replace(/[^0-9]/g, '');
});

// 주민번호 뒷자리 숫자 제한 (1,2,3,4만 허용)
document.getElementById('genderDigitInput').addEventListener('input', function() {
  this.value = this.value.replace(/[^1-4]/g, '');
});

// 비밀번호 확인 실시간 체크
document.getElementById('password2Input').addEventListener('input', function() {
  const password = document.getElementById('passwordInput').value;
  const password2 = this.value;
  const msgSpan = document.getElementById('passwordMsg');
  
  if (password2 === '') {
    msgSpan.textContent = '';
    return;
  }
  
  if (password === password2) {
    msgSpan.textContent = '✓ 비밀번호가 일치합니다';
    msgSpan.style.color = 'green';
  } else {
    msgSpan.textContent = '✗ 비밀번호가 일치하지 않습니다';
    msgSpan.style.color = 'red';
  }
});

// 아이디 입력 시 중복체크 초기화
document.getElementById('useridInput').addEventListener('input', function() {
  isUserIdChecked = false;
  isUserIdAvailable = false;
  document.getElementById('useridMsg').textContent = '';
});

// 닉네임 입력 시 중복체크 초기화
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
  
  // 아이디 유효성 검사 (4~20자, 영문/숫자)
  const idPattern = /^[a-zA-Z0-9]{4,20}$/;
  if (!idPattern.test(userid)) {
    msgSpan.textContent = '✗ 아이디는 4~20자의 영문, 숫자만 사용 가능합니다';
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
      msgSpan.textContent = '✗ 이미 사용 중인 아이디입니다';
      msgSpan.style.color = 'red';
      isUserIdAvailable = false;
    } else {
      msgSpan.textContent = '✓ 사용 가능한 아이디입니다';
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
  
  // 닉네임 유효성 검사 (2~20자, 한글/영문/숫자)
  const nicknamePattern = /^[가-힣a-zA-Z0-9]{2,20}$/;
  if (!nicknamePattern.test(nickname)) {
    msgSpan.textContent = '✗ 닉네임은 2~20자의 한글, 영문, 숫자만 사용 가능합니다';
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
      msgSpan.textContent = '✗ 이미 사용 중인 닉네임입니다';
      msgSpan.style.color = 'red';
      isNicknameAvailable = false;
    } else {
      msgSpan.textContent = '✓ 사용 가능한 닉네임입니다';
      msgSpan.style.color = 'green';
      isNicknameAvailable = true;
    }
  })
  .catch(err => {
    console.error(err);
    alert('중복 확인 중 오류가 발생했습니다.');
  });
}

// 취소 버튼 클릭
document.querySelector('.btn.cancel').addEventListener('click', function() {
  if (confirm('회원가입을 취소하시겠습니까?')) {
    window.location.href = contextPath + '/';
  }
});

// Form 제출 시 유효성 검사
document.getElementById("signupForm").addEventListener("submit", function(e) {
  
  // 아이디 중복 체크 확인
  if (!isUserIdChecked || !isUserIdAvailable) {
    e.preventDefault();
    alert('아이디 중복 확인을 해주세요.');
    return false;
  }
  
  // 닉네임 중복 체크 확인
  if (!isNicknameChecked || !isNicknameAvailable) {
    e.preventDefault();
    alert('닉네임 중복 확인을 해주세요.');
    return false;
  }
  
  // 비밀번호 확인
  const password = document.getElementById('passwordInput').value;
  const password2 = document.getElementById('password2Input').value;
  
  if (password !== password2) {
    e.preventDefault();
    alert('비밀번호가 일치하지 않습니다.');
    return false;
  }
  
  // 비밀번호 유효성 검사 (8자 이상, 영문/숫자/특수문자 포함)
  const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
  if (!passwordPattern.test(password)) {
    e.preventDefault();
    alert('비밀번호는 8자 이상, 영문/숫자/특수문자를 포함해야 합니다.');
    return false;
  }
  
  // 생년월일 검증
  const birthDate = document.getElementById('birthDateInput').value;
  if (birthDate.length !== 6) {
    e.preventDefault();
    alert('생년월일 6자리를 정확히 입력해주세요.');
    return false;
  }
  
  // 성별 숫자 검증
  const genderDigit = document.getElementById('genderDigitInput').value;
  if (!/^[1-4]$/.test(genderDigit)) {
    e.preventDefault();
    alert('성별 숫자는 1, 2, 3, 4 중 하나여야 합니다.');
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