document.addEventListener("DOMContentLoaded", function () { // DOMContentLoaded 이벤트 발생 시 전체 함수 실행
    const addButton = document.querySelector(".btn-add"); // '추가하기' 버튼 DOM 요소 선택
    // modal 오버레이 클래스명 대신 id로 사용했다고 가정
    const modal = document.getElementById("routineModal"); // 루틴 모달 DOM 요소 선택
    const closeButton = document.querySelector(".close-modal-btn"); // 모달 닫기 버튼(X) DOM 요소 선택

    // 💡 [DOM 요소 정의] - 루틴 폼 및 입력 필드
    const routineForm = document.getElementById("routineForm"); // 루틴 저장 폼
    const routineNameInput = document.getElementById("routineNameInput"); // 루틴 이름 입력 필드
    const activityTypeSelect = document.querySelector(".activity-type-select"); // 활동 분류 드롭다운
    const strengthSelect = document.querySelector(".strength-select"); // 강도 드롭다운
    const startTimeInput = document.getElementById("startTimeInput"); // 시작 시간 입력 필드
    const activityNameSelect = document.getElementById("activityNameSelect"); // 종목 드롭다운
    const durationMinSelect = document.getElementById("durationMinSelect"); // 시간(분) 드롭다운
    const dayButtons = document.querySelectorAll(".day-btn"); // 요일 선택 버튼들
    const routineSummaryWrapper = document.querySelector(".routine-summary"); // 모달 요약 정보 컨테이너
    const summaryDayCount = routineSummaryWrapper.querySelector(".summary-day"); // 요약: 반복 요일 수
    const summaryDuration = routineSummaryWrapper.querySelector(".summary-time"); // 요약: 시간
    const summaryKcal = routineSummaryWrapper.querySelector(".summary-kcal"); // 요약: 예상 칼로리

    // 루틴 목록 관련 DOM 요소
    const routineListContainer = document.querySelector(".routine-list"); // 루틴 카드 목록 컨테이너
    const routineCards = document.querySelectorAll(".routine-card"); // (초기 로딩된) 루틴 카드들
    const routineSearchForm = document.getElementById("routineSearchForm"); // 검색 폼
    const searchInput = document.getElementById("searchInput"); // 검색 입력 필드
    const categoryTabs = document.querySelectorAll(".category-tabs .tab-button"); // 카테고리 탭 버튼들

    // 좌측 패널 (활동 요약) 관련 DOM 요소
    const activityListItems = document.querySelectorAll( // 활동 리스트 항목
        ".activity-list .activity-item"
    );
    const chartCircle = document.querySelector(".ratio-chart .chart-circle"); // 카테고리 비율 차트 원형

    // 우측 패널 DOM 요소 (목표 및 칼로리)
    const currentGoalCountSpan = document.getElementById("current-goal-count"); // 현재 달성 횟수 표시
    const progressBar = document.getElementById("progress-bar"); // 주간 목표 진행률 바
    const progressPercentSpan = document.getElementById("progress-percent"); // 진행률 텍스트
    const totalExpectedKcalSpan = document.getElementById("total-expected-kcal"); // 총 예상 칼로리 표시 (우측 패널)

    let currentCaloriePerMin = 0.0; // 현재 선택된 활동의 분당 칼로리 값

    // --------------------------------------------------------
    // [모달/저장/요약 로직]
    // --------------------------------------------------------

    // 모달 열기
    if (addButton && modal) {
        addButton.addEventListener("click", function () {
            modal.style.display = "flex"; // 모달 표시
            // 모달 열 때 폼과 요일 선택 초기화 (상태 초기화)
            routineForm.reset(); // 폼 필드 초기화
            dayButtons.forEach(btn => btn.classList.remove('active')); // 요일 버튼 선택 해제
            updateSummary(); // 모달 요약 정보 초기 업데이트
        });
    }

    // 모달 닫기 - X 버튼
    if (closeButton && modal) {
        closeButton.addEventListener("click", function () {
            modal.style.display = "none"; // 모달 숨김
        });
    }

    // 모달 닫기 - 오버레이 클릭 시
    if (modal) {
        modal.addEventListener("click", function (e) {
            if (e.target === modal) {
                modal.style.display = "none"; // 오버레이 클릭 시 모달 닫기
            }
        });
    }

    // 루틴 저장 폼 제출
    if (routineForm) {
        routineForm.addEventListener("submit", function (e) {
            e.preventDefault(); // 기본 폼 제출 동작 방지

            // 활성화된 요일 버튼에서 요일 데이터 추출 (배열 형태)
            const selectedDays = Array.from(dayButtons)
                .filter((btn) => btn.classList.contains("active"))
                .map((btn) => btn.getAttribute("data-day"));

            if (selectedDays.length === 0) { // 요일 선택 검증
                alert("반복 요일을 1개 이상 선택해 주세요.");
                return;
            }
            if (!activityNameSelect.value || !durationMinSelect.value) { // 종목/시간 선택 검증
                alert("활동 종목과 시간을 모두 선택해 주세요.");
                return;
            }
            
            // 1회 예상 소모 칼로리 계산
            const estimatedKcal = Math.round(currentCaloriePerMin * parseInt(durationMinSelect.value));
            
            // 주당 총 예상 칼로리 계산 (1회 칼로리 * 요일 수)
            const totalWeeklyKcal = estimatedKcal * selectedDays.length;

            const formData = { // 서버 전송을 위한 데이터 객체 생성
                routineName: routineNameInput.value.trim(),
                userNo: 1, // 사용자 번호 (임시값)
                activityName: activityNameSelect.value,
                activityType: activityTypeSelect.value,
                strength: strengthSelect.value,
                durationMin: parseInt(durationMinSelect.value),
                startTime: startTimeInput.value,
                days: selectedDays, // 🚨 수정됨: 요일 배열(List) 자체를 전송
                totalKcal: totalWeeklyKcal // 주당 총 칼로리 값 전송
            };

            console.log("전송할 데이터:", formData);
            saveRoutine(formData); // 루틴 저장 함수 호출 (AJAX)
        });
    }

    /**
     * 루틴 저장 (POST 요청)
     */
    function saveRoutine(data) {
        fetch("/routine/create", { // 루틴 생성 API 호출
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data), // JSON.stringify로 JSON 배열을 포함한 객체 전송
        })
            .then((response) => {
                if (!response.ok) { // HTTP 상태 코드가 200번대가 아닐 경우 에러 처리
                    return response.json().then((error) => {
                        throw new Error(error.message || "루틴 저장 실패");
                    });
                }
                return response.json(); // 성공 시 JSON 응답 파싱
            })
            .then((result) => {
                alert("루틴이 성공적으로 저장되었습니다.");
                modal.style.display = "none";
                // 성공 시, 목록 업데이트를 위해 페이지 새로고침
                window.location.reload(); 
            })
            .catch((error) => {
                console.error("루틴 저장 중 오류 발생:", error);
                alert("루틴 저장에 실패했습니다: " + error.message);
            });
    }

    // --------------------------------------------------------
    // [이벤트 핸들러: 동적 모달 요약 정보]
    // --------------------------------------------------------

    // 요일 버튼 클릭 시 요약 업데이트
    dayButtons.forEach((button) => {
        button.addEventListener("click", function (e) {
            e.preventDefault(); // 기본 동작 방지 (폼 제출)
            this.classList.toggle("active"); // 활성화/비활성화 상태 토글
            updateSummary(); // 모달 요약 정보 업데이트
        });
    });

    // 활동 종목 선택 시 칼로리 조회 및 요약 업데이트
    activityNameSelect.addEventListener("change", function () {
        const selectedActivityName = this.value;

        if (selectedActivityName) {
            fetchCalorieAndUpdatedSummary(selectedActivityName); // 칼로리 조회 및 요약 업데이트
        } else {
            currentCaloriePerMin = 0.0; // 선택 해제 시 0으로 초기화
            updateSummary();
        }
    });

    // 활동 시간 선택 시 요약 업데이트
    durationMinSelect.addEventListener("change", function () {
        updateSummary();
    });

    /**
     * 활동 이름으로 분당 칼로리를 서버에서 조회하는 함수 (AJAX)
     */
    function fetchCalorieAndUpdatedSummary(activityName) {
        // 인코딩하여 GET 요청 (쿼리 파라미터)
        fetch( 
            "/routine/getCalorie?activityName=" + encodeURIComponent(activityName)
        )
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                return response.json(); // JSON 응답 파싱 (분당 칼로리 값)
            })
            .then((data) => {
                currentCaloriePerMin = data || 0.0; // 분당 칼로리 값 저장
                updateSummary(); // 요약 정보 업데이트
            })
            .catch((error) => {
                console.error("칼로리 값 조회 오류:", error);
                currentCaloriePerMin = 0.0; // 오류 발생 시 0으로 설정
                updateSummary();
            });
    }

    /**
     * 모달 내 하단 루틴 요약 정보 (요일, 시간, 예상 kcal)를 업데이트합니다.
     */
    function updateSummary() {
        // 활성화된 요일 버튼의 개수를 세어 요약
        const activeDays = document.querySelectorAll(".day-btn.active").length;
        summaryDayCount.textContent = `반복 요일 : ${activeDays}일`;

        // 선택된 시간(분)을 가져옴
        const durationMin = parseInt(durationMinSelect.value) || 0;
        summaryDuration.textContent = `시간 : ${durationMin}분`;

        // 예상 칼로리 계산: 분당 칼로리 * 시간(분)
        const estimatedKcal = Math.round(currentCaloriePerMin * durationMin);
        summaryKcal.textContent = `예상 소모 kcal / 회 : ${estimatedKcal.toLocaleString( // 숫자 포맷팅
            "ko-KR"
        )} kcal`;
    }

    // --------------------------------------------------------
    // [카테고리 비율 계산 및 업데이트] (좌측 패널)
    // --------------------------------------------------------

    /**
     * 루틴 목록을 분석하여 카테고리별 비율을 계산하고 좌측 패널 차트와 리스트를 업데이트합니다.
     */
    function updateCategoryRatio() {
        const allRoutines = Array.from(document.querySelectorAll(".routine-card")); // 모든 루틴 카드
        if (!chartCircle) return; // 차트 요소가 없으면 종료

        let categoryCounts = { 스포츠: 0, 유산소: 0, 근력: 0, 스트레칭: 0 }; // 카테고리별 횟수 저장 객체
        let totalCount = allRoutines.length; // 총 루틴 개수

        if (totalCount === 0) { // 루틴이 없을 경우 초기화
            activityListItems.forEach((item) => {
                const percentSpan = item.querySelector(".activity-percent");
                if (percentSpan) percentSpan.textContent = "0%";
            });
            chartCircle.style.background = `conic-gradient(#f0f0f0 0deg 360deg)`;
            return;
        }

        // 2. 카테고리별 갯수 계산
        allRoutines.forEach((card) => {
            const tagElement = card.querySelector(".tag"); // 카테고리 태그 요소
            if (tagElement) {
                const category = tagElement.textContent.trim();
                if (categoryCounts.hasOwnProperty(category)) {
                    categoryCounts[category]++; // 해당 카테고리 카운트 증가
                }
            }
        });

        // 3. 비율 계산, 리스트 업데이트, 코닉 그라디언트 문자열 생성
        let currentAngle = 0;
        let conicGradient = [];

        // CSS에 정의된 카테고리별 색상 (차트 시각화를 위해 사용)
        const categoryColors = {
            유산소: "#ffc107",
            근력: "#28a745",
            스포츠: "#dc3545",
            스트레칭: "#007bff",
        };

        for (const category in categoryCounts) {
            const count = categoryCounts[category];
            const percent = (count / totalCount) * 100; // 비율 계산
            const angle = (percent / 100) * 360; // 360도 중 차지하는 각도 계산

            // 활동 리스트 (좌측) 비율 업데이트
            const listItem = Array.from(activityListItems).find((item) => {
                const nameSpan = item.querySelector(".activity-name");
                return nameSpan && nameSpan.textContent.trim() === category;
            });

            if (listItem) {
                const percentSpan = listItem.querySelector(".activity-percent");
                if (percentSpan) {
                    percentSpan.textContent = `${Math.round(percent)}%`;
                }
            }

            // 코닉 그라디언트 문자열 생성 (차트 시각화 데이터)
            if (percent > 0) {
                conicGradient.push(
                    `${categoryColors[category]} ${currentAngle}deg ${
                        currentAngle + angle
                    }deg`
                );
            }
            currentAngle += angle;
        }

        // 4. 차트 업데이트 (코닉 그라디언트 적용)
        if (conicGradient.length > 0) {
            chartCircle.style.background = `conic-gradient(${conicGradient.join(
                ", "
            )})`;
        } else {
            chartCircle.style.background = `conic-gradient(#f0f0f0 0deg 360deg)`;
        }
    }

    // --------------------------------------------------------
    // [주간 목표 요약 및 예상 칼로리 업데이트] (우측 패널)
    // --------------------------------------------------------

    /**
     * 우측 패널의 주간 목표 요약 및 예상 칼로리 정보를 DOM을 기반으로 업데이트합니다.
     */
    function updateGoalSummary() {
        const allRoutines = Array.from(document.querySelectorAll(".routine-card"));
        const goalTarget = 5; // 주간 목표 횟수
        let activeDays = new Set(); // 중복 없이 활동 요일을 저장할 Set
        let totalExpectedKcal = 0; // 주간 총 예상 칼로리 합산 변수

        // 1. 루틴 카드 순회 및 데이터 추출
        allRoutines.forEach((card) => {
            // 1-1. 활성화된 요일 (Day Dot) 추출
            const activeDots = card.querySelectorAll(".routine-days .day-dot.active");
            activeDots.forEach((dot) => {
                activeDays.add(dot.textContent.trim()); // Set에 요일 추가 (중복 제거)
            });

            // 1-2. 예상 소모 칼로리 추출 (JSP에서 설정한 data-weekly-kcal 속성 사용)
            const kcalValue = card.dataset.weeklyKcal; // data-weekly-kcal 값 가져오기
            const kcal = parseInt(kcalValue) || 0; // 정수로 변환 (실패 시 0)
            totalExpectedKcal += kcal; // 총 칼로리에 합산
        });

        const activeDaysCount = activeDays.size; // 주간에 활성화된 요일 수 (목표 달성 횟수)

        // 2. 목표 달성률 계산 및 DOM 업데이트
        const progress = Math.min(100, (activeDaysCount / goalTarget) * 100); // 진행률 계산 (최대 100%)

        if (currentGoalCountSpan)
            currentGoalCountSpan.textContent = activeDaysCount; // 달성 횟수 업데이트
        if (progressBar) progressBar.style.width = progress + "%"; // 진행률 바 스타일 업데이트
        if (progressPercentSpan)
            progressPercentSpan.textContent = Math.round(progress) + "%"; // 진행률 텍스트 업데이트

        // 3. 총 예상 칼로리 DOM 업데이트 (ID: total-expected-kcal 사용)
        if (totalExpectedKcalSpan)
            totalExpectedKcalSpan.textContent =
                totalExpectedKcal.toLocaleString("ko-KR"); // 숫자 포맷팅하여 표시

        console.log(
            `목표 요약 업데이트: 활성 요일 ${activeDaysCount}회, 예상 칼로리 ${totalExpectedKcal} kcal`
        );
    }

    // --------------------------------------------------------
    // [검색 및 카테고리 필터링 로직]
    // --------------------------------------------------------

    /**
     * 루틴 목록을 현재 선택된 카테고리 탭과 검색어에 따라 필터링하는 함수
     */
    function filterRoutinesBy(selectedCategory) {
        const allRoutineCards = Array.from( // 모든 루틴 카드
            document.querySelectorAll(".routine-card")
        );

        if (allRoutineCards.length === 0) {
            return;
        }

        const searchTerm = searchInput.value.trim().toLowerCase(); // 검색어 (소문자)

        allRoutineCards.forEach((card) => {
            const titleElement = card.querySelector(".routine-title");
            const routineName = titleElement
                ? titleElement.textContent.trim().toLowerCase()
                : "";
            const tagElement = card.querySelector(".tag");
            const routineCategory = tagElement ? tagElement.textContent.trim() : "";

            // 1. 카테고리 일치 확인
            const categoryMatch =
                selectedCategory === "전체" || routineCategory === selectedCategory;

            // 2. 검색어 포함 확인 (루틴 이름 또는 카테고리에 검색어 포함)
            const searchMatch =
                routineName.includes(searchTerm) ||
                routineCategory.toLowerCase().includes(searchTerm);

            // 두 조건이 모두 참일 때만 'grid' (표시)
            if (categoryMatch && searchMatch) {
                card.style.display = "grid";
            } else { // 아니면 'none' (숨김)
                card.style.display = "none";
            }
        });
    }

    // --- 카테고리 탭 클릭 이벤트 핸들러 ---
    categoryTabs.forEach((button) => {
        button.addEventListener("click", function () {
            categoryTabs.forEach((btn) => btn.classList.remove("active")); // 모든 탭 비활성화
            this.classList.add("active"); // 클릭된 탭 활성화
            const category = this.textContent.trim();
            filterRoutinesBy(category); // 필터링 실행
        });
    });

    // --- 검색 이벤트 핸들러 ---
    if (routineSearchForm) {
        routineSearchForm.addEventListener("submit", function (e) {
            e.preventDefault(); // 폼 제출 방지
        });
    }

    if (searchInput) {
        searchInput.addEventListener("input", function () { // 입력 시마다 실행
            const activeTab = document.querySelector(".tab-button.active");
            const currentCategory = activeTab ? activeTab.textContent.trim() : "전체";
            filterRoutinesBy(currentCategory); // 현재 활성화된 카테고리를 기준으로 필터링
        });
    }

    // --------------------------------------------------------
    // [루틴 삭제 로직]
    // --------------------------------------------------------

    if (routineListContainer) {
        // 루틴 목록 컨테이너에 이벤트 위임 (동적으로 추가된 요소 처리)
        routineListContainer.addEventListener("click", function (e) {
            if (e.target.classList.contains("delete-routine-btn")) { // 삭제 버튼 클릭 시
                const routineCard = e.target.closest(".routine-card");
                const routineId = routineCard
                    ? routineCard.getAttribute("data-routine-id") // 루틴 ID 추출
                    : null;

                if (routineId && confirm("정말로 이 루틴을 삭제하시겠습니까?")) {
                    deleteRoutine(routineId); // 삭제 함수 호출
                }
            }
        });
    }

    function deleteRoutine(routineId) {
        fetch("/routine/delete/" + routineId, { // 삭제 API 호출
            method: "POST",
            headers: { "Content-Type": "application/json" },
        })
            .then((response) => {
                if (!response.ok) { // HTTP 오류 처리
                    throw new Error(
                        "서버 오류가 발생했거나 루틴 삭제에 실패했습니다. (HTTP Error)"
                    );
                }

                const contentType = response.headers.get("content-type");

                if (contentType && contentType.includes("application/json")) {
                    return response.json(); // JSON 응답 처리
                } else {
                    return null; // JSON이 아니면 null 반환
                }
            })
            .then((result) => {
                alert("루틴이 성공적으로 삭제되었습니다.");
                // 삭제 성공 후 전체 업데이트를 위해 새로고침
                window.location.reload();
            })
            .catch((error) => {
                console.error("루틴 삭제 중 오류 발생:", error);
                alert("루틴 삭제에 실패했습니다: " + error.message);
            });
    }

    // --------------------------------------------------------
    // [초기화]
    // --------------------------------------------------------

    // 페이지 로드 시 초기 요약 정보를 한 번 업데이트 (모달 내 하단 요약)
    updateSummary();

    // 🚨 페이지 로드 시 카테고리 비율 업데이트 (좌측 패널)
    updateCategoryRatio();

    // 🚨 페이지 로드 시 주간 목표 요약 업데이트 (우측 패널)
    updateGoalSummary();

    // 페이지 로드 시 '전체' 탭 기준으로 루틴 목록 초기 필터링 실행
    filterRoutinesBy("전체");
});