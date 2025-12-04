<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../../resources/css/matching/trainerMatchingBoard.css">
</head>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
            <div class="main">
                <div class="matching-board-wrapper">
                    <div class="matching-title-top">
                        <p class="title">트레이닝 모집</p>
                    </div>
                    <div class="search-wrapper">
                        <form action="#" method="get">
                            <input type="hidden" name="location" id="location-value">

                            <div class="location-filter">
                                <span class="material-symbols-outlined">location_on</span>

                                <button type="button" id="location-drop">
                                    <span class="loctiond-btn">전체</span>
                                    <i class="fa-solid fa-angle-down"></i>
                                </button>

                                <div class="filter-btn-wrapper hidden" id="location-filter">
                                    <button class="filter-btn location-filter-btn" value="">전체</button>
                                    <button class="filter-btn location-filter-btn" value="서울">서울</button>
                                    <button class="filter-btn location-filter-btn" value="인천">인천</button>
                                    <button class="filter-btn location-filter-btn" value="강원">강원</button>
                                    <button class="filter-btn location-filter-btn" value="대전/세종">대전/세종</button>
                                    <button class="filter-btn location-filter-btn" value="충남">충남</button>
                                    <button class="filter-btn location-filter-btn" value="충북">충북</button>
                                    <button class="filter-btn location-filter-btn" value="대구">대구</button>
                                    <button class="filter-btn location-filter-btn" value="경북">경북</button>
                                    <button class="filter-btn location-filter-btn" value="부산">부산</button>
                                    <button class="filter-btn location-filter-btn" value="울산">울산</button>
                                    <button class="filter-btn location-filter-btn" value="경남">경남</button>
                                    <button class="filter-btn location-filter-btn" value="광주">광주</button>
                                    <button class="filter-btn location-filter-btn" value="전남">전남</button>
                                    <button class="filter-btn location-filter-btn" value="전북">전북</button>
                                    <button class="filter-btn location-filter-btn" value="제주">제주</button>
                                </div>
                            </div>
                            <div class="search">
                                <span class="material-symbols-outlined">search</span>
                                <input type="text" name="keyword" id="keyword" placeholder="카테고리, 제목으로 검색해주세요..">
                            </div>
                        </form>
                        <div class="matching-add-wrapper">
                            <a href="javascript:void(0)" onclick="matchingAddBtn();">
                                <input type="hidden" id="sessionLogin" value="${userNo}">
                                <i class="fa-solid fa-plus"></i>
                                <span>매칭 등록</span>
                            </a>
                        </div>
                    </div>
                    <div class="matching-board">
                        <div class="matching-content">
                            <div class="matching-card">
                                <div class="matching-card-top">
                                    <div class="card-top-left">
                                        <img src="../../../resources/img/person.png">
                                    </div>
                                    <div class="card-top-right">
                                        <div>
                                            <span class="userName">윤태혁</span>
                                            <span class="price">60,000원/회</span>
                                        </div>
                                        <span class="createDay">4시간전</span>
                                    </div>                                    
                                </div>
                                <div class="matching-review">
                                    <img src="../../../resources/img/star.png">
                                    <span class="reviewAvg">4.5</span>
                                    <span class="reviewCount">(20)</span>
                                </div>
                                <div class="category-wrapper">
                                    <span class="category"># 다이어트</span>
                                </div>
                                <div class="matching-middle">
                                    <span class="matching-title">세미 pt 인원 모집합니다!</span>
                                    <span class="matching-content">체계적인 근력 운동과 식단 관리로 건강한 체형을 만들어드립니다.</span>
                                </div>
                                <div class="matching-footer">
                                    <div class="location">
                                        <span class="material-symbols-outlined">location_on</span>
	                                    <span class="location-txt">서울 강남구</span>
                                    </div>
                                    <div class="time">
                                        <span class="material-symbols-outlined">schedule</span>
                                        <span class="time-txt">평일 오전/오후</span>
                                    </div>
                                    <div class="badge">
                                        <span class="material-symbols-outlined">editor_choice</span>
                                        <span class="badge-txt">5년</span>
                                    </div>                        
                                    <div class="user">
                                        <span class="material-symbols-outlined">groups</span>
                                        <span class="userCount">0/10명</span>
                                    </div>
                                </div>                            
                                <div class="btn-row">
                                    <button type="button" class="apply-btn">신청하기</button>
                                </div>
                            </div>            
                        </div>
                    </div>
                </div>
            </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    <script>
        const headerBtn = document.getElementById("location-drop");
        const dropdown = document.getElementById("location-filter");
        const hiddenInput = document.getElementById("location-value");
        const headerText = document.querySelector(".location-btn-text");

        // 드롭다운 열기/닫기
        headerBtn.addEventListener("click", () => {
            dropdown.classList.toggle("hidden");
        });

        // 지역 버튼 클릭 시 값 반영
        document.querySelectorAll(".location-filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                const value = btn.value;
                hiddenInput.value = value;
                headerText.textContent = value === "" ? "전체" : value;
                dropdown.classList.add("hidden");
            });
        });

        document.addEventListener("click", (e) => {
            if (!headerBtn.contains(e.target) && !dropdown.contains(e.target)) {
                dropdown.classList.add("hidden");
            }
        });

        function matchingAddBtn() {
            const userNo = document.querySelector("#sessionLogin").value;
            console.log(userNo);

            if(!userNo || userNo === "") {
                Swal.fire({
                    icon:'warning',
                    title: '로그인이 필요한 서비스입니다.',
                    text: '로그인 후 이용해주세요.',
                    confirmButtonText: '로그인 하러가기',
                    customClass: {
                        popup: 'error-popup',
                        title: 'error-title',
                        text: 'error-text',
                        confirmButton: 'error-button'
                    }, 
                    didClose: () => {
                        location.href="/user/login";
                    }
                });   
            } else {
                location.href='/trainer/matching/insert';
            }
        }
    </script>
</body>
</html>