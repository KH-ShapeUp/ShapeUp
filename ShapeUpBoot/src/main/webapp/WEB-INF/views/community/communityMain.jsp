<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../../resources/css/community/communityMain.css">
</head>
<body>
	<div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
        <div class="main">
            <div class="board-wrapper">
                <div class="board-wrapper-left">
                    <p class="main-board-title">커뮤니티 게시판</p>
                    <div class="main-board-top">
                        <input type="hidden" id="currentCategory" value="${param.category}">
                        <div class="search-wrapper">
                            <div class="filter">
                                <button class="filter-btn-wrapper">
                                    <span>필터</span>
                                    <span class="material-symbols-outlined">keyboard_arrow_down</span>
                                </button>
                                <div class="filter-btn-list">
                                    <button onclick="movePage(1, '')" class="filter-btn">전체</button>				    	
                                    <button onclick="movePage(1, '운동질문')" class="filter-btn">운동 질문</button>
                                    <button onclick="movePage(1, '운동꿀팁')" class="filter-btn">운동 꿑팁</button>
                                    <button onclick="movePage(1, '식단/영양')" class="filter-btn">식단 / 영양</button>
                                    <button onclick="movePage(1, '운동인증')" class="filter-btn">운동 인증</button>
                                </div>
                            </div>
                            <div class="search">
                                <span class="material-symbols-outlined">search</span>
                                <input type="text" name="keyword" id="keyword" value="${param.keyword}" placeholder="내용, 제목으로 검색해주세요..">  
                                <span class="errMsg" style="display: none; position: absolute; top: 40px; left: 5px; font-size: .8rem; color:#ff3B00; font-weight: 500;">검색어를 입력해주세요.</span>                     
                            </div>
                            <button class="resetBtn" onclick="location.href='/community'">
                                <span class="material-symbols-outlined" title="검색 초기화">replay</span>
                            </button>
                        </div>
                        <div class="board-add-wrapper">
                            <a href="javascript:void(0)" id="communityHref" onclick="communityAddBtn();">
                                <input type="hidden" id="sessionLogin" value="${userNo}">
                                <i class="fa-solid fa-pen"></i>
                                <span>글 쓰기</span>
                            </a>
                        </div>
                    </div>
                    <div class="main-board-middle">
                        <div class="notice-wrapper">
	                        <c:forEach var="nList" items="${nList }">
	                            <a href="/notice/detail?noticeNo = ${nList.noticeNo }">
	                                <div class="notice-card">
	                                    <div class="notice-category-wrapper">
	                                        <span class="notice-category">공지사항</span>
	                                    </div>
	                                    <div class="notice-title-wrapper">
	                                        <span class="notice-title">${nList.noticeTitle }</span>
	                                    </div>
	                                </div>
	                            </a>
	                        </c:forEach>                       
                        </div>
                        <div class="post-content">
                        <c:choose>
                        	<c:when test="${empty cList }">
                                <div style="width:100%; height: 40vh; display:flex; align-items:center; justify-content:center; flex-direction: column; gap:10px">
                                    <span class="material-symbols-outlined" style="font-size:60px; color:#aaa;">error</span>
                                    <p style="margin-top:10px; font-size:16px; font-weight: 500; color:#aaa;">검색 결과가 없습니다.</p>    
                                </div>
                        	</c:when>
                        	<c:otherwise>
		                        <c:forEach var="cList" items="${cList }">
                                    <a href="/community/detail?boardNo=${cList.communityNo }">
                                        <div class="post-card">
                                            <div class="post-header">
                                                <div class="post-header-left">
                                                    <c:choose>
                                                        <c:when test="${cList.communityType eq '운동질문' }">
                                                            <span class="post-category-question">${cList.communityType }</span>
                                                        </c:when>
                                                        <c:when test="${cList.communityType eq '운동꿀팁' }">
                                                            <span class="post-category-tip">${cList.communityType }</span>
                                                        </c:when>
                                                        <c:when test="${cList.communityType eq '식단/영양' }">
                                                            <span class="post-category-food">${cList.communityType }</span>
                                                        </c:when>
                                                        <c:when test="${cList.communityType eq '운동인증' }">
                                                            <span class="post-category-certification">${cList.communityType }</span>
                                                        </c:when>
                                                        <c:when test="${cList.communityType eq '일상/소통' }">
                                                            <span class="post-category">${cList.communityType }</span>
                                                        </c:when>
                                                    </c:choose>
                                                    <span class="post-nickName">${cList.userNickName }</span>
                                                    <span class="post-writeDate">${cList.timeAgo }</span>
                                                </div>
                                                <div class="post-icon">
                                                    <div><i class="fa-solid fa-eye"></i><span>${cList.viewCount}</span></div>
                                                    <div><i class="fa-solid fa-thumbs-up"></i><span>${cList.likeCount }</span></div>
                                                </div>
                                            </div>
                                            <div class="post-middle">
                                                <span class="post-title">${cList.communityTitle }</span>
                                                <span class="post-comment">(${cList.commentCount})</span>
                                            </div>
                                        </div>
                                    </a>                         
		                        </c:forEach>
                        	</c:otherwise>
                        </c:choose>                            
                        </div>
                        <div class="pagination-wrapper">
                            <nav class="pagination">                           	
                            	<c:if test="${startNavi ne 1 }">                                                
	                                <button class="back" 
	                                		onclick="location.href='/community?boarNo=${startNavi - 1}'">
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
	                                		onclick="location.href='/community?boardNo=${endNavi + 1}'">
	                                    <span>이전</span>
	                                    <i class="fa-solid fa-arrow-right"></i>
	                                </button>  
								</c:if>
                            </nav>
                        </div>
                    </div>
                </div>
                <div class="board-wrapper-right">
                    <div class="board-wrapper-comment">
                        <div class="board-comment-top">
                            <span class="board-comment-title">댓글순</span>
                            <div class="board-comment-content">
                            	<c:forEach var="ctList" items="${ctList }">
                            		<a href="/community/detail?boardNo=${ctList.communityNo }">
		                                <div class="board-comment-card">
		                                    <div class="post-header">
		                                        <div class="post-header-left">
		                                            <c:choose>
		                                        		<c:when test="${ctList.communityType eq '운동질문' }">
		                                        			<span class="post-category-question">${ctList.communityType }</span>
		                                        		</c:when>
		                                        		<c:when test="${ctList.communityType eq '운동꿀팁' }">
		                                        			<span class="post-category-tip">${ctList.communityType }</span>
		                                        		</c:when>
		                                        		<c:when test="${ctList.communityType eq '식단/영양' }">
		                                        			<span class="post-category-food">${ctList.communityType }</span>
		                                        		</c:when>
		                                        		<c:when test="${ctList.communityType eq '운동인증' }">
		                                        			<span class="post-category-certification">${ctList.communityType }</span>
		                                        		</c:when>
		                                        		<c:when test="${ctList.communityType eq '일상/소통' }">
		                                        			<span class="post-category">${ctList.communityType }</span>
		                                        		</c:when>
		                                        	</c:choose>
		                                            <span class="post-nickName">${ctList.userNickName }</span>
		                                            <span class="post-writeDate">${ctList.timeAgo }</span>
		                                        </div>
		                                        <div class="post-icon">
													<div><i class="fa-solid fa-eye"></i><span class="post-view">${ctList.viewCount }</span></div>
												</div>
		                                    </div>
		                                    <div class="post-middle">
		                                        <span class="post-title">${ctList.communityTitle }</span>
		                                        <span class="post-comment">(${ctList.commentCount})</span>
		                                    </div>
		                                </div>
	                                </a>                                                   	
                            	</c:forEach>
                            </div>
                        </div>
                    </div>
                    <div class="board-wrapper-view">
                        <div class="board-view-top">
                            <span class="board-view-title">조회순</span>
                            <div class="board-view-content">
	                            <c:forEach var="vList" items="${vList }">
		                            <a href="/community/detail?boardNo=${vList.communityNo }">
		                                <div class="board-view-card">
		                                    <div class="post-header">
		                                        <div class="post-header-left">
			                                        <c:choose>
		                                        		<c:when test="${vList.communityType eq '운동질문' }">
		                                        			<span class="post-category-question">${vList.communityType }</span>
		                                        		</c:when>
		                                        		<c:when test="${vList.communityType eq '운동꿀팁' }">
		                                        			<span class="post-category-tip">${vList.communityType }</span>
		                                        		</c:when>
		                                        		<c:when test="${vList.communityType eq '식단/영양' }">
		                                        			<span class="post-category-food">${vList.communityType }</span>
		                                        		</c:when>
		                                        		<c:when test="${vList.communityType eq '운동인증' }">
		                                        			<span class="post-category-certification">${vList.communityType }</span>
		                                        		</c:when>
		                                        		<c:when test="${vList.communityType eq '일상/소통' }">
		                                        			<span class="post-category">${vList.communityType }</span>
		                                        		</c:when>
		                                        	</c:choose>
		                                            <span class="post-nickName">${vList.userNickName }</span>
		                                            <span class="post-writeDate">${vList.timeAgo }</span>
		                                        </div>
		                                        <div class="post-icon">
													<div><i class="fa-solid fa-eye"></i><span class="post-view">${vList.viewCount }</span></div>
												</div>
		                                    </div>
		                                    <div class="post-middle">
		                                        <span class="post-title">${vList.communityTitle }</span>
		                                        <span class="post-comment">(${vList.commentCount})</span>
		                                    </div>
		                                </div>
		                            </a>
	                            </c:forEach>                             
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <script>
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
                location.href='/community/insert';
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

        function movePage(boardNo, category) {
            if (!boardNo || boardNo === 'undefined') boardNo = 1;
            // 1. 검색어 가져오기
            const keyword = document.querySelector("#keyword").value;
            const errMsg = document.querySelector(".errMsg");
            const search = document.querySelector(".main-board-top");
            const searchErr = document.querySelector(".search input[type='text']");

            if(!keyword) {
                errMsg.style.display = 'flex';
                search.style.marginBottom = 5 + "px";
                errMsg.innerText = '검색어를 입력해주세요';
                searchErr.style.border = '1.5px solid #ff3b00';
                keyword.focus();
                return;
            }
            
            // 2. 카테고리(필터) 가져오기
            // 인자로 category가 넘어오면 그걸 쓰고, 아니면 기존에 저장된 값(hidden)을 씀
            const currentCategory = document.getElementById("currentCategory").value;
            if (category !== undefined && category !== null) {
                currentCategory = category;
            }

            // 3. URL 조립 (GET 방식 쿼리 스트링)
            // Controller에서 받는 파라미터 이름(cPage, keyword, category 등)에 맞춰주세요.
            const url = "/community";
            url += "?boardNo=" + boardNo; // 보통 페이지 번호는 cPage, page 등을 쓰지만 작성자님 코드에 맞춰 boardNo 사용
            
            if (keyword !== "") {
                url += "&keyword=" + encodeURIComponent(keyword);
            }
            
            if (currentCategory !== "") {
                url += "&category=" + encodeURIComponent(currentCategory);
            }

            // 4. 페이지 이동
            location.href = url;
        }
    </script>
</body>
</html>