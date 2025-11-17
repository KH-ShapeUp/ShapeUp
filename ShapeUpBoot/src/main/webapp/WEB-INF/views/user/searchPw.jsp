<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>비밀번호 찾기 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/searchPw.css">
</head>
<body>

  <main class="find-container">
    <section class="right-panel">
      <div class="logo">
        <img src="../../../../resources/img/main_logo.png" alt="" width="180px">
      </div>

      <!-- 상단 탭 -->
      <div class="tab-menu">
        <h3>비밀번호 찾기</h3>
      </div>

      <!-- 비밀번호 찾기 박스 -->
      <div class="find-box">
        <h2>비밀번호 찾기</h2>
        <p class="sub-text">가입 시 등록한 정보를 입력해주세요</p>

        <form id="findPasswordForm">

          <div class="form-group">
            <label>아이디</label>
            <input type="text" name="userid" placeholder="아이디를 입력하세요" required>
          </div>

          

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
            </div>
          </div>

          <div class="form-group" id="verificationGroup" style="display: none;">
            <label>인증번호</label>
            <div class="field-inline">
              <input type="text" name="verificationCode" placeholder="인증번호 6자리 입력">
              <button type="button" class="check-btn verify-btn">확인</button>
            </div>
          </div>

          <!-- 결과 표시 영역 -->
          <div class="result-box success" id="resultBox" style="display: none;">
            <div class="result-content">
              <div class="result-icon">✓</div>
              <p class="result-title">임시 비밀번호가 발송되었습니다</p>
              <p class="result-email" id="resultEmail">user****@naver.com</p>
              <p class="result-desc">위 이메일로 임시 비밀번호를 발송했습니다.<br>로그인 후 비밀번호를 변경해주세요.</p>
            </div>
          </div>

          <!-- 버튼 영역 -->
          <div class="button-area">
            <button type="button" class="btn cancel">취소</button>
            <button type="button" class="btn find">임시 비밀번호 발송</button>
          </div>

          <!-- 추가 링크 -->
          <div class="link-area">
            <a href="/user/searchId">아이디 찾기</a>
            <span class="divider">|</span>
            <a href="/login">로그인</a>
          </div>

        </form>
      </div>
    </section>
  </main>
	
</body>
<script>
// 인증 완료 여부
let isVerified = false;

// 이메일 도메인 선택
document.getElementById("emailDomainSelect").addEventListener("change", function() {
    const domainInput = document.getElementById("emailDomainInput");

    if (this.value === "") {
        domainInput.value = "";
        domainInput.readOnly = false;
        domainInput.placeholder = "직접 입력";
    } else {
        domainInput.value = this.value;
        domainInput.readOnly = true;
    }
});

// 인증번호 발송 버튼
document.querySelector('.check-btn').addEventListener('click', function() {
    const phone = document.querySelector('input[name="phone"]').value;
    
    if (!phone) {
        alert('전화번호를 입력해주세요.');
        return;
    }
    
    // 전화번호 형식 검증
    if (phone.length < 10) {
        alert('올바른 전화번호를 입력해주세요.');
        return;
    }
    
    alert('인증번호가 발송되었습니다.');
    document.getElementById('verificationGroup').style.display = 'block';
});

// 인증번호 확인 버튼
document.querySelector('.verify-btn')?.addEventListener('click', function() {
    const code = document.querySelector('input[name="verificationCode"]').value;
    
    if (!code) {
        alert('인증번호를 입력해주세요.');
        return;
    }
    
    if (code.length !== 6) {
        alert('6자리 인증번호를 입력해주세요.');
        return;
    }
    
    // 실제로는 서버에서 인증번호 검증
    alert('인증이 완료되었습니다.');
    isVerified = true;
    
    // 인증 완료 표시
    this.textContent = '인증완료';
    this.style.background = '#4CAF50';
    this.style.color = '#fff';
    this.disabled = true;
});

// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
    if (confirm('비밀번호 찾기를 취소하시겠습니까?')) {
        window.location.href = '/';
    }
});

// 임시 비밀번호 발송 버튼
document.querySelector('.btn.find').addEventListener('click', function() {
    const form = document.getElementById('findPasswordForm');
    
    // 폼 유효성 검사
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    const userid = document.querySelector('input[name="userid"]').value;
    const name = document.querySelector('input[name="name"]').value;
    const emailId = document.querySelector('input[name="emailId"]').value;
    const emailDomain = document.querySelector('input[name="emailDomain"]').value;
    const phone = document.querySelector('input[name="phone"]').value;
    
    if (!userid || !name || !emailId || !emailDomain || !phone) {
        alert('모든 정보를 입력해주세요.');
        return;
    }
    
    // 인증번호 확인 여부 체크
    if (!isVerified) {
        alert('전화번호 인증을 완료해주세요.');
        return;
    }
    
    // 실제로는 서버에 요청을 보내야 함
    // 서버에서 사용자 정보 확인 후 임시 비밀번호 생성 및 이메일 발송
    
    const fullEmail = emailId + '@' + emailDomain;
    const maskedEmail = emailId.substring(0, 4) + '****@' + emailDomain;
    
    // 결과 표시
    const resultBox = document.getElementById('resultBox');
    const resultEmail = document.getElementById('resultEmail');
    
    resultEmail.textContent = maskedEmail;
    resultBox.style.display = 'block';
    
    // 버튼 텍스트 변경
    this.textContent = '로그인하기';
    this.onclick = function() {
        window.location.href = '/user/login';
    };
    
    // 폼 비활성화
    const inputs = form.querySelectorAll('input, select, button.check-btn');
    inputs.forEach(input => {
        input.disabled = true;
    });
});
</script>

</html>