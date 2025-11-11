<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<style>
.main {
	width: 100%;
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
}

.main-div {
	width: 100%;
	height: 100vh;
	display: flex;
	flex-wrap: nowrap;
	gap: 10px; /* div 사이 여백 */
}

.main-div div {
	width: 100%;
	height: 150px;
	border-radius: 20px;
}


@media screen and (max-width: 768px) {
	.main-div {
		flex-wrap: wrap;  /* 줄 바꿈 허용 */
		height: auto; /* 높이 자동 조절 */
	}
	
	.main-div div {
		width: 100%; /* 한 줄에 하나씩 */
	}
}
</style>
</head>
<body>
	<div class="container">
		<jsp:include page="/WEB-INF/views/include/header.jsp"/>
		<div class="main">
			<div class="main-div">
				<div class="main-1" style="background-color:antiquewhite;"></div>
				<div class="main-2" style="background-color:blue;"></div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	</div>
</body>
</html>