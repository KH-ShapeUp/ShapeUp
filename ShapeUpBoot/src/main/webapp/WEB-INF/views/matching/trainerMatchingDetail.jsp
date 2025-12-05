<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
				<p class="title">트레이닝 매칭</p>
				<div class="board-wrapper">
					<div class="board-wrapper-left">
						<div class="form-group">
							<p class="board-title">제목</p>
						</div>
					</div>
					<div class="board-wrapper-right">

					</div>
				</div>
			</div>
		<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	</div>
</body>
</html>