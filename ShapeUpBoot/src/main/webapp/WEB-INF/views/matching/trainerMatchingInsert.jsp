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
                        <div class="form-group">
                            <label for="matchingTitle">매칭 제목</label>
                            <input type="text" name="matchingTitle" id="matchingTitle" placeholder="매칭 제목을 입력해주세요.">
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
                            <input type="text" id="matchingLocation" placeholder="왼쪽 지도에서 선택해주세요." disabled>
                        </div>
                        <div class="form-group">
                            <label for="matchingTime">매칭 시간</label>
                            <input type="text" name="matchingTime" id="matchingTime" placeholder="ex&#41;&nbsp;평일 오후">
                        </div>
                        <div class="form-group">
                            <label for="matchingCareer">경력</label>
                            <input type="text" name="matchingCareer" id="matchingCareer" placeholder="ex&#41;&nbsp;5개월&nbsp;/&nbsp;5년">
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"> 
    <script>
        // 마커를 담을 배열입니다
        var markers = [];

        var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
            mapOption = {
                center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
                level: 3 // 지도의 확대 레벨
            };

        // 지도를 생성합니다    
        var map = new kakao.maps.Map(mapContainer, mapOption);

        // 장소 검색 객체를 생성합니다
        var ps = new kakao.maps.services.Places();

        var customOverlay = null;

        // 키워드로 장소를 검색합니다
        searchPlaces();

        // 키워드 검색을 요청하는 함수입니다
        function searchPlaces() {
            var keyword = document.getElementById('keyword').value;

            if (!keyword.replace(/^\s+|\s+$/g, '')) {
                alert('키워드를 입력해주세요!');
                return false;
            }

            // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
            ps.keywordSearch(keyword, placesSearchCB);
        }

        // 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
        function placesSearchCB(data, status, pagination) {
            var listEl = document.getElementById('placesList');
            var paginationEl = document.getElementById('pagination');

            if (status === kakao.maps.services.Status.OK) {

                // 정상적으로 검색이 완료됐으면
                // 검색 목록과 마커를 표출합니다
                displayPlaces(data);

                // 페이지 번호를 표출합니다
                displayPagination(pagination);

            } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
                
                // 검색 결과가 없는 경우 리스트 비우고 메시지 표시
                removeAllChildNods(listEl);
                removeAllChildNods(paginationEl);
                
                listEl.innerHTML = 
                    '<div style="text-align:center; padding: 20px; color:#ccc;">' + 
                        '<span class="material-symbols-outlined" style="font-size:40px; display:block; margin-bottom:10px;">error</span>' + 
                        '검색 결과가 없습니다.' + 
                    '</div>';
                return;

            } else if (status === kakao.maps.services.Status.ERROR) {
                
                alert('검색 결과 중 오류가 발생했습니다.');
                return;
            }
        }

        // 검색 결과 목록과 마커를 표출하는 함수입니다
        function displayPlaces(places) {

            var listEl = document.getElementById('placesList'),
                menuEl = document.getElementById('menu_wrap'),
                fragment = document.createDocumentFragment(),
                bounds = new kakao.maps.LatLngBounds();

            // 검색 결과 목록에 추가된 항목들을 제거합니다
            removeAllChildNods(listEl);

            // 지도에 표시되고 있는 마커를 제거합니다
            removeMarker();

            for (var i = 0; i < places.length; i++) {

                // 마커를 생성하고 지도에 표시합니다
                var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                    marker = addMarker(placePosition, i),
                    itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

                // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
                // LatLngBounds 객체에 좌표를 추가합니다
                bounds.extend(placePosition);

                // 마커와 검색결과 항목에 mouseover 했을때
                // 해당 장소에 인포윈도우에 장소명을 표시합니다
                // mouseout 했을 때는 인포윈도우를 닫습니다
                (function (marker, place) {
                    
                    // 마커 클릭 시
                    kakao.maps.event.addListener(marker, 'click', function () {
                        displayInfowindow(marker, place.place_name);
                        
                        document.querySelector("#matchingLocation").value = place.place_name;
                        document.querySelector("#locationInputHidden").value = place.place_name;
                        document.getElementById("latHidden").value = place.y; // 위도
                        document.getElementById("lngHidden").value = place.x; // 경도
                    });

                    // 리스트 클릭 시
                    itemEl.onclick = function () {
                        displayInfowindow(marker, place.place_name);

                        document.querySelector("#matchingLocation").value = place.place_name;
                        document.querySelector("#locationInputHidden").value = place.place_name;
                        document.getElementById("latHidden").value = place.y; // 위도
                        document.getElementById("lngHidden").value = place.x; // 경도
                        console.log("이름", place.place_name, "위도 :", place.y, "경도:", place.x);
                        
                        // 클릭 시 해당 위치로 이동 (선택 사항)
                        map.panTo(marker.getPosition()); 
                    };

                })(marker, places[i]);

                fragment.appendChild(itemEl);
            }

            // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
            listEl.appendChild(fragment);
            // menuEl.scrollTop = 0; // 구조 변경으로 인해 필요 시 .bottom-list-wrap 스크롤 조정 필요

            // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
            map.setBounds(bounds);
        }

        // 검색결과 항목을 Element로 반환하는 함수입니다
       function getListItem(index, place) {
            var el = document.createElement('li');

            var itemStr = 
                '<div class="item-inner">' +
                    '<div class="item-inner-top">' +
                        '<img src="../../../resources/img/map-marker.png">' +
                        '<h5>' + place.place_name + '</h5>' +
                    '</div>';

            // 도로명 주소 + 지번 주소
            if (place.road_address_name) {
                itemStr += 
                    '<div class="item-wrapper">' +
                        '<div class="item-name">' +
                            '<i class="fa-solid fa-location-dot"></i> ' +
                            '<span>' + place.road_address_name + '</span>' +
                        '</div>' +
                        '<div class="item-jibun">' +
                            '<i class="fa-solid fa-tags"></i>' +
                            '<span class="jibun gray">' + place.address_name + '</span>' +
                        '</div>' +
                    '</div>';
            } else {
                itemStr += 
                    '<span>' + place.address_name + '</span>';
            }

            // 전화번호
            if (place.phone) {
                itemStr += '<span class="tel">' + place.phone + '</span>';
            }

            itemStr += '</div>'; // item-inner 닫기

            el.innerHTML = itemStr;
            el.className = 'item';

            return el;
        }


        // 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
        function addMarker(position, idx, title) {
        var imageSrc = '../../resources/img/map-marker.png', //  단일 마커 이미지
                imageSize = new kakao.maps.Size(60, 60), // 실제 마커 이미지 크기
                markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize),
                marker = new kakao.maps.Marker({
                    position: position,
                    image: markerImage
                });

            marker.setMap(map); // 지도 위에 마커를 표출합니다
            markers.push(marker);  // 배열에 생성된 마커를 추가합니다

            return marker;
        }

        // 지도 위에 표시되고 있는 마커를 모두 제거합니다
        function removeMarker() {
            for (var i = 0; i < markers.length; i++) {
                markers[i].setMap(null);
            }
            markers = [];
        }

        // 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
        function displayPagination(pagination) {
            var paginationEl = document.getElementById('pagination'),
                fragment = document.createDocumentFragment(),
                i;

            // 기존에 추가된 페이지번호를 삭제합니다
            while (paginationEl.hasChildNodes()) {
                paginationEl.removeChild(paginationEl.lastChild);
            }

            for (i = 1; i <= pagination.last; i++) {
                var el = document.createElement('a');
                el.href = "#";
                el.innerHTML = i;

                if (i === pagination.current) {
                    el.className = 'on';
                } else {
                    el.onclick = (function (i) {
                        return function () {
                            pagination.gotoPage(i);
                        }
                    })(i);
                }

                fragment.appendChild(el);
            }
            paginationEl.appendChild(fragment);
        }
        
        // 인포윈도우에 장소명을 표시합니다
        function displayInfowindow(marker, title, place) {
            // place 매개변수가 없을 경우를 대비해 title만으로 처리하거나, 
            // displayPlaces 함수에서 호출할 때 place 객체를 통째로 넘겨주는 것이 좋습니다.
            // 여기서는 title만 받아도 이쁘게 나오도록 처리했습니다.
            if (customOverlay !== null) {
                customOverlay.setMap(null);
            }

            var content = 
                '<div class="custom-iw">' + 
                '    <div class="title">' + title + '</div>' + 
                '</div>';

            customOverlay = new kakao.maps.CustomOverlay({
                content:content,
                position: marker.getPosition(),
                map:map,
                yAnchor: 1.4
            });
        }

        /* (선택사항) 지도를 클릭하면 오버레이 닫기 기능 추가 */
        kakao.maps.event.addListener(map, 'click', function() {
            if (customOverlay) {
                customOverlay.setMap(null);
            }
        });

        // 검색결과 목록의 자식 Element를 제거하는 함수입니다
        function removeAllChildNods(el) {
            while (el.hasChildNodes()) {
                el.removeChild(el.lastChild);
            }
        }
    </script>
</body>
</html>