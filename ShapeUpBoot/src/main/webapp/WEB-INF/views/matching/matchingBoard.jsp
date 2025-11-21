<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../resources/css/matching/matchingBoard.css">
</head>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
        <div class="main">
            <div class="matching-main-wrapper">
                <!-- 매칭 전체 필터 -->
                <div class="filter-wrapper">
                    <p>필터</p>
                    <!-- 지역 필터 -->
                    <div class="filter" id="matching-filter">
                        <span class="label" id="matching-label">지역</span>

                        <button class="dropdown-header" id="locationHeader">
                            <span>전체</span>
                            <i class="fa-solid fa-angle-down"></i>
                        </button>
                        
                        <div class="filter-btn-wrapper hidden" id="location-filter">
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">전체</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">서울</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">인천</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">강원</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">대전/세종</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">충남</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">충북</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">대구</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">경북</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">부산</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">울산</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">경남</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">광주</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">전남</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">전북</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn">제주</button>
                        </div>
                    </div>


                    <!-- 시간대 필터 -->
                    <div class="filter" id="time-filter-wrapper">
                        <span class="label" id="time-label">시간대</span>

                        <button class="dropdown-header" id="timeHeader">
                            <span>전체</span>
                            <i class="fa-solid fa-angle-down"></i>
                        </button>

                        <div class="filter-btn-wrapper hidden" id="time-filter">
                            <button class="filter-btn time-filter-btn" id="time-filter-btn">전체</button>
                            <button class="filter-btn time-filter-btn" id="time-filter-btn">오전</button>
                            <button class="filter-btn time-filter-btn" id="time-filter-btn">오후</button>
                            <button class="filter-btn time-filter-btn" id="time-filter-btn">저녁</button>
                        </div>
                    </div>

                    <!-- 난이도 필터 -->
                    <div class="filter" id="level-filter-wrapper">
                        <span class="label" id="level-label">난이도</span>

                        <button class="dropdown-header" id="levelHeader">
                            <span>전체</span>
                            <i class="fa-solid fa-angle-down"></i>
                        </button>

                        <div class="filter-btn-wrapper hidden" id="level-filter">
                            <button class="filter-btn level-filter-btn" id="level-filter-btn">전체</button>
                            <button class="filter-btn level-filter-btn" id="level-filter-btn">초급</button>
                            <button class="filter-btn level-filter-btn" id="level-filter-btn">중급</button>
                            <button class="filter-btn level-filter-btn" id="level-filter-btn">고급</button>
                        </div>
                    </div>
                </div>

                <!-- 매칭 게시판 -->
                <div class="matching-wrapper">
                    <div class="matching-wrapper-top">
                        <div class="matching-top-left">
                            <p>일반 매칭</p>
                        </div>
                        <div class="matching-top-right">
                            <!-- 게시판 순서 필터 -->
                            <div class="filter" id="matching-board-type">
                                
                                <button class="dropdown-header" id="boardHeader">
                                    <span>최신순</span>
                                    <i class="fa-solid fa-angle-down"></i>
                                </button>

                                <div class="filter-btn-wrapper hidden" id="matching-board-filter">
                                    <button class="filter-btn" id="board-filter-btn">최신순</button>
                                    <button class="filter-btn" id="board-filter-btn">마감임박순</button>
                                </div>
                            </div>                                   
                            <a href="/matching/insert" id="matching-add-btn">
                                <i class="fa-solid fa-plus"></i>
                                <span>매칭 등록</span>
                            </a>
                        </div>
                    </div>
                    <div class="matching-board-wrapper">
                        <div class="matching-content">
                        <!-- 매칭 리스트 -->         
                        </div>
                        <div class="matching-pagination-wrapper">
                            <nav class="pagination">
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    <script>
        // 매칭 신청 버튼
        /*document.querySelectorAll(".matching-application-btn").forEach(btn => {
            btn.addEventListener("click", (e) => {
                e.stopPropagation(); // 페이지 이동 막음
                if(confirm("해당 매칭을 신청하시겠습니까?")) {
                } else {
                    alert("매칭 신청을 취소하셨습니다.");
                    return;
                }
                location.href="/";
            })
        })
    
        
        document.addEventListener("DOMContentLoaded", () => {

            /* ---------------------- 지역 필터 ---------------------- */
            const locationHeader = document.querySelector("#locationHeader");
            const locationFilterBox = locationHeader.nextElementSibling;

            locationHeader.addEventListener("click", () => {
                locationFilterBox.classList.toggle("hidden");
                locationHeader.classList.toggle("active");
            });

            document.querySelectorAll(".location-filter-btn").forEach(btn => {
                btn.addEventListener("click", () => {
                    locationHeader.innerText = btn.innerText
                    locationFilterBox.classList.add("hidden");
                    locationHeader.classList.remove("active");
                });
            });


            /* ---------------------- 시간대 필터 ---------------------- */
            const timeHeader = document.querySelector("#timeHeader");
            const timeFilterBox = timeHeader.nextElementSibling;

            timeHeader.addEventListener("click", () => {
                timeFilterBox.classList.toggle("hidden");
                timeHeader.classList.toggle("active");
            });

            document.querySelectorAll(".time-filter-btn").forEach(btn => {
                btn.addEventListener("click", () => {
                    timeHeader.innerText = btn.innerText
                    timeFilterBox.classList.add("hidden");
                    timeHeader.classList.remove("active");
                });
            });


            /* ---------------------- 난이도 필터 ---------------------- */
            const levelHeader = document.querySelector("#levelHeader");
            const levelFilterBox = levelHeader.nextElementSibling;

            levelHeader.addEventListener("click", () => {
                levelFilterBox.classList.toggle("hidden");
                levelHeader.classList.toggle("active");
            });

            document.querySelectorAll(".level-filter-btn").forEach(btn => {
                btn.addEventListener("click", () => {
                    levelHeader.innerText = btn.innerText
                    levelFilterBox.classList.add("hidden");
                    levelHeader.classList.remove("active");
                });
            });


            /* ---------------------- 정렬 필터 ---------------------- */
            const boardHeader = document.querySelector("#boardHeader");
            const boardHeaderSpan = document.querySelector("#boardHeader span");
            const boardFilterBox = boardHeader.nextElementSibling;

            boardHeader.addEventListener("click", () => {
                boardFilterBox.classList.toggle("hidden");
                boardHeader.classList.toggle("active");
            });

            document.querySelectorAll(".board-filter-btn").forEach(btn => {
                btn.addEventListener("click", () => {
                    boardHeaderSpan.innerText = btn.innerText;
                    boardFilterBox.classList.add("hidden");
                    boardHeader.classList.remove("active");
                });
            });
        /* ============================== */
        /*       매칭 게시글 리스트       */
        /* ============================== */
        function matchinglist(currentPage = 1) {
            fetch("/matching/list?page=" + currentPage, {
                method: "get",
                headers: {"Content-Type":"application/json"}
            })
            .then(res => res.json())
            .then(result => {
                console.log(result);
                const matchingList = document.querySelector(".matching-content")
                matchingList.innerHTML = "";

                result.mList.forEach(match => {
                    // ★ [NEW] 상태별 CSS 클래스 정하기 로직
                    let badgeClass = '';
                    let statusText = match.matchingStatus;

                    if (match.matchingStatus === '모집중') {
                        badgeClass = 'ing';      // 초록색 (모집중)
                    } else if (match.matchingStatus === '마감임박') {
                        badgeClass = 'imminent';     // 빨간색 (마감임박)
                    } else {
                        badgeClass = 'finish';      // 회색 (마감)
                    }

                    matchingList.innerHTML += `
                        <div class="matching-card" onclick="location.href='/matching/detail?matchNo=\${match.matchingNo}">
                            <div class="matching-card-header">
                                <div class="card-img">
                                    <img src="../../resources/img/person.png">
                                </div>
                                <div class="card-user-wrapper">
                                    <div class="card-user-info">
                                        <span class="user-name">\${match.userNickName}</span>
                                        <span class="user-category">\${match.activityName}</span>
                                    </div>
                                    <div class="card-state-\${badgeClass}">\${statusText}</div>
                                </div>
                            </div>
                            <div class="mathcing-card-main">
                                <span class="card-title">\${match.matchingTitle}</span>
                                <span class="card-content">\${match.partnerType}</span>
                            </div>
                            <div class="matching-card-bottom">
                                <div class="matching-left">
                                    <div class="matching-location">
                                        <i class="fa-solid fa-location-dot"></i>
                                        <span>\${match.matchingLocation}</span>
                                    </div>
                                    <div class="matching-time">
                                        <i class="fa-solid fa-clock"></i>
                                        <span>\${match.matchingTime}</span>
                                    </div>
                                    <div class="matching-day">
                                        <i class="fa-solid fa-calendar-days"></i>
                                        <span>\${match.matchingDate}</span>
                                    </div>
                                    <div class="matching-money">
                                        <i class="fa-solid fa-wallet"></i>
                                        <span>\${match.matchingPrice}</span>
                                    </div>
                                    <div class="matching-user">
                                        <i class="fa-solid fa-users"></i>
                                        <span>\${match.matchingUserCount}</span>
                                    </div>
                                </div>
                                <div class="matching-right">
                                    <button class="matching-application-btn">신청하기</button>
                                </div>
                            </div>
                        </div>
                    `;
                });
                const pagination = document.querySelector(".pagination");
                if(pagination) {
                    pagination.innerHTML = "";
                    let page="";

                    if(result.startNavi > 1) {
                        page  += `<li><button class="back" onclick="matchinglist(\${result.startNavi - 1})">이전</button></li>`;
                    }

                    for(let i = result.startNavi; i <= result.endNavi; i++) {
                        if( i === result.currentPage) {
                            page += `<li><button class="page-num active" onclick="matchinglist(\${i})">\${i}</button></li>`;
                        } else {
                            page += `<li><button class="page-num" onclick="matchinglist(\${i})">\${i}</button></li>`;
                        }
                    }

                    if (result.endNavi < result.maxPage) {
                        page += `<li><button class="next" onclick="matchinglist(\${result.endNavi + 1})">다음</button></li>`;
                    }
                    pagination.innerHTML = page;
                }
            })
            .catch(err => console.log(err));
        }
        matchinglist(1);
    </script>
</body>
</html>