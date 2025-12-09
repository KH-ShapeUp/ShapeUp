<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티 작성 | ShapeUp</title>
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
                <p class="title">커뮤니티 글 작성</p>
                <div class="community">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="communityTitle">제목</label>
                            <input type="text" name="communityTitle" id="communityTitle" placeholder="작성할 게시글의 제목을 작성해주세요.">
                            <span class="errMsg"></span>
                        </div>
                        <div class="form-group" id="form-category">
                            <div class="community-category">
                                <span class="label">카테고리</span>
                                <button class="dropdown-header">
                                    <span id="selectedCategory">카테고리</span>
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
                        <div class="content"></div>
                    </div>
                    <div class="btn-row">
                        <button class="save-btn">저장</button>
                        <button class="cancel-btn" onclick="cancel();">취소</button>
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
        /*  Toast UI script  */
        /*********************/
        const Editor = toastui.Editor;

        const editor = new Editor({
            el: document.querySelector('.content'),
            height: '500px',
            initialEditType: 'wysiwyg', 
            previewStyle: 'vertical',   
            placeholder: '내용을 입력해주세요. (건전한 커뮤니티 문화를 만들어가요!)',
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
                    // 데이터 저장할 폼 데이터 생성 (이미지 파일 담기)
                    const formData = new FormData();
                    formData.append('image', blob);

                    // 서버 전송
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

        document.querySelector(".save-btn").addEventListener("click", () => {
            const title = document.querySelector("#communityTitle").value;
            const categoryCode = document.querySelector("#selectedCategory").dataset.value; // data-value 값
            const contentHTML = editor.getHTML(); // 에디터의 내용을 HTML로 가져옴

            
            const data = {
                communityTitle: title,
                communityType: categoryCode,
                communityContent: contentHTML
            }
            console.log("전송할 데이터:", data);

            fetch("/community/insert", {
                method:'post',
                headers:{"Content-Type":"application/json"},
                body: JSON.stringify(data)
            })
            .then(res => res.json())
            .then(result => {
                if (result > 0) {
                    Swal.fire({
                        icon:'success',
                        title: '게시글 작성완료!',
                        text: '',
                        confirmButtonText: '확인',
                        customClass: {
                            popup: 'success-popup',
                            title: 'success-title',
                            text: 'success-text',
                            confirmButton: 'success-button'
                        },
                        didClose: () => {
                            location.href="/community"
                        }
                    })
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
            })
        });

        function cancel() {
            Swal.fire({
				title: '작성을 취소하시겠습니까?',
				showCancelButton: true,
				confirmButtonText: '예',
				cancelButtonText: '아니요',
				customClass: {
					popup: 'success-popup',
					title: 'success-title',
					confirmButton: 'success-button',
					cancelButton: 'cancel-button'
				}
            })
            .then(result => {
                if(result.isConfirmed) {
                    window.history.back();
                }
            })
        }
    </script>
</body>
</html>