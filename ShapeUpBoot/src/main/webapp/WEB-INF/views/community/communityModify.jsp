<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티 수정 | ShapeUp</title>
<link rel="stylesheet" href="../../../resources/css/community/communityInsert.css">
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
</head>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
        <div class="main">
            <div class="community-wrapper">
                <p class="title">게시글 수정</p>
                <div class="community">
                    <input type="hidden" id="communityNo" value="${cList.communityNo}">                   
                    <div class="form-row">
                        <div class="form-group">
                            <label for="communityTitle">제목</label>
                            <input type="text" name="communityTitle" id="communityTitle" value="${cList.communityTitle }">
                        </div>
                        <div class="form-group" id="form-category">
                            <div class="community-category">
                                <span class="label">카테고리</span>
                                <button class="dropdown-header">
                                    <span id="selectedCategory" data-value="${cList.communityType}">${cList.communityType}</span>
                                    <span class="material-symbols-outlined">keyboard_arrow_down</span>
                                </button>
                                <div class="community-category-list hidden">
                                    <button class="category-btn" type="button" data-value="일상/소통">일상 / 소통</button>
                                    <button class="category-btn" type="button" data-value="운동질문">운동 질문</button>
                                    <button class="category-btn" type="button" data-value="운동꿀팁">운동 꿀팁</button>
                                    <button class="category-btn" type="button" data-value="식단/영양">식단 / 영양</button>
                                    <button class="category-btn" type="button" data-value="운동인증">운동 인증</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <span class="label">내용</span>
                        <div id="hidden-content" style="display:none;"><c:out value="${cList.communityContent}" escapeXml="false" /></div>
                        
                        <div id="editor"></div>
                    </div>
                    
                    <div class="btn-row">
                        <button class="save-btn">수정 완료</button>
                        <button class="cancel-btn" onclick="history.back()">취소</button>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
    <script src="https://uicdn.toast.com/editor/latest/i18n/ko-kr.js"></script>
    
    <script>
        /*********************/
        /* 카테고리 드롭다운 */
        /*********************/
        const categoryHeader = document.querySelector(".dropdown-header");
        const categorySpan = document.querySelector("#selectedCategory");
        const categoryBox = document.querySelector(".community-category-list");

        categoryHeader.addEventListener("click", () => {
            categoryBox.classList.toggle("hidden");
            categoryHeader.classList.toggle("active");
        });

        document.querySelectorAll(".category-btn").forEach(btn => {
            btn.addEventListener("click", (e) => {
                const text = e.target.innerText;
                const value = e.target.getAttribute("data-value");

                categorySpan.innerText = text;
                categorySpan.dataset.value = value;
                
                categoryHeader.classList.add("selected"); 

                categoryBox.classList.add("hidden");
                categoryHeader.classList.remove("active");
            })
        });

        /*********************/
        /* Toast UI Editor  */
        /*********************/
        const Editor = toastui.Editor;
        
        // 숨겨진 HTML 내용 가져오기
        const content = document.querySelector('#hidden-content').innerHTML;

        const editor = new Editor({
            el: document.querySelector('#editor'),
            height: '500px',
            initialEditType: 'wysiwyg', 
            previewStyle: 'vertical',   
            placeholder: '내용을 입력해주세요.',
            language: 'ko-KR',
            hideModeSwitch: true,        
            toolbarItems: [
                ['heading', 'bold', 'italic', 'strike'],
                ['hr', 'quote'],
                ['ul', 'ol', 'task', 'indent', 'outdent'],
                ['table', 'image', 'link']
            ],
            hooks : {
                addImageBlobHook: (blob, callback) => {
                    const formData = new FormData();
                    formData.append('image', blob);

                    fetch("/community/image-upload", {
                        method: 'post',
                        body: formData
                    })
                    .then(res => res.json())
                    .then(result => {
                        callback(result.url, '이미지 설명');
                    })
                    .catch(err => console.log(err));
                }
            }
        });

        /* 이걸로 불러온 데이터를 보여줌 */
        editor.setHTML(content);


        /*********************/
        /* 수정(Update)    */
        /*********************/
        document.querySelector(".save-btn").addEventListener("click", () => {
            const communityNo = document.querySelector("#communityNo").value; 
            const title = document.querySelector("#communityTitle").value;
            const categoryCode = document.querySelector("#selectedCategory").dataset.value; 
            const contentHTML = editor.getHTML(); // 수정된 내용 가져오기

            // 2. 유효성 검사
            if(!title) { alert("제목을 입력해주세요."); return; }
            if(!categoryCode) { alert("카테고리를 선택해주세요."); return; }

            const data = {
                communityNo: communityNo,      
                communityTitle: title,
                communityType: categoryCode,   
                communityContent: contentHTML
            }
            
            console.log("수정할 데이터:", data);

            fetch("/community/modify", { 
                method:'PUT',
                headers: {"Content-Type":"application/json"},
                body: JSON.stringify(data)
            })
            .then(res => res.json()) 
            .then(result => {
                if (result > 0 || result === "success") {
                    Swal.fire({
                        icon: 'success',
                        title: '수정 완료!',
                        confirmButtonText: '확인',
                        customClass: {
                            popup: 'success-popup',
                            title: 'success-title',
                            text: 'success-text',
                            confirmButton: 'success-button'
                        }
                    }).then(() => {
                        location.href = "/community/detail?boardNo=" + communityNo;
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: '수정 실패',
                        text: '다시 시도해주세요.',
                        customClass: {
                            popup: 'error-popup',
                            title: 'error-title',
                            text: 'error-text',
                            confirmButton: 'error-button'
                        }, 
                    });
                }
            })
            .catch(err => {
                console.error(err);
                Swal.fire({ icon:'error', title: '에러 발생', text: err });
            })
        });
    </script>
</body>
</html>