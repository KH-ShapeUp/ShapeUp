<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../../resources/css/success/successMain.css">
</head>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
        <div class="main">
            <div class="board-wrapper">
                <div class="board-wrapper-left">
                	<div style="padding: 20px 0px">
	                    <p class="board-title">성공 후기 테이블</p>
	                    <span style="font-size:.8rem; color:#222;">총 게시물 : ${TotalCount}</span>
                	</div>
                    <div class="board-left-top">
                        <input type="hidden" id="currentCategory" value="${param.category}">
                        <div class="search-wrapper">
                            <div class="filter">
                                <button class="filter-btn-wrapper">
                                    <span>필터</span>
                                    <span class="material-symbols-outlined">keyboard_arrow_down</span>
                                </button>
                                <div class="filter-btn-list">
                                    <button onclick="movePage(1, '')" class="filter-btn">전체</button>				    	
                                    <button onclick="movePage(1, '다이어트')" class="filter-btn">다이어트</button>
                                    <button onclick="movePage(1, '체중감량')" class="filter-btn">체중감량</button>
                                    <button onclick="movePage(1, '체지방감량')" class="filter-btn">체지방감량</button>
                                    <button onclick="movePage(1, '골격근증가')" class="filter-btn">골격근증가</button>
                                </div>
                            </div>
                            <div class="search">
                                <span class="material-symbols-outlined">search</span>
                                <input type="text" name="keyword" id="keyword" value="${param.keyword}" placeholder="제목으로 검색해주세요..">
                            </div>
                            <div>
                                <a href="javascript:void(0)" id="communityHref" onclick="communityAddBtn();">
                                    <input type="hidden" id="sessionLogin" value="${userNo}">
                                    <i class="fa-solid fa-plus"></i>
                                    <span>성공 후기 등록</span>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="board-left-bottom">
                        <div class="board-left-content">
                            <c:choose>
                                <c:when test="${not empty sList}">
                                    <c:forEach var="sList" items="${sList }">	                  
                                        <a href="/community/detail?boardNo= ${sList.communityNo}">
                                            <div class="board-left-card">
                                                <div class="left-card-top">
                                                    <c:choose>
                                                        <c:when test="${not empty sList.thumbnail }">
                                                            <img src="${sList.thumbnail }">		                                        	                               
                                                        </c:when>
                                                        <c:otherwise>                                                   
                                                            <img src="../../../resources/img/no-img.png" id="noImg">
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="goal-category">${sList.successType }</span>
                                                </div>
                                                <div class="left-card-middle">
                                                    <div class="left-card-middle-top">
                                                        <div class="user-img">
                                                            <img src="../../../resources/img/person.png">
                                                        </div>
                                                        <div class="user-info">
                                                            <div class="user-info-top">
                                                                <span class="left-user-nickname">${sList.userNickName }</span>
                                                                <div class="left-view">
                                                                    <i class="fa-regular fa-eye"></i>
                                                                    <span>${sList.viewCount }</span>
                                                                </div>
                                                            </div>
                                                            <span class="create-date">${sList.timeAgo }</span>
                                                        </div>
                                                    </div>
                                                    <div class="left-card-middle-content">
                                                        <span class="left-board-title">${sList.communityTitle }</span>
                                                        <div class="left-board-content">
                                                            <div class="content-top">
                                                                <i class="fa-regular fa-clock"></i><span>소요기간: ${sList.goalDate }</span>
                                                            </div>
                                                            <span class="board-content">${sList.communityContent }</span>
                                                        </div>
                                                    </div>
                                                    <div class="left-card-footer">
                                                        <div class="viewCount"><i class="fa-regular fa-comment"></i><span>${sList.commentCount }</span></div>
                                                        <div class="like"><i class="fa-regular fa-thumbs-up"></i><span>${sList.likeCount }</span></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </a>                                                               
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
                                        onclick="location.href='/success?boardNo=${startNavi - 1}'">
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
                                        onclick="location.href='/success?boardNo=${endNavi + 1}'">
                                    <span>이전</span>
                                    <i class="fa-solid fa-arrow-right"></i>
                                </button>  
                            </c:if>
                        </nav>
                    </div>
                </div>
                <div class="board-wrapper-right">
                    <div class="board-right-top">
                        <p>인기 게시물</p>
                        <div class="board-right-top-content">
                            <c:forEach var="psList" items="${psList }" varStatus="status">
                                <a href="/community/detail?boardNo=${psList.communityNo }">
                                    <div class="board-right-top-card">
                                        <div class="right-top-top">
                                            <div class="right-user-right">
                                                <c:choose>
                                                    <c:when test="${status.count == 1 }">
                                                        <img src="../../../resources/img/ranking-1.png">													
                                                    </c:when>                                        
                                                    <c:when test="${status.count == 2 }">
                                                        <img src="../../../resources/img/ranking-2.png">
                                                    </c:when>
                                                    <c:when test="${status.count == 3 }">
                                                        <img src="../../../resources/img/ranking-3.png">
                                                    </c:when>
                                                </c:choose>
                                                <span class="right-category">${psList.successType }</span>
                                                <span class="right-user-nickname">${psList.userNickName }</span>
                                            </div>
                                            <span class="create-date">${psList.timeAgo}</span>
                                        </div>
                                        <div class="right-top-middle">                                        
                                            <span class="right-title">${psList.communityTitle }</span><span class="top-comment">(${psList.commentCount })</span>
                                        </div>
                                        <div class="right-top-footer">
                                            <div class="viewCount"><i class="fa-regular fa-eye"></i><span>${psList.viewCount }</span></spam></div>
                                            <div class="like"><i class="fa-regular fa-thumbs-up"></i><span>${psList.likeCount }</span></div>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="board-right-bottom">
                        <p>댓글 순</p>
                        <div class="board-right-bottom-content">
                        	<c:forEach var="cmsList" items="${cmsList }">
	                            <a href="/community/detail?boardNo=${cmsList.communityNo }">
	                                <div class="board-right-bottom-card">
	                                    <div class="right-bottom-top">
	                                        <div class="right-user">
	                                            <span class="right-category">${cmsList.successType }</span>
	                                            <span class="right-user-nickname">${cmsList.userNickName }</span>
	                                        </div>
	                                        <span class="create-date">${cmsList.timeAgo }</span>
	                                    </div>
	                                    <div class="right-bottom-middle">                                        
	                                        <span class="right-title">${cmsList.communityTitle }</span><span class="top-comment">(${cmsList.commentCount })</span>
	                                    </div>
	                                    <div class="right-bottom-footer">
	                                        <div class="viewCount"><i class="fa-regular fa-eye"></i><span>${cmsList.viewCount }</span></div>
	                                        <div class="like"><i class="fa-regular fa-thumbs-up"></i><span>${cmsList.likeCount }</span></div>
	                                    </div>
	                                </div>
	                            </a>                 	
                        	</c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    <script>
        function communityAddBtn() {
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
                location.href='/success/insert';
            }
        }

        const filterBtn = document.querySelector(".filter-btn-wrapper");
        const filterList = document.querySelector(".filter-btn-list");
        
        filterBtn.addEventListener("click", (e) => {
            e.stopPropagation();
            filterBtn.classList.toggle("active");
            filterList.classList.toggle("active");
        });

        // 외부 클릭 시 닫기
        document.addEventListener("click", () => {
            filterBtn.classList.remove("active");
            filterList.classList.remove("active");
        });

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


        function movePage(boardNo, category) {
            if (!boardNo || boardNo === 'undefined') boardNo = 1;

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
            let url = "/success";
            url += "?boardNo=" + boardNo;

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