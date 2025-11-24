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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
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
                    // 카테고리 날짜 기준 마감, 마감임박, 모집중
                    let badgeClass = '';
                    let btnClass = '';
                    let btnText = '신청 하기';
                    let btnDis = '';
                    let statusText = '';
                    let matchingLevel = match.matchingLevel;

                    // 매칭 난이도
                    let levelText = '';
                    let levelClass = '';

                    if (matchingLevel == 1) {
                        levelText = "# 초보";
                    } else if (matchingLevel == 2) {
                        levelText = "# 중급";
                        levelClass = "middleClass";
                    } else {
                        levelText = "# 고급";
                        levelClass = "advanced";
                    }

                    // 모집 인원 / 신청 인원 계산
                    const matchUserCount = match.matchingUserCount;
                    const applyCount = match.applicationCount;

                    // 날짜 기반 마감 체크
                    statusText = match.matchingStatus;

                    // 인원 기반으로 재판단 (최우선 조건)
                    if (applyCount >= matchUserCount) {
                        statusText = "마감";
                    }

                    // final 상태 확정 후 CSS 결정
                    if (statusText === '마감') {
                        badgeClass = 'finish';
                        btnClass = 'finish';
                        btnText = '마감';
                        btnDis = 'disabled';
                    } else if (statusText === '마감임박') {
                        badgeClass = 'imminent';
                    } else {
                        badgeClass = 'ing';
                    }

                    matchingList.innerHTML += `
                        <div class="matching-card" data-id="\${match.matchingNo}">
                            <div class="matching-card-header">
                                <div class="card-img">
                                    <img src="../../resources/img/person.png">
                                </div>
                                <div class="card-user-wrapper">
                                    <div class="card-user-info">
                                        <span class="user-name">\${match.userNickName}</span>
                                        <div class="category-wrapper">
                                            <span class="user-category">\${match.activityName}</span>
                                            <span class="user-level \${levelClass}">\${levelText}</span>
                                        </div>
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
                                        <span>\${match.applicationCount} / \${match.matchingUserCount}</span>
                                    </div>
                                </div>
                                <div class="matching-right">
                                    <button class="matching-application-btn \${btnClass}" \${btnDis} onclick="applicationMatch(\${match.matchingNo}, \${match.userNo})">\${btnText}</button>
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

        function applicationMatch(matchingNo, userNo) {
            console.log(matchingNo);
            console.log(userNo)
            Swal.fire({
                title: '해당 매칭을 신청하시겠습니까?',
                showCancelButton: true,
                cancelButtonText: "취소하기",
                confirmButtonText: "신청하기",
                customClass: {
                    popup: 'success-popup',
                    title: 'success-title',
                    confirmButton: 'success-button',
                    cancelButton: 'cancel-button'
                }
            }).then((result) => {
                if(result.isConfirmed) {
                    fetch('/matching/application', {
                        method: "post",
                        headers: {"Content-Type":"application/json"},
                        body: JSON.stringify({ 
                            matchingNo: matchingNo,
                            userNo: userNo
                        })
                    })
                    .then(res => res.json())
                    .then(result => {
                        console.log(result);
                        if(result > 0) {
                            Swal.fire({
                                icon: 'success',
                                title: '매칭 신청완료!',
                                text: '승인전까지 기다려주세요!',
                                confirmButtonText: '확인',
                                customClass: {
                                    popup: 'success-popup',
                                    title: 'success-title',
                                    confirmButton: 'success-button',
                                }
                            }).then(() => {
                                // 새로고침
                                location.reload();
                            });
                        } else if (result == -1) {
                            Swal.fire({
                                icon:'error',
                                title: '자기가 쓴 매칭을 \n 신청할 수 없습니다..ㅠ',
                                text: '다른 매칭을 신청해주세요.',
                                confirmButtonText: '확인',
                                customClass: {
                                    popup: 'error-popup',
                                    title: 'error-title',
                                    text: 'error-text',
                                    confirmButton: 'error-button'
                                }
                            });
                        } else if (result == -2) {
                            Swal.fire({
                                icon:'error',
                                title: '이미 신청한 매칭입니다.',
                                text: '다른 매칭을 신청해주세요.',
                                confirmButtonText: '확인',
                                customClass: {
                                    popup: 'error-popup',
                                    title: 'error-title',
                                    text: 'error-text',
                                    confirmButton: 'error-button'
                                }
                            });   
                        } else {
                            Swal.fire({
                                icon:'error',
                                title: '매칭 신청 실패..ㅠ',
                                text: '다시 시도 해주세요.',
                                confirmButtonText: '확인',
                                customClass: {
                                    popup: 'error-popup',
                                    title: 'error-title',
                                    text: 'error-text',
                                    confirmButton: 'error-button'
                                }
                            });
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        Swal.fire({
                            icon:'error',
                            title: '매칭 신청 실패..ㅠ',
                            text: '다시 시도 해주세요.',
                            confirmButtonText: '확인',
                            customClass: {
                                popup: 'error-popup',
                                title: 'error-title',
                                text: 'error-text',
                                confirmButton: 'error-button'
                            }
                        });
                    });
                }
            });
        }
    </script>
</body>
</html>