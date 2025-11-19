<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
                                <button class="filter-btn" value="전체">전체</button>
                                <button class="filter-btn" value="서울">서울</button>
                                <button class="filter-btn" value="인천">인천</button>
                                <button class="filter-btn" value="강원">강원</button>
                                <button class="filter-btn" value="대전/세종">대전/세종</button>
                                <button class="filter-btn" value="충남">충남</button>
                                <button class="filter-btn" value="충북">충북</button>
                                <button class="filter-btn" value="대구">대구</button>
                                <button class="filter-btn" value="경북">경북</button>
                                <button class="filter-btn" value="부산">부산</button>
                                <button class="filter-btn" value="울산">울산</button>
                                <button class="filter-btn" value="경남">경남</button>
                                <button class="filter-btn" value="광주">광주</button>
                                <button class="filter-btn" value="전남">전남</button>
                                <button class="filter-btn" value="전북">전북</button>
                                <button class="filter-btn" value="제주">제주</button>
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
                            <label for="matchingDay">매칭 일자</label>
                            <input type="date" name="matchingDate" id="matchingDay" placeholder="매칭 제목을 입력해주세요.">
                            <span class="errMsg"></span>
                        </div>
                        <div class="form-group">
                            <label for="matchingTime">매칭 시간</label>
                            <input type="time" name="matchingTime" id="matchingTime" placeholder="매칭 제목을 입력해주세요.">
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
                            <button class="filter-btn" value="전체">전체</button>
                            <button class="filter-btn" value="서울">서울</button>
                            <button class="filter-btn" value="인천">인천</button>
                            <button class="filter-btn" value="강원">강원</button>
                            <button class="filter-btn" value="대전/세종">대전/세종</button>
                            <button class="filter-btn" value="충남">충남</button>
                            <button class="filter-btn" value="충북">충북</button>
                            <button class="filter-btn" value="대구">대구</button>
                            <button class="filter-btn" value="경북">경북</button>
                            <button class="filter-btn" value="부산">부산</button>
                            <button class="filter-btn" value="울산">울산</button>
                            <button class="filter-btn" value="경남">경남</button>
                            <button class="filter-btn" value="광주">광주</button>
                            <button class="filter-btn" value="전남">전남</button>
                            <button class="filter-btn" value="전북">전북</button>
                            <button class="filter-btn" value="제주">제주</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="partnerType">파트너 조건</label>
                        <textarea name="partnerType" id="partnerType" placeholder="매칭 파트너의 조건 입력해주세요."></textarea>
                        <span class="errMsg"></span>
                    </div>
 
                    <div class="form-group" id="form-user">
                        <i class="fa-solid fa-users"></i>
                        <label for="userCount">매칭 인원 수</label>
                        <input type="number" name="partnerType" id="userCount" min="0">
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
    <script>
        /* ============================== */
        /*       지역 선택 드롭다운       */
        /* ============================== */
        const locationHeader = document.querySelector("#locationHeader");
        const locationSpan = document.querySelector("#locationHeader span");
        const locationFilterBox = locationHeader.nextElementSibling;
 
        locationHeader.addEventListener("click", () => {
            locationFilterBox.classList.toggle("hidden");
            locationHeader.classList.toggle("active");
        });

        let locationBtn = ""; // 지역 저장 변수

        document.querySelectorAll("#location-filter-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                locationBtn = btn.value;
                locationSpan.innerText = btn.innerText;
                locationFilterBox.classList.add("hidden");
                locationHeader.classList.remove("active");
            });
        });

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

        /* ============================== */
        /*          카테고리 검색         */
        /* ============================== */   
        document.querySelector("#categoryKeyword").addEventListener("keydown", (e) => {
        const keyword = document.querySelector("#categoryKeyword").value.trim();
            if(e.key == "Enter") {
                e.preventDefault();
                console.log(keyword)
                category(keyword);
                keyword.value = "";
            }
        });

        function category(keyword="") {
            // const url;
            // const 
            if(categoryKeyword) {
                
            }
            fetch("/matching", {
                method: 'get',
                headers: {'Content-Type' : 'application/json'},
                body: JSon.stringify()
            })
            .then(res => res.json())
            .then(result => {
                const category = document.querySelector(".matching-category-list")
                category.innerHTML = "";

                result.forEach((cList) => {
                    category.innerHTML += `
                        <button class="filter-btn" value="\${cList.ACTIVITY_NAVE}">\${cList.ACTIVITY_NAVE}</button>
                    `;
                })
            })
            .catch(error => console.log(error));
        }



        /* ============================== */
        /*        매칭 게시글 삽입       */
        /* ============================== */
        function saveFun() {
            const level = document.querySelector("input[name='matchingLevel']:checked").value;
    
            const matchingData = {
                boardTitle : document.querySelector("#matchingTitle").value,
                boardContent : document.querySelector("#matchingContent").value,
                matchingLevel : level,
                matchingDate : document.querySelector("#matchingDay").value,
                matchingTime : document.querySelector("#matchingTime").value,
                matchingLocation : locationBtn,
                partnerType : document.querySelector("#partnerType").value,
                matchingUserCount : document.querySelector("#userCount").value
            }
            
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
                            location.href="/matching"
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