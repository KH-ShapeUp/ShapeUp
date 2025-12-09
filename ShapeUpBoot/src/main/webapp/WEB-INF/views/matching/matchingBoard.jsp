<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매칭게시판 | ShapeUp</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../resources/css/matching/matchingBoard.css">
<link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
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
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="">전체</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="서울">서울</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="인천">인천</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="강원">강원</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="대전/세종">대전/세종</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="충남">충남</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="충북">충북</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="대구">대구</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="경북">경북</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="부산">부산</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="울산">울산</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="경남">경남</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="광주">광주</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="전남">전남</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="전북">전북</button>
                            <button class="filter-btn location-filter-btn" id="location-filter-btn" value="제주">제주</button>
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
                            <button class="filter-btn time-filter-btn" id="time-filter-btn" value="">전체</button>
                            <button class="filter-btn time-filter-btn" id="time-filter-btn" value="오전">오전</button>
                            <button class="filter-btn time-filter-btn" id="time-filter-btn" value="오후">오후</button>
                            <button class="filter-btn time-filter-btn" id="time-filter-btn" value="저녁">저녁</button>
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
                            <button class="filter-btn level-filter-btn" id="level-filter-btn" value="1">초급</button>
                            <button class="filter-btn level-filter-btn" id="level-filter-btn" value="2">중급</button>
                            <button class="filter-btn level-filter-btn" id="level-filter-btn" value="3">고급</button>
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
                                    <button class="filter-btn board-filter-btn" id="board-filter-latest-btn" value="latest">최신순</button>
                                    <button class="filter-btn board-filter-btn" id="board-filter-deadline-btn" value="deadline">마감임박순</button>
                                </div>
                            </div>                        
                            <a href="javascript:void(0)" id="matching-add-btn" onclick="matchingAddBtn();">
                                <input type="hidden" id="sessionLogin" value="${userNo}">
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
        // ⭐ contextPath를 JavaScript 변수로 저장
        const contextPath = '${pageContext.request.contextPath}';
        
        /* ---------------------- 지역 필터 ---------------------- */
        const locationHeader = document.querySelector("#locationHeader");
        const locationHeaderSpan = document.querySelector("#locationHeader span");
        const locationFilterBox = locationHeader.nextElementSibling;
        let locationFilter  = '';

        locationHeader.addEventListener("click", () => {
            locationFilterBox.classList.toggle("hidden");
            locationHeader.classList.toggle("active");
        });

        document.querySelectorAll(".location-filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                locationHeaderSpan.innerText = btn.innerText;
                locationFilter = btn.value;
                matchinglist();
                locationFilterBox.classList.add("hidden");
                locationHeader.classList.remove("active");
            });
        });


        /* ---------------------- 시간대 필터 ---------------------- */
        const timeHeader = document.querySelector("#timeHeader");
        const timeHeaderSpan = document.querySelector("#timeHeader span");
        const timeFilterBox = timeHeader.nextElementSibling;
        let timeFilter = '';

        timeHeader.addEventListener("click", () => {
            timeFilterBox.classList.toggle("hidden");
            timeHeader.classList.toggle("active");
        });

        document.querySelectorAll(".time-filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                timeHeaderSpan.innerText = btn.innerText;
                timeFilter = btn.value;
                matchinglist();
                timeFilterBox.classList.add("hidden");
                timeHeader.classList.remove("active");
            });
        });


        /* ---------------------- 난이도 필터 ---------------------- */
        const levelHeader = document.querySelector("#levelHeader");
        const levelHeaderSpan = document.querySelector("#levelHeader span");
        const levelFilterBox = levelHeader.nextElementSibling;
        let levelFilter = '';

        levelHeader.addEventListener("click", () => {
            levelFilterBox.classList.toggle("hidden");
            levelHeader.classList.toggle("active");
        });

        document.querySelectorAll(".level-filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                levelHeaderSpan.innerText = btn.innerText;
                levelFilter = btn.value;
                matchinglist();
                levelFilterBox.classList.add("hidden");
                levelHeader.classList.remove("active");
            });
        });


        /* ---------------------- 정렬 필터 ---------------------- */
        const boardHeader = document.querySelector("#boardHeader");
        const boardHeaderSpan = document.querySelector("#boardHeader span");
        const boardFilterBox = boardHeader.nextElementSibling;
        let boardFilter = '';

        boardHeader.addEventListener("click", () => {
            boardFilterBox.classList.toggle("hidden");
            boardHeader.classList.toggle("active");
        });

        document.querySelectorAll(".board-filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                boardHeaderSpan.innerText = btn.innerText;
                boardFilter = btn.value;
                matchinglist();
                boardFilterBox.classList.add("hidden");
                boardHeader.classList.remove("active");
            });
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
            location.href='/matching/insert';
        }
    }
    /* ============================== */
    /*            매칭 필터           */
    /* ============================== */
    function getFilterValues() {
        return {
            location: locationFilter,
            time: timeFilter,
            level: levelFilter,
            sort: boardFilter
        };
    }
    
    /* ============================== */
    /*       매칭 게시글 리스트       */
    /* ============================== */
    function matchinglist(currentPage = 1) {
        const matchingFilterData = getFilterValues();
        console.log(matchingFilterData);

        const params = new URLSearchParams ({
            page: currentPage,
            ...matchingFilterData
        })
        const url = "/matching/list?" + params.toString();
        console.log(url);
        fetch(url, {
            method: "get",
            headers: {"Content-Type":"application/json"}
        })
        .then(res => res.json())
        .then(result => {
            console.log(result);
            const matchingList = document.querySelector(".matching-content")
            const pagination = document.querySelector(".pagination");
            matchingList.innerHTML = "";

            if(!result.mList || result.mList.length === 0) {
                pagination.innerHTML = "";
                matchingList.innerHTML = `
                    <div style="width:100%; height: 40vh; display:flex; align-items:center; justify-content:center; flex-direction: column; gap:10px">
                        <span class="material-symbols-outlined" style="font-size:60px; color:#aaa;">error</span>
                        <p style="margin-top:10px; font-size:16px; font-weight: 500; color:#aaa;">검색 결과가 없습니다.</p>    
                    </div>
                `;
                return;
            }

            result.mList.forEach(match => {
                // 1. 변수 초기화
                let badgeClass = '';
                let btnClass = '';
                let btnText = '신청 하기'; // 기본값
                let btnDis = '';
                
                // [핵심] 이제 DB에서 계산해서 온 값을 그대로 변수에 넣기만 하면 됩니다.
                let statusText = match.matchingStatus; 

                // 2. 매칭 난이도 UI 설정
                let levelText = '';
                let levelClass = '';
                if (match.matchingLevel == 1) {
                    levelText = "# 초보";
                } else if (match.matchingLevel == 2) {
                    levelText = "# 중급";
                    levelClass = "middleClass";
                } else {
                    levelText = "# 고급";
                    levelClass = "advanced";
                }

                // 3. 상태(마감, 임박, 모집중)에 따른 버튼/뱃지 디자인 결정
                // (이미 DB가 인원수 체크까지 끝내서 '마감'이라고 알려줌)
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


                const imgTag = match.userProfileImg
                    ? `<img src="\${match.userProfileImg}" width="50" alt="프로필">`
                    : `<img src="../../../resources/img/default-profile.png" width="50" alt="기본 프로필">`;



                matchingList.innerHTML += `
                    <div class="matching-card" data-id="\${match.matchingNo}">
                        <div class="matching-card-header">
                            <div class="card-img">
                               \${imgTag}
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
                                    <span>\${match.applicationCount}/\${match.matchingUserCount} 명</span>
                                </div>
                            </div>
                            <div class="matching-right">
                                <button class="matching-application-btn \${btnClass}" \${btnDis} onclick="applicationMatch(\${match.matchingNo}, \${match.userNo})">\${btnText}</button>
                            </div>
                        </div>
                    </div>
                `;
            });

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
                            icon:'warning',
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
                            icon:'warning',
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
                    } else if (result == -10) {
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