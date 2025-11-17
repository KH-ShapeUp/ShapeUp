<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
				<div class="diet-wrapper-title">
					<h2>오늘의 칼로리</h2>
					<span>오늘의 식단을 관리하세요.</span>
				</div>
				<div class="diet-content${empty sessionScope.loginUser ? ' locked' : ''}">
					<!-- 로그인 안했을 때 식단 표시-->
					<!-- <c:if test="${empty sessionScope.loginUser}">
						<div class="diet-lock-overlay">
							<span class="material-symbols-outlined">lock_person</span>
							<p>칼로리를 입력하려면 로그인이 필요합니다.</p>
							<a href="login"><button class="btn-login" type="button">로그인</button></a>
						</div>
					</c:if> -->
					<!-- 로그인 안했을 때 식단 표시 끝 -->
					<!-- 아침 -->
					<div class="user-diet-record" style="border-top: 4px solid #F2B84B;">
						<a href="morning">
							<div class="title">
								<i class="fa-solid fa-mug-saucer"></i>
								<div class="title-info">
									<h3>아침</h3>
									<p>07:30 AM</p>
								</div>	
							</div>
							<div class="info">
								<div class="cal">섭취칼로리</div>
								<h2 class="cal-num">450</h2>
							</div>
							<div class="progress" id="progressWrapper-m">
								<div class="progress-out" id="progressOut-m">
									<div class="progress-in" id="progressIn-m"></div>
								</div>
							</div>
							<div class="meta">목표 : 500 Kcal</div>
						</a>
					</div>
	
					<!-- 점심 -->
					<div class="user-diet-record" style="border-top: 4px solid #2E8CFF;">
						<a href="lunch">
							<div class="title">
								<i class="fa-solid fa-utensils"></i>
								<div class="title-info">
									<h3>점심</h3>
									<p>13:30 PM</p>
								</div>	
							</div>
							<div class="info">
								<div class="cal">섭취칼로리</div>
								<h2 class="cal-num">650</h2>
							</div>
							<div class="progress" id="progressWrapper-l">
								<div class="progress-out" id="progressOut-l">
									<div class="progress-in" id="progressIn-l"></div>
								</div>
							</div>
							<div class="meta">목표 : 680 Kcal</div>
						</a>
					</div>
	
					<!-- 저녁 -->
					<div class="user-diet-record" style="border-top: 4px solid #F25C5C;">
						<a href="dinner">
							<div class="title">
								<i class="fa-solid fa-bowl-food"></i>
								<div class="title-info">
									<h3>저녁</h3>
									<p>18:30 PM</p>
								</div>	
							</div>
							<div class="info">
								<div class="cal">섭취칼로리</div>
								<h2 class="cal-num">350</h2>
							</div>
							<div class="progress" id="progressWrapper-d">
								<div class="progress-out" id="progressOut-d">
									<div class="progress-in" id="progressIn-d"></div>
								</div>
							</div>
							<div class="meta">목표 : 550 Kcal</div>
						</a>
					</div>
	
					<!-- 기타 -->
					<div class="user-diet-record" style="border-top: 4px solid #C58C5D;">
						<a href="other">
							<div class="title">
								<i class="fa-solid fa-cookie-bite"></i>
								<div class="title-info">
									<h3>기타</h3>
									<p>간식 / 음료</p>
								</div>	
							</div>
							<div class="info">
								<div class="cal">섭취칼로리</div>
								<h2 class="cal-num">50</h2>
							</div>
							<div class="progress" id="progressWrapper-o">
								<div class="progress-out" id="progressOut-o">
									<div class="progress-in" id="progressIn-o"></div>
								</div>
							</div>
							<div class="meta">목표 : 500 Kcal</div>	
						</a>
					</div>
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
						<a href="/matching" class="all-page-btn" id="matching-all-list-btn">더보기
							<i class="fa-solid fa-arrow-right"></i>
						</a>
					</div>
				</div>
				<div class="matching-content">
					<div class="matching-card" onclick="matchingDetail('${boardNo}');">
						<div class="matching-user">
							<div class="user-profile">
								<img src="../../resources/img/person.png" width="50">
							</div>
							<div class="user-profile-info">
								<div class="user-profile-top">
									<div class="user-info">
										<span class="nick-name">윤태혁</span>
										<span class="user-gender">(남)</span>
									</div>
									<div class="card-state-ing">모집중</div>
								</div>
								<span class="workout-category">런닝</span>
							</div>
						</div>
						<div class="matching-title">
							<span class="card-title">한강에서 런닝하실분</span>
							<span class="card-content">
								주 3회 저녁 7시~9시 운동하고 있습니다. 
								다이어트 목표로 운동 중이라 함께 동기부여 받으며 운동하실 분 찾습니다.
							</span>
						</div>
						<div class="matching-info">
							<div class="matching-icon">
								<div class="matching-location">
									<i class="fa-solid fa-location-dot"></i>
									<span>도봉산</span>
								</div>
								<div class="matching-day">
									<i class="fa-solid fa-calendar-days"></i>
									<span>2025.11.14</span>
								</div>
								<div class="matching-time">
									<i class="fa-solid fa-clock"></i>
									<span>22:00 ~ 23:00</span>
								</div>
								<div class="matching-money">
									<i class="fa-solid fa-wallet"></i>
									<span>없음</span>
								</div>
								<div class="matching-user-icon">
									<i class="fa-solid fa-users"></i>
									<span>0/1명</span>
								</div>
							</div>
							<div class="matching-btn-wrapper">
								<button class="matching-btn">매칭 신청</button>
							</div>
						</div>
					</div>				
					<div class="matching-card" onclick="matchingDetail('${boardNo}');">
						<div class="matching-user">
							<div class="user-profile">
								<img src="../../resources/img/person.png">
							</div>
							<div class="user-profile-info">
								<div class="user-profile-top">
									<div class="user-info">
										<span class="nick-name">윤태혁</span>
										<span class="user-gender">(남)</span>
									</div>
									<div class="card-state-ing">모집중</div>
								</div>
								<span class="workout-category">런닝</span>
							</div>
						</div>
						<div class="matching-title">
							<span class="card-title">한강에서 런닝하실분</span>
							<span class="card-content">
								주 3회 저녁 7시~9시 운동하고 있습니다. 
								다이어트 목표로 운동 중이라 함께 동기부여 받으며 운동하실 분 찾습니다.
							</span>
						</div>
						<div class="matching-info">
							<div class="matching-icon">
								<div class="matching-location">
									<i class="fa-solid fa-location-dot"></i>
									<span>도봉산</span>
								</div>
								<div class="matching-day">
									<i class="fa-solid fa-calendar-days"></i>
									<span>2025.11.14</span>
								</div>
								<div class="matching-time">
									<i class="fa-solid fa-clock"></i>
									<span>22:00 ~ 23:00</span>
								</div>
								<div class="matching-money">
									<i class="fa-solid fa-wallet"></i>
									<span>없음</span>
								</div>
								<div class="matching-user-icon">
									<i class="fa-solid fa-users"></i>
									<span>0/1명</span>
								</div>
							</div>
							<div class="matching-btn-wrapper">
								<button class="matching-btn">매칭 신청</button>
							</div>
						</div>
					</div>				
					<div class="matching-card" onclick="matchingDetail('${boardNo}');">
						<div class="matching-user">
							<div class="user-profile">
								<img src="../../resources/img/person.png" width="50">
							</div>
							<div class="user-profile-info">
								<div class="user-profile-top">
									<div class="user-info">
										<span class="nick-name">윤태혁</span>
										<span class="user-gender">(남)</span>
									</div>
									<div class="card-state-ing">모집중</div>
								</div>
								<span class="workout-category">런닝</span>
							</div>
						</div>
						<div class="matching-title">
							<span class="card-title">한강에서 런닝하실분</span>
							<span class="card-content">
								주 3회 저녁 7시~9시 운동하고 있습니다. 
								다이어트 목표로 운동 중이라 함께 동기부여 받으며 운동하실 분 찾습니다.
							</span>
						</div>
						<div class="matching-info">
							<div class="matching-icon">
								<div class="matching-location">
									<i class="fa-solid fa-location-dot"></i>
									<span>도봉산</span>
								</div>
								<div class="matching-day">
									<i class="fa-solid fa-calendar-days"></i>
									<span>2025.11.14</span>
								</div>
								<div class="matching-time">
									<i class="fa-solid fa-clock"></i>
									<span>22:00 ~ 23:00</span>
								</div>
								<div class="matching-money">
									<i class="fa-solid fa-wallet"></i>
									<span>없음</span>
								</div>
								<div class="matching-user-icon">
									<i class="fa-solid fa-users"></i>
									<span>0/1명</span>
								</div>
							</div>
							<div class="matching-btn-wrapper">
								<button class="matching-btn">매칭 신청</button>
							</div>
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
							<a href="#" class="all-page-btn" id="goal-all-list-btn">더보기
								<i class="fa-solid fa-arrow-right"></i>
							</a>
						</div>
					</div>

					<div class="goal-content">
						<a href="#">
							<div class="goal-card">
								<div class="goal-card-top">
									<div class="goal-profile-img">
										<img src="../../resources/img/person.png" alt="">
									</div>
									<div class="goal-profile-info">
										<span>윤태혁</span>
										<span>2025.10.31</span>
									</div>
								</div>

								<div class="goal-main">
									<div class="goal-title">
										<h4>3개월만에 20kg 감량</h4>
										<div class="goal-icon">
												<div class="goal-view">
													<i class="fa-solid fa-eye"></i>
													<span>1,203</span>
												</div>
												<div class="goal-good">
													<i class="fa-solid fa-thumbs-up"></i>
													<span>38</span>
												</div>
											</div>
									</div>
									<div class="goal-middle">
										<div class="goal-content">아침엔 고구마와 방울토마토, 점심엔...</div>
										<span class="goal-comment">(120)</span>
									</div>
								</div>
							</div>
						</a>			
						<a href="#">
							<div class="goal-card">
								<div class="goal-card-top">
									<div class="goal-profile-img">
										<img src="../../resources/img/person.png">
									</div>
									<div class="goal-profile-info">
										<span>윤태혁</span>
										<span>2025.10.31</span>
									</div>
								</div>

								<div class="goal-main">
									<div class="goal-title">
										<h4>3개월만에 20kg 감량</h4>
										<div class="goal-icon">
												<div class="goal-view">
													<i class="fa-solid fa-eye"></i>
													<span>1,203</span>
												</div>
												<div class="goal-good">
													<i class="fa-solid fa-thumbs-up"></i>
													<span>38</span>
												</div>
											</div>
									</div>
									<div class="goal-middle">
										<div class="goal-content">아침엔 고구마와 방울토마토, 점심엔...</div>
										<span class="goal-comment">(120)</span>
									</div>
								</div>
							</div>
						</a>			
						<a href="#">
							<div class="goal-card">
								<div class="goal-card-top">
									<div class="goal-profile-img">
										<img src="../../resources/img/person.png" alt="">
									</div>
									<div class="goal-profile-info">
										<span>윤태혁</span>
										<span>2025.10.31</span>
									</div>
								</div>

								<div class="goal-main">
									<div class="goal-title">
										<h4>3개월만에 20kg 감량</h4>
										<div class="goal-icon">
												<div class="goal-view">
													<i class="fa-solid fa-eye"></i>
													<span>1,203</span>
												</div>
												<div class="goal-good">
													<i class="fa-solid fa-thumbs-up"></i>
													<span>38</span>
												</div>
											</div>
									</div>
									<div class="goal-middle">
										<div class="goal-content">아침엔 고구마와 방울토마토, 점심엔...</div>
										<span class="goal-comment">(120)</span>
									</div>
								</div>
							</div>
						</a>			
						<a href="#">
							<div class="goal-card">
								<div class="goal-card-top">
									<div class="goal-profile-img">
										<img src="../../resources/img/person.png" alt="">
									</div>
									<div class="goal-profile-info">
										<span>윤태혁</span>
										<span>2025.10.31</span>
									</div>
								</div>

								<div class="goal-main">
									<div class="goal-title">
										<h4>3개월만에 20kg 감량</h4>
										<div class="goal-icon">
												<div class="goal-view">
													<i class="fa-solid fa-eye"></i>
													<span>1,203</span>
												</div>
												<div class="goal-good">
													<i class="fa-solid fa-thumbs-up"></i>
													<span>38</span>
												</div>
											</div>
									</div>
									<div class="goal-middle">
										<div class="goal-content">아침엔 고구마와 방울토마토, 점심엔...</div>
										<span class="goal-comment">(120)</span>
									</div>
								</div>
							</div>
						</a>			
						<a href="#">
							<div class="goal-card">
								<div class="goal-card-top">
									<div class="goal-profile-img">
										<img src="../../resources/img/person.png" alt="">
									</div>
									<div class="goal-profile-info">
										<span>윤태혁</span>
										<span>2025.10.31</span>
									</div>
								</div>

								<div class="goal-main">
									<div class="goal-title">
										<h4>3개월만에 20kg 감량</h4>
										<div class="goal-icon">
												<div class="goal-view">
													<i class="fa-solid fa-eye"></i>
													<span>1,203</span>
												</div>
												<div class="goal-good">
													<i class="fa-solid fa-thumbs-up"></i>
													<span>38</span>
												</div>
											</div>
									</div>
									<div class="goal-middle">
										<div class="goal-content">아침엔 고구마와 방울토마토, 점심엔...</div>
										<span class="goal-comment">(120)</span>
									</div>
								</div>
							</div>
						</a>			
						<a href="#">
							<div class="goal-card">
								<div class="goal-card-top">
									<div class="goal-profile-img">
										<img src="../../resources/img/person.png" alt="">
									</div>
									<div class="goal-profile-info">
										<span>윤태혁</span>
										<span>2025.10.31</span>
									</div>
								</div>

								<div class="goal-main">
									<div class="goal-title">
										<h4>3개월만에 20kg 감량</h4>
										<div class="goal-icon">
												<div class="goal-view">
													<i class="fa-solid fa-eye"></i>
													<span>1,203</span>
												</div>
												<div class="goal-good">
													<i class="fa-solid fa-thumbs-up"></i>
													<span>38</span>
												</div>
											</div>
									</div>
									<div class="goal-middle">
										<div class="goal-content">아침엔 고구마와 방울토마토, 점심엔...</div>
										<span class="goal-comment">(120)</span>
									</div>
								</div>
							</div>
						</a>			
					</div>
				</div>

				<div class="goal-right">
					<!-- 공지 사항 -->
					<div class="post-left-notice">
						<div class="goal-wrapper-title">
							<span>공지사항 & 이벤트</span>
							<a href="/matching" class="all-page-btn" id="notice-all-list-btn">더보기
								<i class="fa-solid fa-arrow-right"></i>
							</a>
						</div>
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
						<div class="post-wrapper-title">
							<span>자유 게시판</span>
							<a href="/matching" class="all-page-btn" id="free-board-list-btn">더보기
								<i class="fa-solid fa-arrow-right"></i>
							</a>
						</div>
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
						</div>							
					</div>
				</div>
			</div>
			<!-- 성공 후기 div 끝 -->
		</div>
		<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	</div>
	<script>
		// 매칭 디테일 이동
        function matchingDetail(boardNo) {
            location.href="/matching/detail?matchingNo=" + 10;
        }

        // 매칭 신청 버튼
        document.querySelectorAll(".matching-btn").forEach(btn => {
            btn.addEventListener("click", (e) => {
                e.stopPropagation(); // 페이지 이동 막음
                if(confirm("해당 매칭을 신청하시겠습니까?")) {
                } else {
                    alert("매칭 신청을 취소하셨습니다.");
                    return;
                }
                location.href="/";
            })
        })
		const boardNo = 100;
        function matchingPage(boardNo) {
			location.href="/matching=" + boardNo;
		}
        
        document.querySelector("#matching-btn").addEventListener("click", e => {
			e.stopPropagation();
            alert("a");
        })
	</script>
</body>
</html>