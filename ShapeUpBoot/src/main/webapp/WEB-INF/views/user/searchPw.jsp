<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>비밀번호 찾기 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/searchPw.css">
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
        <h3>비밀번호 찾기</h3>
      </div>

      <!-- 비밀번호 찾기 박스 -->
      <div class="find-box">
        <h2>비밀번호 찾기</h2>
        <p class="sub-text">아이디를 입력하면 등록된 이메일로 임시 비밀번호를 보내드립니다</p>

        <form id="findPasswordForm">

          <div class="form-group">
            <label>아이디</label>
            <input type="text" name="userId" id="userIdInput" placeholder="아이디를 입력하세요" required>
          </div>

          <!-- 성공 결과 표시 영역 -->
          <div class="result-box success" id="successBox" style="display: none;">
            <div class="result-content">
              <div class="result-icon">✓</div>
              <p class="result-title">임시 비밀번호가 발송되었습니다</p>
              <p class="result-email" id="resultEmail"></p>
              <p class="result-desc">이메일로 임시 비밀번호를 보내드렸습니다.<br>로그인 후 반드시 비밀번호를 변경해주세요.</p>
            </div>
          </div>

          <!-- 에러 메시지 영역 -->
          <div class="result-box error" id="errorBox" style="display: none;">
            <div class="result-content">
              <div class="result-icon">✕</div>
              <p class="result-title" id="errorTitle">일치하는 회원 정보가 없습니다</p>
              <p class="result-desc" id="errorDesc">입력하신 아이디를 다시 확인해주세요.</p>
            </div>
          </div>

          <!-- 버튼 영역 -->
          <div class="button-area">
            <button type="button" class="btn cancel">취소</button>
            <button type="button" class="btn find" id="findBtn">임시 비밀번호 발송</button>
          </div>

          <!-- 추가 링크 -->
          <div class="link-area">
            <a href="${pageContext.request.contextPath}/user/searchId">아이디 찾기</a>
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
let isSent = false;

// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
    if (confirm('비밀번호 찾기를 취소하시겠습니까?')) {
        window.location.href = contextPath + '/user/login';
    }
});

// 비밀번호 찾기 버튼
document.getElementById('findBtn').addEventListener('click', function() {
    // 이미 발송된 상태면 로그인 페이지로 이동
    if (isSent) {
        window.location.href = contextPath + '/user/login';
        return;
    }
    
    const userId = document.getElementById('userIdInput').value.trim();
    
    // 유효성 검사
    if (!userId) {
        alert('아이디를 입력해주세요.');
        document.getElementById('userIdInput').focus();
        return;
    }
    
    // 결과/에러 영역 초기화
    document.getElementById('successBox').style.display = 'none';
    document.getElementById('errorBox').style.display = 'none';
    
    // 버튼 비활성화 및 로딩 표시
    const findBtn = document.getElementById('findBtn');
    findBtn.disabled = true;
    findBtn.textContent = '처리중...';
    
    // 서버에 비밀번호 찾기 요청
    fetch(contextPath + '/user/searchPw', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'userId=' + encodeURIComponent(userId)
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            // 성공: 결과 표시
            document.getElementById('resultEmail').textContent = data.email;
            document.getElementById('successBox').style.display = 'block';
            
            // 입력 필드 비활성화
            document.getElementById('userIdInput').disabled = true;
            
            // 버튼 텍스트 변경
            isSent = true;
            findBtn.textContent = '로그인하기';
            findBtn.disabled = false;
            
        } else {
            // 실패: 에러 메시지 표시
            document.getElementById('errorTitle').textContent = data.message || '일치하는 회원 정보가 없습니다';
            if (data.message === '일치하는 회원 정보가 없습니다.') {
                document.getElementById('errorDesc').textContent = '입력하신 아이디를 다시 확인해주세요.';
            } else {
                document.getElementById('errorDesc').textContent = '잠시 후 다시 시도해주세요.';
            }
            document.getElementById('errorBox').style.display = 'block';
            
            // 버튼 재활성화
            findBtn.disabled = false;
            findBtn.textContent = '임시 비밀번호 발송';
        }
    })
    .catch(err => {
        console.error('비밀번호 찾기 오류:', err);
        document.getElementById('errorTitle').textContent = '오류가 발생했습니다';
        document.getElementById('errorDesc').textContent = '잠시 후 다시 시도해주세요.';
        document.getElementById('errorBox').style.display = 'block';
        
        // 버튼 재활성화
        findBtn.disabled = false;
        findBtn.textContent = '임시 비밀번호 발송';
    });
});

// Enter 키로 검색
document.getElementById('findPasswordForm').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        document.getElementById('findBtn').click();
    }
});

// 입력 필드 변경 시 상태 초기화
function resetSearchState() {
    if (isSent) {
        isSent = false;
        document.getElementById('findBtn').textContent = '임시 비밀번호 발송';
        document.getElementById('successBox').style.display = 'none';
        document.getElementById('errorBox').style.display = 'none';
        document.getElementById('userIdInput').disabled = false;
    }
}

document.getElementById('userIdInput').addEventListener('input', function() {
    resetSearchState();
    // 에러 박스가 표시되어 있으면 숨김
    document.getElementById('errorBox').style.display = 'none';
});
</script>

</html>