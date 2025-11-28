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
						<span class="material-symbols-outlined" onclick="clip(); return false;">share</span>
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
                    <p>댓글 0개</p> <div class="comment-form">
                        <div class="form-top">
                            <img src="../../../resources/img/person.png" width="50">
                            <textarea name="comment" id="comment-content" placeholder="댓글을 입력해주세요.."></textarea>
                        </div>
                        <div class="form-bottom">
                            <button class="comment-sumbit" type="button" onclick="commentAdd();">등록</button>
                        </div>
                    </div>

                    <div class="comment-list">
                        <ul>
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
		document.addEventListener("DOMContentLoaded", function() {
			getCommentList(); 
		});

		function clip(){
			var url = '';    // <a>태그에서 호출한 함수인 clip 생성
			var textarea = document.createElement("textarea");  
			//url 변수 생성 후, textarea라는 변수에 textarea의 요소를 생성
			
			document.body.appendChild(textarea); //</body> 바로 위에 textarea를 추가(임시 공간이라 위치는 상관 없음)
			url = window.document.location.href;  //url에는 현재 주소값을 넣어줌
			textarea.value = url;  // textarea 값에 url를 넣어줌
			textarea.select();  //textarea를 설정
			document.execCommand("copy");   // 복사
			document.body.removeChild(textarea); //extarea 요소를 없애줌
			
			alert("URL이 복사되었습니다.")  // 알림창
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
		const communityUserNo = "${cList.userNo}";
		console.log(communityUserNo);
		const communityNo = "${cList.communityNo}"; // 현재 게시글 번호
		const userNo = "${userNo}"; // 로그인한 유저 번호 (세션 등에서 가져옴)

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
				commentListContainer.innerHTML = '<li style="text-align:center; padding: 20px;">작성된 댓글이 없습니다.</li>';
				return;
			}

			list.forEach(reply => {
				const paddingLeft = reply.commentDepth * 40;
				
				// 삭제 버튼 HTML 미리 생성
				let deleteBtnHtml = '';
				if (reply.userNo == userNo) {
					deleteBtnHtml = `<span class="comment-delete" onclick="deleteReply(\${reply.commentNo})" style="cursor:pointer; font-weight:500; color:#FF3B00;">삭제</span>`;
				}

				// 글쓴이
				let writerUseNo = '';
				if(reply.userNo == communityUserNo) {
					writerUseNo = `<span style="color:#0A84FF; font-weight:600; font-size:.8rem;">(글쓴이)</span>`
				}
				// 하단 영역 HTML (답글 버튼 등)
				let footerHtml = '';
				if (reply.deleteYn === 'N') { // 정상 댓글일 때만 표시
					footerHtml = `
						<div class="comment-footer">
							<span class="commnet-add" onclick="toggleReplyForm(this)">답글달기</span>
							\${deleteBtnHtml} 
						</div>
						
						<div class="comment-add-input" style="display:none;">
							<div class="form-top">
								<img src="../../../resources/img/person.png" width="50">
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
							<img src="../../../resources/img/person.png" width="50">
						</div>
						<div class="comment-content-wrapper">
							<div class="comment-user">
								<div class="comment-user-wrapper">
									<span class="user-name">\${reply.userNickName} \${writerUseNo}</span></span>
									<span class="comment-writer">\${reply.timeAgo}</span>
								</div>
								<div class="report">
									<button class="report-btn" onclick="reportBtn('\${reply.communityNo}','\${reply.commentNo}','\${communityUserNo}');">
										<span class="material-symbols-outlined">siren</span>
									</button>
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

		// 4. 댓글/대댓글 등록 함수
		// parentcommentNo: 0이면 원댓글, 값이 있으면 대댓글
		// btn: 클릭된 버튼 객체 (대댓글 입력창의 텍스트를 찾기 위해)
		// 댓글/대댓글 등록 함수
		// parentNo: 부모 댓글 번호 (0이면 원댓글)
		// parentDepth: 부모 댓글의 깊이 (0이면 원댓글)
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
				commentContent: content,     // VO 필드명: commentContent
				parentCommentNo: parentNo,   // VO 필드명: parentCommentNo (수정됨)
				commentDepth: depth          // VO 필드명: commentDepth (추가됨)
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

		function reportBtn(communityNo, commentNo) {
			const data = {
				commentNo : commentNo,
				communityNo : communityNo,
				userNo : '${userNo}'
			}
			
			console.log(data);

			fetch("comment/report", {
				method: "post",
				headers: {"Content-Type":"application/json"},
				body: {

				}
			})
			console.log("게시글 번호" + communityNo)
			console.log("댓글 번호" + commentNo);
		
		}
	</script>
</body>
</html>