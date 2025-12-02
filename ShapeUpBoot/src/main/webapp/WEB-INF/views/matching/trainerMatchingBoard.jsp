<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
</head>
<style>
    .location-filter {
    position: relative;
    display: inline-block;
}

.dropdown-header {
    background: #fff;
    border: 1px solid #ccc;
    padding: 7px 12px;
    border-radius: 6px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 6px;
}

.filter-btn-wrapper {
    position: absolute;
    top: 40px;
    left: 0;
    background: #fff;
    border: 1px solid #ccc;
    border-radius: 6px;
    padding: 10px;
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    width: 200px;
    z-index: 100;
}

.filter-btn-wrapper.hidden {
    display: none;
}

.filter-btn {
    padding: 6px 10px;
    border: 1px solid #ddd;
    border-radius: 6px;
    background: #f8f8f8;
    cursor: pointer;
}

.filter-btn:hover {
    background: #eee;
}

.search-submit {
    margin-left: 10px;
}

</style>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
            <div class="main">
                <div class="matching-board-wrapper">
                    <div class="matching-title-top">
                        <p>트레이닝 모집</p>
                    </div>
                    <div class="search-wrapper">
                        <form action="#" method="get">
                            <input type="hidden" name="location" id="location-value">

                            <div class="location-filter">
                                <span class="label" id="matching-label">지역</span>

                                <button type="button" id="drop-header">
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

                            <span class="material-symbols-outlined">search</span>
                            <input type="text" name="keyword" id="keyword" placeholder="제목이나 키워드로 검색해주세요..">
                        </form>
                    </div>
                </div>
            </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    <script>
        const headerBtn = document.getElementById("drop-header");
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

                // 숨겨진 input에 반영
                hiddenInput.value = value;

                // 드롭다운 헤더 텍스트 변경
                headerText.textContent = value === "" ? "전체" : value;

                // 선택 후 드롭다운 닫기
                dropdown.classList.add("hidden");
            });
        });

        // 드롭다운 외부 클릭 시 닫기
        document.addEventListener("click", (e) => {
            if (!headerBtn.contains(e.target) && !dropdown.contains(e.target)) {
                dropdown.classList.add("hidden");
            }
        });

    </script>
</body>
</html>