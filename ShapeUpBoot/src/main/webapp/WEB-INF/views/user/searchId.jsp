<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>아이디 찾기 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/searchId.css">
  <link rel="icon" href="${pageContext.request.contextPath}/resources/img/fav/favicon.png">
</head>
<body>

  <main class="find-container">
    <section class="right-panel">
      <div class="logo">
        <img src="${pageContext.request.contextPath}/resources/img/main_logo.png" alt="ShapeUp 로고" width="180px">
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
            <input type="text" name="name" id="nameInput" placeholder="가입 시 등록한 이름을 입력하세요" required>
          </div>

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
            </div>
          </div>

          <div class="form-group">
            <label>전화번호</label>
            <input type="text" name="phone" id="phoneInput" placeholder="010-1234-5678" required>
          </div>

          <!-- 결과 표시 영역 -->
          <div class="result-box" id="resultBox" style="display: none;">
            <div class="result-content">
              <p class="result-title">회원님의 아이디는</p>
              <p class="result-userid" id="resultUserid"></p>
              <p class="result-date" id="resultDate"></p>
            </div>
          </div>

          <!-- 에러 메시지 영역 -->
          <div class="error-box" id="errorBox" style="display: none;">
            <p id="errorMessage"></p>
          </div>

          <!-- 버튼 영역 -->
          <div class="button-area">
            <button type="button" class="btn cancel">취소</button>
            <button type="button" class="btn find" id="findBtn">아이디 찾기</button>
          </div>

          <!-- 추가 링크 -->
          <div class="link-area">
            <a href="${pageContext.request.contextPath}/user/searchPw">비밀번호 찾기</a>
            <span class="divider">|</span>
            <a href="${pageContext.request.contextPath}/user/login">로그인</a>
          </div>

        </form>
      </div>
    </section>
  </main>
	
</body>
<script>
const contextPath = '${pageContext.request.contextPath}';
let isFound = false;

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

// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
    if (confirm('아이디 찾기를 취소하시겠습니까?')) {
        window.location.href = contextPath + '/';
    }
});

// 아이디 찾기 버튼
document.getElementById('findBtn').addEventListener('click', function() {
    // 이미 찾은 상태면 로그인 페이지로 이동
    if (isFound) {
        window.location.href = contextPath + '/user/login';
        return;
    }
    
    const name = document.getElementById('nameInput').value.trim();
    const emailId = document.getElementById('emailIdInput').value.trim();
    const emailDomain = document.getElementById('emailDomainInput').value.trim();
    const phone = document.getElementById('phoneInput').value.trim();
    
    // 유효성 검사
    if (!name) {
        alert('이름을 입력해주세요.');
        document.getElementById('nameInput').focus();
        return;
    }
    
    if (!emailId || !emailDomain) {
        alert('이메일을 입력해주세요.');
        return;
    }
    
    if (!phone) {
        alert('전화번호를 입력해주세요.');
        document.getElementById('phoneInput').focus();
        return;
    }
    
    // 전화번호 형식 검증 (하이픈 포함)
    const phonePattern = /^01[0-9]-[0-9]{3,4}-[0-9]{4}$/;
    if (!phonePattern.test(phone)) {
        alert("전화번호 형식이 올바르지 않습니다. (예: 010-1234-5678)");
        return;
    }
    
    // 결과/에러 영역 초기화
    document.getElementById('resultBox').style.display = 'none';
    document.getElementById('errorBox').style.display = 'none';
    
    // 서버에 아이디 찾기 요청
    fetch(contextPath + '/user/searchId', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'name=' + encodeURIComponent(name) 
            + '&emailId=' + encodeURIComponent(emailId)
            + '&emailDomain=' + encodeURIComponent(emailDomain)
            + '&phone=' + encodeURIComponent(phone)
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            // 성공: 결과 표시
            document.getElementById('resultUserid').textContent = data.userId;
            
            // 가입일 포맷팅
            if (data.enrollDate) {
                const date = new Date(data.enrollDate);
                const formatted = date.getFullYear() + '.' 
                    + String(date.getMonth() + 1).padStart(2, '0') + '.' 
                    + String(date.getDate()).padStart(2, '0');
                document.getElementById('resultDate').textContent = '가입일: ' + formatted;
            } else {
                document.getElementById('resultDate').textContent = '';
            }
            
            document.getElementById('resultBox').style.display = 'block';
            
            // 버튼 텍스트 변경
            isFound = true;
            document.getElementById('findBtn').textContent = '로그인하기';
            
        } else {
            // 실패: 에러 메시지 표시
            document.getElementById('errorMessage').textContent = data.message || '일치하는 회원 정보가 없습니다.';
            document.getElementById('errorBox').style.display = 'block';
        }
    })
    .catch(err => {
        console.error('아이디 찾기 오류:', err);
        alert('오류가 발생했습니다. 다시 시도해주세요.');
    });
});

// Enter 키로 검색
document.getElementById('findUseridForm').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        document.getElementById('findBtn').click();
    }
});

function resetSearchState() {
    if (isFound) {
        isFound = false;
        document.getElementById('findBtn').textContent = '아이디 찾기';
        document.getElementById('resultBox').style.display = 'none';
        document.getElementById('errorBox').style.display = 'none';
    }
}

['nameInput', 'emailIdInput', 'emailDomainInput', 'emailDomainSelect', 'phoneInput']
    .forEach(id => {
        document.getElementById(id).addEventListener('input', resetSearchState);
        document.getElementById(id).addEventListener('change', resetSearchState);
    });
</script>



</html>