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
                        <div class="search-wrapper">
                            <div class="filter">
                                <button class="filter-btn-wrapper">
                                    <span>필터</span>
                                    <span class="material-symbols-outlined">keyboard_arrow_down</span>
                                </button>
                                <div class="filter-btn-list">							    	
                                    <button onclick="userListFun(1, 'active')" class="filter-btn">운동 질문</button>
                                    <button onclick="userListFun(1, 'inactive')" class="filter-btn">운동 꿑팁</button>
                                    <button onclick="userListFun(1, 'man')" class="filter-btn">식단 / 영양</button>
                                    <button onclick="userListFun(1, 'girl')" class="filter-btn">운동 인증</button>
                                </div>
                            </div>
                            <div class="search">
                                <span class="material-symbols-outlined">search</span>
                                <input type="text" name="keyword" id="keyword" placeholder="내용, 제목으로 검색해주세요..">
                            </div>
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
	                                        <span class="post-comment">(10)</span>
	                                    </div>
	                                </div>
	                            </a>                         
                            </c:forEach>
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
						                onclick="location.href='/community?boardNo=${n}'">
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
                                <div class="board-comment-card">
                                    <div class="post-header">
                                        <div class="post-header-left">
                                            <span class="post-category">자유 게시판</span>
                                            <span class="post-nickName">윤태혁</span>
                                            <span class="post-writeDate">2025.01.25</span>
                                        </div>
                                        <div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span class="post-view">1,203</span></div>
										</div>
                                    </div>
                                    <div class="post-middle">
                                        <span class="post-title">등운동시 광배에 자극이 없어요..</span>
                                        <span class="post-comment">(10)</span>
                                    </div>
                                </div>
                                <div class="board-comment-card">
                                    <div class="post-header">
                                        <div class="post-header-left">
                                            <span class="post-category">자유 게시판</span>
                                            <span class="post-nickName">윤태혁</span>
                                            <span class="post-writeDate">2025.01.25</span>
                                        </div>
                                        <div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span class="post-view">1,203</span></div>
										</div>
                                    </div>
                                    <div class="post-middle">
                                        <span class="post-title">등운동시 광배에 자극이 없어요..</span>
                                        <span class="post-comment">(10)</span>
                                    </div>
                                </div>
                                <div class="board-comment-card">
                                    <div class="post-header">
                                        <div class="post-header-left">
                                            <span class="post-category">자유 게시판</span>
                                            <span class="post-nickName">윤태혁</span>
                                            <span class="post-writeDate">2025.01.25</span>
                                        </div>
                                        <div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span class="post-view">1,203</span></div>
										</div>
                                    </div>
                                    <div class="post-middle">
                                        <span class="post-title">등운동시 광배에 자극이 없어요..</span>
                                        <span class="post-comment">(10)</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="board-wrapper-view">
                        <div class="board-view-top">
                            <span class="board-view-title">조회순</span>
                            <div class="board-view-content">
                                <div class="board-view-card">
                                    <div class="post-header">
                                        <div class="post-header-left">
                                            <span class="post-category">자유 게시판</span>
                                            <span class="post-nickName">윤태혁</span>
                                            <span class="post-writeDate">2025.01.25</span>
                                        </div>
                                        <div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span class="post-view">1,203</span></div>
										</div>
                                    </div>
                                    <div class="post-middle">
                                        <span class="post-title">등운동시 광배에 자극이 없어요..</span>
                                        <span class="post-comment">(10)</span>
                                    </div>
                                </div>
                                <div class="board-view-card">
                                    <div class="post-header">
                                        <div class="post-header-left">
                                            <span class="post-category">자유 게시판</span>
                                            <span class="post-nickName">윤태혁</span>
                                            <span class="post-writeDate">2025.01.25</span>
                                        </div>
                                        <div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span class="post-view">1,203</span></div>
										</div>
                                    </div>
                                    <div class="post-middle">
                                        <span class="post-title">등운동시 광배에 자극이 없어요..</span>
                                        <span class="post-comment">(10)</span>
                                    </div>
                                </div>
                                <div class="board-view-card">
                                    <div class="post-header">
                                        <div class="post-header-left">
                                            <span class="post-category">자유 게시판</span>
                                            <span class="post-nickName">윤태혁</span>
                                            <span class="post-writeDate">2025.01.25</span>
                                        </div>
                                        <div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span class="post-view">1,203</span></div>
										</div>
                                    </div>
                                    <div class="post-middle">
                                        <span class="post-title">등운동시 광배에 자극이 없어요..</span>
                                        <span class="post-comment">(10)</span>
                                    </div>
                                </div>
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
    </script>
</body>
</html>