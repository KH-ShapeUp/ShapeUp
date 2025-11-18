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
      <div class="logo">
            <img src="../../../../resources/img/main_logo.png" alt="" width="180px"></a>
        </div>

      <!-- 상단 탭 -->
      <div class="tab-menu">
       <h3>회원가입</h3>
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
            <label>생년월일 및 성별</label>
            <div class="birth-box">
              <input type="text" name="birthDate" id="birthDateInput" placeholder="YYMMDD" maxlength="6" required>
              <span class="dash">-</span>
              <input type="text" name="genderDigit" placeholder="" maxlength="1" class="gender-digit" required>
              <span class="dots">● ● ● ● ● ●</span>
            </div>
            <p class="hint-text">생년월일 6자리와 주민등록번호 뒷자리 첫 번째 숫자를 입력하세요 (1,2,3,4)</p>
          </div>

          <div class="form-group">
            <label>전화번호</label>
            <div class="field-inline">
              <input type="text" placeholder="010-1234-5678" name="phone" required>
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

// 생년월일 숫자만 입력
document.getElementById('birthDateInput').addEventListener('input', function(e) {
    this.value = this.value.replace(/[^0-9]/g, '');
});

// 주민번호 뒷자리 유효성 검사 (숫자만 입력)
document.querySelector('input[name="genderDigit"]').addEventListener('input', function(e) {
    this.value = this.value.replace(/[^1-4]/g, '');
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
    const birthDate = document.querySelector('input[name="birthDate"]').value;
    
    if (birthDate.length !== 6) {
        alert('생년월일 6자리를 정확히 입력해주세요. (YYMMDD)');
        return;
    }
    
    // 주민번호 뒷자리 첫 번째 숫자 유효성 검사
    const genderDigit = document.querySelector('input[name="genderDigit"]').value;
    
    if (!genderDigit || !['1', '2', '3', '4'].includes(genderDigit)) {
        alert('주민번호 뒷자리 첫 번째 숫자를 정확히 입력해주세요. (1, 2, 3, 4)');
        return;
    }
    
    // 성별 자동 결정 (1,3 = 남성, 2,4 = 여성)
    const gender = (genderDigit === '1' || genderDigit === '3') ? 'M' : 'F';
    
    // hidden input으로 성별과 생년월일 분리 데이터 추가
    let genderInput = document.querySelector('input[name="gender"]');
    if (!genderInput) {
        genderInput = document.createElement('input');
        genderInput.type = 'hidden';
        genderInput.name = 'gender';
        form.appendChild(genderInput);
    }
    genderInput.value = gender;
    
    // 생년월일 분리 (서버에서 필요한 경우)
    const birthYear = '20' + birthDate.substring(0, 2); // 또는 '19' + (필요시 genderDigit으로 판단)
    const birthMonth = birthDate.substring(2, 4);
    const birthDay = birthDate.substring(4, 6);
    
    let yearInput = document.querySelector('input[name="birthYear"]');
    if (!yearInput) {
        yearInput = document.createElement('input');
        yearInput.type = 'hidden';
        yearInput.name = 'birthYear';
        form.appendChild(yearInput);
    }
    yearInput.value = birthYear;
    
    let monthInput = document.querySelector('input[name="birthMonth"]');
    if (!monthInput) {
        monthInput = document.createElement('input');
        monthInput.type = 'hidden';
        monthInput.name = 'birthMonth';
        form.appendChild(monthInput);
    }
    monthInput.value = birthMonth;
    
    let dayInput = document.querySelector('input[name="birthDay"]');
    if (!dayInput) {
        dayInput = document.createElement('input');
        dayInput.type = 'hidden';
        dayInput.name = 'birthDay';
        form.appendChild(dayInput);
    }
    dayInput.value = birthDay;
    
    // 다음 페이지로 이동
    window.location.href = '/user/signupSurvey';
});
</script>

</html>