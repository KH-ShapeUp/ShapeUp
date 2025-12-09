<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>목표 설정 | ShapeUp</title>
  <link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/updateUserInfo.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/mypage.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/goal/settingGoal.css">
  <link rel="icon" href="${pageContext.request.contextPath}/resources/img/fav/favicon.png">
</head>
<body>
<jsp:include page="/WEB-INF/views/include/header.jsp"/>
<div>
	<div class="mypage-container">
	    <div class="page-header">
	      <h1>목표 설정</h1>
	      <p>다양한 목표를 설정해보세요</p>
	    </div>

	    <div class="content-area">
		      <!-- 탭 메뉴 -->
		      <div class="tab-menu">
		        <a href="${pageContext.request.contextPath}/user/updateUserInfo" class="tab-button">
		          <span class="tab-icon">👤</span>사용자 정보
		        </a>
		        <a href="${pageContext.request.contextPath}/user/accountManage" class="tab-button">
		          <span class="tab-icon">⚙️</span>계정 관리
		        </a>
		        <a href="${pageContext.request.contextPath}/user/userInterest" class="tab-button">
		          <span class="tab-icon">⭐</span>관심사 설정
		        </a>
		        <a href="${pageContext.request.contextPath}/user/settingGoal" class="tab-button active">
		          <span class="tab-icon">🎯</span>목표 설정
		        </a>
		      </div>

		      <!-- 목표 설정 컨텐츠 -->
		      <div class="goal-content">
		        
		        <!-- 현재 목표 표시 영역 -->
		        <div class="current-goals-card" id="currentGoalsCard" style="display: none;">
		          <div class="card-header">
		            <h3><span class="icon">📊</span> 현재 목표</h3>
		          </div>
		          <div class="goals-grid">
		            <div class="goal-item">
		              <div class="goal-label">목표 체중</div>
		              <div class="goal-value" id="currentWeight">-</div>
		            </div>
		            <div class="goal-item">
		              <div class="goal-label">목표 체지방량</div>
		              <div class="goal-value" id="currentFat">-</div>
		            </div>
		            <div class="goal-item">
		              <div class="goal-label">목표 골격근량</div>
		              <div class="goal-value" id="currentSmm">-</div>
		            </div>
		          </div>
		        </div>

		        <!-- 정보 박스 -->
		        <div class="info-box">
		          <span class="info-icon">💡</span>
		          <div>
		            <strong>팁:</strong> 현실적이고 달성 가능한 목표를 설정하세요. 전문가와 상담 후 결정하는 것을 권장합니다.
		          </div>
		        </div>

		        <!-- 목표 설정 폼 -->
		        <form id="goalForm" class="goal-form" novalidate>
		          
		          <div class="form-group">
		            <label for="goalWeight">
		              <span class="label-icon">⚖️</span>
		              목표 체중
		            </label>
		            <div class="input-wrapper">
		              <input 
		                type="number" 
		                id="goalWeight" 
		                name="goalWeight" 
		                step="0.1" 
		                min="30" 
		                max="200" 
		                placeholder="목표하는 체중을 입력하세요"
		              >
		              <span class="unit">kg</span>
		            </div>
		          </div>

		          <div class="form-group">
		            <label for="goalFat">
		              <span class="label-icon">📉</span>
		              목표 체지방량
		            </label>
		            <div class="input-wrapper">
		              <input 
		                type="number" 
		                id="goalFat" 
		                name="goalFat" 
		                step="0.1" 
		                min="0" 
		                max="100" 
		                placeholder="목표하는 체지방량을 입력하세요"
		              >
		              <span class="unit">kg</span>
		            </div>
		          </div>

		          <div class="form-group">
		            <label for="goalSmm">
		              <span class="label-icon">💪</span>
		              목표 골격근량
		            </label>
		            <div class="input-wrapper">
		              <input 
		                type="number" 
		                id="goalSmm" 
		                name="goalSmm" 
		                step="0.1" 
		                min="0" 
		                max="100" 
		                placeholder="목표하는 골격근량을 입력하세요"
		              >
		              <span class="unit">kg</span>
		            </div>
		          </div>
		          <div class="button-group">
		            <button type="button" class="btn btn-secondary" onclick="resetGoalForm()">
		              초기화
		            </button>
		            <button type="submit" class="btn btn-primary">
		              목표 저장
		            </button>
		          </div>
		        </form>

		      </div>

	     </div>
     </div>
</div>

<!-- ✅ 모달 창 추가 -->
<div id="customModal" class="modal-overlay" style="display:none;">
  <div class="modal-box">
    <p id="modalMessage">메시지</p>
    <button class="modal-btn" onclick="closeModal()">확인</button>
  </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    window.contextPath = contextPath;
</script>

<script src="${pageContext.request.contextPath}/resources/js/settingGoal.js"></script>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>