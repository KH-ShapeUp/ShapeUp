<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insert title here</title>
    <jsp:include page="/WEB-INF/views/include/head.jsp"/> 
    <link rel="stylesheet" href="../../../resources/css/login.css">
</head>
<body>
    <div class="container">
        <div class="main">
            <div class="login-gif">
                <!--<video src="../../resources/img/workout.mp4" autoplay muted loop playsinline></video>-->
                <div class="video-overlay"></div>
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
                ></iframe>
            </div>
            <div class="login-form-wrapper">
                <div class="login-form-top">
                    <a href="/"><img src="../../resources/img/main_logo.png"></a>
                </div>
                <div class="login-form">
                    <form action="#" method="get" style="width: 100%;">
                        <div class="form-group">
                            <label for="userId">아이디
                                <input type="text" name="userId" id="userId">
                            </label>
                        </div>
                        <div class="form-group">
                            <label for="userPw">비밀번호
                                <input type="password" name="userPw" id="userPw">
                                <i class="fa-solid fa-eye" style="display: none;"></i>
                                <i class="fa-solid fa-eye-slash"></i>
                            </label>
                        </div>
                        <div class="auto-login">
                            <input type="checkbox" id="auto-login">
                            <label for="auto-login">자동 로그인</label>
                        </div>
                        <button type="submit" id="login-btn">로그인</button>
                    </form>
                    <div class="account-list">
                        <ul>
                            <li><a href="#">회원가입</a></li>
                            <li>&#8739;</li>
                            <li><a href="#">아이디 찾기</a></li>
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

        // 두 아이콘 모두 클릭 시 같은 로직 실행되게 설정
        [visiblePw, hiddenPw].forEach(icon => {
            icon.addEventListener("click", () => {
                if (userPw.type === "password") {
                    userPw.type = "text";
                    visiblePw.style.display = "inline";
                    hiddenPw.style.display = "none";
                } else {
                    userPw.type = "password";
                    visiblePw.style.display = "none";
                    hiddenPw.style.display = "inline";
                }
            });
        });
    </script>
</body>
</html>