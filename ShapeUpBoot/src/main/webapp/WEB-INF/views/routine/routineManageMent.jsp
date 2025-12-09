<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c"%> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>루틴 관리 | ShapeUp</title>
    <link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
    <link
      rel="stylesheet"
      href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
    />
    <link
      rel="stylesheet"
      href="/resources/css/routine/routineManageMent.css"
    />
    <jsp:include page="/WEB-INF/views/include/head.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="/resources/js/routineManagement.js" defer></script>
  </head>
  <body>
    <jsp:include page="/WEB-INF/views/include/header.jsp"/>
    <input type="hidden" id="currentUserNo" value="${sessionScope.loginUser.userNo }">
    <div class="page-container">
      <div class="page-title">
        <h1>루틴 관리</h1>
      </div>

      <div class="main-content-grid">
        <div class="panel summary-panel">
          <div class="panel-header">
            <h2>활동 요약</h2>
          </div>

          <div class="ratio-chart">
            <div class="chart-circle">
            </div>
          </div>

          <div class="activity-list">
            <div class="activity-item">
              <span class="activity-name">스포츠</span>
              <span class="activity-percent">0%</span>
            </div>
            <div class="activity-item">
              <span class="activity-name">유산소</span>
              <span class="activity-percent">0%</span>
            </div>
            <div class="activity-item">
              <span class="activity-name">근력</span>
              <span class="activity-percent">0%</span>
            </div>
            <div class="activity-item">
              <span class="activity-name">스트레칭</span>
              <span class="activity-percent">0%</span>
            </div>
          </div>
        </div>

        <div class="center-content">
          <div class="category-tabs">
            <button class="tab-button active">전체</button>
            <button class="tab-button">유산소</button>
            <button class="tab-button">근력</button>
            <button class="tab-button">스포츠</button>
            <button class="tab-button">스트레칭</button>
          </div>

          <form class="actions-row" id="routineSearchForm">
            <div class="search-input-group">
              <input type="text" id="searchInput" placeholder="찾아보기" />
            </div>
            <button class="btn-add" type="button">
              <span class="btn-text">추가하기</span>
              <i class="fa-solid fa-plus"></i>
            </button>
          </form>

          <div class="routine-list">
            <c:forEach var="routineItem" items="${routineList}">
              <div
                class="routine-card"
                data-routine-id="${routineItem.routineId}"
                data-weekly-kcal="${routineItem.totalKcal}"
              >
                <div class="card-header-right">
                  <span class="tag tag-${routineItem.routineCategorySummary}">
                    ${routineItem.routineCategorySummary}
                  </span>
                </div>
                <h3 class="routine-title">${routineItem.routineName}</h3>
                <div class="routine-actions">
                  <i class="fa-solid fa-trash delete-routine-btn"></i>
                </div>
                <div class="routine-days">
                  <c:forEach
                    var="day"
                    items="${fn:split(routineItem.routineDaysSummary, ',')}"
                    varStatus="status"
                  >
                    <span class="day-dot active">${day}</span>
                  </c:forEach>
                </div>
                <p class="routine-meta">
                  주당 약 ${routineItem.totalKcal} kcal 소모
                </p>
              </div>
            </c:forEach>
          </div>
        </div>

        <div class="panel goals-panel">
          <div class="panel-header">
            <h2>🔥 주간 목표 달성률</h2>
          </div>

          <div class="progress-section">
            <div class="progress-header">
              <span class="week-days-compact">월 화 수 목 금 토 일</span>
            </div>

			<div class="progress-details">
			    <p>달성 횟수</p>
			    <p>
			        <span id="current-goal-count" class="count">0</span> / 
			        <input type="number" id="goal-input" value="5" min="1" max="7" 
			        style="width: 40px; text-align: center; border: 1px solid #ccc; border-radius: 4px; padding: 2px;"> 
			        회
			    </p>
			</div>
			<div class="panel goals-panel" data-weekly-goal="5"> 
			</div>
            <div class="progress-bar-container">
              <div
                id="progress-bar"
                class="progress-bar"
                style="width: 0%"
              ></div>
            </div>
            <span id="progress-percent" class="progress-percent">0%</span>
          </div>

          <div class="calorie-section">
            <div class="section-title">📊 주간 예상 칼로리 소모량</div>

            <div class="calorie-current">
              총 예상 소모량: <span id="total-expected-kcal">0</span> kcal
            </div>

            <!-- ⭐ 주간 목표 소모 칼로리 영역 추가 -->
            <div class="calorie-target-wrapper">
              <div class="calorie-target">
                (목표 주간 소모량: <span id="weekly-goal-kcal">3000</span> kcal)
              </div>
              <button type="button" class="btn-edit-goal" id="editWeeklyGoalBtn">
                <i class="fa-solid fa-pen-to-square"></i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 루틴 추가/수정 모달 -->
    <div id="routineModal" class="modal-overlay">
      <form id="routineForm" class="modal-content-card">
        <div class="modal-header">
          <span class="material-symbols-outlined close-modal-btn">close</span>
        </div>

        <input
          type="text"
          id="routineNameInput"
          name="routineName"
          class="routine-name-input"
          placeholder="루틴 이름 입력"
          required
        />

        <div class="form-grid">
          <div class="form-group">
            <label class="dropdown-label">분류</label>
            <select
              name="activityType"
              class="custom-select activity-type-select"
            >
              <option value="유산소">유산소</option>
              <option value="근력">근력</option>
              <option value="스포츠">스포츠</option>
              <option value="스트레칭">스트레칭</option>
            </select>
          </div>

          <div class="form-group">
            <label class="dropdown-label">종목</label>
            <select
              id="activityNameSelect"
              name="activityName"
              class="custom-select"
              required
            >
              <option value="">-- 활동 선택 --</option>
              <c:forEach var="name" items="${activityNames}">
                <option value="${name}">${name}</option>
              </c:forEach>
            </select>
          </div>

          <div class="form-group">
            <label class="dropdown-label">강도</label>
            <select
              name="strength"
              class="custom-select strength-select"
              required
            >
              <option value="상">상</option>
              <option value="중">중</option>
              <option value="하">하</option>
            </select>
          </div>
        </div>

        <div class="form-grid time-section">
          <div class="form-group">
            <label class="dropdown-label">시간 (분)</label>
            <select
              id="durationMinSelect"
              name="durationMin"
              class="custom-select time-select"
              required
            >
              <option value="">-- 시간 선택 --</option>
              <option value="5">5분</option>
              <option value="10">10분</option>
              <option value="15">15분</option>
              <option value="20">20분</option>
              <option value="25">25분</option>
              <option value="30">30분</option>
              <option value="35">35분</option>
              <option value="40">40분</option>
              <option value="45">45분</option>
              <option value="50">50분</option>
              <option value="55">55분</option>
              <option value="60">60분</option>
              <option value="75">75분</option>
              <option value="90">90분</option>
              <option value="120">120분</option>
            </select>
          </div>

          <div class="form-group start-time-group">
            <label class="dropdown-label">시작 시간</label>
            <div class="time-input-container">
              <input
                type="time"
                id="startTimeInput"
                name="startTime"
                class="form-control"
                value="09:00"
                required
              />
            </div>
          </div>
        </div>

        <div class="day-info-wrapper">
          <div class="day-selector">
            <label class="day-label">요일</label>
            <div class="day-buttons">
              <button class="day-btn" data-day="일">일</button>
              <button class="day-btn" data-day="월">월</button>
              <button class="day-btn" data-day="화">화</button>
              <button class="day-btn" data-day="수">수</button>
              <button class="day-btn" data-day="목">목</button>
              <button class="day-btn" data-day="금">금</button>
              <button class="day-btn" data-day="토">토</button>
            </div>
          </div>

          <div class="routine-summary">
            <p class="summary-day">반복 요일 : 0일</p>
            <p class="summary-time">시간 : 0분</p>
            <p class="summary-kcal">예상 소모 kcal / 회 : 0 kcal</p>
          </div>
        </div>

        <button type="submit" class="btn-save">저장</button>
      </form>
    </div>

    <!-- ⭐ 주간 목표 칼로리 수정 모달 -->
    <div id="weeklyGoalModal" class="modal-overlay">
      <div class="modal-content-goal">
        <div class="modal-header">
          <h3>주간 목표 소모 칼로리 설정</h3>
          <span class="material-symbols-outlined close-goal-modal-btn">close</span>
        </div>
        
        <div class="goal-input-wrapper">
          <label for="weeklyGoalInput">주간 목표 칼로리 (kcal)</label>
          <input 
            type="number" 
            id="weeklyGoalInput" 
            class="goal-input" 
            min="0" 
            step="100"
            placeholder="예: 3000"
          />
          <p class="goal-hint">일주일 동안 소모하고 싶은 칼로리를 입력하세요.</p>
        </div>

        <div class="modal-actions">
          <button type="button" class="btn-cancel-goal">취소</button>
          <button type="button" class="btn-save-goal">저장</button>
        </div>
      </div>
    </div>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
    
    <!-- ⭐ 주간 목표 칼로리 스크립트 -->
    <script>
      // 페이지 로드 시 목표 칼로리 불러오기
      document.addEventListener('DOMContentLoaded', function() {
        loadWeeklyGoalCalorie();
      });

      // 주간 목표 칼로리 불러오기
      function loadWeeklyGoalCalorie() {
        fetch('/routine/goal/weekly')
          .then(response => response.json())
          .then(data => {
            if (data.goalCalorieActivityWeekly) {
              document.getElementById('weekly-goal-kcal').textContent = 
                Number(data.goalCalorieActivityWeekly).toLocaleString();
            }
          })
          .catch(error => {
            console.error('목표 칼로리 로드 실패:', error);
          });
      }

      // 수정 버튼 클릭
      document.getElementById('editWeeklyGoalBtn').addEventListener('click', function() {
        const currentGoal = document.getElementById('weekly-goal-kcal').textContent.replace(/,/g, '');
        document.getElementById('weeklyGoalInput').value = currentGoal;
        document.getElementById('weeklyGoalModal').style.display = 'flex';
      });

      // 모달 닫기
      document.querySelector('.close-goal-modal-btn').addEventListener('click', function() {
        document.getElementById('weeklyGoalModal').style.display = 'none';
      });

      document.querySelector('.btn-cancel-goal').addEventListener('click', function() {
        document.getElementById('weeklyGoalModal').style.display = 'none';
      });

      // 모달 외부 클릭 시 닫기
      document.getElementById('weeklyGoalModal').addEventListener('click', function(e) {
        if (e.target === this) {
          this.style.display = 'none';
        }
      });

      // 저장 버튼 클릭
      document.querySelector('.btn-save-goal').addEventListener('click', function() {
        const goalValue = document.getElementById('weeklyGoalInput').value;
        
        if (!goalValue || goalValue <= 0) {
          Swal.fire({
            icon: 'warning',
            title: '입력 오류',
            text: '목표 칼로리를 올바르게 입력해주세요.',
            confirmButtonText: '확인'
          });
          return;
        }

        // 서버에 저장
        fetch('/routine/goal/weekly', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            goalCalorieActivityWeekly: Number(goalValue)
          })
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            document.getElementById('weekly-goal-kcal').textContent = 
              Number(goalValue).toLocaleString();
            document.getElementById('weeklyGoalModal').style.display = 'none';
            
            Swal.fire({
              icon: 'success',
              title: '저장 완료',
              text: '주간 목표 칼로리가 설정되었습니다.',
              confirmButtonText: '확인'
            });
          } else {
            throw new Error('저장 실패');
          }
        })
        .catch(error => {
          console.error('목표 칼로리 저장 실패:', error);
          Swal.fire({
            icon: 'error',
            title: '저장 실패',
            text: '목표 칼로리 저장에 실패했습니다.',
            confirmButtonText: '확인'
          });
        });
      });
    </script>
  </body>
</html>