<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티 | ShapeUp</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../../resources/css/community/communityDetail.css"/>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
</head>
<body>
	<div class="container">
	<jsp:include page="/WEB-INF/views/include/header.jsp"/>
		<div class="main">
			<div class="community-wrapper">
				<div class="community-wrapper-top">
					<c:choose>
						<c:when test="${cList.communityType eq '운동질문'}">
							<div class="community-category-question">
								<span>${cList.communityType}</span>
							</div>
						</c:when>
						<c:when test="${cList.communityType eq '운동꿀팁'}">
							<div class="community-category-tip">
								<span>${cList.communityType}</span>
							</div>
						</c:when>
						<c:when test="${cList.communityType eq '식단/영양'}">
							<div class="community-category-food">
								<span>${cList.communityType}</span>
							</div>
						</c:when>
						<c:when test="${cList.communityType eq '운동인증'}">
							<div class="community-category-certification">
								<span>${cList.communityType}</span>
							</div>
						</c:when>
						<c:when test="${cList.communityType eq '일상/소통'}">				
							<div class="community-category">
								<span>${cList.communityType}</span>
							</div>
						</c:when>
						<c:when test="${cList.successType eq '다이어트'}">
							<div class="community-category">
								<span>${cList.successType}</span>
							</div>
						</c:when>
						<c:when test="${cList.successType eq '체중감량'}">
							<div class="community-category">
								<span>${cList.successType}</span>
							</div>
						</c:when>
						<c:when test="${cList.successType eq '체지방감량'}">
							<div class="community-category">
								<span>${cList.successType}</span>
							</div>
						</c:when>
						<c:when test="${cList.successType eq '골격근증가'}">
							<div class="community-category">
								<span>${cList.successType}</span>
							</div>
						</c:when>					
					</c:choose>
					<div class="report" data-type="board">
						<span class="material-symbols-outlined more_vert">more_vert</span>
						
						<div class="report-button">
							<span class="material-symbols-outlined flag">flag</span>
							<span>신고하기</span>
						</div>
	
						<div class="report-list-wrapper">
							<div class="report-list">
								<span class="reportSecond">신고 유형 선택</span>
								<button class="report-btn" type="button">정치 발언</button>
								<button class="report-btn" type="button">성희롱/음담패설</button>
								<button class="report-btn" type="button">상업 광고</button>
								<button class="report-btn" type="button">욕설/비하</button>
								<button class="report-btn" type="button">유출/사기/사칭</button>
							</div>
						</div>
					</div>
				</div>
				<div class="community-title">
					<span>${cList.communityTitle}</span>					
				</div>
				<div class="community-writer">
					<div class="writer-left">
						<!-- ⭐ 게시글 작성자 프로필 이미지 -->
						<img src="${pageContext.request.contextPath}${not empty cList.userProfileImg ? cList.userProfileImg : '/resources/img/default-profile.png'}" 
						     width="50" 
						     alt="프로필 이미지"
						     onerror="this.src='${pageContext.request.contextPath}/resources/img/default-profile.png'">
						<span class="nick-name">${cList.userNickName}</span>						
					</div>
					<div class="writer-right">
						<span class="writer-date">${cList.timeAgo}<span class="community-view">조회수 ${cList.viewCount}</span></span>
					</div>
				</div>
				<c:if test="${cList.goalDate != null}">
					<div class="goaldate-wrapper">
						<i class="fa-regular fa-clock"></i><span class="goalDate">소요기간: ${cList.goalDate}</span>
					</div>
				</c:if>
				<div class="community-content">					
					<!-- 엔터로 줄바꿈으로 하면 코드블럭으로 인식-->
				    <div id="hidden-content" style="display:none;"><c:out value="${cList.communityContent}" escapeXml="false" /></div>
				    <div id="viewer"></div>
				</div>
				
				<div class="community-other">
					<button class="community-like" onclick="boardLike('${cList.communityNo}');">
						<span class="material-symbols-outlined">thumb_up</span>
						<span class="like-count" style="margin-left: 10px;">${cList.likeCount}</span>
					</button>
					<button class="community-share">
						<span class="material-symbols-outlined" onclick="clip(); return false;">share</span>
					</button>
				</div>
				<c:choose>
					<c:when test="${userNo == cList.userNo}">
						<div class="community-setting">
							<a href="/community/modify?boardNo=${cList.communityNo}" class="community-modify">수정</a>
							<button class="community-delete" onclick="deleteCommunity('${cList.communityNo}');">삭제</button>
						</div>
					</c:when>
					<c:when test="${userType == 'SYSTEM_MANAGER'}">
						<div class="community-setting">					
							<button class="community-delete" onclick="deleteCommunity('${cList.communityNo}');">삭제</button>
						</div>
					</c:when>				
				</c:choose>
				
				<!-- 댓글 wrapper -->
				<div class="comment-wrapper">
                    <p>댓글 0개</p>
                    <div class="comment-form">
	                    <c:choose>
	                    	<c:when test="${userNo != null}">
		                        <div class="form-top">
		                            <!-- ⭐ 댓글 작성자 프로필 이미지 - 로그인한 사용자 -->
		                            <img src="${pageContext.request.contextPath}${not empty userProfileImg ? userProfileImg : '/resources/img/default-profile.png'}" 
		                                 width="50" 
		                                 alt="프로필 이미지"
		                                 onerror="this.src='${pageContext.request.contextPath}/resources/img/default-profile.png'">
		                            <textarea name="comment" id="comment-content" placeholder="댓글을 입력해주세요.."></textarea>                            
		                        </div>
		                        <div class="form-bottom">
		                            <button class="comment-sumbit" type="button" onclick="commentAdd();">등록</button>
		                        </div>                  
	                    	</c:when>
	                    	<c:when test="${userNo == null}">
	                    		<div class="form-top">
		                            <img src="${pageContext.request.contextPath}/resources/img/default-profile.png" width="50" alt="기본 프로필">
		                            <textarea name="comment" id="comment-content" placeholder="로그인후 이용바랍니다." disabled></textarea>                            
		                        </div>
		                        <div class="form-bottom">
		                            <button class="comment-sumbit" type="button" onclick="commentAdd();" disabled>등록</button>
		                        </div>     
	                    	</c:when>
	                    </c:choose>
                    </div>

                    <div class="comment-list">
                        <ul></ul>
                    </div>
                </div>
			</div>
		</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	</div>
	<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
	<script>
		const communityUserNo = "${cList.userNo}";
		const communityNo = "${cList.communityNo}";
		const userNo = "${userNo}";
		const userType = "${userType}";
		const sessionUserProfileImg = "${userProfileImg}";
		const contextPath = "${pageContext.request.contextPath}"; // ⭐ contextPath 추가

		document.addEventListener("DOMContentLoaded", function() {
			getCommentList(); 
		});

		function clip(){
			let url = '';
			let textarea = document.createElement("textarea");
			
			document.body.appendChild(textarea);
			url = window.document.location.href;
			textarea.value = url;
			textarea.select();
			document.execCommand("copy");
			document.body.removeChild(textarea);
			
			alert("URL이 복사되었습니다.")
		}

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
				cancelButtonText: "취소",
				confirmButtonText: "삭제",
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
					if (result.deleteYn === "liked") {
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

		// 1. 댓글 목록 조회 함수
		function getCommentList() {
			fetch('/comment/list?communityNo=' + communityNo)
			.then(res => res.json())
			.then(list => {
				renderComments(list);
			})
			.catch(err => console.error(err));
		}

		// 2. 댓글 렌더링 함수 (대댓글 들여쓰기 처리)
		function renderComments(list) {
	        const commentListContainer = document.querySelector(".comment-list ul");
	        commentListContainer.innerHTML = ""; 
	        
	        document.querySelector(".comment-wrapper p").innerText = "댓글 " + list.length + "개";

	        if (list.length === 0) {
	            commentListContainer.innerHTML = '<li style="text-align:center; padding: 20px; font-weight:500;">작성된 댓글이 없습니다.</li>';
	            return;
	        }

	        list.forEach(reply => {
	            const paddingLeft = reply.commentDepth * 40;
	            
	            // ⭐ 댓글 작성자 프로필 이미지 (contextPath 추가)
	            const profileImg = reply.userProfileImg 
	                ? contextPath + reply.userProfileImg 
	                : contextPath + '/resources/img/default-profile.png';
	            
	            // 삭제 버튼 HTML 미리 생성
	            let deleteBtnHtml = '';
	            if (reply.userNo == userNo || userType == "SYSTEM_MANAGER") {
	                deleteBtnHtml = `<span class="comment-delete" onclick="deleteReply(\${reply.commentNo})" style="cursor:pointer; font-weight:500; color:#FF3B00;">삭제</span>`;
	            }

	            // 글쓴이
	            let writerUseNo = '';
	            if(reply.userNo == communityUserNo) {
	                writerUseNo = `<span style="color:#0A84FF; font-weight:600; font-size:.8rem;">(글쓴이)</span>`
	            }
	            
	            // ⭐ 답글 입력창 프로필 이미지 (로그인한 사용자) - contextPath 추가
	            const replyProfileImg = sessionUserProfileImg 
	                ? contextPath + sessionUserProfileImg 
	                : contextPath + '/resources/img/default-profile.png';
	            
	            // 하단 영역 HTML (답글 버튼 등)
	            let footerHtml = '';
	            if (reply.deleteYn === 'N') {
	                footerHtml = `
	                    <div class="comment-footer">
	                        <span class="commnet-add" onclick="toggleReplyForm(this)">답글달기</span>
	                        \${deleteBtnHtml} 
	                    </div>
	                    
	                    <div class="comment-add-input" style="display:none;">
	                        <div class="form-top">
	                            <img src="\${replyProfileImg}" width="50" onerror="this.src='\${contextPath}/resources/img/default-profile.png'">
	                            <textarea class="reply-content" placeholder="답글을 입력해주세요.."></textarea>
	                        </div>
	                        <div class="form-bottom">
	                            <button class="comment-sumbit" type="button" onclick="commentAdd(\${reply.commentNo}, \${reply.commentDepth}, this)">등록</button>
	                        </div>
	                    </div>
	                `;
	            }

	            let html = `
	                <li class="comment-list-wrapper" style="padding-left: \${paddingLeft}px;">
	                    <div class="comment-user-info">
	                        <img src="\${profileImg}" width="50" onerror="this.src='\${contextPath}/resources/img/default-profile.png'">
	                    </div>
	                    <div class="comment-content-wrapper">
	                        <div class="comment-user">
	                            <div class="comment-user-wrapper">
	                                <span class="user-name">\${reply.userNickName} \${writerUseNo}</span>
	                                <span class="comment-writer">\${reply.timeAgo}</span>
	                            </div>
	                            <div class="report" data-comment-no="\${reply.commentNo}">
	                                <span class="material-symbols-outlined more_vert">more_vert</span>
	                                
	                                <div class="report-button">
	                                    <span class="material-symbols-outlined flag">flag</span>
	                                    <span>신고하기</span>
	                                </div>

	                                <div class="report-list-wrapper">
	                                    <div class="report-list">
	                                        <span class="reportSecond">신고 유형 선택</span>
	                                        <button class="report-btn" type="button">정치 발언</button>
	                                        <button class="report-btn" type="button">성희롱/음담패설</button>
	                                        <button class="report-btn" type="button">상업 광고</button>
	                                        <button class="report-btn" type="button">욕설/비하</button>
	                                        <button class="report-btn" type="button">유출/사기/사칭</button>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	                        <div class="comment-text">
	                            <span class="comment-content">
	                                \${reply.deleteYn === 'Y' ? '<span style="color:#ccc;">삭제된 댓글입니다.</span>' : reply.commentContent}
	                            </span>
	                        </div>
	                        \${footerHtml}
	                    </div>
	                </li>
	            `;
	            
	            commentListContainer.insertAdjacentHTML('beforeend', html);
	        });
	    }
	    
		document.addEventListener("click", (e) => {
			// 1. 점 3개(more_vert) 버튼 클릭 시 -> '신고하기' 버튼 토글
			const moreBtn = e.target.closest(".more_vert");
			if (moreBtn) {
				const reportContainer = moreBtn.closest(".report");
				const reportButton = reportContainer.querySelector(".report-button");
				const reportListWrapper = reportContainer.querySelector(".report-list-wrapper");

				// 토글 실행
				reportButton.classList.toggle("active");

				// 점 3개를 눌러서 닫을 때, 열려있던 신고 사유 목록도 같이 닫아주는 것이 자연스러움
				if (!reportButton.classList.contains("active")) {
					reportListWrapper.classList.remove("active");
				}
				return; // 이벤트 종료
			}

			// 2. '신고하기' 버튼 클릭 시 -> 신고 사유 목록(리스트) 토글
			const reportBtnAction = e.target.closest(".report-button");
			if (reportBtnAction) {

				if(!userNo || userNo == null) {
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
					return;
				}
				const reportContainer = reportBtnAction.closest(".report");
				const reportListWrapper = reportContainer.querySelector(".report-list-wrapper");
				
				reportListWrapper.classList.toggle("active");
				return; // 이벤트 종료
			}
			
			const finalReportBtn = e.target.closest(".report-btn");
			if (finalReportBtn) {
				const reportContainer = finalReportBtn.closest(".report");
				const reportListWrapper = reportContainer.querySelector(".report-list-wrapper");
				const reportButton = reportContainer.querySelector(".report-button");
				
				// 1) 리스트 닫기 (필수)
				reportListWrapper.classList.remove("active");
				
				// 2) '신고하기' 버튼도 닫고 다시 점 3개 상태로 돌리려면 아래 줄 주석 해제
				reportButton.classList.remove("active");
								
				
				const commentNo = reportContainer.dataset.commentNo;
				const reportReason = finalReportBtn.innerText;
				// 3) 여기서 실제 신고 처리 로직을 작성합니다 (예: 서버로 전송)
				console.log(`신고 접수됨: \${finalReportBtn.innerText}`);

				// [3] 상황에 맞춰 신고 함수 호출
				if (commentNo) {
					// (A) 댓글 번호가 존재하면 -> 댓글 신고
					reportBtn(commentNo, 'comment', reportReason);
				} else {
					// (B) 댓글 번호가 없으면 -> 게시글 신고 (전역변수 communityNo 사용)
					reportBtn(communityNo, 'board', reportReason);
				}

				return;
			}
		});

		// 3. 답글 입력창 토글 함수
		function toggleReplyForm(btn) {
			// 클릭된 버튼이 속한 wrapper 찾기
			const wrapper = btn.closest(".comment-content-wrapper");
			const inputDiv = wrapper.querySelector(".comment-add-input");
			
			// display 상태 토글
			if(inputDiv.style.display === "none") {
				inputDiv.style.display = "block";
				inputDiv.querySelector("textarea").focus();
			} else {
				inputDiv.style.display = "none";
			}
		}

		// 1. 메인 댓글 입력창 (상단) 엔터키 처리
		const mainCommentInput = document.querySelector("#comment-content");

		if (mainCommentInput) {
			mainCommentInput.addEventListener("keydown", function(e) {
				// 한글 조합 중이거나, Shift+Enter(줄바꿈)인 경우는 제외
				if (e.isComposing || (e.key === "Enter" && e.shiftKey)) {
					return; 
				}

				if (e.key === "Enter") {
					e.preventDefault(); // 기본 줄바꿈 동작 막기
					commentAdd(); // 부모번호 0, 깊이 0 (기본값) 실행
				}
			});
		}

		// 2. 대댓글(답글) 입력창 엔터키 처리 (이벤트 위임)
		document.addEventListener("keydown", function(e) {
			// 이벤트가 발생한 요소가 대댓글 입력창(.reply-content)인지 확인
			if (e.target.classList.contains("reply-content")) {
				
				// 한글 조합 중이거나, Shift+Enter(줄바꿈)인 경우는 제외
				if (e.isComposing || (e.key === "Enter" && e.shiftKey)) {
					return;
				}

				if (e.key === "Enter") {
					e.preventDefault(); // 줄바꿈 방지

					// 현재 입력창이 속한 영역(.comment-add-input)을 찾음
					const inputDiv = e.target.closest(".comment-add-input");
					
					// 그 영역 안에 있는 '등록 버튼'을 찾아서 클릭 이벤트를 강제로 발생시킴
					const submitBtn = inputDiv.querySelector("button"); 
					
					if (submitBtn) {
						submitBtn.click();
					}
				}
			}
		});

		// 4. 댓글/대댓글 등록 함수
		function commentAdd(parentNo = 0, parentDepth = 0, btn = null) {
			let content = "";
			
			if (parentNo === 0) {
				// 1. 일반 댓글 (상단 입력창)
				content = document.querySelector("#comment-content").value;
			} else {
				// 2. 대댓글 (답글 입력창)
				const inputDiv = btn.closest(".comment-add-input");
				content = inputDiv.querySelector(".reply-content").value;
			}

			if (!content.trim()) {
				Swal.fire({
					icon:'warning',
					title: '댓글을 작성해주세요.',
					confirmButtonText: '확인',
					customClass: {
						popup: 'error-popup',
						title: 'error-title',
						text: 'error-text',
						confirmButton: 'error-button'
					}
				});
				return;
			}

			// 깊이 계산: 대댓글이면 부모 깊이 + 1, 아니면 0
			const depth = parentNo === 0 ? 0 : parentDepth + 1;

			const data = {
				communityNo : communityNo,
				userNo : userNo,
				commentContent: content,
				parentCommentNo: parentNo,
				commentDepth: depth
			};

			fetch('/comment/add', {
				method:'post',
				headers:{"Content-Type":"application/json"},
				body: JSON.stringify(data)
			})
			.then(res => res.json())
			.then(list => {
				if(parentNo === 0) {
					document.querySelector("#comment-content").value = "";
				}
				renderComments(list);
			})
			.catch(err => {
				console.error(err);
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
			});
		}
		
		// 댓글 삭제 함수
		function deleteReply(commentNo) {
			console.log(commentNo);
			Swal.fire({
				title: '삭제하시겠습니까?',
				showCancelButton: true,
				confirmButtonText: '삭제',
				cancelButtonText: '취소',
				customClass: {
					popup: 'success-popup',
					title: 'success-title',
					confirmButton: 'success-button',
					cancelButton: 'cancel-button'
				}
			}).then((result) => {
				if (result.isConfirmed) {
					fetch("/comment/delete?commentNo=" + commentNo, {
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
								getCommentList();
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

		function reportBtn(targetNo, type, reportReason) {
			const data = {
				reporterNo : '${userNo}',
				reportReason : reportReason,
				reportType : type,
				communityNo: communityNo
			}

			// 2. 타입에 따라 번호 할당
			if (type === 'comment') {
				data.commentNo = targetNo;
			}

			console.log("신고 전송:", data);
		
			fetch("/report/add", {
				method: "post",
				headers: {"Content-Type":"application/json"},
				body: JSON.stringify(data)
			})
			.then(res => res.json())
			.then(result => {
				if(result > 0) {
					Swal.fire({
                        icon:'success',
                        title: '신고 완료!',
                        text: '건전한 커뮤니티에 힘써주셔서 감사합니다!',
                        confirmButtonText: '확인',
                        customClass: {
                            popup: 'success-popup',
                            title: 'success-title',
                            text: 'success-text',
                            confirmButton: 'success-button'
                        }
                    })
				} else {
					Swal.fire({
						icon:'error',
						title: '신고 실패..ㅠ',
						text: '다시 시도해주세요!',
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
                    title: '신고 실패..ㅠ',
                    text: err,
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
	</script>
</body>
</html>