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

    <!-- 오른쪽 -->
    <section class="right-panel">
      <h1 class="logo">Shape<span>Up</span></h1>

      <!-- 회원가입 탭 -->
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

      <!-- 약관 박스 -->
      <div class="signup-box">
        <h2>약관 동의</h2>
        <p class="sub-text">서비스 이용을 위해 약관에 동의해주세요</p>

        <div class="agree-section">
          <label class="check-all">
            <input type="checkbox" id="checkAll"> 전체 약관 동의
          </label>

          <!-- 1. 서비스 이용 약관 -->
          <div class="agree-item">
            <label><input type="checkbox" class="check-item required-item" required> 서비스 이용 약관 (필수)</label>
            <button class="toggle">+</button>
          </div>
          <div class="terms-content">
            <h3>서비스 이용 약관</h3>
            <p>
              본 약관은 회사가 제공하는 서비스 이용과 관련하여 이용자와 회사 간의 권리, 의무를 규정합니다.<br>
              1. 이용자는 타인의 정보를 도용하여서는 안 됩니다.<br>
              2. 서비스 운영을 방해하는 행위를 금지합니다.<br>
              3. 회사는 관련 법령에 따라 서비스를 변경하거나 중단할 수 있습니다.
            </p>
          </div>

          <!-- 2. 개인정보 수집 및 이용 동의 -->
          <div class="agree-item">
            <label><input type="checkbox" class="check-item required-item" required> 개인정보 수집 및 이용 동의 (필수)</label>
            <button class="toggle">+</button>
          </div>
          <div class="terms-content">
            <h3>개인정보 수집 및 이용</h3>
            <p>
              수집 항목: 이름, 이메일, 비밀번호, 휴대전화번호 등<br>
              수집 목적: 회원가입, 본인확인, 서비스 제공 및 운영 등<br>
              보유 기간: 회원 탈퇴 시 즉시 삭제 (관련 법령에 따라 일부 보관 가능)
            </p>
          </div>

          <!-- 3. 개인정보 제3자 제공 동의 -->
          <div class="agree-item">
            <label><input type="checkbox" class="check-item"> 개인정보 제3자 제공 동의 (선택)</label>
            <button class="toggle">+</button>
          </div>
          <div class="terms-content">
            <h3>개인정보 제3자 제공</h3>
            <p>
              회사는 원칙적으로 개인정보를 외부에 제공하지 않습니다.<br>
              단, 서비스 제공을 위해 필요한 경우 최소한의 정보만 제공할 수 있습니다.
            </p>
          </div>

          <!-- 4. 마케팅 정보 수신 동의 -->
          <div class="agree-item">
            <label><input type="checkbox" class="check-item"> 마케팅 정보 수신 동의 (선택)</label>
            <button class="toggle">+</button>
          </div>
          <div class="terms-content">
            <h3>마케팅 정보 수신</h3>
            <p>
              할인 정보, 이벤트, 신규 콘텐츠 등의 알림을 이메일·문자 등으로 제공할 수 있습니다.<br>
              수신 동의는 언제든지 철회 가능합니다.
            </p>
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
    // 체크박스 기능
    (function() {
      const checkAll = document.getElementById('checkAll');
      const items = document.querySelectorAll('.check-item');
      const cancelBtn = document.querySelector('.btn.cancel');
      const nextBtn = document.querySelector('.btn.next');

      // 전체 동의 체크박스
      checkAll.addEventListener('change', function() {
        items.forEach(chk => chk.checked = checkAll.checked);
      });

      // 개별 체크박스 변경 시 전체 동의 체크
      items.forEach(chk => {
        chk.addEventListener('change', function() {
          checkAll.checked = Array.from(items).every(item => item.checked);
        });
      });

      // 취소 버튼
      cancelBtn.addEventListener('click', function(e) {
        e.preventDefault();
        if (confirm('회원가입을 취소하시겠습니까?')) {
          window.location.href = '/';
        }
      });

      // 다음 버튼
      nextBtn.addEventListener('click', function(e) {
        e.preventDefault();

        const requiredItems = document.querySelectorAll('.required-item');
        const allRequiredChecked = Array.from(requiredItems).every(item => item.checked);

        if (!allRequiredChecked) {
          alert('필수 약관에 동의해주세요.');
          return;
        }

        window.location.href = '/user/signupInsertInfo';
      });
    })();


    // 토글 기능 (+ → -)
    document.querySelectorAll('.toggle').forEach((btn, index) => {
  btn.addEventListener('click', () => {
    const content = document.querySelectorAll('.terms-content')[index];
    const isOpen = content.classList.contains('open');

    if (isOpen) {
      // 닫기
      content.style.maxHeight = "0px";
      content.style.paddingTop = "0px";
      content.style.paddingBottom = "0px";
      btn.textContent = '+';
      content.classList.remove('open');
    } else {
      // 열기
      content.style.maxHeight = content.scrollHeight + "px";
      content.style.paddingTop = "15px";
      content.style.paddingBottom = "15px";
      btn.textContent = '-';
      content.classList.add('open');
    }
  });
});
  </script>
</body>
</html>
