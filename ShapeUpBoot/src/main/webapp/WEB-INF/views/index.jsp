<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp"/>
<link rel="stylesheet" href="../../resources/css/main.css">
</head>
<body>
	<div class="container">
		<jsp:include page="/WEB-INF/views/include/header.jsp"/>
		<div class="main">
			<!-- 광고 div -->
			<div class="ad-wrapper">
			</div>
			<!-- 광고 div 끝 -->

			<!-- 식단, 환영 div -->
			<div class="diet-wrapper">
				<div class="diet-left">
					<!-- 환영 문구-->
					<div class="welcome-text">

					</div>
					<!-- 환영 문구 끝 -->
				</div>

				<div class="diet-right">
					<!-- 아침 -->
					<div class="morning diet-view-wrapper">
						<div class="diet-view-top">
							<h2>아침</h2>
							<img src="../../resources/img/diet-img/morning.png" width="30px">
						</div>
						<div class="diet-view-bottom">
							<span>0 Kcal</span>
						</div>
					</div>
					<!-- 아침 끝 -->

					<!-- 점심 -->
					<div class="lunch diet-view-wrapper">
						<div class="diet-view-top">
							<h2>점심</h2>
							<img src="../../resources/img/diet-img/lunch.png" width="30px">
						</div>
						<div class="diet-view-bottom">
							<span>0 Kcal</span>
						</div>
					</div>
					<!-- 점심 끝 -->

					<!-- 저녁 -->
					<div class="dinner diet-view-wrapper">
							<div class="diet-view-top">
							<h2>저녁</h2>
							<img src="../../resources/img/diet-img/dinner.png" width="30px">
						</div>
						<div class="diet-view-bottom">
							<span>0 Kcal</span>
						</div>
					</div>
					<!-- 저녁 끝 -->

					<!-- 기타 -->
					<div class="other diet-view-wrapper">
							<div class="diet-view-top">
							<h2>기타</h2>
							<img src="../../resources/img/diet-img/other.png" width="30px">
						</div>
						<div class="diet-view-bottom">
							<span>0 Kcal</span>
						</div>
					</div>
					<!-- 기타 끝 -->

					<!--**********-->

					<!-- 탄수화물 -->
					<div class="carb detail-wrapper">
						<div class="detail-view-top">
							<h3>탄수화물</h3>
						</div>
						<div class="detail-view-bottom">
							<span>0 g</span>
						</div>
					</div>
					<!-- 탄수화물 끝 -->

					<!-- 단백질 -->
					<div class="protein detail-wrapper">
						<div class="detail-view-top">
							<h3>단백질</h3>
						</div>
						<div class="detail-view-bottom">
							<span>0 g</span>
						</div>
					</div>
					<!-- 단백질 끝 -->

					<!-- 지방 -->
					<div class="fat detail-wrapper">
						<div class="detail-view-top">
							<h3>지방</h3>
						</div>
						<div class="detail-view-bottom">
							<span>0 g</span>
						</div>
					</div>
					<!-- 지방 끝-->

				</div>
			</div>
			<!-- 식단 div 끝 -->

			<!-- 최근 올라온 매칭 -->
			<div class="recent-matching-wrapper">
				<div class="matching">
					<div class="match">
						<h2>최근에 올라온 매칭</h2>
						<span>회원님과 맞는 매칭을 찾아보세요.</span>
					</div>
					<div class="matching-all-btn">
						<a href="#" id="matching-all-list-btn">더보기
							<i class="fa-solid fa-arrow-right"></i>
						</a>
					</div>
				</div>
				<div class="matching-content">
					<div class="matching-card">
						<div class="matching-user">
							<div class="user-profile">
								<img src="../../resources/img/person.png" alt="">
							</div>
							<div class="user-profile-info">
								<span class="nick-name">윤태혁&nbsp;(남)</span>
								<span class="workout-category">런닝</span>
							</div>
						</div>
						<div class="matching-title">
							<h3>한강에서 런닝하실분</h3>
						</div>
						<div class="matching-info">
							<div class="matching-location">
								<i class="fa-solid fa-location-dot"></i>
								<span>도봉산</span>
							</div>
							<div class="matching-time">
								<i class="fa-solid fa-clock"></i>
								<span>3시간</span>
							</div>
							<div class="matching-day">
								<i class="fa-solid fa-calendar-days"></i>
								<span>2025.12.25</span>
							</div>
							<div class="matching-money">
								<i class="fa-solid fa-wallet"></i>
								<span>없음</span>
							</div>
						</div>
						<div class="matching-btn-wrapper">
							<button id="matching-btn">매칭 신청</button>
						</div>
					</div>
					<div class="matching-card">
						<div class="matching-user">
							<div class="user-profile">
								<img src="../../resources/img/person.png" alt="">
							</div>
							<div class="user-profile-info">
								<span class="nick-name">윤태혁&nbsp;(남)</span>
								<span class="workout-category">런닝</span>
							</div>
						</div>
						<div class="matching-title">
							<h3>한강에서 런닝하실분</h3>
						</div>
						<div class="matching-info">
							<div class="matching-location">
								<i class="fa-solid fa-location-dot"></i>
								<span>도봉산</span>
							</div>
							<div class="matching-time">
								<i class="fa-solid fa-clock"></i>
								<span>3시간</span>
							</div>
							<div class="matching-day">
								<i class="fa-solid fa-calendar-days"></i>
								<span>2025.12.25</span>
							</div>
							<div class="matching-money">
								<i class="fa-solid fa-wallet"></i>
								<span>없음</span>
							</div>
						</div>
						<div class="matching-btn-wrapper">
							<button id="matching-btn">매칭 신청</button>
						</div>
					</div>
					<div class="matching-card">
						<div class="matching-user">
							<div class="user-profile">
								<img src="../../resources/img/person.png" alt="">
							</div>
							<div class="user-profile-info">
								<span class="nick-name">윤태혁&nbsp;(남)</span>
								<span class="workout-category">런닝</span>
							</div>
						</div>
						<div class="matching-title">
							<h3>한강에서 런닝하실분</h3>
						</div>
						<div class="matching-info">
							<div class="matching-location">
								<i class="fa-solid fa-location-dot"></i>
								<span>도봉산</span>
							</div>
							<div class="matching-time">
								<i class="fa-solid fa-clock"></i>
								<span>3시간</span>
							</div>
							<div class="matching-day">
								<i class="fa-solid fa-calendar-days"></i>
								<span>2025.12.25</span>
							</div>
							<div class="matching-money">
								<i class="fa-solid fa-wallet"></i>
								<span>없음</span>
							</div>
						</div>
						<div class="matching-btn-wrapper">
							<button id="matching-btn">매칭 신청</button>
						</div>
					</div>

				</div>
			</div>
			<!-- 최근 올라온 매칭 끝 -->
			
			<!-- 성공 후기 div -->
			<div class="goal-wrapper">
				<div class="goal-left-content">
					<div class="goal-top">
						<div class="goal">
							<h2>성공 후기</h2>
							<span>다른 회원들의 성공 스토리를 확인하세요.</span>
						</div>
						<div class="goal-all">
							<a href="#" id="goal-all-list-btn">더보기
								<i class="fa-solid fa-arrow-right"></i>
							</a>
						</div>
					</div>

					<div class="goal-content">
						<a href="#">
							<div class="goal-card">
								<div class="goal-user-profile">
									<div class="profile-img">
										<img src="../../resources/img/person.png">
									</div>
									<div class="profile-info">
										<span class="writer">윤태혁</span>
										<span class="writerDate">2025.11.13</span>
									</div>
								</div>
								<div class="goal-title">
									<span>3개월만에 20감량</span>
								</div>
								<div class="goal-setting">
									<div class="goal-view">
										<i class="fa-solid fa-eye"></i>
										<span>1,203</span>
									</div>
									<div class="goal-comment">
										<i class="fa-solid fa-comments"></i>
										<span>30</span>
									</div>
									<div class="goal-good">
										<i class="fa-solid fa-thumbs-up"></i>
										<span>38</span>
									</div>
								</div>
							</div>
						</a>				
						<a href="#">
							<div class="goal-card">
								<div class="goal-user-profile">
									<div class="profile-img">
										<img src="../../resources/img/person.png">
									</div>
									<div class="profile-info">
										<span class="writer">윤태혁</span>
										<span class="writerDate">2025.11.13</span>
									</div>
								</div>
								<div class="goal-title">
									<span>3개월만에 20감량</span>
								</div>
								<div class="goal-setting">
									<div class="goal-view">
										<i class="fa-solid fa-eye"></i>
										<span>1,203</span>
									</div>
									<div class="goal-comment">
										<i class="fa-solid fa-comments"></i>
										<span>30</span>
									</div>
									<div class="goal-good">
										<i class="fa-solid fa-thumbs-up"></i>
										<span>38</span>
									</div>
								</div>
							</div>
						</a>				
						<a href="#">
							<div class="goal-card">
								<div class="goal-user-profile">
									<div class="profile-img">
										<img src="../../resources/img/person.png">
									</div>
									<div class="profile-info">
										<span class="writer">윤태혁</span>
										<span class="writerDate">2025.11.13</span>
									</div>
								</div>
								<div class="goal-title">
									<span>3개월만에 20감량</span>
								</div>
								<div class="goal-setting">
									<div class="goal-view">
										<i class="fa-solid fa-eye"></i>
										<span>1,203</span>
									</div>
									<div class="goal-comment">
										<i class="fa-solid fa-comments"></i>
										<span>30</span>
									</div>
									<div class="goal-good">
										<i class="fa-solid fa-thumbs-up"></i>
										<span>38</span>
									</div>
								</div>
							</div>
						</a>				
						<a href="#">
							<div class="goal-card">
								<div class="goal-user-profile">
									<div class="profile-img">
										<img src="../../resources/img/person.png">
									</div>
									<div class="profile-info">
										<span class="writer">윤태혁</span>
										<span class="writerDate">2025.11.13</span>
									</div>
								</div>
								<div class="goal-title">
									<span>3개월만에 20감량</span>
								</div>
								<div class="goal-setting">
									<div class="goal-view">
										<i class="fa-solid fa-eye"></i>
										<span>1,203</span>
									</div>
									<div class="goal-comment">
										<i class="fa-solid fa-comments"></i>
										<span>30</span>
									</div>
									<div class="goal-good">
										<i class="fa-solid fa-thumbs-up"></i>
										<span>38</span>
									</div>
								</div>
							</div>
						</a>				
						<a href="#">
							<div class="goal-card">
								<div class="goal-user-profile">
									<div class="profile-img">
										<img src="../../resources/img/person.png">
									</div>
									<div class="profile-info">
										<span class="writer">윤태혁</span>
										<span class="writerDate">2025.11.13</span>
									</div>
								</div>
								<div class="goal-title">
									<span>3개월만에 20감량</span>
								</div>
								<div class="goal-setting">
									<div class="goal-view">
										<i class="fa-solid fa-eye"></i>
										<span>1,203</span>
									</div>
									<div class="goal-comment">
										<i class="fa-solid fa-comments"></i>
										<span>30</span>
									</div>
									<div class="goal-good">
										<i class="fa-solid fa-thumbs-up"></i>
										<span>38</span>
									</div>
								</div>
							</div>
						</a>								
						<a href="#">
							<div class="goal-card">
								<div class="goal-user-profile">
									<div class="profile-img">
										<img src="../../resources/img/person.png">
									</div>
									<div class="profile-info">
										<span class="writer">윤태혁</span>
										<span class="writerDate">2025.11.13</span>
									</div>
								</div>
								<div class="goal-title">
									<span>3개월만에 20감량</span>
								</div>
								<div class="goal-setting">
									<div class="goal-view">
										<i class="fa-solid fa-eye"></i>
										<span>1,203</span>
									</div>
									<div class="goal-comment">
										<i class="fa-solid fa-comments"></i>
										<span>30</span>
									</div>
									<div class="goal-good">
										<i class="fa-solid fa-thumbs-up"></i>
										<span>38</span>
									</div>
								</div>
							</div>
						</a>				
					</div>
				</div>


				<div class="goal-right">
					<!-- 공지 사항 -->
					<div class="post-left-notice">
						<h3 class="goal-wrapper-title">공지사항 & 이벤트</h3>
						<div class="notice-content">					
							<a href="#" class="notice-ahref">
								<div class="notice-card">
									<div class="notice-top">
										<span class="notice-category-e">이벤트</span>
										<span class="notice-writeDate">2025.10.08</span>
									</div>
									<div class="notice-main">
										<div class="notice-middle">
											<h4>시스템 정기 점검 안내 <span class="notice-comment">(30)</span></h4>
										</div>							
										<div class="notice-icon">
											<div>
												<i class="fa-solid fa-eye"></i>
												<span>1,203</span>
											</div>
											<div>
												<i class="fa-solid fa-thumbs-up"></i>
												<span>38</span>
											</div>
										</div>																	
									</div>
								</div>
							</a>
							<a href="#" class="notice-ahref">
								<div class="notice-card">
									<div class="notice-top">
										<span class="notice-category-e">이벤트</span>
										<span class="notice-writeDate">2025.10.08</span>
									</div>
									<div class="notice-main">
										<div class="notice-middle">
											<h4>시스템 정기 점검 안내 <span class="notice-comment">(30)</span></h4>
										</div>							
										<div class="notice-icon">
											<div>
												<i class="fa-solid fa-eye"></i>
												<span>1,203</span>
											</div>
											<div>
												<i class="fa-solid fa-thumbs-up"></i>
												<span>38</span>
											</div>
										</div>																	
									</div>
								</div>
							</a>
							<a href="#" class="notice-ahref">
								<div class="notice-card">
									<div class="notice-top">
										<span class="notice-category-c">제휴</span>
										<span class="notice-writeDate">2025.10.08</span>
									</div>
									<div class="notice-main">
										<div class="notice-middle">
											<h4>시스템 정기 점검 안내 <span class="notice-comment">(30)</span></h4>
										</div>							
										<div class="notice-icon">
											<div>
												<i class="fa-solid fa-eye"></i>
												<span>1,203</span>
											</div>
											<div>
												<i class="fa-solid fa-thumbs-up"></i>
												<span>38</span>
											</div>
										</div>																	
									</div>
								</div>
							</a>
							<a href="#" class="notice-ahref">
								<div class="notice-card">
									<div class="notice-top">
										<span class="notice-category-n">공지</span>
										<span class="notice-writeDate">2025.10.08</span>
									</div>
									<div class="notice-main">
										<div class="notice-middle">
											<h4>시스템 정기 점검 안내 <span class="notice-comment">(30)</span></h4>
										</div>							
										<div class="notice-icon">
											<div>
												<i class="fa-solid fa-eye"></i>
												<span>1,203</span>
											</div>
											<div>
												<i class="fa-solid fa-thumbs-up"></i>
												<span>38</span>
											</div>
										</div>																	
									</div>
								</div>
							</a>
							<a href="#" class="notice-ahref">
								<div class="notice-card">
									<div class="notice-top">
										<span class="notice-category-d">징계</span>
										<span class="notice-writeDate">2025.10.08</span>
									</div>
									<div class="notice-main">
										<div class="notice-middle">
											<h4>시스템 정기 점검 안내 <span class="notice-comment">(30)</span></h4>
										</div>							
										<div class="notice-icon">
											<div>
												<i class="fa-solid fa-eye"></i>
												<span>1,203</span>
											</div>
											<div>
												<i class="fa-solid fa-thumbs-up"></i>
												<span>38</span>
											</div>
										</div>																	
									</div>
								</div>
							</a>
						</div>
					</div>

					<!-- 자유게시판 -->
					<div class="post-right-free">
						<h3 class="post-wrapper-title">자유 게시판</h3>
						<div class="post-content">
							<a href="#" class="post-ahref">
								<div class="post-card">
									<div class="post-header">
										<div class="post-header-left">
											<span class="post-category">자유 게시판</span>
											<span class="post-nickName">윤태혁</span>
											<span class="post-writeDate">2025.01.25</span>
										</div>
										<div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span>1,203</span></div>
											<div><i class="fa-solid fa-thumbs-up"></i><span>38</span></div>
										</div>
									</div>
									<div class="post-middle">
										<span class="post-title">등운동시 광배에 자극이 없어요..</span>
										<span class="post-comment">(10)</span>
									</div>
								</div>
							</a>
							<a href="#" class="post-ahref">
								<div class="post-card">
									<div class="post-header">
										<div class="post-header-left">
											<span class="post-category">자유 게시판</span>
											<span class="post-nickName">윤태혁</span>
											<span class="post-writeDate">2025.01.25</span>
										</div>
										<div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span>1,203</span></div>
											<div><i class="fa-solid fa-thumbs-up"></i><span>38</span></div>
										</div>
									</div>
									<div class="post-middle">
										<span class="post-title">등운동시 광배에 자극이 없어요..</span>
										<span class="post-comment">(10)</span>
									</div>
								</div>
							</a>
							<a href="#" class="post-ahref">
								<div class="post-card">
									<div class="post-header">
										<div class="post-header-left">
											<span class="post-category">자유 게시판</span>
											<span class="post-nickName">윤태혁</span>
											<span class="post-writeDate">2025.01.25</span>
										</div>
										<div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span>1,203</span></div>
											<div><i class="fa-solid fa-thumbs-up"></i><span>38</span></div>
										</div>
									</div>
									<div class="post-middle">
										<span class="post-title">등운동시 광배에 자극이 없어요..</span>
										<span class="post-comment">(10)</span>
									</div>
								</div>
							</a>
							<a href="#" class="post-ahref">
								<div class="post-card">
									<div class="post-header">
										<div class="post-header-left">
											<span class="post-category">자유 게시판</span>
											<span class="post-nickName">윤태혁</span>
											<span class="post-writeDate">2025.01.25</span>
										</div>
										<div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span>1,203</span></div>
											<div><i class="fa-solid fa-thumbs-up"></i><span>38</span></div>
										</div>
									</div>
									<div class="post-middle">
										<span class="post-title">등운동시 광배에 자극이 없어요..</span>
										<span class="post-comment">(10)</span>
									</div>
								</div>
							</a>
							<a href="#" class="post-ahref">
								<div class="post-card">
									<div class="post-header">
										<div class="post-header-left">
											<span class="post-category">자유 게시판</span>
											<span class="post-nickName">윤태혁</span>
											<span class="post-writeDate">2025.01.25</span>
										</div>
										<div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span>1,203</span></div>
											<div><i class="fa-solid fa-thumbs-up"></i><span>38</span></div>
										</div>
									</div>
									<div class="post-middle">
										<span class="post-title">등운동시 광배에 자극이 없어요..</span>
										<span class="post-comment">(10)</span>
									</div>
								</div>
							</a>
							<a href="#" class="post-ahref">
								<div class="post-card">
									<div class="post-header">
										<div class="post-header-left">
											<span class="post-category">자유 게시판</span>
											<span class="post-nickName">윤태혁</span>
											<span class="post-writeDate">2025.01.25</span>
										</div>
										<div class="post-icon">
											<div><i class="fa-solid fa-eye"></i><span>1,203</span></div>
											<div><i class="fa-solid fa-thumbs-up"></i><span>38</span></div>
										</div>
									</div>
									<div class="post-middle">
										<span class="post-title">등운동시 광배에 자극이 없어요..</span>
										<span class="post-comment">(10)</span>
									</div>
								</div>
							</a>
						</div>							
					</div>
				</div>
			</div>
			<!-- 성공 후기 div 끝 -->
		</div>
		<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	</div>
</body>
</html>