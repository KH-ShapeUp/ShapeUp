<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입 | ShapeUp</title>

  <!-- JSP에서는 경로를 contextPath 기반으로 -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/signup.css">
</head>
<body>
  <main class="signup-container">
    <section class="left-panel">
      <p>gif 이미지</p>
    </section>

    <section class="right-panel">
      <h1 class="logo">ShapeUp</h1>

      <div class="tab-menu">
        <button class="tab">로그인</button>
        <button class="tab active">회원가입</button>
      </div>

      <div class="signup-box">
        <h2>회원가입</h2>
        <p class="sub-text">회원가입 방법을 선택해주세요</p>

        <div class="signup-options">
          <button class="signup-btn">이메일로 회원가입</button>
          <button class="signup-btn kakao">카카오로 회원가입</button>
          <button class="signup-btn naver">네이버로 회원가입</button>
        </div>
      </div>
    </section>
  </main>
</body>
</html>