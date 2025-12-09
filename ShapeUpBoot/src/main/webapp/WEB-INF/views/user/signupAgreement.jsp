<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>약관 동의 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/signupAgreement.css">
  <link rel="icon" href="${pageContext.request.contextPath}/resources/img/fav/favicon.png">
</head>
<body>
  <main class="signup-container">
    <section class="right-panel">
      <div class="logo">
      	<a href ="/">
	        <img src="${pageContext.request.contextPath}/resources/img/main_logo.png" alt="Logo" width="180px">
      	</a>
      </div>

      <div class="tab-menu"><h3>회원가입</h3></div>

      <div class="step-bar">
        <div class="step active"><div class="circle">1</div><p>약관 동의</p></div>
        <div class="line"></div>
        <div class="step"><div class="circle">2</div><p>정보 입력</p></div>
        <div class="line"></div>
        <div class="step"><div class="circle">3</div><p>가입 완료</p></div>
      </div>

      <div class="signup-box">
        <h2>약관 동의</h2>
        <p class="sub-text">서비스 이용을 위해 약관에 동의해주세요</p>

        <form id="agreementForm" action="${pageContext.request.contextPath}/user/signupAgreement" method="post">
          <div class="agree-section">
            <label class="check-all">
              <input type="checkbox" id="checkAll"> 전체 약관 동의
            </label>

            <!-- 필수 약관 -->
            <div class="agree-item">
              <label>
                <input type="checkbox" name="termsAgree" class="check-item required-item">
                서비스 이용 약관 (필수)
              </label>
              <button type="button" class="toggle">+</button>
            </div>
            <div class="terms-content">
              <p>본 약관은 회사가 제공하는 서비스 이용과 관련하여 이용자와 회사 간의 권리, 의무를 규정합니다.</p>
              <ul>
                <li>이용자는 타인의 정보를 도용하여서는 안 됩니다.</li>
                <li>서비스 운영을 방해하는 행위를 금지합니다.</li>
                <li>회사는 관련 법령에 따라 서비스를 변경하거나 중단할 수 있습니다.</li>
              </ul>
            </div>

            <div class="agree-item">
              <label>
                <input type="checkbox" name="privacyAgree" class="check-item required-item">
                개인정보 수집 및 이용 동의 (필수)
              </label>
              <button type="button" class="toggle">+</button>
            </div>
            <div class="terms-content">
              <p>수집 항목: 이름, 이메일, 비밀번호, 휴대전화번호 등</p>
              <p>수집 목적: 회원가입, 본인확인, 서비스 제공 및 운영 등</p>
              <p>보유 기간: 회원 탈퇴 시 즉시 삭제 (관련 법령에 따라 일부 보관 가능)</p>
            </div>

            <!-- 선택 약관 -->
            <div class="agree-item">
              <label>
                <input type="checkbox" name="thirdPartyAgree" class="check-item">
                개인정보 제3자 제공 동의 (선택)
              </label>
              <button type="button" class="toggle">+</button>
            </div>
            <div class="terms-content">
              <p>회사는 원칙적으로 개인정보를 외부에 제공하지 않습니다.</p>
              <p>단, 서비스 제공을 위해 필요한 경우 최소한의 정보만 제공할 수 있습니다.</p>
            </div>

            <div class="agree-item">
              <label>
                <input type="checkbox" name="marketingAgree" class="check-item">
                마케팅 정보 수신 동의 (선택)
              </label>
              <button type="button" class="toggle">+</button>
            </div>
            <div class="terms-content">
              <p>할인 정보, 이벤트, 신규 콘텐츠 등의 알림을 이메일·문자 등으로 제공할 수 있습니다.</p>
              <p>수신 동의는 언제든지 철회 가능합니다.</p>
            </div>
          </div>

          <div class="button-area">
            <a href="/" class="btn cancel">취소</a>
            <button type="submit" class="btn next">다음</button>
          </div>
        </form>
      </div>
    </section>
  </main>

  <script>
    // 전체 동의 체크
    const checkAll = document.getElementById('checkAll');
    const items = document.querySelectorAll('.check-item');
    checkAll?.addEventListener('change', () => {
      items.forEach(item => item.checked = checkAll.checked);
    });
    items.forEach(item => item.addEventListener('change', () => {
      checkAll.checked = Array.from(items).every(i => i.checked);
    }));

    // 약관 토글 (+ / -)
    document.querySelectorAll('.toggle').forEach((btn, index) => {
      btn.addEventListener('click', () => {
        const content = document.querySelectorAll('.terms-content')[index];
        if (content.classList.contains('open')) {
          content.style.maxHeight = "0px";
          content.style.paddingTop = "0px";
          content.style.paddingBottom = "0px";
          btn.textContent = "+";
          content.classList.remove('open');
        } else {
          content.style.maxHeight = content.scrollHeight + "px";
          content.style.paddingTop = "15px";
          content.style.paddingBottom = "15px";
          btn.textContent = "-";
          content.classList.add('open');
        }
      });
    });

    // 필수 약관 체크 후 submit
    document.getElementById('agreementForm').addEventListener('submit', function(e) {
      const requiredItems = document.querySelectorAll('.required-item');
      const allRequiredChecked = Array.from(requiredItems).every(item => item.checked);

      if (!allRequiredChecked) {
        e.preventDefault(); // 폼 제출 막기
        alert('필수 약관에 모두 동의하셔야 합니다.');
      }
    });
  </script>
</body>
</html>
