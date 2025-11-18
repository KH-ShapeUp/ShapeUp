<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
</head>
<body>
	<div class="header">
        <div class="logo">
            <a href="/"><img src="../../../resources/img/main_logo.png" alt="" width="110px"></a>
        </div>
        <div class="menu">
            <ul class="main-menu">
                <li><a href="/">홈</a></li>
                
                <li class="has-submenu">
                    <a>매칭 찾기</a>
                    <ul class="sub-menu">
                        <li><a href="/matching">일반 매칭</a></li>
                        <li><a href="#">트레이너 매칭</a></li>
                    </ul>
                </li>

                <li><a href="/map">시설 지도</a></li>

                <li class="has-submenu">
                    <a>커뮤니티</a>
                    <ul class="sub-menu">
                        <li><a href="#">자유게시판</a></li>
                        <li><a href="#">성공 인증 게시판</a></li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="searchInput">
            <input type="text" placeholder="검색할 매칭의 카테고리를 입력해주세요..">
            <span class="material-symbols-outlined">search</span>
        </div>
        <div class="sideBtn">
            <a href="/login" id="loginBtn">로그인</a>
            <a href="/user/signupAgreement" id="singnBtn"">회원가입</a>
        </div>
        <span class="material-symbols-outlined" id="menu-icon">menu</span>
    </div>
    <div class="mobile-searchInput">
        <input type="text" placeholder="검색할 매칭의 카테고리를 입력해주세요..">
        <span class="material-symbols-outlined">search</span>
    </div>
    <div class="mobile-sideBar">
        <div class="sideBar-wrapper">
            <button class="close-btn">
                <span class="material-symbols-outlined">close</span>
            </button>
            <div class="userInfo" >
                <div class="profile-img">
                    <img src="../../../resources/img/person.png">
                </div>
                <div class="profile-info">
                    <span class="name">윤태혁</span>
                    <span class="email">yth010801@naver.com</span>
                </div>
            </div>
            <!-- 로그인 안했을 때-->
            <div class="notLogin-warning-view" style="display: none;">
                <span class="material-symbols-outlined">lock_person</span>
                <a href="#" id="notLogin-warning">로그인을 해주세요</a>
            </div>
            <!-- 로그인 안했을 때 끝 -->
            <hr style="border: 0.3px solid #f1f1f1;">
            <div class="sideBar-List">
                <div class="list-item">
                    <a href="/">
                        <span class="material-symbols-outlined">home</span>
                        <span>홈</span>
                    </a>
                </div>
                <div class="list-item">
                    <a href="/matching"> 
                        <span class="material-symbols-outlined">group_search</span>
                        <span>일반 매칭</span>
                    </a>
                </div>
                <div class="list-item">
                    <a href="#">
                        <span class="material-symbols-outlined">person_search</span>
                        <span>트레이너 매칭</span>
                    </a>
                </div>
                <div class="list-item">
                    <a href="#"> 
                        <span class="material-symbols-outlined">forum</span>
                        <span>커뮤니티</span>
                    </a>
                </div>
                <div class="list-item">
                    <a href="#">
                        <span class="material-symbols-outlined">rewarded_ads</span>
                        <span>성공 인증 게시판</span>
                    </a>
                </div>
                <div class="list-item">
                    <a href="/map">
                        <span class="material-symbols-outlined">map_search</span>
                        <span>시설 지도</span>
                    </a>
                </div>
                <div class="list-item">
                    <a href="#">
                        <span class="material-symbols-outlined">settings_account_box</span>
                        <span>설정</span>
                    </a>
                </div>
            </div>
            <hr style="border: 0.3px solid #f1f1f1;">
            <div class="list-item" id="logOut-item">
                <button type="button" onclick="location.href='home'">
                    <span class="material-symbols-outlined">logout</span>
                    <span>로그아웃</span>
                </button>
            </div>
        </div>
    </div>
    <script>
        const menuBtn = document.querySelector("#menu-icon");
        const menuSideBar = document.querySelector(".mobile-sideBar");
        const closeBtn = document.querySelector(".close-btn");
        const body = document.querySelector("body")

        menuBtn.addEventListener('click', () => {
            menuSideBar.classList.toggle('open');
            body.style.overflow = "hidden";
        });

        closeBtn.addEventListener('click', () => {
            menuSideBar.classList.remove('open'); // 'open' 클래스 제거
            body.style.overflow = "auto";
        });

    </script>
</body>
</html>