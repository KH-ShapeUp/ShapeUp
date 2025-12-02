document.addEventListener("DOMContentLoaded", function () { // 문서의 HTML과 DOM 트리가 완전히 로드된 후 전체 함수 실행
    // --------------------------------------------------------
    // [DOM 요소 정의] - 모달 및 폼 관련
    // --------------------------------------------------------

    const addButton = document.querySelector(".btn-add"); // '추가하기' 버튼 DOM 요소 선택 (루틴 추가)
    const modal = document.getElementById("routineModal"); // 루틴 모달 오버레이 (배경 포함) DOM 요소 선택
    const closeButton = document.querySelector(".close-modal-btn"); // 모달 닫기 버튼(X 아이콘) DOM 요소 선택
    
    // 루틴 폼 및 입력 필드
    const routineForm = document.getElementById("routineForm"); // 루틴 저장 및 수정 폼
    const routineNameInput = document.getElementById("routineNameInput"); // 루틴 이름 입력 필드
    const activityTypeSelect = document.querySelector(".activity-type-select"); // 활동 분류 (유산소, 근력 등) 드롭다운
    const strengthSelect = document.querySelector(".strength-select"); // 강도 (상, 중, 하) 드롭다운
    const startTimeInput = document.getElementById("startTimeInput"); // 시작 시간 (time 타입) 입력 필드
    const activityNameSelect = document.getElementById("activityNameSelect"); // 종목 (달리기, 수영 등) 드롭다운
    const durationMinSelect = document.getElementById("durationMinSelect"); // 시간(분) 드롭다운
    const dayButtons = document.querySelectorAll(".day-btn"); // 월~일 요일 선택 버튼들 (NodeList)
    
    // 모달 하단 요약 정보 컨테이너 및 항목
    const routineSummaryWrapper = document.querySelector(".routine-summary"); // 모달 요약 정보 컨테이너
    const summaryDayCount = routineSummaryWrapper.querySelector(".summary-day"); // 요약: 반복 요일 수 표시 <span>
    const summaryDuration = routineSummaryWrapper.querySelector(".summary-time"); // 요약: 시간 표시 <span>
    const summaryKcal = routineSummaryWrapper.querySelector(".summary-kcal"); // 요약: 예상 칼로리 표시 <span>

    // --------------------------------------------------------
    // [DOM 요소 정의] - 루틴 목록 및 패널 관련
    // --------------------------------------------------------

    // 루틴 목록 관련 DOM 요소
    const routineListContainer = document.querySelector(".routine-list"); // 루틴 카드 목록을 담는 컨테이너
    const routineCards = document.querySelectorAll(".routine-card"); // (초기 로딩된) 루틴 카드들 (현재 페이지에 존재하는 카드)
    const routineSearchForm = document.getElementById("routineSearchForm"); // 검색 폼 (submit 방지용)
    const searchInput = document.getElementById("searchInput"); // 검색 입력 필드
    const categoryTabs = document.querySelectorAll(".category-tabs .tab-button"); // 카테고리 탭 버튼들

    // 좌측 패널 (활동 요약) 관련 DOM 요소
    const activityListItems = document.querySelectorAll( // 활동 리스트 항목 (스포츠, 유산소 등)
        ".activity-list .activity-item"
    );
    const chartCircle = document.querySelector(".ratio-chart .chart-circle"); // 카테고리 비율을 시각화하는 차트 원형 (CSS conic-gradient 적용)

    // 우측 패널 DOM 요소 (목표 및 칼로리)
    const currentGoalCountSpan = document.getElementById("current-goal-count"); // 현재 달성 횟수 표시 <span>
    const progressBar = document.getElementById("progress-bar"); // 주간 목표 진행률 바
    const progressPercentSpan = document.getElementById("progress-percent"); // 진행률 텍스트 (예: 60%)
    const totalExpectedKcalSpan = document.getElementById("total-expected-kcal"); // 주간 총 예상 칼로리 표시 (우측 패널)

    let currentCaloriePerMin = 0.0; // 현재 선택된 활동 종목의 **분당** 칼로리 값 (AJAX를 통해 서버에서 가져옴)

    // --------------------------------------------------------
    // [모달 열기/닫기 로직]
    // --------------------------------------------------------

    // 루틴 추가 버튼 클릭 이벤트: 모달 표시 및 폼 초기화
    if (addButton && modal) {
        addButton.addEventListener("click", function () {
            modal.style.display = "flex"; // 모달을 보이게 설정
            // 모달 열 때 폼과 요일 선택 초기화 (사용자 경험 개선)
            routineForm.reset(); // 모든 폼 필드 초기화 (텍스트, 드롭다운)
            dayButtons.forEach(btn => btn.classList.remove('active')); // 요일 버튼 활성화 상태 해제
            updateSummary(); // 모달 하단 요약 정보 초기화 및 업데이트
        });
    }

    // 모달 닫기 - X 버튼 클릭 이벤트
    if (closeButton && modal) {
        closeButton.addEventListener("click", function () {
            modal.style.display = "none"; // 모달 숨김
        });
    }

    // 모달 닫기 - 오버레이 영역 클릭 이벤트
    if (modal) {
        modal.addEventListener("click", function (e) {
            if (e.target === modal) { // 클릭된 요소가 정확히 모달 오버레이 자신일 경우에만
                modal.style.display = "none"; // 오버레이 클릭 시 모달 닫기
            }
        });
    }

    // --------------------------------------------------------
    // [루틴 저장 및 폼 제출 로직]
    // --------------------------------------------------------

    // 루틴 저장 폼 제출 이벤트 핸들러
    if (routineForm) {
        routineForm.addEventListener("submit", function (e) {
            e.preventDefault(); // 기본 폼 제출(페이지 이동/새로고침) 동작 방지

            // 활성화된 요일 버튼에서 요일 데이터 추출 (배열 형태)
            const selectedDays = Array.from(dayButtons)
                .filter((btn) => btn.classList.contains("active")) // 'active' 클래스가 있는 버튼만 필터링
                .map((btn) => btn.getAttribute("data-day")); // 각 버튼의 'data-day' 속성값(요일)을 추출

            // 폼 유효성 검증
            if (selectedDays.length === 0) { // 요일 선택 검증
                alert("반복 요일을 1개 이상 선택해 주세요.");
                return; // 함수 실행 중단
            }
            if (!activityNameSelect.value || !durationMinSelect.value) { // 종목/시간 선택 검증
                alert("활동 종목과 시간을 모두 선택해 주세요.");
                return; // 함수 실행 중단
            }
            
            // 1회 예상 소모 칼로리 계산 (Math.round를 사용하여 정수로 반올림)
            const durationValue = parseInt(durationMinSelect.value);
            const estimatedKcal = Math.round(currentCaloriePerMin * durationValue);
            
            // 주당 총 예상 칼로리 계산 (1회 칼로리 * 반복 요일 수)
            const totalWeeklyKcal = estimatedKcal * selectedDays.length;

            // 서버 전송을 위한 데이터 객체 구성
            const formData = {
                routineName: routineNameInput.value.trim(),
                userNo: 1, // 서버에서 실제 사용자 정보로 대체 필요
                activityName: activityNameSelect.value,
                activityType: activityTypeSelect.value,
                strength: strengthSelect.value,
                durationMin: durationValue, // 정수 형태로 전송
                startTime: startTimeInput.value,
                days: selectedDays, // 배열(List) 형태의 요일 데이터 전송
                totalKcal: totalWeeklyKcal // 계산된 주당 총 칼로리 값 전송
            };

            console.log("전송할 루틴 데이터:", formData);
            saveRoutine(formData); // 루틴 저장 함수 호출 (AJAX POST)
        });
    }

    /**
     * 서버에 루틴 저장 요청 (POST 요청, JSON 데이터 전송)
     * @param {Object} data - 저장할 루틴 정보 객체
     */
    function saveRoutine(data) {
        fetch("/routine/create", { // 루틴 생성 API 엔드포인트
            method: "POST",
            headers: { 
                "Content-Type": "application/json" // 서버에 JSON 데이터를 보냄을 알림
            },
            body: JSON.stringify(data), // JavaScript 객체를 JSON 문자열로 변환하여 전송
        })
            .then((response) => {
                if (!response.ok) { // HTTP 상태 코드가 4xx 또는 5xx 일 때
                    // 서버가 에러 메시지를 JSON 형태로 보냈다고 가정하고 처리
                    return response.json().then((error) => {
                        throw new Error(error.message || "루틴 저장 실패");
                    });
                }
                return response.json(); // 성공 시 응답 본문을 JSON으로 파싱
            })
            .then((result) => {
                alert("루틴이 성공적으로 저장되었습니다.");
                modal.style.display = "none";
                // 루틴 목록, 요약 정보, 차트 등 전체 업데이트를 위해 페이지 새로고침
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

    // 요일 버튼 클릭 이벤트: 활성화 상태 토글 및 요약 정보 업데이트
    dayButtons.forEach((button) => {
        button.addEventListener("click", function (e) {
            e.preventDefault(); // 버튼 클릭 시 폼 제출 방지 (폼 안에 있어도 발생 가능)
            this.classList.toggle("active"); // 'active' 클래스를 추가/제거
            updateSummary(); // 모달 요약 정보(반복 요일 수) 업데이트
        });
    });

    // 활동 종목 선택 변경 이벤트: 분당 칼로리 조회 및 요약 업데이트
    activityNameSelect.addEventListener("change", function () {
        const selectedActivityName = this.value; // 선택된 활동 이름

        if (selectedActivityName) {
            fetchCalorieAndUpdatedSummary(selectedActivityName); // 서버에서 분당 칼로리 조회 후 요약 업데이트
        } else {
            currentCaloriePerMin = 0.0; // 활동 선택이 해제되면 칼로리 값을 0으로 초기화
            updateSummary(); // 요약 정보 업데이트 (칼로리 0으로 표시)
        }
    });

    // 활동 시간(분) 선택 변경 이벤트: 예상 칼로리 요약 업데이트
    durationMinSelect.addEventListener("change", function () {
        updateSummary();
    });

    /**
     * 활동 이름에 해당하는 분당 칼로리를 서버에서 조회 (GET 요청)하고 전역 변수를 업데이트합니다.
     * @param {string} activityName - 조회할 활동 종목 이름
     */
    function fetchCalorieAndUpdatedSummary(activityName) {
        // 활동 이름을 인코딩하여 GET 쿼리 파라미터로 전송 (한글 깨짐 방지)
        fetch( 
            "/routine/getCalorie?activityName=" + encodeURIComponent(activityName)
        )
            .then((response) => {
                if (!response.ok) { // 응답 코드가 200번대가 아닐 경우
                    throw new Error("분당 칼로리 조회 실패 (네트워크/서버)");
                }
                return response.json(); // 응답 본문의 분당 칼로리 값(JSON) 파싱
            })
            .then((data) => {
                currentCaloriePerMin = data || 0.0; // 전역 변수 업데이트 (서버 응답 값 또는 0.0)
                updateSummary(); // 새로운 칼로리 값으로 모달 요약 업데이트
            })
            .catch((error) => {
                console.error("칼로리 값 조회 오류:", error);
                currentCaloriePerMin = 0.0; // 오류 발생 시 안전하게 0으로 설정
                updateSummary();
            });
    }

    /**
     * 모달 내 하단 루틴 요약 정보 (요일 수, 시간, 예상 kcal/회)를 계산하고 업데이트합니다.
     */
    function updateSummary() {
        // 1. 반복 요일 수 계산 및 업데이트
        const activeDays = document.querySelectorAll(".day-btn.active").length;
        summaryDayCount.textContent = `반복 요일 : ${activeDays}일`;

        // 2. 선택된 시간(분) 업데이트
        const durationMin = parseInt(durationMinSelect.value) || 0;
        summaryDuration.textContent = `시간 : ${durationMin}분`;

        // 3. 예상 칼로리 계산 및 업데이트 (1회 기준)
        // Math.round를 사용하여 소수점을 반올림 처리
        const estimatedKcal = Math.round(currentCaloriePerMin * durationMin); 
        summaryKcal.textContent = `예상 소모 kcal / 회 : ${estimatedKcal.toLocaleString( // 숫자 포맷팅 (예: 1,000)
            "ko-KR"
        )} kcal`;
    }

    // --------------------------------------------------------
    // [카테고리 비율 계산 및 업데이트] (좌측 패널)
    // --------------------------------------------------------

    /**
     * 루틴 목록을 순회하며 카테고리별 비율을 계산하고 좌측 패널 차트와 리스트를 업데이트합니다.
     */
    function updateCategoryRatio() {
        const allRoutines = Array.from(document.querySelectorAll(".routine-card")); // 현재 DOM에 있는 모든 루틴 카드
        if (!chartCircle) return; // 차트 요소가 없으면 실행 중지

        let categoryCounts = { 스포츠: 0, 유산소: 0, 근력: 0, 스트레칭: 0 }; // 카테고리별 횟수를 저장할 객체 초기화
        let totalCount = allRoutines.length; // 총 루틴 개수

        if (totalCount === 0) { // 루틴이 없을 경우, 0%로 초기화
            activityListItems.forEach((item) => {
                const percentSpan = item.querySelector(".activity-percent");
                if (percentSpan) percentSpan.textContent = "0%";
            });
            chartCircle.style.background = `conic-gradient(#f0f0f0 0deg 360deg)`; // 차트를 회색으로 초기화
            return;
        }

        // 2. 루틴 카드를 순회하며 카테고리별 갯수 카운트
        allRoutines.forEach((card) => {
            const tagElement = card.querySelector(".tag"); // 카테고리 태그 (예: <span class="tag tag-유산소">유산소</span>)
            if (tagElement) {
                const category = tagElement.textContent.trim(); // 카테고리 이름 추출
                if (categoryCounts.hasOwnProperty(category)) {
                    categoryCounts[category]++; // 해당 카테고리 카운트 증가
                }
            }
        });

        // 3. 비율 계산, 리스트 업데이트, 코닉 그라디언트 문자열 생성
        let currentAngle = 0; // 현재까지 누적된 각도
        let conicGradient = []; // CSS conic-gradient 값 저장 배열

        // CSS에 정의된 카테고리별 색상 (차트 시각화를 위해 미리 정의)
        const categoryColors = {
            유산소: "#ffc107",
            근력: "#28a745",
            스포츠: "#dc3545",
            스트레칭: "#007bff",
        };

        for (const category in categoryCounts) {
            const count = categoryCounts[category];
            const percent = (count / totalCount) * 100; // 비율 (%) 계산
            const angle = (percent / 100) * 360; // 360도 중 차지하는 각도 계산

            // 활동 리스트 (좌측 패널) 비율 텍스트 업데이트
            const listItem = Array.from(activityListItems).find((item) => {
                const nameSpan = item.querySelector(".activity-name");
                return nameSpan && nameSpan.textContent.trim() === category; // 카테고리 이름이 일치하는 리스트 항목 찾기
            });

            if (listItem) {
                const percentSpan = listItem.querySelector(".activity-percent");
                if (percentSpan) {
                    percentSpan.textContent = `${Math.round(percent)}%`; // 소수점 제거 후 표시
                }
            }

            // 코닉 그라디언트 문자열 생성 (파이 차트 시각화 데이터)
            if (percent > 0) {
                conicGradient.push(
                    `${categoryColors[category]} ${currentAngle}deg ${ // 색상, 시작 각도
                        currentAngle + angle // 종료 각도
                    }deg`
                );
            }
            currentAngle += angle; // 다음 카테고리를 위해 각도 누적
        }

        // 4. 차트 업데이트 (background-image 속성에 conic-gradient 적용)
        if (conicGradient.length > 0) {
            chartCircle.style.background = `conic-gradient(${conicGradient.join(
                ", "
            )})`;
        } else { // 모든 카운트가 0일 때
            chartCircle.style.background = `conic-gradient(#f0f0f0 0deg 360deg)`;
        }
    }

    // --------------------------------------------------------
    // [주간 목표 요약 및 예상 칼로리 업데이트] (우측 패널)
    // --------------------------------------------------------

    /**
     * 우측 패널의 주간 목표 달성 횟수, 진행률 및 총 예상 칼로리를 DOM을 기반으로 계산/업데이트합니다.
     */
    function updateGoalSummary() {
        const allRoutines = Array.from(document.querySelectorAll(".routine-card")); // 모든 루틴 카드
        const goalTarget = 5; // 주간 목표 횟수 (예: 주 5회 운동 목표)
        let activeDays = new Set(); // 중복 없이 활동 요일을 저장할 Set (실제 달성 횟수 계산용)
        let totalExpectedKcal = 0; // 모든 루틴의 주간 총 예상 칼로리 합산 변수

        // 1. 루틴 카드 순회 및 데이터 추출
        allRoutines.forEach((card) => {
            // 1-1. 활성화된 요일 (Day Dot) 추출 및 Set에 추가
            const activeDots = card.querySelectorAll(".routine-days .day-dot.active");
            activeDots.forEach((dot) => {
                activeDays.add(dot.textContent.trim()); // 요일을 추가 (Set이 중복을 자동으로 제거)
            });

            // 1-2. 주간 예상 소모 칼로리 추출
            const kcalValue = card.dataset.weeklyKcal; // data-weekly-kcal 속성 값 가져오기 (JSP에서 계산된 값)
            const kcal = parseInt(kcalValue) || 0; 
            totalExpectedKcal += kcal; // 총 칼로리에 합산
        });

        const activeDaysCount = activeDays.size; // Set의 크기 = 중복이 제거된 실제 활동 요일 수

        // 2. 목표 달성률 계산 및 DOM 업데이트
        // (달성 횟수 / 목표 횟수) * 100. 최대 100%를 넘지 않도록 Math.min 사용
        const progress = Math.min(100, (activeDaysCount / goalTarget) * 100); 

        if (currentGoalCountSpan)
            currentGoalCountSpan.textContent = activeDaysCount; // 달성 횟수 업데이트
        if (progressBar) progressBar.style.width = progress + "%"; // 진행률 바 너비 업데이트
        if (progressPercentSpan)
            progressPercentSpan.textContent = Math.round(progress) + "%"; // 진행률 텍스트 업데이트

        // 3. 총 예상 칼로리 DOM 업데이트
        if (totalExpectedKcalSpan)
            totalExpectedKcalSpan.textContent =
                totalExpectedKcal.toLocaleString("ko-KR"); // 천 단위 구분 기호 포맷팅
    }

    // --------------------------------------------------------
    // [검색 및 카테고리 필터링 로직]
    // --------------------------------------------------------

    /**
     * 루틴 목록을 현재 선택된 카테고리 탭과 검색어에 따라 필터링하여 표시/숨김 처리합니다.
     * @param {string} selectedCategory - 현재 활성화된 카테고리 탭 이름 (예: "유산소", "전체")
     */
    function filterRoutinesBy(selectedCategory) {
        const allRoutineCards = Array.from( // 모든 루틴 카드
            document.querySelectorAll(".routine-card")
        );

        if (allRoutineCards.length === 0) {
            return;
        }

        const searchTerm = searchInput.value.trim().toLowerCase(); // 검색어 공백 제거 및 소문자 변환

        allRoutineCards.forEach((card) => {
            const titleElement = card.querySelector(".routine-title");
            const routineName = titleElement
                ? titleElement.textContent.trim().toLowerCase() // 루틴 이름 소문자 변환
                : "";
            const tagElement = card.querySelector(".tag");
            const routineCategory = tagElement ? tagElement.textContent.trim() : ""; // 루틴 카테고리 이름

            // 1. 카테고리 일치 확인: "전체"이거나 카테고리 이름이 일치해야 함
            const categoryMatch =
                selectedCategory === "전체" || routineCategory === selectedCategory;

            // 2. 검색어 포함 확인: 루틴 이름 또는 카테고리 이름에 검색어가 포함되어야 함
            const searchMatch =
                routineName.includes(searchTerm) ||
                routineCategory.toLowerCase().includes(searchTerm);

            // 두 조건이 모두 참일 때만 'grid' 레이아웃으로 표시
            if (categoryMatch && searchMatch) {
                card.style.display = "grid"; // CSS 그리드 레이아웃으로 카드 표시
            } else { 
                card.style.display = "none"; // 조건 불일치 시 카드 숨김
            }
        });
    }

    // --- 카테고리 탭 클릭 이벤트 핸들러 ---
    categoryTabs.forEach((button) => {
        button.addEventListener("click", function () {
            categoryTabs.forEach((btn) => btn.classList.remove("active")); // 모든 탭 비활성화
            this.classList.add("active"); // 클릭된 탭 활성화
            const category = this.textContent.trim(); // 클릭된 탭의 텍스트(카테고리 이름)
            filterRoutinesBy(category); // 필터링 함수 실행
        });
    });

    // --- 검색 폼 제출 방지 핸들러 ---
    if (routineSearchForm) {
        routineSearchForm.addEventListener("submit", function (e) {
            e.preventDefault(); // 검색 폼 제출 시 페이지 이동 방지
        });
    }

    // --- 검색 입력 변경 이벤트 핸들러 ---
    if (searchInput) {
        searchInput.addEventListener("input", function () { // 사용자가 입력 필드를 수정할 때마다 실행
            const activeTab = document.querySelector(".tab-button.active");
            const currentCategory = activeTab ? activeTab.textContent.trim() : "전체"; // 현재 활성화된 탭 확인
            filterRoutinesBy(currentCategory); // 현재 카테고리와 검색어를 기준으로 필터링
        });
    }

    // --------------------------------------------------------
    // [루틴 삭제 로직]
    // --------------------------------------------------------

    if (routineListContainer) {
        // 부모 요소(routineListContainer)에 이벤트 리스너를 등록하여 동적으로 추가된 삭제 버튼 처리 (이벤트 위임)
        routineListContainer.addEventListener("click", function (e) {
            // 클릭된 요소가 삭제 버튼(.delete-routine-btn)인지 확인
            if (e.target.classList.contains("delete-routine-btn")) { 
                const routineCard = e.target.closest(".routine-card"); // 가장 가까운 부모 루틴 카드 찾기
                const routineId = routineCard
                    ? routineCard.getAttribute("data-routine-id") // data-routine-id 속성에서 루틴 ID 추출
                    : null;

                if (routineId && confirm("정말로 이 루틴을 삭제하시겠습니까?")) { // 루틴 ID가 유효하고 사용자 확인을 거쳤을 경우
                    deleteRoutine(routineId); // 루틴 삭제 함수 호출 (AJAX)
                }
            }
        });
    }

    /**
     * 서버에 루틴 삭제 요청 (POST 요청)
     * @param {string} routineId - 삭제할 루틴의 고유 ID
     */
    function deleteRoutine(routineId) {
        fetch("/routine/delete/" + routineId, { // 루틴 삭제 API 엔드포인트
            method: "POST", // HTTP DELETE 대신 POST를 사용하는 경우
            headers: { "Content-Type": "application/json" },
            // body: JSON.stringify({ routineId: routineId }), // ID를 URL로 전달했으므로 body는 생략 가능
        })
            .then((response) => {
                if (!response.ok) { 
                    throw new Error(
                        "서버 오류 또는 루틴 삭제 실패 (HTTP 상태 코드 오류)"
                    );
                }

                // 응답 Content-Type 확인 (서버가 성공 응답 시 JSON을 반환할 수도 있고, 아닐 수도 있음)
                const contentType = response.headers.get("content-type");

                if (contentType && contentType.includes("application/json")) {
                    return response.json(); // JSON 응답 파싱
                } else {
                    return null; // JSON이 아니면 다음 .then으로 null 반환
                }
            })
            .then((result) => {
                alert("루틴이 성공적으로 삭제되었습니다.");
                // 삭제 성공 후, 변경된 목록 반영을 위해 페이지 전체 새로고침
                window.location.reload();
            })
            .catch((error) => {
                console.error("루틴 삭제 중 오류 발생:", error);
                alert("루틴 삭제에 실패했습니다: " + error.message);
            });
    }

    // --------------------------------------------------------
    // [초기 실행 로직]
    // --------------------------------------------------------

    // DOMContentLoaded 이벤트 발생 시, 페이지의 모든 동적 정보를 초기화하고 업데이트
    
    // 1. 페이지 로드 시 초기 모달 요약 정보를 업데이트 (선택된 값 기준으로 계산)
    updateSummary();

    // 2. 페이지 로드 시 좌측 패널의 루틴 카테고리 비율 정보를 계산 및 업데이트
    updateCategoryRatio();

    // 3. 페이지 로드 시 우측 패널의 주간 목표 달성 횟수 및 총 예상 칼로리를 계산 및 업데이트
    updateGoalSummary();

    // 4. 페이지 로드 시 '전체' 탭 기준으로 루틴 목록 초기 필터링을 적용 (숨겨진 카드가 없도록 보장)
    filterRoutinesBy("전체");
});