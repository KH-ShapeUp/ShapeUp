<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>아이디 찾기 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/searchId.css">
</head>
<body>

  <main class="find-container">
    <section class="right-panel">
      <div class="logo">
        <img src="../../../../resources/img/main_logo.png" alt="" width="180px">
      </div>

      <!-- 상단 탭 -->
      <div class="tab-menu">
        <h3>아이디 찾기</h3>
      </div>

      <!-- 아이디 찾기 박스 -->
      <div class="find-box">
        <h2>아이디 찾기</h2>
        <p class="sub-text">가입 시 등록한 정보를 입력해주세요</p>

        <form id="findUseridForm">

          <div class="form-group">
            <label>이름</label>
            <input type="text" name="name" placeholder="가입 시 등록한 이름을 입력하세요" required>
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

          <div class="form-group">
            <label>전화번호</label>
            <div class="field-inline">
              <input type="text" name="phone" placeholder="'-' 없이 입력" required>
              <button type="button" class="check-btn">인증번호 발송</button>
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
          <div class="result-box" id="resultBox" style="display: none;">
            <div class="result-content">
              <p class="result-title">회원님의 아이디는</p>
              <p class="result-userid" id="resultUserid">user****</p>
              <p class="result-date" id="resultDate">가입일: 2024.01.15</p>
            </div>
          </div>

          <!-- 버튼 영역 -->
          <div class="button-area">
            <button type="button" class="btn cancel">취소</button>
            <button type="button" class="btn find">아이디 찾기</button>
          </div>

          <!-- 추가 링크 -->
          <div class="link-area">
            <a href="/user/findPassword">비밀번호 찾기</a>
            <span class="divider">|</span>
            <a href="/user/login">로그인</a>
          </div>

        </form>
      </div>
    </section>
  </main>
	
</body>
<script>
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
    
    // 전화번호 형식 검증 (간단한 예시)
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
    
    alert('인증이 완료되었습니다.');
});

// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
    if (confirm('아이디 찾기를 취소하시겠습니까?')) {
        window.location.href = '/';
    }
});

// 아이디 찾기 버튼
document.querySelector('.btn.find').addEventListener('click', function() {
    const form = document.getElementById('findUseridForm');
    
    // 폼 유효성 검사
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    const name = document.querySelector('input[name="name"]').value;
    const emailId = document.querySelector('input[name="emailId"]').value;
    const emailDomain = document.querySelector('input[name="emailDomain"]').value;
    const phone = document.querySelector('input[name="phone"]').value;
    
    if (!name || !emailId || !emailDomain || !phone) {
        alert('모든 정보를 입력해주세요.');
        return;
    }
    
    // 실제로는 서버에 요청을 보내야 함
    // 여기서는 예시로 결과를 표시
    const resultBox = document.getElementById('resultBox');
    const resultUserid = document.getElementById('resultUserid');
    const resultDate = document.getElementById('resultDate');
    
    // 임시 데이터 (실제로는 서버 응답 데이터 사용)
    resultUserid.textContent = 'user****';
    resultDate.textContent = '가입일: 2024.01.15';
    
    resultBox.style.display = 'block';
    
    // 버튼 텍스트 변경
    this.textContent = '로그인하기';
    this.onclick = function() {
        window.location.href = '/login';
    };
});
</script>

</html>