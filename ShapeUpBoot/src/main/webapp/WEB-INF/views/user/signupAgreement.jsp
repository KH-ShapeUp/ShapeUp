<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>약관 동의 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/signupAgreement.css">
</head>
<body>
  <main class="signup-container">

    <!-- 오른쪽 영역 -->
    <section class="right-panel">
      <h1 class="logo">Shape<span>Up</span></h1>

      <!-- 로그인 / 회원가입 탭 -->
      <div class="tab-menu">
        <button class="tab">회원가입</button>
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
            <label><input type="checkbox" class="check-item required-item" required> 서비스 이용 약관 (필수)</label>
            <button class="toggle">+</button>
          </div>

          <div class="agree-item">
            <label><input type="checkbox" class="check-item required-item" required> 개인정보 수집 및 이용 동의 (필수)</label>
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
          <button type="button" class="btn cancel">취소</button>
          <button type="button" class="btn next">다음</button>
        </div>
      </div>
    </section>
  </main>

  <script>
    // 페이지 로드 즉시 실행
    (function() {
      console.log('스크립트 로드됨'); // 디버깅용
      
      const checkAll = document.getElementById('checkAll');
      const items = document.querySelectorAll('.check-item');
      const cancelBtn = document.querySelector('.btn.cancel');
      const nextBtn = document.querySelector('.btn.next');

      console.log('버튼 찾음:', cancelBtn, nextBtn); // 디버깅용

      // 전체 동의 체크박스
      if (checkAll) {
        checkAll.addEventListener('change', function() {
          items.forEach(chk => chk.checked = checkAll.checked);
        });
      }

      // 개별 체크박스
      items.forEach(chk => {
        chk.addEventListener('change', function() {
          checkAll.checked = Array.from(items).every(item => item.checked);
        });
      });

      // 취소 버튼
      if (cancelBtn) {
        cancelBtn.addEventListener('click', function(e) {
          e.preventDefault();
          console.log('취소 버튼 클릭됨'); // 디버깅용
          if (confirm('회원가입을 취소하시겠습니까?')) {
            window.location.href = '/';
          }
        });
      }

      // 다음 버튼
      if (nextBtn) {
        nextBtn.addEventListener('click', function(e) {
          e.preventDefault();
          console.log('다음 버튼 클릭됨'); // 디버깅용
          
          const requiredItems = document.querySelectorAll('.required-item');
          const allRequiredChecked = Array.from(requiredItems).every(item => item.checked);

          if (!allRequiredChecked) {
            alert('필수 약관에 동의해주세요.');
            return;
          }

          // 다음 단계로 이동
          window.location.href = '/user/signupInsertInfo';
        });
      }
    })();
  </script>
</body>
</html>