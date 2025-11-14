<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>약관 동의 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/signup_agreement.css">
</head>
<body>
  <main class="signup-container">

    <!-- 왼쪽 영역 -->
    <section class="left-panel">
      <p>운동하는 gif 이미지</p>
    </section>

    <!-- 오른쪽 영역 -->
    <section class="right-panel">
      <h1 class="logo">Shape<span>Up</span></h1>

      <!-- 로그인 / 회원가입 탭 -->
      <div class="tab-menu">
        <button class="tab">로그인</button>
        <button class="tab active">회원가입</button>
      </div>

      <!-- 단계 표시 바 -->
      <div class="step-bar">
        <div class="step active">
          <div class="circle">1</div>
          <p>약관 동의</p>
        </div>
        <div class="line"></div>
        <div class="step">
          <div class="circle">2</div>
          <p>정보 입력</p>
        </div>
        <div class="line"></div>
        <div class="step">
          <div class="circle">3</div>
          <p>가입 완료</p>
        </div>
      </div>

      <!-- 약관 동의 박스 -->
      <div class="signup-box">
        <h2>약관 동의</h2>
        <p class="sub-text">서비스 이용을 위해 약관에 동의해주세요</p>

        <div class="agree-section">
          <label class="check-all">
            <input type="checkbox" id="checkAll"> 전체 약관 동의
          </label>

          <div class="agree-item">
            <label><input type="checkbox" class="check-item" required> 서비스 이용 약관 (필수)</label>
            <button class="toggle">+</button>
          </div>

          <div class="agree-item">
            <label><input type="checkbox" class="check-item" required> 개인정보 수집 및 이용 동의 (필수)</label>
            <button class="toggle">+</button>
          </div>

          <div class="agree-item">
            <label><input type="checkbox" class="check-item"> 개인정보 제3자 제공 동의 (선택)</label>
            <button class="toggle">+</button>
          </div>

          <div class="agree-item">
            <label><input type="checkbox" class="check-item"> 마케팅 정보 수신 동의 (선택)</label>
            <button class="toggle">+</button>
          </div>
        </div>

        <div class="button-area">
          <button class="btn cancel">취소</button>
          <button class="btn next">다음</button>
        </div>
      </div>
    </section>
  </main>

  <script>
    const checkAll = document.getElementById('checkAll');
    const items = document.querySelectorAll('.check-item');

    checkAll.addEventListener('change', () => {
      items.forEach(chk => chk.checked = checkAll.checked);
    });

    items.forEach(chk => {
      chk.addEventListener('change', () => {
        checkAll.checked = [...items].every(item => item.checked);
      });
    });
  </script>
</body>
</html>
