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

				<form class="actions-row" id="routineSearchForm">
					<div class="search-input-group">
						<input type="text" id="searchInput" placeholder="찾아보기" />
					</div>
					<button class="btn-add" type="button">
						<span class="btn-text">추가하기</span> <i class="fa-solid fa-plus"></i>
					</button>
				</form>

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
  // ----- DOM 요소 정의 -----
  const addButton = document.querySelector(".btn-add");
  const modal = document.getElementById("routineModal");
  const closeButton = document.querySelector(".close-modal-btn");

  const routineForm = document.getElementById("routineForm");
  const routineNameInput = document.getElementById("routineNameInput");
  const activityTypeSelect = document.querySelector(".activity-type-select");
  const strengthSelect = document.querySelector(".strength-select");
  const startTimeInput = document.getElementById("startTimeInput");
  const activityNameSelect = document.getElementById("activityNameSelect");
  const durationMinSelect = document.getElementById("durationMinSelect");
  const dayButtons = document.querySelectorAll(".day-btn");

  const routineSummaryWrapper = document.querySelector(".routine-summary");
  const summaryDayCount = routineSummaryWrapper.querySelector(".summary-day");
  const summaryDuration = routineSummaryWrapper.querySelector(".summary-time");
  const summaryKcal = routineSummaryWrapper.querySelector(".summary-kcal");

  const routineListContainer = document.querySelector(".routine-list");
  const searchInput = document.getElementById("searchInput");
  const categoryTabs = document.querySelectorAll(".category-tabs .tab-button");

  let currentCaloriePerMin = 0;

  // ----- 모달 열기/닫기 -----
  if (addButton && modal) {
    addButton.addEventListener("click", function () {
      modal.style.display = "flex";
      updateSummary();
    });
  }

  if (closeButton && modal) {
    closeButton.addEventListener("click", function () {
      modal.style.display = "none";
    });
  }

  modal?.addEventListener("click", function (e) {
    if (e.target === modal) modal.style.display = "none";
  });

  // ----- 요일 버튼 토글 -----
  dayButtons.forEach(btn => {
    btn.setAttribute("type", "button"); // 안전
    btn.addEventListener("click", function (e) {
      e.preventDefault();
      this.classList.toggle("active");
      updateSummary();
    });
  });

  // ----- 칼로리 fetch 및 요약 업데이트 -----
  activityNameSelect?.addEventListener("change", function () {
    const selectedActivityName = this.value;
    if (!selectedActivityName) {
      currentCaloriePerMin = 0;
      updateSummary();
      return;
    }

    fetch("/routine/getCalorie?activityName=" + encodeURIComponent(selectedActivityName))
      .then(res => res.ok ? res.json() : Promise.reject("Network error"))
      .then(data => {
        currentCaloriePerMin = data || 0;
        updateSummary();
      })
      .catch(err => {
        console.error("칼로리 조회 실패:", err);
        currentCaloriePerMin = 0;
        updateSummary();
      });
  });

  durationMinSelect?.addEventListener("change", updateSummary);

  function updateSummary() {
    const activeDays = document.querySelectorAll(".day-btn.active").length;
    summaryDayCount.textContent = `반복 요일 : ${activeDays}일 / 주`;
    const durationMin = parseInt(durationMinSelect?.value || 0);
    summaryDuration.textContent = `시간 : ${durationMin}분`;
    const estimatedKcal = Math.round(currentCaloriePerMin * durationMin);
    summaryKcal.textContent = `예상 소모 kcal / 회 : ${estimatedKcal} kcal`;
  }

  // ----- 루틴 저장 -----
  routineForm?.addEventListener("submit", function (e) {
    e.preventDefault();
    const selectedDays = Array.from(dayButtons)
      .filter(btn => btn.classList.contains("active"))
      .map(btn => btn.getAttribute("data-day"));

    if (selectedDays.length === 0) return alert("요일을 1개 이상 선택하세요.");
    if (!activityNameSelect.value || !durationMinSelect.value) return alert("종목과 시간을 선택하세요.");

    const payload = {
      routineName: routineNameInput.value.trim(),
      userNo: 1,
      activityName: activityNameSelect.value,
      activityType: activityTypeSelect.value,
      strength: strengthSelect.value,
      durationMin: parseInt(durationMinSelect.value),
      startTime: startTimeInput.value,
      days: selectedDays
    };

    fetch("/routine/create", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    })
      .then(res => res.ok ? res.json() : Promise.reject("저장 실패"))
      .then(() => {
        alert("루틴이 저장되었습니다.");
        modal.style.display = "none";
        window.location.reload();
      })
      .catch(err => alert(err));
  });

  // ----- 루틴 삭제 -----
  routineListContainer?.addEventListener("click", function (e) {
    if (!e.target.classList.contains("delete-routine-btn")) return;
    const routineCard = e.target.closest(".routine-card");
    const routineId = routineCard?.dataset.routineId;
    if (!routineId) return;

    if (!confirm("정말 삭제하시겠습니까?")) return;

    fetch("/routine/delete/" + routineId, { method: "POST", headers: { "Content-Type": "application/json" } })
      .then(res => res.ok ? res.json() : Promise.reject("삭제 실패"))
      .then(() => window.location.reload())
      .catch(err => alert(err));
  });

  // ----- 검색 & 카테고리 필터링 -----
  function filterRoutinesBy(category) {
    const routineCards = document.querySelectorAll(".routine-card");
    const searchTerm = searchInput?.value.trim().toLowerCase() || "";

    routineCards.forEach(card => {
      const title = card.querySelector(".routine-title")?.textContent.trim().toLowerCase() || "";
      const tag = card.querySelector(".tag")?.textContent.trim() || "";
      const categoryMatch = category === "전체" || tag === category;
      const searchMatch = title.includes(searchTerm) || tag.toLowerCase().includes(searchTerm);
      card.style.display = categoryMatch && searchMatch ? "grid" : "none";
    });
  }

  categoryTabs.forEach(tab => {
    tab.addEventListener("click", function () {
      categoryTabs.forEach(btn => btn.classList.remove("active"));
      this.classList.add("active");
      filterRoutinesBy(this.textContent.trim());
    });
  });

  searchInput?.addEventListener("input", function () {
    const activeTab = document.querySelector(".tab-button.active");
    const currentCategory = activeTab?.textContent.trim() || "전체";
    filterRoutinesBy(currentCategory);
  });

  // ----- 초기 실행 -----
  updateSummary();
  filterRoutinesBy("전체");
});
</script>

</body>
</html>
