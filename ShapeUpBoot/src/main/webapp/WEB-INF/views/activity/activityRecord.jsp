<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>오늘의 운동</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700;800&display=swap">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/activity/activityRecord.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/activity/activityList.css">
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
</head>
<body class="activity-record">
  <jsp:include page="/WEB-INF/views/include/header.jsp"/>
  <main class="activity-main">
    <h1 class="page-title">오늘의 운동</h1>
    
    <div class="layout">
      <section class="left-col">
        <section class="summary-card card">
          <div class="summary-top">
            <div class="date-inline">
              <button class="calendar-btn" type="button">📅</button>
              <span class="today-text">2025.11.11</span>
            </div>
            <button class="add-btn-lg" onclick="openActivityModal()">활동 추가하기</button>
          </div>
          
          <div class="summary-grid">
            <div class="summary-item">
              <div class="label">총 운동 시간</div>
              <div class="value">60 분</div>
            </div>
            <div class="summary-item">
              <div class="label">총 소모 칼로리</div>
              <div class="value">600 kcal</div>
            </div>
            <div class="summary-item">
              <div class="label">운동 횟수</div>
              <div class="value">2 회</div>
            </div>
          </div>
        </section>

        <div class="category-tabs">
          <button class="active">전체</button>
          <button>스포츠</button>
          <button>유산소</button>
          <button>근력</button>
          <button>스트레칭</button>
        </div>
        <div class="table-wrap">
          <table class="table">
            <thead>
              <tr><th>운동명</th><th>활동 시간</th><th>소모 칼로리</th><th>삭제</th></tr>
            </thead>
            <tbody>
              <tr><td>런닝</td><td>30 분</td><td>300 kcal</td><td>◎</td></tr>
              <tr><td>런닝</td><td>30 분</td><td>300 kcal</td><td>◎</td></tr>
              <tr><td>런닝</td><td>30 분</td><td>300 kcal</td><td>◎</td></tr>
              <tr><td>런닝</td><td>30 분</td><td>300 kcal</td><td>◎</td></tr>
            </tbody>
          </table>
        </div>

        <div class="card progress-card">
          <div class="section-title">진행도</div>
          <div class="progress-track"><div class="progress-bar"></div></div>
          <div class="progress-meta"><span>30%</span><span>600 kcal / 2000 kcal</span></div>
        </div>
      </section>

      <section class="right-col">
        <div class="card ratio-card">
          <div class="section-title">비율</div>
          <div class="ratio-chart">스포츠/유산소/근력/스트레칭 비율</div>
          <div class="ratio-legend">
            <div class="item"><span class="ratio-dot"></span><span>스포츠</span></div>
            <div class="item"><span class="ratio-dot"></span><span>유산소</span></div>
            <div class="item"><span class="ratio-dot"></span><span>근력</span></div>
            <div class="item"><span class="ratio-dot"></span><span>스트레칭</span></div>
          </div>
        </div>
        <div class="card weekly-card">
          <div class="section-title">주간 소모 칼로리</div>
          <div class="chart-placeholder">그래프 영역</div>
          <div class="weekly-target">이번 주 목표 90% 달성</div>
        </div>
      </section>
    </div>
  </main>
  <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
  <jsp:include page="/WEB-INF/views/activity/tools/activityList.jsp"/>
  <jsp:include page="/WEB-INF/views/activity/tools/activityInsertModal.jsp"/>
</body>


<script>
	document.addEventListener('DOMContentLoaded', () => {
		const activityBackdrop = document.getElementById('activity-list-backdrop');
		
		if (activityBackdrop) activityBackdrop.style.display = 'none';
		
		
		/* document.querySelector('add-btn-lg'). */
	})
</script>
</html>














