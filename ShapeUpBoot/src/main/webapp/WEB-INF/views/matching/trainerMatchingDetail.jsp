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

								<c:choose>
									<c:when test="${not empty tmdList.userProfileImg}">
										<img src="${tmdList.userProfileImg}" width="50" alt="프로필">
									</c:when>
									<c:otherwise>
										<img src="../../../resources/img/default-profile.png" width="50" alt="기본 프로필">
									</c:otherwise>
								</c:choose>
							</div>
							<div class="user-info">
								<div class="setting-left">
									<span class="user-name">${tmdList.userName }</span>								
									<div class="setting">
										<c:choose>
											<c:when test="${tmdList.userNo == userNo}">
												<a href="#">수정</a>
												<button onclick="matchingDelete('${tmdList.matchingNo}');">삭제</button>
											</c:when>
											<c:when test="${userType == 'SYSTEM_MANAGER'}">
												<button onclick="matchingDelete('${tmdList.matchingNo}');">삭제</button>
											</c:when>
										</c:choose>
									</div>
								</div>
								<span class="created-date">${tmdList.timeAgo }</span>
							</div>
						</div>
						<div class="matching-category">
							<div class="info">
								<span class="category"># ${tmdList.partnerType }</span>
							</div>
							<div class="user-view">
								<img src="../../../resources/img/star.png">
								<span class="viewAvg">4.8</span>
								<span class="viewCount">(10)</span>
							</div>
							<div class="left-title">${tmdList.matchingTitle }</div>

						</div>
						<div class="left-middle">
							<dic class="left-content">${tmdList.matchingContent }</dic>
						</div>
						<div class="matching-footer">
							<p class="matching-info">매칭 정보</p>
							<div class="location">
								<span class="material-symbols-outlined">location_on</span>
								<span class="location-txt">${tmdList.matchingLocation}</span>
							</div>
							<div class="location">
								<span class="material-symbols-outlined">phone_enabled</span>
								<span class="location-txt">${tmdList.userPhone}</span>
							</div>
							<div class="time">
								<span class="material-symbols-outlined">schedule</span>
								<span class="time-txt">${tmdList.matchingTime}</span>
							</div>
							<div class="badge">
								<span class="material-symbols-outlined">editor_choice</span>
								<span class="badge-txt">${tmdList.career}</span>							
							</div>
							<div class="career-detail">
							    <span class="badge-title">경력 상세 정보</span>
							    <ul class="career-list">
							        <c:forEach var="career" items="${tmdList.careerInfo}">
							            <li class="career-txt">- ${career}</li>
							        </c:forEach>
							    </ul>
							</div>
							<div class="user">
								<span class="material-symbols-outlined">groups</span>
								<span class="user-txt">${tmdList.applyCount}/${tmdList.matchingUserCount} 명</span>
							</div>
							<c:choose>
								<c:when test="${tmdList.matchingStatus == '마감임박'}">
									<button type="button" id="applyBtnImminent"  onclick="applyBtn('${tmdList.matchingNo}', '${tmdList.userNo}');">마감 임박</button>
								</c:when>
								<c:when test="${tmdList.matchingStatus == '마감'}">
									<button type="button" id="applyBtn" disabled>마감</button>
								</c:when>
								<c:otherwise>
									<button type="button" id="applyBtn" onclick="applyBtn('${tmdList.matchingNo}', '${tmdList.userNo}');">신청하기</button>
								</c:otherwise>
							</c:choose>
						</div>
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
			var placeName = "${tmdList.matchingLocation}";
			var lat = "${tmdList.latitude}";
			var lng = "${tmdList.longitude}";		
			var detailInfo = "${tmdList.locationUrl}";

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
		

		function applyBtn(matchingNo, userNo) {
			console.log(matchingNo);
			console.log(userNo);
			Swal.fire({
				title: '해당 매칭을 신청하시겠습니까?',
				showCancelButton: true,
				cancelButtonText: "취소하기",
				confirmButtonText: "신청하기",
				customClass: {
					popup: 'success-popup',
					title: 'success-title',
					confirmButton: 'success-button',
					cancelButton: 'cancel-button'
				}
			}).then(result => {
				if(result.isConfirmed) {
					fetch("/trainer/apply", {
						method: "post",
						headers: {"Content-Type":"application/json"},
						body: JSON.stringify({
							matchingNo: matchingNo,
							userNo: userNo
						})
					})
					.then(res => res.json())
					.then(result => {
						if(result > 0) {
							Swal.fire({
								icon: 'success',
								title: '매칭 신청완료!',
								text: '승인전까지 기다려주세요!',
								confirmButtonText: '확인',
								customClass: {
									popup: 'success-popup',
									title: 'success-title',
									confirmButton: 'success-button',
								}
							}).then(() => {
								location.reload();
							});
						/* 자기가쓴 매칭 신청 방지 */
						} else if (result == -33) {
							Swal.fire({
								icon:'warning',
								title: '자기가 쓴 매칭을 \n 신청할 수 없습니다..ㅠ',
								text: '다른 매칭을 신청해주세요.',
								confirmButtonText: '확인',
								customClass: {
									popup: 'error-popup',
									title: 'error-title',
									text: 'error-text',
									confirmButton: 'error-button'
								}
							});
						/* 재신청 방지 */
						} else if (result == -55) {
							Swal.fire({
								icon:'warning',
								title: '이미 신청한 매칭입니다.',
								text: '다른 매칭을 신청해주세요.',
								confirmButtonText: '확인',
								customClass: {
									popup: 'error-popup',
									title: 'error-title',
									text: 'error-text',
									confirmButton: 'error-button'
								}
							}); 
						} else if (result == -99) {
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
						} else {
						 	Swal.fire({
								icon:'error',
								title: '매칭 신청 실패..ㅠ',
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
							title: '매칭 신청 실패..ㅠ',
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

		function matchingDelete(matchingNo) {
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
					fetch("/trainer/detail?matchingNo=" + matchingNo, {
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
								location.href="/trainer/matching/board";
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
			})
		}
	</script>
</body>
</html>