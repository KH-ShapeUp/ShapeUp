<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 세션에서 로그인 정보 가져오기
    String loginUserNickname = (String) session.getAttribute("userNickname");
    boolean isLogin = loginUserNickname != null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 | ShapeUp</title>
    <jsp:include page="/WEB-INF/views/include/head.jsp"/> 
    <link rel="stylesheet" href="../../../resources/css/user/login.css">
</head>
<body>

    <!-- 모바일 검색 / 사이드바 등 생략 가능 -->

    <!-- 메인 컨테이너 -->
    <div class="container">
        <div class="main">
            <!-- iframe 배경 -->
            <div class="login-gif" style="position: relative; height: 100vh;">
                <iframe 
                    width="100%" 
                    height="100%" 
                    src="https://www.youtube.com/embed/Kovp09aghdc?autoplay=1&mute=1&loop=1&playlist=Kovp09aghdc&controls=0&modestbranding=1&showinfo=0"
                    title="Workout Motivation"
                    frameborder="0"
                    allow="autoplay; encrypted-media"
                    referrerpolicy="strict-origin-when-cross-origin" 
                    allowfullscreen
                    playsinline
                    style="position:absolute; top:0; left:0; width:100%; height:100%; z-index:0;"
                ></iframe>
                <!-- 반투명 오버레이 -->
                <div class="video-overlay" style="position:absolute; top:0; left:0; width:100%; height:100%; background-color: rgba(0,0,0,0.4); z-index:1;"></div>
            </div>

            <!-- 로그인 폼 -->
            <div class="login-form-wrapper" style="position: relative; z-index:2;">
                <div class="login-form-top">
                    <a href="/"><img src="../../resources/img/main_logo.png"></a>
                </div>

                <div class="login-form">
                    <form action="/user/login" method="post" style="width: 100%;">
                        <div class="form-group">
                            <label for="userId">아이디
                                <input type="text" name="userId" id="userId" required>
                            </label>
                        </div>

                        <div class="form-group">
                            <label for="userPw">비밀번호
                                <input type="password" name="userPw" id="userPw" required>
                                <i class="fa-solid fa-eye" style="display: none;"></i>
                                <i class="fa-solid fa-eye-slash"></i>
                            </label>
                        </div>

                        <div class="auto-login">
                            <input type="checkbox" id="auto-login" name="autoLogin">
                            <label for="auto-login">자동 로그인</label>
                        </div>

                        <button type="submit" id="login-btn">로그인</button>

                        <% if(request.getAttribute("errorMsg") != null) { %>
                            <div class="error-msg" style="color:#ff3b00; margin-top:10px; font-weight: 500; font-size: .8rem; text-align: center;">
                                <%= request.getAttribute("errorMsg") %>
                            </div>
                        <% } %>

                        
                    </form>

                    <div class="account-list">
                        <ul>
                            <li><a href="/user/signupAgreement">회원가입</a></li>
                            <li>&#8739;</li>
                            <li><a href="/user/searchId">아이디 찾기</a></li>
                            <li>&#8739;</li>
                            <li><a href="#">비밀번호 찾기</a></li>
                        </ul>
                    </div>

                    <div class="social-login">
                        <img src="../../resources/img/naver.png" class="naver">
                        <img src="../../resources/img/kakao.png" class="kakao">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const userPw = document.querySelector("#userPw");
        const visiblePw = document.querySelector(".fa-eye");
        const hiddenPw = document.querySelector(".fa-eye-slash");

        [visiblePw, hiddenPw].forEach(icon => {
            icon.addEventListener("click", () => {
                if (userPw.type === "password") {
                    userPw.type = "text";
                    visiblePw.style.display = "flex";
                    hiddenPw.style.display = "none";
                } else {
                    userPw.type = "password";
                    visiblePw.style.display = "none";
                    hiddenPw.style.display = "flex";
                }
            });
        });
    </script>
</body>
</html>
