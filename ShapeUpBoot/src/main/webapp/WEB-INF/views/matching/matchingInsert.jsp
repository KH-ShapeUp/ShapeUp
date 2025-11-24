<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../resources/css/matching/matchingInsert.css">
</head>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
        <div class="main">
            <div class="matching-title">
                <span>매칭 등록</span>
            </div>
            <div class="matching-wrapper">
                <div class="matching-wrapper-left">
                    <div class="form-group">
                        <label for="matchingTitle">매칭 제목</label>
                        <input type="text" name="boardTitle" id="matchingTitle" placeholder="매칭 제목을 입력해주세요.">
                        <span class="errMsg"></span>
                    </div>

                    <div class="form-group" id="matching-category">
                        <span class="label">매칭 카테고리</span>

                        <button class="dropdown-header" id="CategoryHeader">
                            <span>전체</span>
                            <i class="fa-solid fa-angle-down"></i>
                        </button>
                        
                        <div class="matching-btn-wrapper hidden" id="matching-filter">
                            <div class="categroy-search">
                                <span class="material-symbols-outlined">search</span>
                                <input type="text" name="categoryKeyword" id="categoryKeyword" placeholder="매칭할 카테고리를 선택해주세요..">
                            </div>
                            <div class="matching-category-list">
                            <c:forEach var="aList" items="${aList}">
                            	<input type="hidden" name="activityId" id="activityId" value="${aList.activityId }">
                                <button class="filter-btn" value="${aList.activityName}">${aList.activityName}</button>                      
                            </c:forEach>
                            </div>
                        </div>
                        
                    </div>

                    <div class="matching-level-wrapper">
                        <p class="form-title">매칭 난이도</p>
                        <div class="level-wrapper">

                            <label for="matchingLevel_1">
                                <span>초급</span>
                                <input type="radio" name="matchingLevel" id="matchingLevel_1" value="1" checked>
                            </label>
                                            
                            <label for="matchingLevel_2">
                                <span>중급</span>
                                <input type="radio" name="matchingLevel" id="matchingLevel_2" value="2">
                            </label>              
                        
                            <label for="matchingLevel_3">
                                <span>고급</span>
                                <input type="radio" name="matchingLevel" id="matchingLevel_3" value="3">
                            </label>           
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="matchingContent">매칭 내용</label>
                        <textarea name="boardContent" id="matchingContent" placeholder="매칭 내용을 입력해주세요."></textarea>
                        <span class="errMsg"></span>
                    </div>

                </div>
                <div class="matching-wrapper-right">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="datePicker">매칭 일자</label>
                            <input type="date" name="matchingDate" id="matchingDay" placeholder="매칭 날짜를 선택해주세요.">
                            <span class="errMsg"></span>
                        </div>
                        <div class="form-group">
                            <label for="timePicker">매칭 시간</label>
                            <input type="time" name="matchingTime" id="matchingTime" placeholder="매칭 시간을 선택해주세요.">
                            <span class="errMsg"></span>
                        </div>
                    </div>

                    <div class="form-group" id="form-location">                                                              
                        <span class="label" id="matching-label">매칭 지역</span>

                        <button class="dropdown-header" id="locationHeader">
                            <span>전체</span>
                            <i class="fa-solid fa-angle-down"></i>
                        </button>
                        
                        <div class="filter-btn-wrapper hidden" id="location-filter">
                            <button class="location-filter-btn" value="전체">전체</button>
                            <button class="location-filter-btn" value="서울">서울</button>
                            <button class="location-filter-btn" value="인천">인천</button>
                            <button class="location-filter-btn" value="강원">강원</button>
                            <button class="location-filter-btn" value="대전/세종">대전/세종</button>
                            <button class="location-filter-btn" value="충남">충남</button>
                            <button class="location-filter-btn" value="충북">충북</button>
                            <button class="location-filter-btn" value="대구">대구</button>
                            <button class="location-filter-btn" value="경북">경북</button>
                            <button class="location-filter-btn" value="부산">부산</button>
                            <button class="location-filter-btn" value="울산">울산</button>
                            <button class="location-filter-btn" value="경남">경남</button>
                            <button class="location-filter-btn" value="광주">광주</button>
                            <button class="location-filter-btn" value="전남">전남</button>
                            <button class="location-filter-btn" value="전북">전북</button>
                            <button class="location-filter-btn" value="제주">제주</button>
                        </div>
                    </div>

                    <div class="form-group" id="form-price">
                        <i class="fa-solid fa-wallet"></i>
                        <label for="matchingPrice">매칭 가격</label>
                        <input type="text" name="matchingPrice" id="matchingPrice" min="0" max="1000000">
                        <span class="errMsg"></span>
                    </div>

                    <div class="form-group">
                        <label for="partnerType">파트너 조건</label>
                        <textarea name="partnerType" id="partnerType" placeholder="매칭 파트너의 조건 입력해주세요."></textarea>
                        <span class="errMsg"></span>
                    </div>
 
                    <div class="form-group" id="form-user">
                        <i class="fa-solid fa-users"></i>
                        <label for="userCount">매칭 인원 수</label>
                        <input type="number" name="userCount" id="userCount" min="0">
                        <span class="errMsg"></span>
                    </div>
                </div>
            </div>
            <div class="btn-row">
                <button id="save-btn" onclick="saveFun();">등록</button>
                <button id="cancel-btn">취소</button>
            </div>
        </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" type="text/css" href="https://npmcdn.com/flatpickr/dist/themes/material_blue.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>
    <script>
        /* ============================== */
        /*       지역 선택 드롭다운       */
        /* ============================== */
        const locationHeader = document.querySelector("#locationHeader");
        const locationSpan = document.querySelector("#locationHeader span");
        const locationFilterBox = locationHeader.nextElementSibling;

        /* 헤더 클릭 시 토글 */
        locationHeader.addEventListener("click", () => {
            locationFilterBox.classList.toggle("hidden");
            locationHeader.classList.toggle("active");
        });

        let locationBtn = ""; // 지역 저장 변수

        /* 리스트 아이템 클릭 시 선택 및 닫기 */
        document.querySelectorAll(".location-filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                locationBtn = btn.value;
                locationSpan.innerText = btn.innerText;
                locationFilterBox.classList.add("hidden");
                locationHeader.classList.remove("active");
            });
        });

         /* 매칭 지역 리스트 버튼 클릭시 드롭다운 닫기 */
        document.querySelectorAll(".location-filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                locationFilterBox.classList.add("hidden");
                locationHeader.classList.remove("active");
            })
        })

        /* ============================== */
        /*     매칭 카테고리 드롭다운     */
        /* ============================== */
        const categoryHeader = document.querySelector("#CategoryHeader");
        const categorySpan = document.querySelector("#CategoryHeader span");
        const categoryFilterBox = categoryHeader.nextElementSibling;
 
        categoryHeader.addEventListener("click", () => {
            categoryFilterBox.classList.toggle("hidden");
            categoryHeader.classList.toggle("active");
        });

        let categoryBtn = ""; // 카테고리 저장 변수

        document.querySelectorAll("#matching-btn-wrapper").forEach(btn => {
            btn.addEventListener("click", () => {
                categoryBtn = btn.value;
                categorySpan.innerText = btn.innerText;
                categoryFilterBox.classList.add("hidden");
                categoryHeader.classList.remove("active");
            });
        });
        /* 매칭 카테고리 리스트 버튼 클릭시 드롭다운 닫기 */
        document.querySelectorAll(".matching-category-list .filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                categoryFilterBox.classList.add("hidden");
                categoryHeader.classList.remove("active");
            })
        })
        /* ============================== */
        /*     매칭 날짜, 시간 커스텀     */
        /* ============================== */
        flatpickr("#matchingDay", {
            locale: "ko",
            dateFormat: "Y-m-d",  // 데이터베이스 저장 형식 (2024-11-21)
            minDate: "today",     // 오늘 이전 날짜 선택 불가 (여행이니까!)
            disableMobile: "true" // 모바일에서도 커스텀 디자인 유지
        })

        flatpickr("#matchingTime", {
            enableTime: true,     // 시간 기능 켜기
            noCalendar: true,     // 달력은 끄기
            dateFormat: "H:i",    // 24시간 형식 (14:30)
            time_24hr: true,      // AM/PM 대신 24시간제 사용
            minuteIncrement: 10,  // 분 단위 10분씩 끊기 (옵션)
            disableMobile: "true"
        })

        /* ============================== */
        /*          카테고리 검색         */
        /* ============================== */   
        document.querySelector("#categoryKeyword").addEventListener("keydown", (e) => {
        const keyword = document.querySelector("#categoryKeyword").value.trim();
            if(e.key == "Enter") {
                e.preventDefault();
                console.log(keyword)
                searchCategory(keyword);
                keyword.value = "";
            }
        });

        function searchCategory(keyword) {
            console.log("키워드 : " + keyword);
            fetch("/matching/search?keyword=" + keyword, {
                method : "get",
                headers : {"Content-Type":"application/json"},
            })
            .then(res => res.json())
            .then(result => {
                const categoryList = document.querySelector(".matching-category-list")
                categoryList.innerHTML = "";

                if(result.length === 0) {
                    categoryList.innerHTML = "<p style='text-align : center; padding:20px; font-size:.9rem; font-weight:500; color:#666;'>해당 검색 결과가 없습니다.</p>";
                    return;
                }
       
                result.forEach(aList => {
                    categoryList.innerHTML += `
                        <button type="button" 
                            class="filter-btn"
                            data-id ="\${aList.activityId}" 
                            value="\${aList.activityName}">
                            \${aList.activityName}
                        </button>
                    `;
                })
            })
            .catch(err => console.log(err))
        }

        /* ============================== */
        /*         선택한 카테고리        */
        /* ============================== */
        let categorySelect = " ";
        document.querySelectorAll(".filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
               categorySelect = btn.value;
               const searchInput = document.querySelector("#CategoryHeader span");
                searchInput.innerText = categorySelect;
            })
        })

        
        /* ============================== */
        /*         매칭 게시글 삽입       */
        /* ============================== */
        function saveFun() {
            const inputs = [
                {el: document.querySelector("#matchingTitle"), msg : "매칭 제목을 입력해주세요."},
                {el: document.querySelector("#matchingContent"), msg : "매칭 내용을 입력해주세요."},
                {el: document.querySelector("#matchingDay"), msg : "매칭 날짜를 입력해주세요."},
                {el: document.querySelector("#matchingTime"), msg : "매칭 시간을 입력해주세요."},
                {el: document.querySelector("#matchingPrice"), msg : "매칭 가격을 입력해주세요."},
                {el: document.querySelector("#partnerType"), msg : "파트너 타입을 입력해주세요."},
                {el: document.querySelector("#userCount"), msg : "모집 인원 수를 입력해주세요."}
            ]

            document.querySelectorAll(".errMsg").forEach(span => {
                span.innerText = '';
            });

            for(let i = 0; i < inputs.length; i++) {
                const input  = inputs[i];
                const value = input.el.value.trim();
                const errSpan = document.querySelectorAll(".errMsg")[i];

                input.el.style.border = ''; 
                errSpan.innerText = '';

                if(value === '') {
                    const price = document.querySelector(".fa-wallet");
                    input.el.style.border = '1.5px solid #ff3b00';
                    errSpan.innerText = input.msg;
                    price.style.top = 43 + "%";
                    input.el.focus(); // 오류난 input에 포커스
                    return; 
                }
            }
    
            if(matchingTitle.value.trim() === '') {
                matchingTitle.style.border = '1.5px solid #ff3b00';
                errMsg.innerText = '매칭 제목을 입력해주세요.';
                return;
            }


            const level = document.querySelector("input[name='matchingLevel']:checked").value;
            const matchingData = {
                matchingTitle : document.querySelector("#matchingTitle").value,
                matchingContent : document.querySelector("#matchingContent").value,
                matchingLevel : level,
                matchingCategory : categorySelect,
                matchingPrice : document.querySelector("#matchingPrice").value,
                matchingDate : document.querySelector("#matchingDay").value,
                matchingTime : document.querySelector("#matchingTime").value,
                matchingLocation : locationBtn,
                activityId : document.querySelector("#activityId").value,
                partnerType : document.querySelector("#partnerType").value,
                matchingUserCount : document.querySelector("#userCount").value,
            }

            console.log(matchingData)
        
            fetch("/matching", {
                method: 'post',
                headers:{"Content-Type" : "application/json"},
                body: JSON.stringify(matchingData)
            })
            .then(res => res.json())
            .then(result => {
                if(result > 0) {
                    // document.body.style.pointerEvents = "none";
                    // const Toast = Swal.mixin({
                    //     toast: true,
                    //     position: 'center-center',
                    //     showConfirmButton: false,
                    //     timer: 25000,
                    //     timerProgressBar: true,
                    //     didClose: () => {
                    //         location.href="/matching"
                    //     }
                    // });

                    // Toast.fire({
                    //     icon: 'success',
                    //     title: '게시글 작성 완료'
                    // });
                    Swal.fire({
                        icon:'success',
                        title: '매칭 준비 완료!',
                        text: '이제 매칭만 기다리면 돼요.',
                        confirmButtonText: '확인',
                        customClass: {
                            popup: 'success-popup',
                            title: 'success-title',
                            text: 'success-text',
                            confirmButton: 'success-button'
                        },
                        didClose: () => {
                            location.href="/matching/board?ts=" + new Date().getTime();
                        }
                    });                 
                } else {
                    Swal.fire({
                        icon:'error',
                        title: '매칭 등록 실패..ㅠ',
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
                    title: '매칭 등록 실패..ㅠ',
                    text: err,
                    confirmButtonText: '확인',
                    customClass: {
                        popup: 'error-popup',
                        title: 'error-title',
                        text: 'error-text',
                        confirmButton: 'error-button'
                    }
                });
            });
        };
    </script>
</body>
</html>