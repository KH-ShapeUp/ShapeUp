<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../resources/css/matching/trainerMatchingDetail.css">
</head>
<body>
	<div class="container">
		<jsp:include page="/WEB-INF/views/include/header.jsp"/>
			<div class="main">
				<div class="board-wrapper">
					<div class="board-wrapper-left">
						<div class="left-top">
							<div class="user-img">
								<!-- ⭐ 프로필 이미지 동적 처리 -->
								<c:choose>
									<c:when test="${not empty mList.userProfileImg}">
										<img src="${pageContext.request.contextPath}${mList.userProfileImg}" 
										     alt="프로필 이미지"
										     onerror="this.src='${pageContext.request.contextPath}/resources/img/default-profile.png'">
									</c:when>
									<c:otherwise>
										<img src="${pageContext.request.contextPath}/resources/img/default-profile.png" 
										     alt="기본 프로필">
									</c:otherwise>
								</c:choose>
							</div>
							<div class="user-info">
								<span class="user-name">${mList.userName}</span>								
								<span class="created-date">${mList.timeAgo}</span>
							</div>
						</div>
						<div class="matching-category">
							<div class="info">
								<span class="category"># ${mList.partnerType}</span>
							</div>
							<div class="user-view">
								<img src="../../../resources/img/star.png">
								<span class="viewAvg">4.8</span>
								<span class="viewCount">(10)</span>
							</div>
							<div class="left-title">${mList.matchingTitle}</div>
						</div>
						<div class="left-middle">
							<dic class="left-content">${mList.matchingContent}</dic>
						</div>
						<div class="matching-footer">
							<p class="matching-info">매칭 정보</p>
							<div class="location">
								<span class="material-symbols-outlined">location_on</span>
								<span class="location-txt">${mList.matchingLocation}</span>
							</div>
							<div class="time">
								<span class="material-symbols-outlined">schedule</span>
								<span class="time-txt">${mList.matchingTime}</span>
							</div>
							<div class="badge">
								<span class="material-symbols-outlined">editor_choice</span>
								<span class="badge-txt">${mList.career}</span>							
							</div>
							<div class="career-detail hidden">
								<span class="badge-title">상세 정보</span>
								<span class="badge-txt">${mList.careerDetail}</span>
							</div>
							<div class="user">
								<span class="material-symbols-outlined">groups</span>
								<span class="user-txt">${mList.matchingUserCount} 명</span>
							</div>
						</div>
						<button type="button" id="applyBtn">
							신청하기
						</button>
					</div>
					<div class="board-wrapper-right">
 						<div id="map"></div>
					</div>
				</div>
			</div>
		<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	</div>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1382c885f22984e6547b8e00aa6fab29"></script>
	<script>	
		document.addEventListener("DOMContentLoaded", function () {
			var placeName = "${mList.matchingLocation}";
			var lat = "${mList.latitude}";
			var lng = "${mList.longitude}";		
			var detailInfo = "${mList.locationUrl}";

			var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
			mapOption = { 
					center: new kakao.maps.LatLng(lat, lng), // 지도의 중심좌표
					level: 3 // 지도의 확대 레벨
				};
	
			var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
			
			// 마커가 표시될 위치입니다 
			var markerPosition  = new kakao.maps.LatLng(lat, lng); 
			
			// 마커를 생성합니다
			var imgSrc = '../../resources/img/map-marker.png';
			var imgSize = new kakao.maps.Size(60,60);
			var markerImg = new kakao.maps.MarkerImage(imgSrc, imgSize);
			
			var marker = new kakao.maps.Marker({
				position: markerPosition,
				image: markerImg
			});
			
			// 마커가 지도 위에 표시되도록 설정합니다
			marker.setMap(map);
			var mapTypeControl = new kakao.maps.MapTypeControl();
			map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
			
			var overlay = null;
			var linkUrl = "https://map.kakao.com/link/map/" + placeName + "," + lat + "," + lng;
			var findUrl = "";
        
			// 모바일 기기인지 체크
			var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);

			if (isMobile) {
				// [모바일] 카카오맵 앱 호출
				// ep: 도착지(End Point), by: 이동수단(CAR)
				// 출발지(sp)를 생략하면 자동으로 '현위치(GPS)'가 됩니다.
				findUrl = "kakaomap://route?ep=" + lat + "," + lng + "&by=CAR";
			} else {
				// [PC] 카카오맵 웹사이트 연결
				// 웹에서는 보안상 자동으로 GPS를 잡지 못할 수 있어 일반 길찾기 페이지로 보냅니다.
				findUrl = "https://map.kakao.com/link/to/" + placeName + "," + lat + "," + lng;
			}	
	
			var content = `
				<div class="overlay-info">
					<div class="info-top">
						<strong>\${placeName}</strong>					
					</div>
					<div class="info-footer">
						<a href="\${detailInfo}" target="_blank">상세정보</a>
						<a href="\${findUrl}" target="_blank">길찾기</a>
					</div>
				</div>
			`;

				
			   var iwPosition = new kakao.maps.LatLng(lat, lng); //인포윈도우 표시 위치입니다
	
			   overlay = new kakao.maps.CustomOverlay({
				content: content,
				map: map,                // map을 지정하면 바로 지도에 표시됩니다.
				position: markerPosition,// 마커와 같은 위치
				yAnchor: 1.7               // 1로 설정하면 오버레이의 바닥 중앙이 좌표에 위치합니다 (마커 바로 위)
			});
		});
		
	</script>
</body>
</html>