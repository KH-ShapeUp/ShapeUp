<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>시설 신규 등록</title>

<!-- 카카오 지도 SDK (autoload=false) -->
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f7deb3a806ca7664155378171a6f8121&libraries=services&autoload=false"></script>

<!-- 다음 우편번호 -->
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/place/insertPlace.css" />
</head>
<body>
	<main class="container">
		<h1 class="page-title">시설 신규 등록</h1>
		<form id="placeRegistrationForm" class="registration-form"
			action="${pageContext.request.contextPath}/place/create"
			method="POST" enctype="multipart/form-data">
			<!-- 기본 정보 -->
			<section class="form-section basic-info">
				<h2>기본 정보</h2>
				<div class="input-group">
					<label for="placeName">시설 이름 <span
						class="required">*</span></label> <input type="text" id="placeName"
						name="placeName" maxlength="50" required />
				</div>
				<div class="input-row">
					<div class="input-group">
						<label for="placeType">시설 분류 <span
							class="required">*</span></label> <select id="placeType" name="placeType"
							required>
							<option value="" disabled selected>분류 선택</option>
							<option value="헬스장">헬스장</option>
							<option value="수영장">수영장</option>
							<option value="풋살장">풋살장(축구장)</option>
							<option value="기타 스포츠">기타 스포츠</option>
						</select>
					</div>
					<div class="input-group">
						<label for="placePrice">이용 가격 (월/시간 기준)</label> <input
							type="number" id="placePrice" name="placePrice"
							placeholder="숫자만 입력" />
					</div>
				</div>
				<div class="input-group">
					<label for="phone">연락처 <span class="required">*</span></label> <input
						type="text" id="phone" name="phone" maxlength="20"
						placeholder="예: 010-1234-5678" required />
				</div>
			</section>

			<hr />

			<!-- 상세 정보 -->
			<section class="form-section detail-info">
				<h2>시설 상세 설명</h2>
				<div class="input-group">
					<label for="placeInfo">시설 소개 및 특징 (최대 1000자)</label>
					<textarea id="placeInfo" name="placeInfo" rows="5" maxlength="1000"
						placeholder="시설의 장점, 이용 방법 등을 상세하게 입력해주세요."></textarea>
				</div>
			</section>

			<hr />

			<!-- 위치 정보 -->
			<section class="form-section location-info">
				<h2>
					위치 정보 <span class="required">*</span>
				</h2>
				<div class="address-input-group">
					<div class="input-group road-name-group">
						<label for="placeRoadName">도로명 주소</label> <input type="text"
							id="placeRoadName" name="placeRoadName" readonly
							placeholder="주소 검색을 통해 자동 입력" /> <input
							type="hidden" id="latitude" name="latitude" /> <input
							type="hidden" id="longitude" name="longitude" />
					</div>
					<button type="button" class="btn btn-search-address"
						onclick="execDaumPostcode()">주소 검색</button>
				</div>
				<div class="input-group">
					<label for="placeLocalName">지번 주소/상세 주소</label> <input type="text"
						id="placeLocalName" name="placeLocalName"
						placeholder="지번 주소 또는 건물/층/호수 등 상세 주소를 입력하세요." />
				</div>
				<div id="mapContainer"
					style="width: 100%; height: 400px; margin-top: 10px">
					주소 검색 후 지도 표시</div>
			</section>

			<hr />

			<!-- 이미지 업로드 -->
			<section class="form-section image-upload">
				<h2>시설 이미지 첨부</h2>
				<p class="guide-text">최소 1개 이상의 시설 사진을 등록해야 합니다. (첫 번째 사진이 대표
					이미지)</p>
				<input type="file" id="placeImages" name="placeImages"
					accept="image/*" multiple required />
				<div id="imagePreview" class="image-preview">업로드된 이미지 미리보기</div>
			</section>

			<hr />

			<div class="action-buttons">
				<button type="submit" class="btn btn-primary">시설 등록하기</button>
				<button type="button" class="btn btn-secondary"
					onclick="window.history.back()">취소</button>
			</div>
		</form>
	</main>

<script type="text/javascript">
let map, marker, geocoder;
let postcodePopup;

// ------------------------------------------
// 1️⃣ 카카오 지도 초기화 함수
// ------------------------------------------
function initKakaoMap() {
    // ⚠️ services 라이브러리가 로드되었는지 확인하고 객체 생성
    if (!window.kakao.maps.services) {
        console.error("Geocoding(services) 라이브러리가 로드되지 않았습니다. API URL을 확인하세요.");
        return;
    }
    
    const container = document.getElementById("mapContainer");
    container.innerHTML = ""; 
    
    map = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 서울 시청 중심
        level: 3
    });
    
    geocoder = new kakao.maps.services.Geocoder();
    
    // 초기 마커는 지도 중앙에 위치
    marker = new kakao.maps.Marker({ 
        position: map.getCenter(),
        map: map
    });
    
    console.log("지도 객체 생성 및 초기화 완료");

    // 🌟 지도 클릭 이벤트 등록 (마커 위치 이동 및 주소 업데이트)
    kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
        const latlng = mouseEvent.latLng;
        
        // 마커 위치 업데이트
        marker.setPosition(latlng);
        
        // 업데이트된 좌표로 주소 역변환 요청
        updateAddressFromCoords(latlng); 
    });

    // 초기 주소 값 설정 및 지도 표시
    const roadName = document.getElementById("placeRoadName").value;
    if (roadName) {
        searchAddrToCoords(roadName);
    } else {
         // 주소가 없으면 초기 중앙 좌표로 위도/경도 필드를 초기화
         const center = map.getCenter();
         document.getElementById("latitude").value = center.getLat();
         document.getElementById("longitude").value = center.getLng();
    }
}


// ------------------------------------------
// 2️⃣ 주소 검색 팝업 (다음 우편번호 API 연동)
// ------------------------------------------
function execDaumPostcode() {
    if (!window.kakao || !window.kakao.maps || !map) {
        alert("지도 API가 로드 중이거나 로드에 실패했습니다. 잠시 후 다시 시도해 주세요.");
        return;
    }
    
    postcodePopup = new daum.Postcode({
        oncomplete: function(data) {
            // 도로명 주소 필드 채우기
            document.getElementById("placeRoadName").value = data.roadAddress;
            
            // 좌표 변환 함수 호출
            searchAddrToCoords(data.roadAddress);

            if(postcodePopup) postcodePopup.close();
        },
        onclose: function(state) {
             if (map && state === 'COMPLETE_CLOSE') {
                 map.relayout();
                 // 팝업 닫고 지도가 제대로 표시되도록 중앙 마커 위치도 재설정
                 marker.setPosition(map.getCenter()); 
             }
        }
    }).open();
}


// ------------------------------------------
// 3️⃣ 주소 → 좌표 → 지도 (Geocoding)
// ------------------------------------------
function searchAddrToCoords(address) {
    if(!map || !geocoder) {
         console.error("오류: 지도 API가 준비되지 않았는데 좌표 검색을 시도했습니다.");
         return; 
    }

    geocoder.addressSearch(address, function(result, status) {
        if(status === kakao.maps.services.Status.OK) {
            const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            
            // 위도/경도 필드 업데이트
            document.getElementById("latitude").value = result[0].y;
            document.getElementById("longitude").value = result[0].x;
            
            // 지도 중심 이동 및 마커 위치 변경
            map.setCenter(coords);
            marker.setPosition(coords);
            map.relayout();
            
        } else {
             alert("주소를 좌표로 변환할 수 없습니다. (상태: " + status + ")");
             console.error("좌표 변환 실패:", status);
        }
    });
}


// ------------------------------------------
// 4️⃣ 좌표 → 주소 역변환 (Reverse Geocoding)
// ------------------------------------------
function updateAddressFromCoords(latlng) {
    if(!geocoder) {
        console.error("지오코더가 초기화되지 않았습니다.");
        return;
    }

    // 좌표를 주소로 변환 요청
    geocoder.coord2Address(latlng.getLng(), latlng.getLat(), function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            let roadAddress = '';
            
            // 도로명 주소(road_address)가 있으면 사용, 없으면 지번 주소(address) 사용
            if (result[0].road_address) {
                roadAddress = result[0].road_address.address_name;
            } else {
                roadAddress = result[0].address.address_name;
            }
            
            // 폼 필드와 hidden 필드 업데이트
            document.getElementById("placeRoadName").value = roadAddress;
            document.getElementById("latitude").value = latlng.getLat();
            document.getElementById("longitude").value = latlng.getLng();
            
            console.log("주소가 클릭에 의해 업데이트되었습니다:", roadAddress);
            
        } else {
            // 역변환 실패 시 좌표는 유지하고 주소 필드만 비움
            document.getElementById("placeRoadName").value = "주소를 찾을 수 없는 위치입니다.";
            console.error("역지오코딩 실패:", status);
        }
    });
}


// ------------------------------------------
// 5️⃣ 페이지 로드 후 API 로드 시작
// ------------------------------------------
window.addEventListener("load", () => {
    // 폼 재로드 시 잔여 값 초기화
    document.getElementById("latitude").value = "";
    document.getElementById("longitude").value = "";

    // API 객체가 로드되었는지 확인하고 콜백을 등록
    if (window.kakao && window.kakao.maps) {
        // kakao.maps.load는 SDK 로드 완료를 보장하며 콜백을 호출합니다.
        // 이때 services 라이브러리가 필요합니다.
        kakao.maps.load(initKakaoMap); 
    } else {
        console.error("카카오 지도 SDK 객체(window.kakao)가 존재하지 않습니다. 스크립트 로드 경로를 확인하세요.");
    }
});
</script>
</body>
</html>
