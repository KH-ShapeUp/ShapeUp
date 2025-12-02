<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>ShapeUp 소개</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp" />
  <link rel="stylesheet" href="/resources/css/introduce.css">
</head>
<body>
  <div class="intro-wrap">
    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <main class="intro-main">
      <!-- HERO -->
      <section class="intro-section hero">
        <div class="bg-cover"></div>
        <div class="hero-content float-up">
          <p class="eyebrow">바쁜 현대인을 위한 스포츠 어시스턴스</p>
          <h1>ShapeUp과 함께<br/>운동의 시작을 더 쉽고 가볍게</h1>
          <img src="/resources/img/introduce-img/int_logo.png" alt="ShapeUp 로고" class="hero-logo float float-up">
        </div>
      </section>

      <!-- PROBLEM CARDS -->
      <section class="intro-section problem">
        <h2 class="section-title float-up">운동이 어려운 이유, 우리는 잘 알고 있습니다.</h2>
        <div class="card-grid">
          <article class="card float-up" style="--delay: 0.2s;">
            <img src="/resources/img/introduce-img/int_icon_5.png" alt="시간 부족" class="icon float">
            <h3>시간 부족</h3>
            <p>불규칙한 스케줄로<br/>운동 시간을 내기 힘들다</p>
          </article>
          <article class="card float-up" style="--delay: 0.3s;">
            <img src="/resources/img/introduce-img/int_icon_1.png" alt="메이트 찾기" class="icon float">
            <h3>힘든 메이트 찾기</h3>
            <p>나와 맞는 팀원을<br/>찾기 어렵다</p>
          </article>
          <article class="card float-up" style="--delay: 0.4s;">
            <img src="/resources/img/introduce-img/int_icon_3.png" alt="접근성 한계" class="icon float">
            <h3>접근성 한계</h3>
            <p>운동 공간 정보를<br/>한눈에 보기 어렵다</p>
          </article>
        </div>
      </section>

      <!-- VALUE LOGO -->
      <section class="intro-section logo-punch">
        <div class="logo-box float-up">
          <p class="eyebrow">우리가 만든 이유</p>
          <h2>지속 가능한 자기관리를 돕는<br/>스포츠 플랫폼 ShapeUp</h2>
          <img src="/resources/img/introduce-img/int_logo.png" alt="ShapeUp 로고" class="logo-main float">
        </div>
      </section>

      <!-- STORY SLIDES -->
      <section class="intro-section story-slide slide-purple">
        <div class="story-inner float-up">
          <div class="story-text">
            <p class="eyebrow">지속적인 동기부여</p>
            <h3>기록과 인증으로<br/>꾸준함을 만들어갑니다.</h3>
            <p class="body">운동 기록과 인증샷을 공유해 개인의 변화와 성장을 눈으로 확인하고, 함께하는 멤버들과 동기부여를 주고받습니다.</p>
          </div>
          <div class="story-visual">
            <img src="/resources/img/introduce-img/int_icon_4.png" alt="동기부여 아이콘" class="story-img float float-up">
          </div>
        </div>
      </section>

      <section class="intro-section story-slide slide-blue">
        <div class="story-inner float-up">
          <div class="story-text">
            <p class="eyebrow">혼자서도 쉽게</p>
            <h3>맞춤 매칭으로<br/>나와 잘 맞는 팀원 찾기</h3>
            <p class="body">원하는 시간대와 운동 유형을 설정해 알맞은 파트너를 손쉽게 매칭합니다. 누구나 편하게 합류할 수 있는 경험을 제공합니다.</p>
          </div>
          <div class="story-visual">
            <img src="/resources/img/introduce-img/int_icon_6.png" alt="매칭 아이콘" class="story-img float float-up">
          </div>
        </div>
      </section>

      <section class="intro-section story-slide slide-gradient">
        <div class="story-inner float-up">
          <div class="story-text">
            <p class="eyebrow">피드백 & 루틴</p>
            <h3>전문 피드백과 루틴 관리로<br/>정확하게, 꾸준하게.</h3>
            <p class="body">트레이너 매칭과 루틴 관리 기능을 통해 올바른 자세와 반복 가능한 일정을 만들어 부상 없이 성장하세요.</p>
          </div>
          <div class="story-visual">
            <img src="/resources/img/introduce-img/int_icon_3.png" alt="루틴 아이콘" class="story-img float float-up">
          </div>
        </div>
      </section>

      <!-- CTA -->
      <section class="intro-section cta">
        <div class="cta-inner float-up">
          <p class="eyebrow">이제 건강할 시간</p>
          <h2>당신의 건강한 루틴을<br/>ShapeUp과 함께 만들어보세요.</h2>
          <div class="cta-actions">
            <c:choose>
              <c:when test="${
                  not empty sessionScope.userNickname
                  or not empty sessionScope.loginUser
                  or not empty sessionScope.userNo
                  or not empty sessionScope.loginUserEmail
                }">
                <p class="cta-welcome">이미 회원이시군요! 환영합니다!</p>
              </c:when>
              <c:otherwise>
                <a href="/user/signupAgreement" class="btn primary">지금 시작하기</a>
                <a href="/user/login" class="btn ghost">로그인</a>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </section>
    </main>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
  </div>

  <script>
    // Scroll reveal
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('show');
          } else {
            entry.target.classList.remove('show');
          }
        });
      },
      { threshold: 0.2 }
    );

    document.querySelectorAll('.float-up, .float').forEach((el) => observer.observe(el));
  </script>
</body>
</html>
