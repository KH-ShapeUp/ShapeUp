<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
</head>
    <style>
		.main {
			width: 70%;
			display: flex;
			--justify-content: center;
			align-items: center;
		}

		.terms-wrapper {
			width: 80%;
			display: flex;
			flex-direction: column;
			padding: 30px;
			background-color: #fff;
			border-radius: 12px;
			border: 1px solid #ddd;
		}

        .terms-wrapper h1 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .terms-wrapper h2 {
            font-size: 20px;
            margin-top: 25px;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .terms-wrapper p, 
		.terms-wrapper li {
            line-height: 1.6;
            font-size: 15px;
        }

        .terms-wrapper ul {
            padding-left: 18px;
        }
    </style>
<body>
	<div class="container">
		<jsp:include page="/WEB-INF/views/include/header.jsp"/>
			<div class="main">
				<div class="main-title">
					<h1>이용약관</h1>
					<p>본 이용약관은 회원이 서비스를 이용함에 있어 필요한 조건과 절차, <br>회사와 회원 간의 권리∙의무 및 책임 사항 등을 규정하고 있습니다. 서비스를 이용하시기 전에 본 약관을 주의 깊게 읽어주시기 바랍니다.</p>
				</div>
				<div class="terms-wrapper">
					<h2>제 1조 (목적)</h2>
					<p>이 약관은 회사가 제공하는 서비스의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임 사항 등을 규정함을 목적으로 합니다.</p>
	
					<h2>제 2조 (용어의 정의)</h2>
					<ul>
						<li>“회원”이란 본 약관에 따라 서비스를 이용하는 이용자를 말합니다.</li>
						<li>“서비스”란 회사가 제공하는 모든 온라인 기능과 콘텐츠를 말합니다.</li>
						<li>“게시물”이란 회원이 서비스에 게시한 글, 이미지, 댓글 등을 의미합니다.</li>
					</ul>
	
					<h2>제 3조 (약관의 효력 및 변경)</h2>
					<ul>
						<li>본 약관은 서비스를 이용하고자 하는 모든 회원에 대하여 효력이 발생합니다.</li>
						<li>회사는 관련 법령을 위배하지 않는 범위에서 약관을 변경할 수 있습니다.</li>
						<li>약관이 변경되는 경우 회사는 공지사항을 통해 공지합니다.</li>
					</ul>
	
					<h2>제 4조 (회원의 의무)</h2>
					<ul>
						<li>회원은 서비스 이용 시 관련 법령과 약관을 준수해야 합니다.</li>
						<li>다른 회원의 개인정보를 무단으로 수집하거나 이용해서는 안 됩니다.</li>
						<li>회사와 타인의 지식재산권을 침해해서는 안 됩니다.</li>
					</ul>
	
					<h2>제 5조 (회사의 의무)</h2>
					<ul>
						<li>회사는 안정적인 서비스 제공을 위해 노력합니다.</li>
						<li>회원의 개인정보를 관련 법령에 따라 안전하게 보호합니다.</li>
						<li>서비스 장애 발생 시 가능한 신속하게 복구합니다.</li>
					</ul>
	
					<h2>제 6조 (게시물 관리)</h2>
					<ul>
						<li>회원이 작성한 게시물에 대한 책임은 해당 회원에게 있습니다.</li>
						<li>회사 는 법령 또는 약관을 위반한 게시물을 사전 통보 없이 삭제할 수 있습니다.</li>
					</ul>
	
					<h2>제 7조 (서비스 이용제한)</h2>
					<p>회사는 회원이 본 약관을 위반하거나 정상적인 서비스 운영을 방해하는 경우 서비스 이용을 제한할 수 있습니다.</p>
	
					<h2>제 8조 (면책조항)</h2>
					<ul>
						<li>천재지변 등 회사의 책임 없는 사유로 인한 서비스 중단에 대하여 회사는 책임을 지지 않습니다.</li>
						<li>회원의 부주의로 인해 발생한 손해에 대해 회사는 책임을 지지 않습니다.</li>
					</ul>
	
					<h2>제 9조 (기타)</h2>
					<p>본 약관에 명시되지 않은 사항은 관련 법령 및 관례에 따릅니다.</p>
				</div>
			</div>
		<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	</div>
</body>
</html>