<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관심사 설정 | ShapeUp</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/updateUserInfo.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/mypage.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/updateInterest.css">
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/header.jsp"/>

  <div class="mypage-container">
    <div class="page-header">
      <h1>관심사 설정</h1>
      <p>원하는 운동 종목과 시간대를 선택해주세요</p>
    </div>

    <div class="content-area">
      <div id="messageBox" class="message"></div>

      <!-- 탭 메뉴 -->
      <div class="tab-menu">
        <a href="${pageContext.request.contextPath}/user/updateUserInfo" class="tab-button">
          <span class="tab-icon">👤</span>사용자 정보
        </a>
        <a href="${pageContext.request.contextPath}/user/accountManage" class="tab-button">
          <span class="tab-icon">⚙️</span>계정 관리
        </a>
        <a href="${pageContext.request.contextPath}/user/userInterest" class="tab-button active">
          <span class="tab-icon">⭐</span>관심사 설정
        </a>
        <a href="${pageContext.request.contextPath}/user/settingGoal" class="tab-button">
          <span class="tab-icon">🎯</span>목표 설정
        </a>
      </div>

      <form id="interestForm">
        <!-- 운동 종목 선택 -->
        <div class="interest-section">
          <h2 class="interest-title">
            관심 운동 종목
            <span class="selected-count" id="activityCount">0개 선택</span>
          </h2>
          <p class="helper-text">💡 관심있는 운동 종목을 모두 선택해주세요 (중복 선택 가능)</p>
          
          <!-- 구기종목 드롭다운 -->
          <div class="dropdown-section">
            <button type="button" class="dropdown-toggle" onclick="toggleDropdown('ballSports')">
              <span>구기종목</span>
              <span class="arrow">▼</span>
            </button>
            <div class="dropdown-content" id="ballSports">
              <div class="tag-grid">
                <button type="button" class="tag-btn" data-group="exercise" data-value="축구">⚽ 축구</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="풋살">⚽ 풋살</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="농구">🏀 농구</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="배구">🏐 배구</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="배드민턴">🏸 배드민턴</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="테니스">🎾 테니스</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="탁구">🏓 탁구</button>
              </div>
            </div>
          </div>

          <!-- 기타 운동 드롭다운 -->
          <div class="dropdown-section">
            <button type="button" class="dropdown-toggle" onclick="toggleDropdown('others')">
              <span>기타</span>
              <span class="arrow">▼</span>
            </button>
            <div class="dropdown-content" id="others">
              <div class="tag-grid">
                <button type="button" class="tag-btn" data-group="exercise" data-value="헬스">💪 헬스</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="등산">🏔️ 등산</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="클라이밍">🧗 클라이밍</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="수영">🏊 수영</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="스키">⛷️ 스키</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="격투기/복싱">🥊 격투기/복싱</button>
                <button type="button" class="tag-btn" data-group="exercise" data-value="러닝">🏃 러닝</button>
              </div>
            </div>
          </div>
        </div>

        <!-- 시간대 선택 -->
        <div class="interest-section">
          <h2 class="interest-title">
            선호 시간대
            <span class="selected-count" id="timeCount">0개 선택</span>
          </h2>
          <p class="helper-text">💡 운동하기 좋은 시간대를 선택해주세요 (중복 선택 가능)</p>
          
          <div class="tag-grid time-grid">
            <button type="button" class="tag-btn" data-group="time" data-value="평일">📅 평일</button>
            <button type="button" class="tag-btn" data-group="time" data-value="주말">📅 주말</button>
          </div>
          <div class="tag-grid time-grid">
            <button type="button" class="tag-btn" data-group="time" data-value="새벽">🌅 새벽</button>
            <button type="button" class="tag-btn" data-group="time" data-value="아침">🌄 아침</button>
            <button type="button" class="tag-btn" data-group="time" data-value="점심">☀️ 점심</button>
            <button type="button" class="tag-btn" data-group="time" data-value="저녁">🌆 저녁</button>
          </div>
        </div>

        <!-- 버튼 -->
        <div class="btn-container">
          <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
          <button type="button" class="btn btn-primary" onclick="submitForm()">저장하기</button>
        </div>
      </form>
    </div>
  </div>

  <div id="customModal" class="modal-overlay" style="display:none;">
    <div class="modal-box">
      <p id="modalMessage">메시지</p>
      <button class="modal-btn" onclick="closeModal()">확인</button>
    </div>
  </div>

  <jsp:include page="/WEB-INF/views/include/footer.jsp"/>

  <script>
  const contextPath = '${pageContext.request.contextPath}';
  
  // 서버에서 받은 기존 관심사 데이터
  const existingInterests = '${userInterest.interestActivity}' || '';
  const existingTimes = '${userInterest.activityTime}' || '';

  // 페이지 로드 시 기존 선택 복원
  window.addEventListener('DOMContentLoaded', function() {
    // 운동 종목 복원
    if (existingInterests) {
      const activities = existingInterests.split(',');
      activities.forEach(activity => {
        const trimmedActivity = activity.trim();
        const btn = document.querySelector(`button[data-group="exercise"][data-value="${trimmedActivity}"]`);
        if (btn) {
          btn.classList.add('active');
        }
      });
    }
    
    // 시간대 복원
    if (existingTimes) {
      const times = existingTimes.split(',');
      times.forEach(time => {
        const trimmedTime = time.trim();
        const btn = document.querySelector(`button[data-group="time"][data-value="${trimmedTime}"]`);
        if (btn) {
          btn.classList.add('active');
        }
      });
    }
    
    updateCounts();
  });

  // 태그 버튼 클릭 이벤트
  document.addEventListener('click', function(e) {
    if (e.target.classList.contains('tag-btn')) {
      e.target.classList.toggle('active');
      updateCounts();
    }
  });

  // 드롭다운 토글
  function toggleDropdown(id) {
    const dropdown = document.getElementById(id);
    const toggleBtn = event.currentTarget;
    dropdown.classList.toggle('active');
    toggleBtn.classList.toggle('active');
  }

  // 선택 개수 업데이트
  function updateCounts() {
    const activityCount = document.querySelectorAll('button[data-group="exercise"].active').length;
    const timeCount = document.querySelectorAll('button[data-group="time"].active').length;
    
    document.getElementById('activityCount').textContent = activityCount + '개 선택';
    document.getElementById('timeCount').textContent = timeCount + '개 선택';
  }

  // 폼 제출
  function submitForm() {
    // 선택된 운동 종목
    const selectedActivities = Array.from(document.querySelectorAll('button[data-group="exercise"].active'))
      .map(btn => btn.getAttribute('data-value'));
    
    // 선택된 시간대
    const selectedTimes = Array.from(document.querySelectorAll('button[data-group="time"].active'))
      .map(btn => btn.getAttribute('data-value'));
    
    // 유효성 검사
    if (selectedActivities.length === 0) {
      showModal('최소 1개 이상의 운동 종목을 선택해주세요.');
      return;
    }
    
    if (selectedTimes.length === 0) {
      showModal('최소 1개 이상의 시간대를 선택해주세요.');
      return;
    }
    
    // 서버로 전송
    const formData = new URLSearchParams();
    formData.append('interests', selectedActivities.join(','));
    formData.append('times', selectedTimes.join(','));
    
    fetch(contextPath + '/user/updateInterest', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: formData
    })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        showModal('관심사가 저장되었습니다.');
        setTimeout(() => {
          window.location.href = contextPath + '/user/updateUserInfo';
        }, 1500);
      } else {
        showModal(data.message || '저장에 실패했습니다.');
      }
    })
    .catch(err => {
      console.error('오류:', err);
      showModal('오류가 발생했습니다.');
    });
  }

  function showModal(message) {
    document.getElementById('modalMessage').textContent = message;
    document.getElementById('customModal').style.display = 'flex';
  }

  function closeModal() {
    document.getElementById('customModal').style.display = 'none';
  }
  </script>
</body>
</html>