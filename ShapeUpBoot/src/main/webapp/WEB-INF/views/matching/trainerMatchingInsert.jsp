<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../resources/css/matching/trainerMatchingInsert.css">
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
                            </div>
                            <div class="form-group">
                                <label for="matchingPrice">회당 가격</label>
                                <input type="text" name="matchingPrice" id="matchingPrice" placeholder="회당 가격을 입력해주세요.">
                            </div>

                        </div>
                        <div class="form-group">
                            <label for="matchingCategory">매칭 카테고리</label>
                            <input type="text" name="matchingCategory" id="matchingCategory" placeholder="매칭 카테고리를 입력해주세요.">
                        </div>
                        <div class="form-group">
                            <label for="matchingContent">매칭 내용</label>
                            <textarea name="matchingContent" id="matchingContent" placeholder="매칭 내용을 입력해주세요."></textarea>                
                        </div>
                    </div>
                    <div class="matching-footer">
                        <div class="form-group">
                            <label for="matchingLocation">매칭 지역</label>
                            <input type="hidden" name="matchingLocation" id="locationInputHidden">
                            <input type="hidden" name="lat" id="latHidden">
                            <input type="hidden" name="lng" id="lngHidden">
                            <input type="hidden" name="url" id="urlHidden">
                            <input type="text" id="matchingLocation" placeholder="왼쪽 지도에서 선택해주세요." disabled>
                        </div>
                        <div class="form-group">
                            <label for="matchingTime">매칭 시간</label>
                            <input type="text" name="matchingTime" id="matchingTime" placeholder="ex&#41;&nbsp;평일 오후">
                        </div>                         
                        <div class="form-group">
                            <label for="matchingUser">모집 인원</label>
                            <input type="text" name="matchingUser" id="matchingUser" placeholder="모집할 인원을 입력해주세요.">
                        </div>
                    </div>
                    <div class="btn-row">
                        <button id="save-btn" onclick="saveFun();">등록</button>
                        <button id="cancel-btn">취소</button>
                    </div>
                </div>
                <div class="matching-right">
                    <div class="map-wrap">
                        <div id="map"></div>

                        <div id="menu_wrap">
                            
                            <div class="option">
                                <form onsubmit="searchPlaces(); return false;">
                                    <input type="text" value="이태원 맛집" id="keyword" size="15" placeholder="검색어 입력"> 
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
    </script>
</body>
</html>