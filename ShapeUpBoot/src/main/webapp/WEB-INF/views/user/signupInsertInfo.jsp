<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/signupInsertInfo.css">
</head>
<body>

  <main class="signup-container">

    <!-- 오른쪽 영역 -->
    <section class="right-panel">
      <h1 class="logo">Shape<span>Up</span></h1>

      <!-- 상단 탭 -->
      <div class="tab-menu">
        <button class="tab">회원가입</button>
      </div>

      <!-- 3단계 진행 바 -->
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

      <!-- 정보 입력 박스 -->
      <div class="signup-box">
        <h2>정보 입력</h2>
        <p class="sub-text">필수 정보를 입력해주세요</p>

        <form id="signupForm" action="/user/signupSurvey" method="post">

          <div class="form-group">
            <label>이름</label>
            <input type="text" name="name" required>
          </div>

          <div class="form-group">
            <label>닉네임</label>
            <div class="field-inline">
              <input type="text" name="nickname" required>
              <button type="button" class="check-btn">중복 확인</button>
            </div>
          </div>

          <div class="form-group">
            <label>아이디</label>
            <div class="field-inline">
              <input type="text" name="userid" required>
              <button type="button" class="check-btn">중복 확인</button>
            </div>
          </div>

          <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="password" required>
          </div>

          <div class="form-group">
            <label>비밀번호 확인</label>
            <input type="password" name="password2" required>
          </div>

          <div class="form-group">
            <label>이메일</label>
            <div class="field-inline email-box">
              <input type="text" name="emailId" placeholder="이메일 아이디" required>
              <span>@</span>
              <!-- 도메인 입력 필드 -->
              <input type="text" name="emailDomain" id="emailDomainInput" placeholder="직접 입력" required>
              <!-- 도메인 드롭다운 -->
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

          <div class="form-group">
            <label>성별</label>
            <div class="radio-box">
              <label><input type="radio" name="gender" value="M" required> 남성</label>
              <label><input type="radio" name="gender" value="F" required> 여성</label>
            </div>
          </div>

          <div class="form-group">
            <label>생년월일</label>
            <div class="birth-box">
              <input type="text" name="birthYear" placeholder="YYYY" maxlength="4" required>
              <input type="text" name="birthMonth" placeholder="MM" maxlength="2" required>
              <input type="text" name="birthDay" placeholder="DD" maxlength="2" required>
            </div>
          </div>

          <div class="form-group">
            <label>전화번호</label>
            <div class="field-inline">
              <input type="text" name="phone" required>
              <button type="button" class="check-btn">인증번호 발송</button>
            </div>
          </div>

          <!-- 버튼 영역 -->
          <div class="button-area">
            <button type="button" class="btn cancel">취소</button>
            <button type="button" class="btn next">다음</button>
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
        // 직접 입력 
        domainInput.value = "";
        domainInput.readOnly = false;
        domainInput.placeholder = "직접 입력";
    } else {
        // 선택한 도메인 자동 입력
        domainInput.value = this.value;
        domainInput.readOnly = true; // 선택한 경우 입력 불가
    }
});

// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
    if (confirm('회원가입을 취소하시겠습니까?')) {
        window.location.href = '/';
    }
});

// 다음 버튼
document.querySelector('.btn.next').addEventListener('click', function() {
    const form = document.getElementById('signupForm');
    
    // 폼 유효성 검사
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    // 비밀번호 확인
    const password = document.querySelector('input[name="password"]').value;
    const password2 = document.querySelector('input[name="password2"]').value;
    
    if (password !== password2) {
        alert('비밀번호가 일치하지 않습니다.');
        return;
    }
    
    // 생년월일 유효성 검사
    const birthYear = document.querySelector('input[name="birthYear"]').value;
    const birthMonth = document.querySelector('input[name="birthMonth"]').value;
    const birthDay = document.querySelector('input[name="birthDay"]').value;
    
    if (birthYear.length !== 4 || birthMonth.length !== 2 || birthDay.length !== 2) {
        alert('생년월일을 정확히 입력해주세요.');
        return;
    }
    
    // 다음 페이지로 이동
    window.location.href = '/user/signupSurvey';
});
</script>

</html>