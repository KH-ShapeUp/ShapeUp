<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>ShapeUp | 루틴 관리</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet"
	href="/resources/css/routine/routineManageMent.css" />
</head>
<body>
	<header class="main-header-placeholder">
		<div class="header-content-placeholder"></div>
	</header>
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
						<span class="label">카테고리 비율</span>
					</div>
				</div>

				<div class="activity-list">
					<div class="activity-item">
						<span class="activity-name">스포츠</span> <span
							class="activity-percent">0%</span>
					</div>
					<div class="activity-item">
						<span class="activity-name">유산소</span> <span
							class="activity-percent">0%</span>
					</div>
					<div class="activity-item">
						<span class="activity-name">근력</span> <span
							class="activity-percent">0%</span>
					</div>
					<div class="activity-item">
						<span class="activity-name">스트레칭</span> <span
							class="activity-percent">0%</span>
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

				<div class="actions-row">
					<div class="search-input-group">
						<input type="text" placeholder="찾아보기" /> <i
							class="fa-solid fa-magnifying-glass"></i>
					</div>
					<button class="btn-add">
						<span class="btn-text">추가하기</span> <i class="fa-solid fa-plus"></i>
					</button>
				</div>

				<div class="routine-list">
					<c:forEach var="routineItem" items="${routineList}">
						<div class="routine-card"
							data-routine-id="${routineItem.routineId}">
							<div class="card-header-right">
								<span class="tag tag-${routineItem.routineCategorySummary}">
									${routineItem.routineCategorySummary} </span>
							</div>
							<h3 class="routine-title">${routineItem.routineName}</h3>
							<div class="routine-actions">
								<i class="fa-solid fa-trash delete-routine-btn"></i>
							</div>
							<div class="routine-days">
								<c:forEach var="day"
									items="${fn:split(routineItem.routineDaysSummary, ',')}"
									varStatus="status">
									<span class="day-dot active">${day}</span>
								</c:forEach>
							</div>
							<p class="routine-meta">주당 약 ${routineItem.totalKcal} kcal 소모
							</p>
						</div>
					</c:forEach>
				</div>
			</div>

			<div class="panel goals-panel">
				<div class="panel-header">
					<span class="material-symbols-outlined">calendar_today</span>
					<h2>이번 주</h2>
				</div>

				<div class="progress-section">
					<div class="progress-header">
						<div class="week-days-compact">
							<span>일</span><span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span>토</span>
						</div>
					</div>

					<div class="progress-details">
						<p>달성률</p>
						<p class="count">총 완료 횟수: 4회</p>
					</div>

					<div class="progress-bar-container">
						<div class="progress-bar" style="width: 60%"></div>
					</div>
					<span class="progress-percent">60%</span>
				</div>

				<div class="calorie-section">
					<h2 class="section-title">주간 예상 소모 칼로리</h2>
					<p class="calorie-current">현재: 약 1110 kcal</p>
					<p class="calorie-target">목표: 2500 kcal</p>
					<button class="btn-more-activity">추가 활동 필요</button>
				</div>
			</div>
		</div>
	</div>

	<div id="routineModal" class="modal-overlay">
		<form id="routineForm" class="modal-content-card">
			<div class="modal-header">
				<span class="material-symbols-outlined close-modal-btn">close</span>
			</div>

			<input type="text" id="routineNameInput" name="routineName"
				class="routine-name-input" placeholder="루틴 이름 입력" required />

			<div class="form-grid">
				<div class="form-group">
					<label class="dropdown-label">분류</label> <select
						name="activityType" class="custom-select activity-type-select">
						<option value="유산소">유산소</option>
						<option value="근력">근력</option>
						<option value="스포츠">스포츠</option>
						<option value="스트레칭">스트레칭</option>
					</select>
				</div>

				<div class="form-group">
					<label class="dropdown-label">종목</label> <select
						id="activityNameSelect" name="activityName" class="custom-select"
						required>
						<option value="">-- 활동 선택 --</option>
						<c:forEach var="name" items="${activityNames}">
							<option value="${name}">${name}</option>
						</c:forEach>
					</select>
				</div>

				<div class="form-group">
					<label class="dropdown-label">강도</label> <select name="strength"
						class="custom-select strength-select" required>
						<option value="상">상</option>
						<option value="중">중</option>
						<option value="하">하</option>
					</select>
				</div>
			</div>

			<div class="form-grid time-section">
				<div class="form-group">
					<label class="dropdown-label">시간 (분)</label> <select
						id="durationMinSelect" name="durationMin"
						class="custom-select time-select" required>
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
					</select>
				</div>

				<div class="form-group start-time-group">
					<label class="dropdown-label">시작 시간</label>
					<div class="time-input-container">
						<input type="time" id="startTimeInput" name="startTime"
							class="form-control" value="09:00" required />
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
					<p class="summary-day">반복 요일 : 0일 / 주</p>
					<p class="summary-time">시간 : 0분</p>
					<p class="summary-kcal">예상 소모 kcal / 회 : 0 kcal</p>
				</div>
			</div>

			<button type="submit" class="btn-save">저장</button>
		</form>
	</div>

	<script>
      document.addEventListener("DOMContentLoaded", function () {
        const addButton = document.querySelector(".btn-add");
        const modal = document.getElementById("routineModal");
        const closeButton = document.querySelector(".close-modal-btn");

        // 💡 [추가 및 변경된 DOM 요소]
        const routineForm = document.getElementById("routineForm"); // 폼 자체
        const routineNameInput = document.getElementById("routineNameInput");
        const activityTypeSelect = document.querySelector(
          ".activity-type-select"
        );
        const strengthSelect = document.querySelector(".strength-select");
        const startTimeInput = document.getElementById("startTimeInput");

        const activityNameSelect =
          document.getElementById("activityNameSelect");
        const durationMinSelect = document.getElementById("durationMinSelect");
        const dayButtons = document.querySelectorAll(".day-btn");

        // 요약 정보 표시 영역 DOM (클래스 선택자로 변경)
        const routineSummaryWrapper =
          document.querySelector(".routine-summary");
        const summaryDayCount =
          routineSummaryWrapper.querySelector(".summary-day");
        const summaryDuration =
          routineSummaryWrapper.querySelector(".summary-time");
        const summaryKcal =
          routineSummaryWrapper.querySelector(".summary-kcal");

        let currentCaloriePerMin = 0.0;

        // --------------------------------------------------------
        // [모달 기본 동작]
        // --------------------------------------------------------

        if (addButton && modal) {
          addButton.addEventListener("click", function () {
            modal.style.display = "flex";
            updateSummary(); // 모달 열 때 초기화
          });
        }

        if (closeButton && modal) {
          closeButton.addEventListener("click", function () {
            modal.style.display = "none";
          });
        }

        if (modal) {
          modal.addEventListener("click", function (e) {
            if (e.target === modal) {
              modal.style.display = "none";
            }
          });
        }

        // --------------------------------------------------------
        // [저장 버튼 클릭 (Form Submit) 이벤트 핸들러]
        // --------------------------------------------------------
        if (routineForm) {
          routineForm.addEventListener("submit", function (e) {
            e.preventDefault(); // 폼 기본 제출 방지

            // 1. 선택된 요일 수집
            const selectedDays = Array.from(dayButtons)
              .filter((btn) => btn.classList.contains("active"))
              .map((btn) => btn.getAttribute("data-day"));

            if (selectedDays.length === 0) {
              alert("반복 요일을 1개 이상 선택해 주세요.");
              return;
            }

            // 필수 필드 값 확인 (Activity, Duration)은 HTML required 속성으로도 처리되지만, JS에서 한번 더 체크
            if (!activityNameSelect.value || !durationMinSelect.value) {
              alert("활동 종목과 시간을 모두 선택해 주세요.");
              return;
            }

            // 2. 전송할 데이터 객체 생성
            const formData = {
              routineName: routineNameInput.value.trim(),
              userNo: 1, // 🚨 임시 사용자 번호 (로그인 기능 구현 시 변경 필요)

              // 루틴 아이템 및 시간 정보
              activityName: activityNameSelect.value,
              activityType: activityTypeSelect.value,
              strength: strengthSelect.value,
              durationMin: parseInt(durationMinSelect.value),
              startTime: startTimeInput.value, // "HH:MM" 형식

              // 반복 요일 정보
              days: selectedDays,
            };

            console.log("전송할 데이터:", formData);

            // 3. AJAX 요청 전송
            saveRoutine(formData);
          });
        }

        /**
         * 루틴 데이터를 서버로 전송하여 저장하는 함수
         */
        function saveRoutine(data) {
          fetch("/routine/create", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(data),
          })
            .then((response) => {
              if (!response.ok) {
                // 서버에서 발생한 오류 메시지를 가져와서 에러를 던짐
                return response.json().then((error) => {
                  throw new Error(error.message || "루틴 저장 실패");
                });
              }
              return response.json();
            })
            .then((result) => {
              alert("루틴이 성공적으로 저장되었습니다.");
              modal.style.display = "none";
              // 저장 후 페이지 새로고침하여 목록 업데이트
              window.location.reload();
            })
            .catch((error) => {
              console.error("루틴 저장 중 오류 발생:", error);
              alert("루틴 저장에 실패했습니다: " + error.message);
            });
        }

        // --------------------------------------------------------
        // [이벤트 핸들러: 동적 요약 정보]
        // --------------------------------------------------------

        // 1. 요일 버튼 클릭 이벤트 (활성화 토글 및 요약 업데이트)
        dayButtons.forEach((button) => {
          button.addEventListener("click", function (e) {
            e.preventDefault();
            this.classList.toggle("active");
            updateSummary(); // 클릭 후 요약 정보 업데이트
          });
        });

        // 2. 활동 선택이 변경될 때 (AJAX 요청 발생)
        activityNameSelect.addEventListener("change", function () {
          const selectedActivityName = this.value;

          if (selectedActivityName) {
            fetchCalorieAndUpdatedSummary(selectedActivityName);
          } else {
            currentCaloriePerMin = 0.0; // 활동 선택 안 함
            updateSummary();
          }
        });

        // 3. 시간(분) 선택이 변경될 때
        durationMinSelect.addEventListener("change", function () {
          updateSummary();
        });

        // --------------------------------------------------------
        // [함수 정의]
        // --------------------------------------------------------

        /**
         * 활동명으로 서버에서 CAL_PER_MIN 값을 가져오는 함수
         */
        function fetchCalorieAndUpdatedSummary(activityName) {
          fetch(
            "/routine/getCalorie?activityName=" +
              encodeURIComponent(activityName)
          )
            .then((response) => {
              if (!response.ok) {
                throw new Error("Network response was not ok");
              }
              return response.json();
            })
            .then((data) => {
              currentCaloriePerMin = data || 0.0;
              updateSummary();
            })
            .catch((error) => {
              console.error("칼로리 값 조회 오류:", error);
              currentCaloriePerMin = 0.0;
              updateSummary();
            });
        }

        /**
         * 현재 선택된 값들을 기반으로 요약 정보를 계산하고 화면을 업데이트하는 핵심 함수
         */
        function updateSummary() {
          console.log("--- updateSummary 함수 호출됨 ---");

          // 1. 요일 계산
          const activeDays =
            document.querySelectorAll(".day-btn.active").length;
          summaryDayCount.textContent = `반복 요일 : ${activeDays}일 / 주`;

          // 2. 시간 계산
          const durationMin = parseInt(durationMinSelect.value) || 0;
          summaryDuration.textContent = `시간 : ${durationMin}분`;

          // 3. 칼로리 계산
          const estimatedKcal = Math.round(currentCaloriePerMin * durationMin);
          summaryKcal.textContent = `예상 소모 kcal / 회 : ${estimatedKcal} kcal`;
        }

        // 페이지 로드 시 초기 요약 정보를 한 번 업데이트
        updateSummary();
      });

      // 💡 [루틴 삭제 이벤트 핸들러 추가]
      // --------------------------------------------------------
      const routineListContainer = document.querySelector(".routine-list");

      if (routineListContainer) {
        routineListContainer.addEventListener("click", function (e) {
          if (e.target.classList.contains("delete-routine-btn")) {
            const routineCard = e.target.closest(".routine-card");
            const routineId = routineCard.getAttribute("data-routine-id");

            if (routineId && confirm("정말로 이 루틴을 삭제하시겠습니까?")) {
              deleteRoutine(routineId);
            }
          }
        });
      }

      /**
       * 루틴을 서버에 삭제 요청하는 함수 (AJAX)
       */
      function deleteRoutine(routineId) {
          fetch("/routine/delete/" + routineId, {
              method: "POST", 
              headers: {
                  "Content-Type": "application/json",
                  // CSRF 토큰이 필요하다면 여기에 추가해야 함
              },
          })
          .then((response) => {
              if (!response.ok) {
                  // HTTP 오류 코드 처리 (예: 4xx, 5xx)
                  throw new Error("서버 오류가 발생했거나 루틴 삭제에 실패했습니다. (HTTP Error)");
              }
              
              // 🚨 수정된 부분: 응답의 Content-Type을 확인합니다.
              const contentType = response.headers.get("content-type");
              
              if (contentType && contentType.includes("application/json")) {
                  // 서버가 JSON을 반환한 경우 (성공 메시지 등)
                  return response.json();
              } else {
                  // 서버가 JSON이 아닌 다른 응답(HTML, No Content 등)을 반환한 경우
                  // 여기서 오류를 던지지 않고 빈 객체 또는 null을 반환하여 다음 then으로 진행시킵니다.
                  return null; 
              }
          })
          .then((result) => {
              // result가 null이면 서버가 JSON을 반환하지 않았지만 성공한 것으로 간주합니다.
              alert("루틴이 성공적으로 삭제되었습니다.");
              window.location.reload();
          })
          .catch((error) => {
              console.error("루틴 삭제 중 오류 발생:", error);
              alert("루틴 삭제에 실패했습니다: " + error.message);
          });
      }
    </script>
</body>
</html>
