<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 세션에서 로그인 정보 가져오기 (한 번만 선언)
    String loginUserNickname = (String) session.getAttribute("userNickname");
    boolean isLogin = loginUserNickname != null;
%>

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
        <% if(isLogin) { %>
            <!-- 로그인 상태 -->
            <span class="user-nickname"><%= loginUserNickname %>님</span>

            <a href="/logout" id="singnBtn" class="btn logout-btn">로그아웃</a>
        <% } else { %>
            <!-- 비로그인 상태 -->
            <a href="/user/login" id="loginBtn" class="btn login-btn">로그인</a>
            <a href="/user/signupAgreement" id="singnBtn" class="btn signup-btn">회원가입</a>

        <% } %>
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

        <div class="userInfo">
            <div class="profile-img">
                <img src="../../../resources/img/person.png">
            </div>
            <div class="profile-info">
                <% if(isLogin) { %>
                    <span class="name"><%= loginUserNickname %>님</span>
                <% } else { %>
                    <span class="name">게스트</span>
                <% } %>
            </div>
        </div>

        <% if(!isLogin) { %>
            <div class="notLogin-warning-view">
                <span class="material-symbols-outlined">lock_person</span>
                <a href="/login" id="notLogin-warning">로그인을 해주세요</a>
            </div>
        <% } %>

        <hr style="border: 0.3px solid #f1f1f1;">

        <div class="sideBar-List">
            <!-- 메뉴 리스트 동일 -->
        </div>

        <% if(isLogin) { %>
            <hr style="border: 0.3px solid #f1f1f1;">
            <div class="list-item" id="logOut-item">
                <button type="button" onclick="location.href='/logout'">
                    <span class="material-symbols-outlined">logout</span>
                    <span>로그아웃</span>
                </button>
            </div>
        <% } %>
    </div>
</div>

<script>
    const menuBtn = document.querySelector("#menu-icon");
    const menuSideBar = document.querySelector(".mobile-sideBar");
    const closeBtn = document.querySelector(".close-btn");
    const body = document.querySelector("body");

    menuBtn.addEventListener('click', () => {
        menuSideBar.classList.toggle('open');
        body.style.overflow = "hidden";
    });

    closeBtn.addEventListener('click', () => {
        menuSideBar.classList.remove('open');
        body.style.overflow = "auto";
    });
</script>
