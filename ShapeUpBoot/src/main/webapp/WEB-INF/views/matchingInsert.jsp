<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
</head>
<body>
    <div class="container">
        <jsp:include page="/WEB-INF/views/include/header.jsp"/>
        <div class="main">
            <div class="matching-title">
                <span>매칭 등록</span>
            </div>
            <div class="matching-warpper">
                <div class="matching-wrapper-left">
                    <div class="form-group">
                        <label for="matchingTitle">매칭 제목</label>
                        <input type="text" name="matchingTitle" id="matchingTitle" placeholder="매칭 제목을 입력해주세요.">
                    </div>
                    <div class="form-group">
                        <label for="matchingContent">매칭 내용</label>
                        <textarea name="matchingContent" id="matchingContent" placeholder="매칭 내용을 입력해주세요."></textarea>
                    </div>
                    <div class="form-group">
                        <label for="matchingLevel">매칭 난이도</label>
                        <input type="radio" name="matchingLevel" id="matchingLevel">
                    </div>
                </div>
                <div class="matching-wrapper-right">

                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    </div>
</body>
</html>