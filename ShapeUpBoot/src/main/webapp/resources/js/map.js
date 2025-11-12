var markers = [];
var myLocation = null; //  내 위치 좌표(LatLng)를 저장할 변수
var myLocationMarker = null; //  내 위치 마커를 저장할 변수

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
// ★ (Feature 1) '내 위치' 마커를 표시하고 좌표를 저장하는 함수
// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
function displayMarker(locPosition, message) {
    // 기존 '내 위치' 마커가 있다면 제거
    if (myLocationMarker) {
        myLocationMarker.setMap(null);
    }

    // '내 위치' 마커 생성
    var imageSrc = '../../resources/img/my-location.png', //  단일 마커 이미지
    imageSize = new kakao.maps.Size(60, 60), // 실제 마커 이미지 크기
    myMarkerImage = new kakao.maps.MarkerImage(imageSrc, imageSize),
    myLocationMarker = new kakao.maps.Marker({  
        map: map, 
        position: locPosition,
        image : myMarkerImage
    }); 
    
    var iwContent = message,
        iwRemoveable = true;

    var infowindow = new kakao.maps.InfoWindow({
        content : iwContent,
        removable : iwRemoveable
    });
    
    infowindow.open(map); // 인포윈도우 표시
    
    // '내 위치' 좌표 저장
    myLocation = locPosition; 
    
    // 지도 중심을 '내 위치'로 이동
    map.setCenter(locPosition);
}

// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
if (navigator.geolocation) {
    
    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
    navigator.geolocation.getCurrentPosition(function(position) {
        
        var lat = position.coords.latitude, // 위도
            lon = position.coords.longitude; // 경도
        
        var locPosition = new kakao.maps.LatLng(lat, lon) // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
    
        
        // ★ 마커와 인포윈도우를 표시합니다 (이제 이 함수가 지도 중심 이동도 처리)
        displayMarker(locPosition);
            
    });
    
} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
    
    var locPosition = new kakao.maps.LatLng(33.450701, 126.570667)
    // ★ 함수를 호출합니다.
    displayMarker(locPosition);
}

// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
var mapTypeControl = new kakao.maps.MapTypeControl();

// 지도에 컨트롤을 추가해야 지도위에 표시됩니다
// kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
var zoomControl = new kakao.maps.ZoomControl();
map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);


// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
// ★ (Feature 2) '내 위치로' 버튼 기능 구현
// ★ HTML에 <button id="myLocationBtn">내 위치로</button> 와 같은 버튼이 필요합니다.
// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
// 이 코드는 HTML이 로드된 후 실행되어야 합니다. (예: window.onload 또는 DOMContentLoaded)
// 여기서는 간단히 코드 하단에 배치하거나, HTML 버튼 태그에
// onclick="panToMyLocation()" 을 추가하고 아래 함수를 전역으로 만들 수 있습니다.

// '내 위치로' 버튼 ID를 'myLocationBtn'이라고 가정합니다.
// 실제 HTML에 버튼을 추가해주세요. 예: <div id="menu_wrap">...</div> 위에 <button id="myLocationBtn">내 위치로</button>
// 이 스크립트가 <head>에 있다면, DOM이 로드된 후 리스너를 붙여야 합니다.
document.addEventListener("DOMContentLoaded", function() {
    // DOM이 준비되면 버튼에 이벤트 리스너 추가
    var myLocationBtn = document.getElementById('myLocationBtn');
    if (myLocationBtn) { // 버튼이 존재하는지 확인
        myLocationBtn.onclick = function() {
            if (myLocation) {
                map.setCenter(myLocation); // '내 위치'로 지도 중심 이동
                map.setLevel(3, { animate: true }); // 부드럽게 3레벨로 확대
            } else {
                alert('아직 위치 정보를 가져오지 못했습니다. 잠시 후 다시 시도해주세요.');
            }
        };
    } else {
        console.warn("'myLocationBtn' ID를 가진 버튼을 찾을 수 없습니다.");
    }
});


// 장소 검색 객체를 생성합니다
var ps = new kakao.maps.services.Places();  

// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});

// 키워드로 장소를 검색합니다
// searchPlaces(); // 페이지 로드 시 바로 검색하지 않도록 주석 처리 (보통 검색 버튼 클릭 시 호출)

// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
// ★ (Feature 3) 키워드 검색을 요청하는 함수 (내 위치 주변 검색)
// ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
function searchPlaces() {

    var keyword = document.getElementById('keyword').value;

    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!');
        return false;
    }

    // ★ (Feature 3) '내 위치' 정보가 있으면 검색 옵션에 추가
    var searchOptions = {};
    if (myLocation) {
        searchOptions.location = myLocation; // 검색 중심 위치
        searchOptions.radius = 10000; // 10km (10000m) 반경 내에서 검색
        // searchOptions.sort = kakao.maps.services.SortBy.DISTANCE; // (선택) 거리순 정렬
    }
    
    console.log("검색 옵션:", searchOptions);

    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
    // ★ (Feature 3) 옵션 객체를 함께 전달
    ps.keywordSearch( keyword, placesSearchCB, searchOptions); 
}

const placesList = document.querySelector("#placesList")
const searchResult = document.querySelector(".search-result span");
// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
        // console.log("검색 결과:", data);
        // 정상적으로 검색이 완료됐으면
        // 검색 목록과 마커를 표출합니다
        displayPlaces(data);
        
        // 페이지 번호를 표출합니다
        displayPagination(pagination);
        searchResult.style.display="flex";

    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
        searchResult.style.display="none";  
        placesList.innerHTML = 
                            '<div style="text-align:center; margin-top: 20px;">' + 
                                '<span class="material-symbols-outlined" style="font-size:60px; color:#ccc;">error</span>' + 
                                '<p style="margin-top:10px; font-size:16px; font-weight: 600; color:#ccc;">검색 결과가 없습니다.</p></div>';

        return;

    } else if (status === kakao.maps.services.Status.ERROR) {
        searchResult.style.display="none";
        placesList.innerHTML = '<div style="text-align:center; margin-top: 20px;">' + 
                                '<span class="material-symbols-outlined" style="font-size:60px; color:#FF3B30;">error</span>' + 
                                '<p style="margin-top:10px; font-size:16px; font-weight: 600; color:#FF3B30;">검색 결과 중 오류가 발생했습니다.</p></div>';
        return;

    }
}

// 검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places) {
    var listEl = document.getElementById('placesList'), 
    menuEl = document.getElementById('menu-wrap'),
    fragment = document.createDocumentFragment(), 
    bounds = new kakao.maps.LatLngBounds(), 
    listStr = '';

    // 검색 결과 목록에 추가된 항목들을 제거합니다
    removeAllChildNods(listEl);

    // 지도에 표시되고 있는 마커를 제거합니다
    removeMarker();
    
    for ( var i=0; i<places.length; i++ ) {

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
        (function(marker, place) {
            kakao.maps.event.addListener(marker, 'click', function() {
                // 이미 열려있는 인포윈도우가 현재 마커와 같으면 닫기
                if (customOverlay && customOverlay.getPosition().equals(marker.getPosition())) {
                    closeOverlay();
                } else {
                    displayInfowindow(marker, place);
                }
            });

            // 리스트 클릭 시에도 동일하게 작동
            itemEl.onclick = function () {
                if (customOverlay && customOverlay.getPosition().equals(marker.getPosition())) {
                    closeOverlay();
                } else {
                    displayInfowindow(marker, place);
                }
            };
        })(marker, places[i]);

        fragment.appendChild(itemEl);
    }

    // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;

    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
    map.setBounds(bounds);
}

// 검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places) {

    var el = document.createElement('li'),
    itemStr =   
                '<div class="info">' +
                '   <h4>' + places.place_name + '</h4>';

    if (places.road_address_name) {
        itemStr +=  '   <span>' + places.road_address_name + '</span>' +
                    '   <div class="places-addr-wrapper">'+
                    '   <i class="fa-solid fa-location-dot"></i>' +
                    '   <span class="jibun gray">' +  places.address_name  + '</span></div>';
    } else {
        itemStr += '    <span>' +  places.address_name  + '</span>'; 
    }
       
    if (places.phone && places.phone.trim() !== "") {
        itemStr += 	'<div class="places-phone-wrapper">'+
                    ' <i class="fa-solid fa-phone"></i>' +
                       '   <span class="tel">' + places.phone + '</span></div>';
    }

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
    for ( var i = 0; i < markers.length; i++ ) {
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
        paginationEl.removeChild (paginationEl.lastChild);
    }

    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}
let customOverlay = null;
// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
function displayInfowindow(marker, place) {
    // 커스텀 인포윈도우 내용 구성
    if (customOverlay) {
        customOverlay.setMap(null);
    }
	var directionsLinks = ''
    if (myLocation) {
		// '내 위치'가 있으면 '내 위치' -> '장소'로 길찾기 URL 생성
		
		// 출발지 정보 (내 위치)
		var originName = "내 위치";
		var originLat = myLocation.getLat();
		var originLng = myLocation.getLng();
		var origin = `${originName},${originLat},${originLng}`; // "내 위치,위도,경도"
		
		// 도착지 정보 (클릭한 장소)
		var destName = place.place_name;
		var destLat = place.y;
		var destLng = place.x;
		var dest = `${destName},${destLat},${destLng}`; // "장소이름,위도,경도"

		// 이동수단별 링크 생성
		directionsLinks = `
        <div class="car">
            <i class="fa-solid fa-car"></i><a href="https://map.kakao.com/link/by/car/${origin}/${dest}" target="_blank" title="자동차 길찾기">자동차</a>
        </div>
        <div class="pubtrans">
            <i class="fa-solid fa-bus"></i><a href="https://map.kakao.com/link/by/pubtrans/${origin}/${dest}" target="_blank" title="대중교통 길찾기">대중교통</a>
        </div>
        <div class="walk">
           <i class="fa-solid fa-person-walking"></i><a href="https://map.kakao.com/link/by/walk/${origin}/${dest}" target="_blank" title="도보 길찾기">도보</a>
        </div>
		`;
		
	} else {
		// '내 위치'가 없으면 (geolocation 실패 또는 로딩 중)
		// 기존 방식처럼 단순히 해당 장소를 목적지로만 설정
		directionsLinks = `<a href="https://map.kakao.com/link/to/${place.place_name},${place.y},${place.x}" target="_blank">길찾기</a>`;
	}
	// ★★★★★ (수정 끝) ★★★★★

	var content = `
		<div class="places-info-wrapper">
			<div class="close" onclick="closeOverlay()" title="닫기"></div>
			<p class="places-name">${place.place_name}</p>
			<p style="font-size:16px; font-weight: 600;">${place.road_address_name}</p>
			<p>${place.address_name}</p>
			<div class="phone">
				<i class="fa-solid fa-phone"></i>
				<p class="places-phone">${place.phone}</p>
			</div>
			<div class="places-url">
				${directionsLinks}
				<a href="${place.place_url}" target="_blank">홈페이지</a>
			</div>
		</div>
	`;

	customOverlay = new kakao.maps.CustomOverlay({
		content: content,
		position: marker.getPosition(),
		map: map,
		yAnchor: 1.4 // 마커 위쪽으로 띄우기
	});;
}

function closeOverlay() {
    if (customOverlay) {
        customOverlay.setMap(null);
    }
}
 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
}