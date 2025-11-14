<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입 완료 | ShapeUp</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/signupSuccess.css">
</head>
<body>

  <main class="signup-container">


    <!-- 오른쪽 영역 -->
    <section class="right-panel">
      <h1 class="logo">Shape<span>Up</span></h1>

      <!-- 상단 탭 -->
      <div class="tab-menu">
        <button class="tab active">회원가입</button>
      </div>

      <!-- 3단계 진행 바 -->
      <div class="step-bar">
        <div class="step completed">
          <div class="circle">1</div>
          <p>약관 동의</p>
        </div>
        <div class="line"></div>
        <div class="step completed">
          <div class="circle">2</div>
          <p>정보 입력</p>
        </div>
        <div class="line"></div>
        <div class="step active">
          <div class="circle">3</div>
          <p>가입 완료</p>
        </div>
      </div>

      <!-- 완료 박스 -->
      <div class="signup-box">
        <div class="complete-content">
          <!-- 체크 아이콘 -->
          <div class="check-icon">
            <svg width="80" height="80" viewBox="0 0 80 80" fill="none">
              <circle cx="40" cy="40" r="40" fill="#000"/>
              <path d="M25 40L35 50L55 30" stroke="#fff" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>

          <h2>회원가입이 완료되었습니다!</h2>
          <p class="sub-text">ShapeUp의 회원이 되신 것을 환영합니다.</p>
          <p class="sub-text">지금 바로 로그인하여 다양한 운동 기록을 시작해보세요.</p>

          <!-- 버튼 영역 -->
          <div class="button-area">
            <button type="button" class="btn main-btn" onclick="goToMain()">메인페이지</button>
            <button type="button" class="btn login-btn" onclick="goToLogin()">로그인</button>
          </div>
        </div>
      </div>
    </section>
  </main>

</body>

<script>
// 메인페이지로 이동
function goToMain() {
  window.location.href = '/';
}

// 로그인 페이지로 이동
function goToLogin() {
  window.location.href = '/login';
}
</script>

</html>