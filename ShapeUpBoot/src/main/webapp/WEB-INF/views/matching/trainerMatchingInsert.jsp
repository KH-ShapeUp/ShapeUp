<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>트레이닝 매칭 등록 | ShapeUp</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../resources/css/matching/trainerMatchingInsert.css">
<link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
</head>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
        <div class="main">
            <p class="title">트레이너 매칭</p>
            <div class="matching-wrapper">
                <div class="matching">
                    <div class="matching-top">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="matchingTitle">매칭 제목</label>
                                <input type="text" name="matchingTitle" id="matchingTitle" placeholder="매칭 제목을 입력해주세요.">
                                <span class="errMsg"></span>
                            </div>
                            <div class="form-group">
                                <label for="matchingPrice">회당 가격</label>
                                <div class="input">
                                    <input type="text" name="matchingPrice" id="matchingPrice" placeholder="ex&#41;&nbsp;10000">
                                    <span class="errTxt">원</span>
                                </div>
                                <span class="errMsg"></span>
                            </div>

                        </div>
                        <div class="form-group">
                            <label for="matchingCategory">매칭 카테고리</label>
                            <input type="text" name="matchingCategory" id="matchingCategory" placeholder="매칭 카테고리를 입력해주세요.">
                            <span class="errMsg"></span>
                        </div>
                        <div class="form-group">
                            <label for="matchingContent">매칭 내용</label>
                            <textarea name="matchingContent" id="matchingContent" placeholder="매칭 내용을 입력해주세요."></textarea>                
                            <span class="errMsg"></span>
                        </div>
                    </div>
                    <div class="matching-footer">
                        <div class="form-group">
                            <label for="matchingLocation">매칭 지역</label>
                            <input type="hidden" name="matchingLocation" id="locationInputHidden">
                            <input type="hidden" name="addrName" id="addrNameHidden">
                            <input type="hidden" name="lat" id="latHidden">
                            <input type="hidden" name="lng" id="lngHidden">
                            <input type="hidden" name="url" id="urlHidden">
                            <input type="text" id="matchingLocation" placeholder="왼쪽 지도에서 선택해주세요." disabled>
                            <span class="errMsg"></span>
                        </div>
                        <div class="form-group">
                            <label for="matchingTime">매칭 시간</label>
                            <input type="text" name="matchingTime" id="matchingTime" placeholder="ex&#41;&nbsp;평일 오후">
                            <span class="errMsg"></span>
                        </div>                         
                        <div class="form-group">
                            <label for="matchingUser">모집 인원</label>
                            <div class="input">
                                <input type="text" name="matchingUser" id="matchingUser" placeholder="ex&#41;&nbsp; 10">
                                <span class="errTxt">명</span>
                            </div>
                            <span class="errMsg"></span>
                        </div>
                    </div>
                    <div class="btn-row">
                        <button id="save-btn" onclick="saveFun();">등록</button>
                        <button id="cancel-btn" onclick="cancel();">취소</button>
                    </div>
                </div>
                <div class="matching-right">
                    <div class="map-wrap">
                        <div id="map"></div>    

                        <div id="menu_wrap">
                            
                            <div class="option">
                                <form onsubmit="searchPlaces(); return false;">
                                    <input type="text" value="헬스장" id="keyword" size="15" placeholder="검색어 입력"> 
                                    <button type="submit">검색</button> 
                                </form>
                            </div>

                            <div class="bottom-list-wrap"> <ul id="placesList"></ul>
                                <div id="pagination"></div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1382c885f22984e6547b8e00aa6fab29&libraries=services"></script>
    <script src="../../../resources/js/tainerInsertMap.js"></script>
    <script>
        function saveFun() {
            const userNo = '${userNo}';
            const numberRegex = /^[0-9]+$/;
            const inputs = [
                {el: document.querySelector("#matchingTitle"), msg : "매칭 제목을 입력해주세요."},
                {el: document.querySelector("#matchingPrice"), msg : "회당 가격을 입력해주세요."},
                {el: document.querySelector("#matchingCategory"), msg : "카테고리를 입력해주세요."},
                {el: document.querySelector("#matchingContent"), msg : "매칭 내용을 입력해주세요."},
                {el: document.querySelector("#matchingLocation"), msg : "매칭 지역을 선택해주세요."},
                {el: document.querySelector("#matchingTime"), msg : "매칭 시간을 입력해주세요."},
                {el: document.querySelector("#matchingUser"), msg : "모집 인원 수를 입력해주세요."},
            ]

            document.querySelectorAll(".errMsg").forEach(span => {
                span.innerText = '';
            })

            for(let i = 0; i < inputs.length; i++) {
                const input = inputs[i];
                const value = input.el.value.trim();
                const errSpan = document.querySelectorAll(".errMsg")[i];
                const targetId = input.el.id; // 해당 input id값 가져오기

                input.el.style.border = '';
                errSpan.innerText = '';

                if(value === '') {
                    input.el.style.border = '1.5px solid #ff3b00';
                    errSpan.innerText = input.msg;
                    input.el.focus();
                    return;
                }

                if (targetId === "matchingPrice" || targetId === "matchingUser") {
                    if(!numberRegex.test(value)) {
                        input.el.style.border = '1.5px solid #ff3b00';
                        errSpan.innerText = '숫자만 입력해주세요.';
                        input.el.focus();
                        return;
                    }
                }

                
            }

            const data = {
                userNo: userNo,
                matchingTitle: document.querySelector("#matchingTitle").value,
                matchingPrice: document.querySelector("#matchingPrice").value,
                partnerType: document.querySelector("#matchingCategory").value,
                matchingContent: document.querySelector("#matchingContent").value,
                matchingLocation: document.querySelector("#locationInputHidden").value,
                locationUrl: document.querySelector("#urlHidden").value,
                latitude: document.querySelector("#latHidden").value,
                longitude: document.querySelector("#lngHidden").value,
                matchingTime: document.querySelector("#matchingTime").value,
                matchingUserCount: document.querySelector("#matchingUser").value,
                addrName: document.querySelector("#addrNameHidden").value
            }

            console.log(data);
            
            fetch("/trainer/matching", {
                method : "post",
                headers:{"Content-Type" : "application/json"},
                body: JSON.stringify(data)
            })
            .then(res => res.json())
            .then(result => {
                if(result > 0) {
                    Swal.fire({
                        icon:'success',
                        title: '등록 완료!',
                        text: '이제 회원님의 신청만 기다리면 돼요.',
                        confirmButtonText: '확인',
                        customClass: {
                            popup: 'success-popup',
                            title: 'success-title',
                            text: 'success-text',
                            confirmButton: 'success-button'
                        },
                        didClose: () => {
                            location.href="/trainer/matching/board";
                        }
                    });               
                } else {
                    Swal.fire({
                        icon:'error',
                        title: '등록 실패..ㅠ',
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
                    title: '등록 실패..ㅠ',
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