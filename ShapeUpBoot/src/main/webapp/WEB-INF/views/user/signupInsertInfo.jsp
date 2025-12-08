<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
      <c:if test="${not empty errorMsg}">
        <div style="color: red; background-color: #ffe6e6; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
          ${errorMsg}
        </div>
      </c:if>

      <%-- ✅ 소셜 로그인일 때 다른 action URL 사용 --%>
      <form id="signupForm" 
            action="<c:choose>
                      <c:when test='${isSocialLogin}'><%=request.getContextPath()%>/user/updateSocialUserInfo</c:when>
                      <c:otherwise><%=request.getContextPath()%>/user/signupInsertInfo</c:otherwise>
                    </c:choose>" 
            method="post">

        <%-- 이름 --%>
        <div class="form-group">
          <label>이름</label>
          <input type="text" name="name" id="nameInput" value="${socialName}" 
                 <c:if test="${isSocialLogin}">readonly style="background-color: #f5f5f5;"</c:if> required>
        </div>

        <%-- ⭐ 닉네임 (소셜/일반 모두 중복 확인 가능) --%>
        <div class="form-group">
          <label>닉네임</label>
          <div class="field-inline">
            <input type="text" name="nickname" id="nicknameInput" required>
            <button type="button" class="check-btn" onclick="checkNickname()">중복 확인</button>
          </div>
          <span id="nicknameMsg" class="validation-msg"></span>
        </div>

        <%-- 아이디 (소셜 로그인 시 숨김) --%>
        <c:if test="${!isSocialLogin}">
          <div class="form-group" id="userIdGroup">
            <label>아이디</label>
            <div class="field-inline">
              <input type="text" name="userid" id="useridInput" required>
              <button type="button" class="check-btn" onclick="checkUserId()">중복 확인</button>
            </div>
            <span id="useridMsg" class="validation-msg"></span>
          </div>
        </c:if>

        <%-- 비밀번호 (소셜 로그인 시 숨김) --%>
        <c:if test="${!isSocialLogin}">
          <div class="form-group" id="passwordGroup">
            <label>비밀번호</label>
            <input type="password" name="password" id="passwordInput" required>
            <p class="hint-text">8자 이상, 영문/숫자/특수문자 조합<br>
            사용 가능한 특수문자: <strong>@ $ ! % * # ? &</strong></p>
            <span id="passwordValidMsg" class="validation-msg"></span>
            <div class="password-strength" id="passwordStrength">
              <div class="strength-label">강도: <span id="strengthText">-</span></div>
              <div class="strength-bar">
                <div class="strength-fill" id="strengthFill"></div>
              </div>
            </div>
          </div>
          <div class="form-group" id="password2Group">
            <label>비밀번호 확인</label>
            <input type="password" name="password2" id="password2Input" required>
            <span id="passwordMatchMsg" class="validation-msg"></span>
          </div>
        </c:if>

        <%-- 이메일 --%>
        <div class="form-group">
          <label>이메일</label>
          <c:choose>
            <c:when test="${isSocialLogin}">
              <%-- 소셜 로그인: 표시만 (전송 안함) --%>
              <input type="text" id="emailDisplay" value="${socialEmail}" 
                     readonly style="background-color: #f5f5f5;">
            </c:when>
            <c:otherwise>
              <%-- 일반 회원가입: 입력 가능 --%>
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
            </c:otherwise>
          </c:choose>
        </div>

        <!-- 주민등록번호 -->
		<div class="form-group">
		  <label>주민등록번호</label>
		  <div style="display: flex; align-items: center; gap: 8px;">
		    <input type="text" name="birthDate" id="birthDateInput" placeholder="YYMMDD" maxlength="6" 
		           style="flex: 0 0 120px;" required>
		    <span style="font-size: 1.2em; font-weight: bold;">-</span>
		    <input type="text" name="genderDigit" id="genderDigitInput" placeholder="1" maxlength="1" 
		           style="flex: 0 0 50px; text-align: center;" required>
		    <span style="color: #666;">● ● ● ● ● ●</span>
		  </div>
		  <p class="hint-text" style="font-size: 0.85em; color: #666; margin-top: 5px;">
		    뒷자리 첫 번째 숫자만 입력 (1,2: 1900년대생 | 3,4: 2000년대생)
		  </p>
		  <span id="birthDateMsg" class="validation-msg"></span>
		</div>

        <%-- 전화번호 --%>
        <div class="form-group">
          <label>전화번호</label>
          <input type="text" name="phone" id="phoneInput" placeholder="010-1234-5678" required>
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
const isSocialLogin = ${isSocialLogin != null ? isSocialLogin : false};

// ⭐ 닉네임 입력값 변경 시 중복확인 초기화 (소셜/일반 모두 적용)
document.getElementById('nicknameInput').addEventListener('input', function() {
  window.isNicknameChecked = false;
  window.isNicknameAvailable = false;
  document.getElementById('nicknameMsg').textContent = '';
});

// ⭐ 닉네임 중복 확인 (소셜/일반 모두 적용)
function checkNickname() {
  const nickname = document.getElementById('nicknameInput').value.trim();
  if (!nickname) {
    alert('닉네임을 입력해주세요.');
    return;
  }
  
  fetch(contextPath + '/user/checkNickname?nickname=' + encodeURIComponent(nickname))
    .then(response => response.json())
    .then(data => {
      const nicknameMsg = document.getElementById('nicknameMsg');
      if (data.available) {
        nicknameMsg.textContent = '✅ ' + data.message;
        nicknameMsg.style.color = 'green';
        window.isNicknameChecked = true;
        window.isNicknameAvailable = true;
      } else {
        nicknameMsg.textContent = '❌ ' + data.message;
        nicknameMsg.style.color = 'red';
        window.isNicknameChecked = true;
        window.isNicknameAvailable = false;
      }
    })
    .catch(err => {
      alert('닉네임 확인 중 오류가 발생했습니다.');
      console.error(err);
    });
}

// ✅ 아이디 입력값 변경 시 중복확인 초기화 (일반 회원가입만)
if (!isSocialLogin) {
  const useridInput = document.getElementById('useridInput');
  if (useridInput) {
    useridInput.addEventListener('input', function() {
      window.isUserIdChecked = false;
      window.isUserIdAvailable = false;
      document.getElementById('useridMsg').textContent = '';
    });
  }
}

// 아이디 중복 확인 (일반 회원가입만)
function checkUserId() {
  const userid = document.getElementById('useridInput').value.trim();
  if (!userid) {
    alert('아이디를 입력해주세요.');
    return;
  }
  
  fetch(contextPath + '/user/checkUserId?userid=' + encodeURIComponent(userid))
    .then(response => response.json())
    .then(data => {
      const useridMsg = document.getElementById('useridMsg');
      if (data.available) {
        useridMsg.textContent = '✅ ' + data.message;
        useridMsg.style.color = 'green';
        window.isUserIdChecked = true;
        window.isUserIdAvailable = true;
      } else {
        useridMsg.textContent = '❌ ' + data.message;
        useridMsg.style.color = 'red';
        window.isUserIdChecked = true;
        window.isUserIdAvailable = false;
      }
    })
    .catch(err => {
      alert('아이디 확인 중 오류가 발생했습니다.');
      console.error(err);
    });
}

// ✅ 비밀번호 유효성 검사 (일반 회원가입만)
if (!isSocialLogin) {
  const passwordInput = document.getElementById('passwordInput');
  const password2Input = document.getElementById('password2Input');
  const passwordValidMsg = document.getElementById('passwordValidMsg');
  const passwordMatchMsg = document.getElementById('passwordMatchMsg');
  
  if (passwordInput) {
    passwordInput.addEventListener('input', function() {
      const password = this.value;
      const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
      
      if (password.length === 0) {
        passwordValidMsg.textContent = '';
        return;
      }
      
      if (!passwordPattern.test(password)) {
        let errorMsg = '❌ ';
        
        if (password.length < 8) {
          errorMsg += '8자 이상 입력해주세요. ';
        }
        if (!/[A-Za-z]/.test(password)) {
          errorMsg += '영문 포함 필수. ';
        }
        if (!/\d/.test(password)) {
          errorMsg += '숫자 포함 필수. ';
        }
        if (!/[@$!%*#?&]/.test(password)) {
          errorMsg += '특수문자(@$!%*#?&) 포함 필수. ';
        }
        
        passwordValidMsg.textContent = errorMsg;
        passwordValidMsg.style.color = 'red';
        window.isPasswordValid = false;
      } else {
        passwordValidMsg.textContent = '✅ 사용 가능한 비밀번호입니다.';
        passwordValidMsg.style.color = 'green';
        window.isPasswordValid = true;
      }
      
      // 비밀번호 확인란이 입력되어 있으면 일치 여부도 체크
      if (password2Input.value.length > 0) {
        checkPasswordMatch();
      }
    });
  }
  
  if (password2Input) {
    password2Input.addEventListener('input', function() {
      checkPasswordMatch();
    });
  }
  
  function checkPasswordMatch() {
    const password = passwordInput.value;
    const password2 = password2Input.value;
    
    if (password2.length === 0) {
      passwordMatchMsg.textContent = '';
      return;
    }
    
    if (password === password2) {
      passwordMatchMsg.textContent = '✅ 비밀번호가 일치합니다.';
      passwordMatchMsg.style.color = 'green';
      window.isPasswordMatched = true;
    } else {
      passwordMatchMsg.textContent = '❌ 비밀번호가 일치하지 않습니다.';
      passwordMatchMsg.style.color = 'red';
      window.isPasswordMatched = false;
    }
  }
}

// ✅ 생년월일 유효성 검사 함수
function validateBirthDate(birthDate, genderDigit) {
  // 1. 숫자 6자리 확인
  if (!/^\d{6}$/.test(birthDate)) {
    return { valid: false, message: '생년월일은 6자리 숫자여야 합니다. (예: 990101)' };
  }
  
  const year = parseInt(birthDate.substring(0, 2));
  const month = parseInt(birthDate.substring(2, 4));
  const day = parseInt(birthDate.substring(4, 6));
  
  // 2. 월 검증 (1~12)
  if (month < 1 || month > 12) {
    return { valid: false, message: '올바른 월을 입력해주세요.' };
  }
  
  // 3. 일 검증 (1~31, 월별로 다름)
  const daysInMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  if (day < 1 || day > daysInMonth[month - 1]) {
    return { valid: false, message: '올바른 일을 입력해주세요.' };
  }
  
  // 4. 성별 숫자에 따른 연도 계산
  let fullYear;
  if (genderDigit === '1' || genderDigit === '2') {
    fullYear = 1900 + year;
  } else if (genderDigit === '3' || genderDigit === '4') {
    fullYear = 2000 + year;
  } else {
    return { valid: false, message: '주민등록번호 뒷자리 첫 번째 숫자를 1~4 중에서 입력해주세요.' };
  }
  
  // 5. 윤년 검증 (2월 29일인 경우)
  if (month === 2 && day === 29) {
    const isLeapYear = (fullYear % 4 === 0 && fullYear % 100 !== 0) || (fullYear % 400 === 0);
    if (!isLeapYear) {
      return { valid: false, message: `${fullYear}년은 윤년이 아니므로 2월 29일은 존재하지 않습니다.` };
    }
  }
  
  // 6. 미래 날짜 체크
  const birthDateObj = new Date(fullYear, month - 1, day);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  if (birthDateObj > today) {
    return { valid: false, message: '생년월일은 오늘 이후 날짜일 수 없습니다.' };
  }
  
  // 7. 너무 오래된 날짜 체크 (120세 이상)
  const minDate = new Date();
  minDate.setFullYear(minDate.getFullYear() - 120);
  
  if (birthDateObj < minDate) {
    return { valid: false, message: '생년월일이 너무 오래되었습니다.' };
  }
  
  // 8. 만 14세 미만 체크
  const minAgeDate = new Date();
  minAgeDate.setFullYear(minAgeDate.getFullYear() - 14);
  
  if (birthDateObj > minAgeDate) {
    return { valid: false, message: '만 14세 이상만 가입할 수 있습니다.' };
  }
  
  return { valid: true, message: '유효한 생년월일입니다.' };
}

// ✅ 생년월일 실시간 검증
const birthDateInput = document.getElementById('birthDateInput');
const genderDigitInput = document.getElementById('genderDigitInput');
const birthDateMsg = document.getElementById('birthDateMsg');

birthDateInput.addEventListener('input', function() {
  // 숫자만 입력되도록
  this.value = this.value.replace(/[^0-9]/g, '');
  
  if (this.value.length === 6 && genderDigitInput.value) {
    const result = validateBirthDate(this.value, genderDigitInput.value);
    if (!result.valid) {
      birthDateMsg.textContent = '❌ ' + result.message;
      birthDateMsg.style.color = 'red';
      window.isBirthDateValid = false;
    } else {
      birthDateMsg.textContent = '✅ ' + result.message;
      birthDateMsg.style.color = 'green';
      window.isBirthDateValid = true;
    }
  } else {
    birthDateMsg.textContent = '';
    window.isBirthDateValid = false;
  }
});

genderDigitInput.addEventListener('input', function() {
  // 숫자만 입력되도록
  this.value = this.value.replace(/[^0-9]/g, '');
  
  if (birthDateInput.value.length === 6 && this.value) {
    const result = validateBirthDate(birthDateInput.value, this.value);
    if (!result.valid) {
      birthDateMsg.textContent = '❌ ' + result.message;
      birthDateMsg.style.color = 'red';
      window.isBirthDateValid = false;
    } else {
      birthDateMsg.textContent = '✅ ' + result.message;
      birthDateMsg.style.color = 'green';
      window.isBirthDateValid = true;
    }
  } else {
    birthDateMsg.textContent = '';
    window.isBirthDateValid = false;
  }
});

// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
  if(confirm('회원가입을 취소하시겠습니까?')) {
    window.location.href = contextPath + '/';
  }
});

// ⭐ Form 제출 검증 (소셜/일반 구분)
document.getElementById('signupForm').addEventListener('submit', function(e) {
  // ⭐ 닉네임 검증 (소셜/일반 모두 필수)
  const nicknameChecked = window.isNicknameChecked || false;
  const nicknameAvailable = window.isNicknameAvailable || false;
  if (!nicknameChecked || !nicknameAvailable) {
    e.preventDefault();
    alert('닉네임 중복 확인을 해주세요.');
    return false;
  }

  if (!isSocialLogin) {
    // 일반 회원 검증 (아이디/비밀번호)
    const useridChecked = window.isUserIdChecked || false;
    const userIdAvailable = window.isUserIdAvailable || false;
    if (!useridChecked || !userIdAvailable) {
      e.preventDefault();
      alert('아이디 중복 확인을 해주세요.');
      return false;
    }

    const password = document.getElementById('passwordInput').value;
    const password2 = document.getElementById('password2Input').value;
    
    const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
    if (!passwordPattern.test(password)) {
      e.preventDefault();
      alert('비밀번호는 8자 이상, 영문/숫자/특수문자를 모두 포함해야 합니다.');
      return false;
    }
    
    if (password !== password2) {
      e.preventDefault();
      alert('비밀번호가 일치하지 않습니다.');
      return false;
    }
    
    // ✅ 이메일 인증 확인
    if (!window.emailVerified) {
      e.preventDefault();
      alert('이메일 인증을 완료해주세요.');
      return false;
    }
  }

  // ✅ 생년월일 및 주민번호 검증 (소셜/일반 모두 필수)
  const birthDate = document.getElementById('birthDateInput').value;
  const genderDigit = document.getElementById('genderDigitInput').value;
  
  const birthValidation = validateBirthDate(birthDate, genderDigit);
  if (!birthValidation.valid) {
    e.preventDefault();
    birthDateMsg.textContent = '❌ ' + birthValidation.message;
    birthDateMsg.style.color = 'red';
    birthDateInput.focus();
    return false;
  }

  // 전화번호 검증 (소셜/일반 모두 필수)
  const phone = document.getElementById('phoneInput').value.trim();
  const phonePattern = /^01[0-9]-[0-9]{4}-[0-9]{4}$/;
  if (!phonePattern.test(phone)) {
    e.preventDefault();
    alert('전화번호 형식이 올바르지 않습니다. (예: 010-1234-5678)');
    return false;
  }

  return true;
});

// 이메일 도메인 선택 (일반 회원가입만)
if (!isSocialLogin) {
  const emailDomainSelect = document.getElementById('emailDomainSelect');
  const emailDomainInput = document.getElementById('emailDomainInput');
  
  if (emailDomainSelect && emailDomainInput) {
    emailDomainSelect.addEventListener('change', function() {
      if (this.value) {
        emailDomainInput.value = this.value;
        emailDomainInput.readOnly = true;
      } else {
        emailDomainInput.value = '';
        emailDomainInput.readOnly = false;
      }
    });
  }
  
  // ✅ 이메일 인증번호 발송
  const sendEmailBtn = document.getElementById('sendEmailBtn');
  if (sendEmailBtn) {
    sendEmailBtn.addEventListener('click', function() {
      const emailId = document.getElementById('emailIdInput').value.trim();
      const emailDomain = document.getElementById('emailDomainInput').value.trim();
      
      if (!emailId || !emailDomain) {
        alert('이메일을 입력해주세요.');
        return;
      }
      
      const email = emailId + '@' + emailDomain;
      
      sendEmailBtn.disabled = true;
      sendEmailBtn.textContent = '발송 중...';
      
      fetch(contextPath + '/user/sendEmailCode', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'email=' + encodeURIComponent(email)
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert(data.message);
          document.getElementById('emailVerifyMsg').textContent = '✅ 인증번호가 발송되었습니다.';
          document.getElementById('emailVerifyMsg').style.color = 'green';
          
          // 타이머 시작 (5분)
          let timeLeft = 300;
          const timer = setInterval(function() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            sendEmailBtn.textContent = `재발송 (${minutes}:${seconds.toString().padStart(2, '0')})`;
            
            if (timeLeft <= 0) {
              clearInterval(timer);
              sendEmailBtn.disabled = false;
              sendEmailBtn.textContent = '인증번호 재발송';
            }
            timeLeft--;
          }, 1000);
          
        } else {
          alert(data.message || '인증번호 발송에 실패했습니다.');
          sendEmailBtn.disabled = false;
          sendEmailBtn.textContent = '인증번호 발송';
        }
      })
      .catch(err => {
        console.error(err);
        alert('인증번호 발송 중 오류가 발생했습니다.');
        sendEmailBtn.disabled = false;
        sendEmailBtn.textContent = '인증번호 발송';
      });
    });
  }
  
  // ✅ 이메일 인증번호 확인
  const verifyEmailBtn = document.getElementById('verifyEmailBtn');
  if (verifyEmailBtn) {
    verifyEmailBtn.addEventListener('click', function() {
      const emailId = document.getElementById('emailIdInput').value.trim();
      const emailDomain = document.getElementById('emailDomainInput').value.trim();
      const code = document.getElementById('emailCodeInput').value.trim();
      
      if (!emailId || !emailDomain) {
        alert('이메일을 입력해주세요.');
        return;
      }
      
      if (!code) {
        alert('인증번호를 입력해주세요.');
        return;
      }
      
      const email = emailId + '@' + emailDomain;
      
      fetch(contextPath + '/user/verifyEmailCode', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'email=' + encodeURIComponent(email) + '&code=' + encodeURIComponent(code)
      })
      .then(response => response.json())
      .then(data => {
        const emailVerifyMsg = document.getElementById('emailVerifyMsg');
        if (data.success) {
          emailVerifyMsg.textContent = '✅ ' + data.message;
          emailVerifyMsg.style.color = 'green';
          window.emailVerified = true;
          
          // 인증 완료 후 입력 필드 비활성화
          document.getElementById('emailIdInput').readOnly = true;
          document.getElementById('emailDomainInput').readOnly = true;
          document.getElementById('emailCodeInput').readOnly = true;
          verifyEmailBtn.disabled = true;
          document.getElementById('sendEmailBtn').disabled = true;
        } else {
          emailVerifyMsg.textContent = '❌ ' + data.message;
          emailVerifyMsg.style.color = 'red';
          window.emailVerified = false;
        }
      })
      .catch(err => {
        console.error(err);
        alert('인증번호 확인 중 오류가 발생했습니다.');
      });
    });
  }
}
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