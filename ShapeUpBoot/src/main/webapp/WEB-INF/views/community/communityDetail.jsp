<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../../resources/css/community/communityDetail.css"/>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
</head>
<body>
	<div class="container">
	<jsp:include page="/WEB-INF/views/include/header.jsp"/>
		<div class="main">
			<div class="community-wrapper">
				<c:choose>
					<c:when test="${cList.communityType eq '운동질문' }">
						<div class="community-category-question">
							<span>${cList.communityType }</span>
						</div>
					</c:when>
					<c:when test="${cList.communityType eq '운동꿀팁' }">
						<div class="community-category-tip">
							<span>${cList.communityType }</span>
						</div>
					</c:when>
					<c:when test="${cList.communityType eq '식단/영양' }">
						<div class="community-category-food">
							<span>${cList.communityType }</span>
						</div>
					</c:when>
					<c:when test="${cList.communityType eq '운동인증' }">
						<div class="community-category-certification">
							<span>${cList.communityType }</span>
						</div>
					</c:when>
					<c:when test="${cList.communityType eq '일상/소통' }">				
						<div class="community-category">
							<span>${cList.communityType }</span>
						</div>
					</c:when>
				</c:choose>
				<div class="community-title">
					<span>${cList.communityTitle }</span>
				</div>
				<div class="community-writer">
					<div class="writer-left">
						<img src="../../../resources/img/person.png" width="50">
						<span class="nick-name">${cList.userNickName }</span>
					</div>
					<div class="writer-right">
						<span class="writer-date">${cList.timeAgo }<span class="community-view">조회수 ${cList.viewCount }</span></span>
					</div>
				</div>
				
				<div class="community-content">
					<!-- 엔터로 줄바꿈으로 하면 코드블럭으로 인식-->
				    <div id="hidden-content" style="display:none;"><c:out value="${cList.communityContent}" escapeXml="false" /></div>
				    <div id="viewer"></div>
				</div>
				
				<div class="community-other">
					<button class="community-like" onclick="boardLike('${cList.communityNo}');">
						<span class="material-symbols-outlined">thumb_up</span>
						<span class="like-count" style="margin-left: 10px;">${cList.likeCount }</span>
					</button>
					<button class="community-share">
						<span class="material-symbols-outlined">share</span>
					</button>
				</div>
				<c:if test="${userNo == cList.userNo}">
				    <div class="community-setting">
				        <a href="/community/modify?boardNo=${cList.communityNo}" class="community-modify">수정</a>
				        <button class="community-delete" onclick="deleteCommunity('${cList.communityNo}');">삭제</button>
				    </div>
				</c:if>
				<!-- 댓글 wrapper -->
				<div class="comment-wrapper">
					<p>댓글 10개</p>
					<div class="comment-form">
						<div class="form-top">
							<img src="../../../resources/img/person.png" width="50">
							<textarea name="comment" id="comment" placeholder="댓글을 입력해주세요.."></textarea>
						</div>
						<div class="form-bottom">
							<button class="comment-sumbit">등록</button>
						</div>
					</div>
					<!-- 댓글 목록 -->
					<div class="comment-list">
						<ul>
							<li class="comment-list-wrapper">
								<div class="comment-user-info">
									<img src="../../../resources/img/person.png" width="50">
								</div>
								<div class="comment-content-wrapper">
									<div class="comment-user">
										<span class="user-name">윤태혁</span><span class="comment-writer">22시간전</span>
									</div>
									<div class="comment-text">
										<span class="comment-content">안녕하세요..</span>
									</div>
									<div class="comment-footer">
										<span class="comment-like">좋아요 5</span>
										<span class="commnet-add">답글달기</span>
									</div>
									<div class="comment-add-input">
										<ul>
											<li>
												<div class="form-top">
													<img src="../../../resources/img/person.png" width="50">
													<textarea name="comment" id="comment" placeholder="댓글을 입력해주세요.."></textarea>
												</div>
												<div class="form-bottom">
													<button class="comment-sumbit">등록</button>
												</div>
											</li>
										</ul>
									</div>
								</div>
							</li>
						</ul>
						<ul>
							<li class="comment-list-wrapper">
								<div class="comment-user-info">
									<img src="../../../resources/img/person.png" width="50">
								</div>
								<div class="comment-content-wrapper">
									<div class="comment-user">
										<span class="user-name">윤태혁</span><span class="comment-writer">22시간전</span>
									</div>
									<div class="comment-text">
										<span class="comment-content">안녕하세요..</span>
									</div>
									<div class="comment-footer">
										<span class="comment-like">좋아요 5</span>
										<span class="commnet-add">답글달기</span>
									</div>
									<div class="comment-add-input">
										<ul>
											<li>
												<div class="form-top">
													<img src="../../../resources/img/person.png" width="50">
													<textarea name="comment" id="comment" placeholder="댓글을 입력해주세요.."></textarea>
												</div>
												<div class="form-bottom">
													<button class="comment-sumbit">등록</button>
												</div>
											</li>
										</ul>
									</div>
									<div class="comment-add-list">
										<div class="comment-add-left">
											<img src="../../../resources/img/person.png">
										</div>
										<div class="comment-add-right">
											<div class="comment-add-right-top">
												<span class="comment-add-name">윤태혁</span>
												<span class="comment-add-write">10시간 전</span>
											</div>
											<div class="comment-add-right-bottom">
												<span class="comment-add-content">안녕하세요.</span>
											</div>
										</div>
									</div>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	</div>
	<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
	<script>
		document.querySelectorAll(".commnet-add").forEach(btn => {
	        btn.addEventListener("click", function() {
	            const inputArea = this.closest(".comment-content-wrapper").querySelector(".comment-add-input");
	            
	            if(inputArea) {
	                inputArea.classList.toggle("active");
	                
	                if(inputArea.classList.contains("active")) {
	                    inputArea.querySelector("textarea").focus();
	                }
	            }
	        });
		});
		
        const Viewer = toastui.Editor;
        
        const content = document.querySelector('#hidden-content').innerHTML;

        const viewer = Viewer.factory({
            el: document.querySelector('#viewer'),
            viewer: true,
            initialValue: content,
            height: '500px'
        });

        function deleteCommunity(communityNo) {
			console.log(communityNo)
            Swal.fire({
				title: '해당 게시글을 삭제하시겠습니까?',
				showCancelButton: true,
				cancelButtonText: "취소하기",
				confirmButtonText: "삭제하기",
				customClass: {
					popup: 'success-popup',
					title: 'success-title',
					confirmButton: 'success-button',
					cancelButton: 'cancel-button'
				}
			}).then((result)=> {
				if(result.isConfirmed) {
					fetch('/community/delete?boardNo=' + communityNo, {
						method: 'delete',
						headers: {"Content-Type":"application/json"}
					})
					.then(res => res.json())
					.then(result => {
						if(result > 0) {
							Swal.fire({
								icon: 'success',
								title: '삭제 완료!',
								confirmButtonText: '확인',
								customClass: {
									popup: 'success-popup',
									title: 'success-title',
									confirmButton: 'success-button',
								}
							}).then(() => {
								location.href = "/community";
							});
						} else {
							Swal.fire({
								icon:'error',
								title: '삭제 실패..ㅠ',
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
                            title: '오류가 발생하였습니다.',
                            text: '다시 시도 해주세요.',
                            confirmButtonText: '확인',
                            customClass: {
                                popup: 'error-popup',
                                title: 'error-title',
                                text: 'error-text',
                                confirmButton: 'error-button'
                            }
                        });
					})
				}
			})
        }

		function boardLike(communityNo) {	
			fetch('/community/like', {
				method: 'post',
				headers: {"Content-Type":"application/json"},
				body: JSON.stringify({
					communityNo : communityNo
				})
			})
			.then(res => res.json())
			.then(result => {
					if(result.result === "success") {

					const likeSpan = document.querySelector(".like-count");
					likeSpan.innerText = result.likeCount;
					
					const likeBtn = document.querySelector(".community-like");
					if (result.status === "liked") {
						likeBtn.classList.add("active"); 
					} else {
						likeBtn.classList.remove("active");
					}
				} else {
					Swal.fire({
						icon:'error',
						title: '좋아요 실패..ㅠ',
						text: '로그인또는 오류가 발생하였습니다.',
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
					title: '좋아요 실패..ㅠ',
					text: '로그인또는 오류가 발생하였습니다.',
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
	</script>
</body>
</html>