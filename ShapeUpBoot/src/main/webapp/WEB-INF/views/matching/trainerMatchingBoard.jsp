<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri ="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                        <div class="form">
                            <input type="hidden" name="location" id="location-value">

                            <div class="location-filter">
                                <span class="material-symbols-outlined">location_on</span>
                                <input type="hidden" id="currentCategory" value="${param.category}">
                                <button type="button" id="location-drop">
                                    <span class="location-btn">전체</span>
                                    <i class="fa-solid fa-angle-down"></i>
                                </button>

                                <div class="filter-btn-wrapper hidden" id="location-filter">
                                    <button onclick="movePage(1, '')" class="filter-btn location-filter-btn">전체</button>
                                    <button onclick="movePage(1, '서울')" class="filter-btn location-filter-btn">서울</button>
                                    <button onclick="movePage(1, '인천')" class="filter-btn location-filter-btn">인천</button>
                                    <button onclick="movePage(1, '강원')" class="filter-btn location-filter-btn">강원</button>
                                    <button onclick="movePage(1, '대전')" class="filter-btn location-filter-btn">대전</button>
                                    <button onclick="movePage(1, '세종')" class="filter-btn location-filter-btn">세종</button>
                                    <button onclick="movePage(1, '충남')" class="filter-btn location-filter-btn">충남</button>
                                    <button onclick="movePage(1, '충북')" class="filter-btn location-filter-btn">충북</button>
                                    <button onclick="movePage(1, '대구')" class="filter-btn location-filter-btn">대구</button>
                                    <button onclick="movePage(1, '경북')" class="filter-btn location-filter-btn">경북</button>
                                    <button onclick="movePage(1, '부산')" class="filter-btn location-filter-btn">부산</button>
                                    <button onclick="movePage(1, '울산')" class="filter-btn location-filter-btn">울산</button>
                                    <button onclick="movePage(1, '경남')" class="filter-btn location-filter-btn">경남</button>
                                    <button onclick="movePage(1, '광주')" class="filter-btn location-filter-btn">광주</button>
                                    <button onclick="movePage(1, '전남')" class="filter-btn location-filter-btn">전남</button>
                                    <button onclick="movePage(1, '전북')" class="filter-btn location-filter-btn">전북</button>
                                    <button onclick="movePage(1, '제주')" class="filter-btn location-filter-btn">제주</button>
                                </div>
                            </div>
                            <div class="search">
                                <span class="material-symbols-outlined">search</span>
                                <input type="text" name="keyword" id="keyword" value="${param.keyword}" placeholder="카테고리, 제목으로 검색해주세요..">
                            </div>
                        </div>
                        <div class="matching-add-wrapper">
                            <a href="javascript:void(0)" onclick="matchingAddBtn();">
                                <input type="hidden" id="sessionLogin" value="${userNo}">
                                <i class="fa-solid fa-plus"></i>
                                <span>매칭 등록</span>
                            </a>
                        </div>
                    </div>
                    <div class="matching-board">
                        <div class="matching-content-wrapper">
                            <c:choose>
                                <c:when test="${not empty mList}">
                                    <c:forEach var="mList" items="${mList }">                
                                        <div class="matching-card">
                                            <div class="matching-card-top">
                                                <div class="card-top-left">
                                                    <c:choose>
                                                        <c:when test="${not empty mList.userProfileImg}">
                                                            <img src="${mList.userProfileImg}" width="50" alt="프로필">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="../../../resources/img/default-profile.png" width="50" alt="기본 프로필">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="card-top-right">
                                                    <div>
                                                        <span class="userName">${mList.userName }</span>
                                                        <span class="price">${mList.matchingPrice}원/회</span>
                                                    </div>
                                                    <span class="createDay">${mList.timeAgo }</span>
                                                </div>                                    
                                            </div>
                                            <div class="matching-review">
                                                <img src="../../../resources/img/star.png">
                                                <span class="reviewAvg">4.5</span>
                                                <span class="reviewCount">(20)</span>
                                            </div>
                                            <div class="category-wrapper">
                                                <span class="category"># ${mList.partnerType }</span>
                                            </div>
                                            <div class="matching-middle">
                                                <span class="matching-title">${mList.matchingTitle }</span>
                                                <span class="matching-content">${mList.matchingContent }</span>
                                            </div>
                                            <div class="matching-footer">
                                                <div class="status">
                                                    <c:choose>
                                                        <c:when test="${mList.matchingStatus == '모집중'}">
                                                            <span class="status-txt">${mList.matchingStatus }</span>
                                                        </c:when>
                                                        <c:when test="${mList.matchingStatus == '마감임박'}">
                                                            <span class="status-txt-imminent">${mList.matchingStatus }</span>
                                                        </c:when>
                                                        <c:when test="${mList.matchingStatus == '마감'}">
                                                            <span class="status-txt-finish">${mList.matchingStatus }</span>
                                                        </c:when>
                                                    </c:choose>	                                
                                                </div>
                                                <div class="location">
                                                    <span class="material-symbols-outlined">location_on</span>
                                                    <span class="location-txt">${mList.matchingLocation }</span>
                                                </div>
                                                <div class="location">
                                                    <span class="material-symbols-outlined">phone_enabled</span>
                                                    <span class="location-txt">${mList.userPhone}</span>
                                                </div>
                                                <div class="time">
                                                    <span class="material-symbols-outlined">schedule</span>
                                                    <span class="time-txt">${mList.matchingTime }</span>
                                                </div>
                                                <div class="badge">
                                                    <span class="material-symbols-outlined">editor_choice</span>
                                                    <span class="badge-txt">${mList.career }</span>
                                                </div>
                                                <div class="user">
                                                    <span class="material-symbols-outlined">groups</span>
                                                    <span class="userCount">${mList.applyCount}/${mList.matchingUserCount }</span>
                                                </div>
                                            </div>                         
                                            <a href="/trainer/matching/detail?boardNo=${mList.matchingNo }" class="detail-btn">상세보기</a>
                                        </div>            
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>              
                                    <div style="width:100%; height: 10vh; display:flex; align-items:center; justify-content:center; flex-direction: column; gap:10px">
                                        <span class="material-symbols-outlined" style="font-size:50px; color:#aaa; font-weight: 500;">error</span>
                                        <p style="margin-top:10px; font-size:1rem; font-weight: 500; color:#aaa;">작성한 댓글이 없습니다.</p>    
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="pagination-wrapper">
                        <nav class="pagination">                           	
                            <c:if test="${startNavi ne 1 }">                                                
                                <button class="back" 
                                        onclick="location.href='/trainer/matching/board?pageNo=${startNavi - 1}'">
                                    <i class="fa-solid fa-arrow-left"></i>
                                    <span>이전</span>
                                </button>
                            </c:if>
                            
                            <c:forEach begin="${startNavi }" end="${endNavi }" var="n">
                                <button 
                                    class="page-num ${currentPage eq n ? 'active' : ''}"
                                    onclick="movePage('${n}')">
                                    ${n}
                                </button>
                            </c:forEach>
                            
                            <c:if test="${endNavi ne maxPage }">
                                <button class="next" 
                                        onclick="location.href='/trainer/matching/board?pageNo=${endNavi + 1}'">
                                    <span>이전</span>
                                    <i class="fa-solid fa-arrow-right"></i>
                                </button>  
                            </c:if>
                        </nav>
                    </div>
                </div>
            </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <script>
        const headerBtn = document.getElementById("location-drop");
        const dropdown = document.getElementById("location-filter");
        const hiddenInput = document.getElementById("location-value");
        const headerText = document.querySelector(".location-btn");

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
            const userType = "${userType}"
            
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
            } else if (userType === "USER") {
                Swal.fire({
                    icon:'warning',
                    title: '트레이너만 등록 가능합니다.',
                    text: '회원은 매칭 신청만 가능합니다..',
                    confirmButtonText: '확인',
                    customClass: {
                        popup: 'error-popup',
                        title: 'error-title',
                        text: 'error-text',
                        confirmButton: 'error-button'
                    }, 
                    didClose: () => {
                        location.reload();
                    }
                }); 
            } else {
                location.href='/trainer/matching/insert';
            }
        }
        
        const SearchKeyword = document.querySelector("#keyword");

        if (SearchKeyword) {
            SearchKeyword.addEventListener("keydown", function(e) {
                // 한글 조합 중이거나, Shift+Enter(줄바꿈)인 경우는 제외
                if (e.isComposing || (e.key === "Enter" && e.shiftKey)) {
                    return; 
                }

                if (e.key === "Enter") {
                    e.preventDefault(); // 기본 줄바꿈 동작 막기
                    movePage(1); 
                }
            });
        }

        function movePage(pageNo, category) {
            if (!pageNo || pageNo === 'undefined') pageNo = 1;

            // input 엘리먼트를 가져와야 함(value X)
            const keywordInput = document.querySelector("#keyword");

            // 검색어 가져오기
            let keyword = "";
            if (keywordInput && keywordInput.value != null) {
                keyword = keywordInput.value;
            }

            // "전체" 클릭한 경우 keyword 초기화
            if (category === "") {
                keyword = "";
                if (keywordInput) keywordInput.value = "";
            }

            // 카테고리 읽기
            let currentCategory = document.getElementById("currentCategory").value;

            // category 인자가 있을 때만 카테고리 변경
            if (category !== undefined) {
                currentCategory = category;
            }

            // URL 구성
            let url = "/trainer/matching/board";
            url += "?pageNo=" + pageNo;

            if (keyword !== "") {
                url += "&keyword=" + encodeURIComponent(keyword);
            }

            if (currentCategory !== "") {
                url += "&category=" + encodeURIComponent(currentCategory);
            }

            // 이동
            location.href = url;
        }

    </script>
</body>
</html>