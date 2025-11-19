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
            <input type="text" name="nickname" required>
            <button type="button" class="check-btn" onclick="checkNickname()">중복 확인</button>
          </div>
        </div>

        <!-- 아이디 -->
        <div class="form-group">
          <label>아이디</label>
          <div class="field-inline">
            <input type="text" name="userid" required>
            <button type="button" class="check-btn" onclick="checkUserId()">중복 확인</button>
          </div>
        </div>

        <!-- 비밀번호 -->
        <div class="form-group">
          <label>비밀번호</label>
          <input type="password" name="password" required>
        </div>
        <div class="form-group">
          <label>비밀번호 확인</label>
          <input type="password" name="password2" required>
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

        <!-- 생년월일 및 성별 -->
        <div class="form-group">
          <label>생년월일 및 성별</label>
          <div class="birth-box">
            <input type="text" name="birthDate" id="birthDateInput" placeholder="YYMMDD" maxlength="6" required>
            <span class="dash">-</span>
            <input type="text" name="genderDigit" placeholder="" maxlength="1" class="gender-digit" required>
            <span class="dots">● ● ● ● ● ●</span>
          </div>
          <p class="hint-text">생년월일 6자리와 주민등록번호 뒷자리 첫 번째 숫자를 입력하세요 (1,2,3,4)</p>
        </div>

        <!-- 전화번호 -->
        <div class="form-group">
          <label>전화번호</label>
          <div class="field-inline">
            <input type="text" placeholder="010-1234-5678" name="phone" required>
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

// 주민번호 뒷자리 숫자 제한
document.querySelector('input[name="genderDigit"]').addEventListener('input', function() {
  this.value = this.value.replace(/[^1-4]/g, '');
});

// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
  if (confirm('회원가입을 취소하시겠습니까?')) {
    window.location.href = contextPath + '/';
  }
});

// AJAX 중복확인
function checkUserId() {
  const userid = document.querySelector('input[name="userid"]').value;
  fetch(contextPath + '/user/checkUserId', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'userid=' + encodeURIComponent(userid)
  })
  .then(res => res.json())
  .then(data => alert(data ? '사용 불가' : '사용 가능'));
}

function checkNickname() {
  const nickname = document.querySelector('input[name="nickname"]').value;
  fetch(contextPath + '/user/checkNickname', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'nickname=' + encodeURIComponent(nickname)
  })
  .then(res => res.json())
  .then(data => alert(data ? '사용 불가' : '사용 가능'));
}
</script>

</body>
</html>
