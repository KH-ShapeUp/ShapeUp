<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>시설 지도 | ShapeUp</title>
    <jsp:include page="/WEB-INF/views/include/head.jsp"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/map/map.css">
    <link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
</head>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
        <div class="map-wrap">
            <div id="map" style="width:100%;height:100%;">
                <button id="myLocationBtn" class="my-location-btn">
                    <i class="fa-solid fa-crosshairs"></i>
                </button>
            </div>
            <div id="menu-wrap" class="bg_white">
                <div class="option">
                    <div>
                        <form onsubmit="searchPlaces(); return false;">
                            <span class="material-symbols-outlined">search</span>
                            <input type="text" value="헬스장" id="keyword" size="15">
                        </form>
                    </div>
                </div>
                <div class="search-result" style="display: flex; align-items: center; justify-content: space-between;">
                    <h4>검색 결과</h4>
                    <span style="font-size: 13px; font-weight: 600; color: #888; display: none;">10km 이내</span>
                </div>
                <ul id="placesList"></ul>
                <div id="pagination"></div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
    
    <!-- 카카오맵 API 먼저 로드 -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1382c885f22984e6547b8e00aa6fab29&libraries=services"></script>
    
    <!-- map.js는 컨텍스트 경로로 로드 -->
    <script src="${pageContext.request.contextPath}/resources/js/map.js"></script>
</body>
</html>