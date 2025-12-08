document.addEventListener("DOMContentLoaded", function() {
	// 문서의 HTML과 DOM 트리가 완전히 로드된 후 전체 함수 실행
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
	const activityListItems = document.querySelectorAll(
		// 활동 리스트 항목 (스포츠, 유산소 등)
		".activity-list .activity-item"
	);
	const chartCircle = document.querySelector(".ratio-chart .chart-circle"); // 카테고리 비율을 시각화하는 차트 원형
	const chartTooltip = document.getElementById('chartTooltip'); // 차트 마우스 오버 시 표시되는 외부 툴팁

	// 우측 패널 DOM 요소 (목표 및 칼로리)
	const goalsPanel = document.querySelector(".goals-panel"); // 주간 목표 전체 컨테이너 (data-weekly-goal 속성을 가짐)
	const currentGoalCountSpan = document.getElementById("current-goal-count"); // 현재 달성 횟수 표시 <span>
	const progressBar = document.getElementById("progress-bar"); // 주간 목표 진행률 바
	const progressPercentSpan = document.getElementById("progress-percent"); // 진행률 텍스트 (예: 60%)
	const totalExpectedKcalSpan = document.getElementById("total-expected-kcal"); // 주간 총 예상 칼로리 표시 (우측 패널)
	
    // 🚨 [추가] 사용자가 목표 횟수를 입력하는 필드
    const goalInput = document.getElementById("goal-input"); 

	let currentCaloriePerMin = 0.0; // 현재 선택된 활동 종목의 **분당** 칼로리 값
    
    // 툴팁 기능에서 사용할 차트 데이터 세그먼트 저장 배열
    let chartDataSegments = []; 
    // 카테고리 색상 정의 (JS에서 사용)
    const categoryColors = {
        스포츠: '#2f80ff',    
        유산소: '#ff9fb2',   
        근력: '#ffce73',     
        스트레칭: '#8b9bff'  
    };

	// --------------------------------------------------------
	// [모달 열기/닫기 로직]
	// --------------------------------------------------------
	// 루틴 추가 버튼 클릭 이벤트: 모달 표시 및 폼 초기화
	if (addButton && modal) {
		addButton.addEventListener("click", function() {
			modal.style.display = "flex"; // 모달을 보이게 설정
			routineForm.reset(); // 모든 폼 필드 초기화
			dayButtons.forEach((btn) => btn.classList.remove("active")); // 요일 버튼 활성화 상태 해제
			updateSummary(); // 모달 하단 요약 정보 초기화 및 업데이트
		});
	}
	// 모달 닫기 - X 버튼 클릭 이벤트
	if (closeButton && modal) {
		closeButton.addEventListener("click", function() {
			modal.style.display = "none"; // 모달 숨김
		});
	}
	// 모달 닫기 - 오버레이 영역 클릭 이벤트
	if (modal) {
		modal.addEventListener("click", function(e) {
			if (e.target === modal) {
				modal.style.display = "none"; // 오버레이 클릭 시 모달 닫기
			}
		});
	}

	// --------------------------------------------------------
	// [루틴 저장 및 폼 제출 로직]
	// --------------------------------------------------------
	// 루틴 저장 폼 제출 이벤트 핸들러
	if (routineForm) {
		routineForm.addEventListener("submit", function(e) {
			e.preventDefault(); // 기본 폼 제출 동작 방지
			// 활성화된 요일 버튼에서 요일 데이터 추출
			const selectedDays = Array.from(dayButtons)
				.filter((btn) => btn.classList.contains("active")) 
				.map((btn) => btn.getAttribute("data-day")); 

			// 폼 유효성 검증 (요일 선택)
			if (selectedDays.length === 0) {
				alert("반복 요일을 1개 이상 선택해 주세요.");
				return; 
			}
			// 폼 유효성 검증 (종목/시간 선택)
			if (!activityNameSelect.value || !durationMinSelect.value) {
				alert("활동 종목과 시간을 모두 선택해 주세요.");
				return; 
			}

			const durationValue = parseInt(durationMinSelect.value);

			// 시간 값 유효성 추가 검증
			if (isNaN(durationValue) || durationValue <= 0) {
				alert("유효한 활동 시간(분)을 선택해 주세요.");
				return;
			}

			// 1회 예상 소모 칼로리 계산 (정수로 반올림)
			const estimatedKcal = Math.round(currentCaloriePerMin * durationValue);
			// 주당 총 예상 칼로리 계산
			const totalWeeklyKcal = estimatedKcal * selectedDays.length;

			// 서버 전송을 위한 데이터 객체 구성
			const formData = {
				routineName: routineNameInput.value.trim(),
				userNo: 1, 
				activityName: activityNameSelect.value,
				activityType: activityTypeSelect.value,
				strength: strengthSelect.value,
				durationMin: durationValue, 
				startTime: startTimeInput.value,
				days: selectedDays, 
				totalKcal: totalWeeklyKcal, 
			};

			console.log("전송할 루틴 데이터:", formData);
			saveRoutine(formData); // 루틴 저장 함수 호출
		});
	}
	/**
	 * 서버에 루틴 저장 요청 (POST 요청, JSON 데이터 전송)
	 * @param {Object} data - 저장할 루틴 정보 객체
	 */
	function saveRoutine(data) {
		fetch("/routine/create", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify(data), // JSON 문자열로 변환하여 전송
		})
			.then((response) => {
				if (!response.ok) {
					return response.json().then((error) => {
						throw new Error(error.message || "루틴 저장 실패");
					});
				}
				return response.json(); // 성공 시 응답 본문을 JSON으로 파싱
			})
			.then((result) => {
				alert("루틴이 성공적으로 저장되었습니다.");
				modal.style.display = "none";
				window.location.reload(); // 페이지 새로고침으로 전체 업데이트
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
		button.addEventListener("click", function(e) {
			e.preventDefault(); 
			this.classList.toggle("active"); // 'active' 클래스를 추가/제거
			updateSummary(); // 모달 요약 정보 업데이트
		});
	});

	// 활동 종목 선택 변경 이벤트: 분당 칼로리 조회 및 요약 업데이트
	activityNameSelect.addEventListener("change", function() {
		const selectedActivityName = this.value; 

		if (selectedActivityName) {
			fetchCalorieAndUpdatedSummary(selectedActivityName); // 서버에서 분당 칼로리 조회 후 요약 업데이트
		} else {
			currentCaloriePerMin = 0.0; // 활동 선택 해제 시 칼로리 0으로 초기화
			updateSummary(); 
		}
	});

	// 활동 시간(분) 선택 변경 이벤트: 예상 칼로리 요약 업데이트
	durationMinSelect.addEventListener("change", function() {
		updateSummary();
	});

	/**
	 * 활동 이름에 해당하는 분당 칼로리를 서버에서 조회 (GET 요청)하고 전역 변수를 업데이트합니다.
	 * @param {string} activityName - 조회할 활동 종목 이름
	 */
	function fetchCalorieAndUpdatedSummary(activityName) {
		// 활동 이름을 인코딩하여 GET 쿼리 파라미터로 전송
		fetch(
			"/routine/getCalorie?activityName=" + encodeURIComponent(activityName)
		)
			.then((response) => {
				if (!response.ok) {
					throw new Error("분당 칼로리 조회 실패 (네트워크/서버)");
				}
				return response.json(); // 응답 본문의 분당 칼로리 값 파싱
			})
			.then((data) => {
				currentCaloriePerMin = data || 0.0; // 전역 변수 업데이트
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
		const estimatedKcal = Math.round(currentCaloriePerMin * durationMin);
		summaryKcal.textContent = `예상 소모 kcal / 회 : ${estimatedKcal.toLocaleString(
			"ko-KR"
		)} kcal`;
	}

	// --------------------------------------------------------
	// [활동 리스트 강조 로직]
	// --------------------------------------------------------

	/**
	 * 활동 리스트 항목에 마우스 이벤트 리스너를 등록합니다.
	 */
	function initializeActivityListEvents() {
		activityListItems.forEach(item => {
			// 마우스 오버 시
			item.addEventListener('mouseenter', function() {
				const categoryName = this.querySelector(".activity-name").textContent.trim();
				highlightActivityItem(categoryName, true); // 강조 (활성화)
			});

			// 마우스 이탈 시
			item.addEventListener('mouseleave', function() {
				const categoryName = this.querySelector(".activity-name").textContent.trim();
				highlightActivityItem(categoryName, false); // 강조 해제 (비활성화)
			});
		});
	}

	/**
	 * 특정 활동 리스트 항목을 강조하거나 해제합니다.
	 * @param {string} categoryName - 활동 카테고리 이름
	 * @param {boolean} highlight - 강조할지 여부 (true/false)
	 */
	function highlightActivityItem(categoryName, highlight) {
		const color = categoryColors[categoryName] || 'var(--text-dark)';
		
		// 1. 해당 리스트 아이템 찾기
		const listItem = Array.from(activityListItems).find(item => 
			item.querySelector(".activity-name").textContent.trim() === categoryName
		);

		if (listItem) {
			if (highlight) {
				// 강조 시: 배경색 또는 테두리 색상 적용
				listItem.style.border = `2px solid ${color}`;
				listItem.style.backgroundColor = `${color}1A`; // 색상의 10% 투명도
			} else {
				// 해제 시: 스타일 제거
				listItem.style.border = '2px solid transparent';
				listItem.style.backgroundColor = 'transparent';
			}
		}
	}


	// --------------------------------------------------------
	// [카테고리 비율 계산 및 업데이트 (차트/툴팁)]
	// --------------------------------------------------------
	/**
	 * 루틴 목록을 순회하며 카테고리별 비율을 계산하고 좌측 패널 차트와 리스트를 업데이트합니다.
	 */
	function updateCategoryRatio() {
		const allRoutines = Array.from(document.querySelectorAll(".routine-card")); // 모든 루틴 카드 DOM 요소를 배열로 가져옴
		if (!chartCircle) return; // 차트 요소가 없으면 함수 종료

		let categoryCounts = { 스포츠: 0, 유산소: 0, 근력: 0, 스트레칭: 0 }; // 카테고리별 갯수 초기화
		let totalCount = allRoutines.length; // 전체 루틴 카드 수

		const categories = ["스포츠", "유산소", "근력", "스트레칭"]; // 순서 보장을 위한 카테고리 배열

		if (totalCount === 0) {
			// 루틴이 없을 경우, 0%로 초기화 및 회색 차트 표시
			activityListItems.forEach((item) => {
				const percentSpan = item.querySelector(".activity-percent");
				if (percentSpan) percentSpan.textContent = "0%";
			});
			chartCircle.style.setProperty('--_conic-gradient', 'conic-gradient(#f0f0f0 0deg 360deg)'); 
            
            chartDataSegments = []; // 툴팁 데이터 초기화
            initializeTooltip(); // 툴팁 이벤트 리스너 설정
			return;
		}

		// 2. 루틴 카드를 순회하며 카테고리별 갯수 카운트
		allRoutines.forEach((card) => {
			const tagElement = card.querySelector(".tag");
			if (tagElement) {
				const category = tagElement.textContent.trim();
				if (categoryCounts.hasOwnProperty(category)) {
					categoryCounts[category]++;
				}
			}
		});

		// 3. 비율 계산 및 코닉 그라디언트 문자열 생성
		let currentAngle = 0; // 현재까지 누적된 각도 (0도에서 시작)
		let stops = []; // conic-gradient의 색상 정지점을 저장할 배열
        chartDataSegments = []; // 차트 데이터 세그먼트 배열 초기화

		for (const category of categories) {
			const count = categoryCounts[category] || 0;
			const percent = (count / totalCount) * 100;
			const angle = (percent / 100) * 360; // 360도 중 차지하는 각도 계산
			
			// 활동 리스트 비율 텍스트 업데이트 
			const listItem = Array.from(activityListItems).find((item) => {
				const nameSpan = item.querySelector(".activity-name");
				return nameSpan && nameSpan.textContent.trim() === category;
			});

			if (listItem) {
				const percentSpan = listItem.querySelector(".activity-percent");
				if (percentSpan) {
					percentSpan.textContent = `${Math.round(percent)}%`; // 소수점 제거하여 비율 표시
				}
			}

			if (percent > 0) {
				const color = categoryColors[category];
				const nextAngle = currentAngle + angle;
				
				// 현재 색상 시작점/끝점 정의
				stops.push(`${color} ${currentAngle}deg`);
				stops.push(`${color} ${nextAngle}deg`);
                
                // 툴팁 로직을 위한 세그먼트 데이터 저장
                chartDataSegments.push({
                    category: category,
					// 카테고리별 '갯수'도 툴팁에 표시하기 위해 count 저장
                    count: count, 
                    percent: Math.round(percent),
                    startAngle: currentAngle,
                    endAngle: nextAngle
                });
				
				currentAngle = nextAngle; // 다음 조각의 시작점 업데이트
			}
		}

		// 4. 차트 업데이트
		if (stops.length > 0) {
			// 부동 소수점 오차 방지를 위해 마지막 조각을 360도로 강제
			const lastColor = stops[stops.length - 1].split(' ')[0]; 
			stops[stops.length - 1] = `${lastColor} 360deg`;
			
			const finalConicGradient = `conic-gradient(${stops.join(", ")})`;
			
			// CSS 변수 --_conic-gradient 에 최종 conic-gradient 값 설정
			chartCircle.style.setProperty('--_conic-gradient', finalConicGradient);
		} else {
			// 루틴이 없을 경우 대비
			chartCircle.style.setProperty('--_conic-gradient', 'conic-gradient(#f0f0f0 0deg 360deg)');
		}
        
        // 5. 툴팁 이벤트 리스너 등록
        initializeTooltip();
		
		// 6. 활동 리스트 항목 이벤트 등록 및 초기화
		initializeActivityListEvents(); 
	}


    /**
     * 툴팁 초기화 및 마우스 이벤트 등록 함수
     */
    function initializeTooltip() {
        if (!chartCircle || !chartTooltip) {
            if (chartTooltip) chartTooltip.style.opacity = 0;
            // 이벤트 제거
            chartCircle.removeEventListener('mousemove', handleChartMouseMove);
            chartCircle.removeEventListener('mouseleave', handleChartMouseLeave);
            return;
        }

        // 마우스 이벤트 리스너 등록 (중복 등록 방지)
        chartCircle.removeEventListener('mousemove', handleChartMouseMove);
        chartCircle.removeEventListener('mouseleave', handleChartMouseLeave);
        chartCircle.addEventListener('mousemove', handleChartMouseMove);
        chartCircle.addEventListener('mouseleave', handleChartMouseLeave);
    }
    
    /**
     * 마우스가 차트를 벗어날 때 툴팁을 숨기는 핸들러
     */
    function handleChartMouseLeave() {
        if (chartTooltip) {
            chartTooltip.style.opacity = 0; // 툴팁 숨김
        }
		// 차트 확대 효과 제거
		chartCircle.classList.remove('hover-effect'); 
    }


    /**
     * 마우스 이동 시 툴팁을 업데이트하고 위치를 계산하는 핸들러 (각도 계산 로직)
     * @param {MouseEvent} e
     */
    function handleChartMouseMove(e) {
        if (!chartTooltip) return;
        
        const rect = chartCircle.getBoundingClientRect();
        const centerX = rect.left + rect.width / 2;
        const centerY = rect.top + rect.height / 2;

        const deltaX = e.clientX - centerX;
        const deltaY = e.clientY - centerY;
        
        // 차트의 중앙 구멍 또는 바깥쪽에 마우스가 있는지 확인
        const radius = rect.width / 2;
        const distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
        
        // 중앙 구멍 (40%) 안에 있거나, 차트 영역(radius) 밖에 있으면 툴팁 숨김
        if (distance < radius * 0.4 || distance > radius) { 
            chartTooltip.style.opacity = 0;
			chartCircle.classList.remove('hover-effect'); // 확대 효과 제거
            return;
        }
		
		// 마우스가 차트 영역 내에 있으면 확대 효과 적용
		chartCircle.classList.add('hover-effect'); 

        // 1. 마우스 각도 계산 (0~360도, 시계방향)
        let angleRad = Math.atan2(deltaY, deltaX);
        let angleDeg = angleRad * (180 / Math.PI);
        angleDeg = angleDeg < 0 ? angleDeg + 360 : angleDeg; 

        // 2. 현재 각도에 해당하는 카테고리 찾기
        const segment = chartDataSegments.find(segment => {
            // 각도 범위 검사 (startAngle <= angleDeg < endAngle)
            return angleDeg >= segment.startAngle && angleDeg < segment.endAngle;
        });

        if (segment) {
            // 3. 툴팁 내용 업데이트 (카테고리명과 갯수 표시)
            const categoryName = segment.category;
            const count = segment.count; 
            const color = categoryColors[categoryName] || '#000';
            
            // 툴팁 내용 채우기
            chartTooltip.querySelector('.tooltip-category').textContent = categoryName;
            chartTooltip.querySelector('.tooltip-count').innerHTML = `<span style="color:${color};">&#9632;</span> ${count}`;
            
            // 4. 툴팁 위치 계산 (마우스 좌표를 기준으로)
            const chartParentRect = chartCircle.closest('.ratio-chart').getBoundingClientRect(); 
            
            // 마우스 커서 위치를 기준으로 툴팁을 표시
            let tooltipX = e.clientX - chartParentRect.left - chartTooltip.offsetWidth / 2; // 툴팁 중앙을 커서 아래에 맞춤
            let tooltipY = e.clientY - chartParentRect.top - chartTooltip.offsetHeight - 15; 
            
            // 툴팁이 차트 영역 밖으로 나가지 않도록 경계 처리 (선택 사항)
            if (tooltipX < 0) tooltipX = 0;
            if (tooltipY < 0) tooltipY = 0;

            chartTooltip.style.left = `${tooltipX}px`;
            chartTooltip.style.top = `${tooltipY}px`;
            chartTooltip.style.opacity = 1; // 툴팁 표시
            
        } else {
             chartTooltip.style.opacity = 0;
			 chartCircle.classList.remove('hover-effect');
        }
    }
    

	// --------------------------------------------------------
	// [주간 목표 요약 및 예상 칼로리 업데이트]
	// --------------------------------------------------------
	/**
	 * 우측 패널의 주간 목표 달성 횟수, 진행률 및 총 예상 칼로리를 DOM을 기반으로 계산/업데이트합니다.
	 */
	function updateGoalSummary() {
		const allRoutines = Array.from(document.querySelectorAll(".routine-card")); // 모든 루틴 카드
		
		let goalTarget = 5; // 기본 목표 횟수
		
		// 🚨 [수정] 목표 횟수를 입력 필드에서 읽어오고 유효성 검사
		if (goalInput) {
			goalTarget = parseInt(goalInput.value) || 5; 
			// 1~7 범위 제한
			if (goalTarget < 1) goalTarget = 1;
			if (goalTarget > 7) goalTarget = 7;
			// HTML의 data 속성도 업데이트 (다음에 로드될 때를 대비)
			goalsPanel.setAttribute('data-weekly-goal', goalTarget); 
		} else if (goalsPanel) {
			// goalInput이 정의되지 않은 경우(초기 로드 등), data 속성에서 목표 횟수 읽기
			const rawGoalTarget = goalsPanel.getAttribute('data-weekly-goal'); 
			goalTarget = parseInt(rawGoalTarget) || 5; 
		}
		
		let activeDays = new Set(); // 중복 없이 활동 요일을 저장할 Set
		let totalExpectedKcal = 0; // 모든 루틴의 주간 총 예상 칼로리 합산 변수

		// 1. 루틴 카드 순회 및 데이터 추출
		allRoutines.forEach((card) => {
			// 1-1. 활성화된 요일 (Day Dot) 추출 및 Set에 추가 (중복 제거)
			const activeDots = card.querySelectorAll(".routine-days .day-dot.active");
			activeDots.forEach((dot) => {
				activeDays.add(dot.textContent.trim());
			});

			// 1-2. 주간 예상 소모 칼로리 추출 및 합산
			const kcalValue = card.dataset.weeklyKcal; 
			const kcal = parseInt(kcalValue) || 0;
			totalExpectedKcal += kcal; 
		});

		const activeDaysCount = activeDays.size; // 실제 활동 요일 수

		// 2. 목표 달성률 계산 및 DOM 업데이트
		// 목표가 0일 경우 무한대 방지 (달성률 0% 또는 100% 처리)
        const progress = (goalTarget > 0) ? Math.min(100, (activeDaysCount / goalTarget) * 100) : 0;

		if (currentGoalCountSpan)
			currentGoalCountSpan.textContent = activeDaysCount; // 달성 횟수 업데이트
		
		// 🚨 goalTargetDisplaySpan은 input으로 대체되었으므로, 별도의 텍스트 업데이트 로직이 필요 없습니다.

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
	 * @param {string} selectedCategory - 현재 활성화된 카테고리 탭 이름
	 */
	function filterRoutinesBy(selectedCategory) {
		const allRoutineCards = Array.from(
			document.querySelectorAll(".routine-card")
		);

		if (allRoutineCards.length === 0) {
			return;
		}

		const searchTerm = searchInput.value.trim().toLowerCase(); // 검색어 소문자 변환

		allRoutineCards.forEach((card) => {
			const titleElement = card.querySelector(".routine-title");
			const routineName = titleElement
				? titleElement.textContent.trim().toLowerCase() // 루틴 이름 소문자 변환
				: "";
			const tagElement = card.querySelector(".tag");
			const routineCategory = tagElement ? tagElement.textContent.trim() : ""; // 루틴 카테고리 이름

			// 1. 카테고리 일치 확인
			const categoryMatch =
				selectedCategory === "전체" || routineCategory === selectedCategory;

			// 2. 검색어 포함 확인
			const searchMatch =
				routineName.includes(searchTerm) ||
				routineCategory.toLowerCase().includes(searchTerm);

			// 두 조건이 모두 참일 때만 표시
			if (categoryMatch && searchMatch) {
				card.style.display = "grid"; 
			} else {
				card.style.display = "none"; 
			}
		});
	}

	// --- 카테고리 탭 클릭 이벤트 핸들러 ---
	categoryTabs.forEach((button) => {
		button.addEventListener("click", function() {
			categoryTabs.forEach((btn) => btn.classList.remove("active")); // 모든 탭 비활성화
			this.classList.add("active"); // 클릭된 탭 활성화
			const category = this.textContent.trim(); // 클릭된 탭의 카테고리 이름
			filterRoutinesBy(category); // 필터링 함수 실행
		});
	});

	// --- 검색 폼 제출 방지 핸들러 ---
	if (routineSearchForm) {
		routineSearchForm.addEventListener("submit", function(e) {
			e.preventDefault(); // 검색 폼 제출 시 페이지 이동 방지
		});
	}

	// --- 검색 입력 변경 이벤트 핸들러 ---
	if (searchInput) {
		searchInput.addEventListener("input", function() {
			// 입력 필드 수정 시 실행
			const activeTab = document.querySelector(".tab-button.active");
			const currentCategory = activeTab ? activeTab.textContent.trim() : "전체"; 
			filterRoutinesBy(currentCategory); // 현재 카테고리와 검색어를 기준으로 필터링
		});
	}

	// --------------------------------------------------------
	// [루틴 삭제 로직]
	// --------------------------------------------------------
	if (routineListContainer) {
		// 부모 요소에 이벤트 리스너를 등록하여 동적으로 추가된 삭제 버튼 처리 (이벤트 위임)
		routineListContainer.addEventListener("click", function(e) {
			// 클릭된 요소가 삭제 버튼인지 확인
			if (e.target.classList.contains("delete-routine-btn")) {
				const routineCard = e.target.closest(".routine-card"); // 가장 가까운 부모 루틴 카드 찾기
				const routineId = routineCard
					? routineCard.getAttribute("data-routine-id") // 루틴 ID 추출
					: null;

				if (routineId && confirm("정말로 이 루틴을 삭제하시겠습니까?")) {
					deleteRoutine(routineId); // 루틴 삭제 함수 호출
				}
			}
		});
	}
	/**
	 * 서버에 루틴 삭제 요청 (POST 요청)
	 * @param {string} routineId - 삭제할 루틴의 고유 ID
	 */
	function deleteRoutine(routineId) {
		fetch("/routine/delete/" + routineId, {
			method: "POST", 
			headers: { "Content-Type": "application/json" }, 
		})
			.then((response) => {
				if (!response.ok) {
					throw new Error(
						"서버 오류 또는 루틴 삭제 실패 (HTTP 상태 코드 오류)"
					);
				} 

				const contentType = response.headers.get("content-type");

				if (contentType && contentType.includes("application/json")) {
					return response.json(); // JSON 응답 파싱
				} else {
					return null; 
				}
			})
			.then((result) => {
				alert("루틴이 성공적으로 삭제되었습니다.");
				window.location.reload(); // 삭제 후 페이지 새로고침
			})
			.catch((error) => {
				console.error("루틴 삭제 중 오류 발생:", error);
				alert("루틴 삭제에 실패했습니다: " + error.message);
			});
	}

	// --------------------------------------------------------
	// [초기 실행 로직]
	// --------------------------------------------------------
	// 페이지 로드 시 초기 모달 요약 정보 업데이트
	updateSummary();

	// 페이지 로드 시 좌측 패널의 루틴 카테고리 비율 정보를 계산 및 업데이트
	updateCategoryRatio();

	// 페이지 로드 시 우측 패널의 주간 목표 달성 횟수 및 총 예상 칼로리를 계산 및 업데이트
	updateGoalSummary();

    // 🚨 [추가] 목표 입력 필드 변경 이벤트 리스너
    if (goalInput) {
        // 값이 변경(focus 잃음, 엔터)되거나, 키를 누를 때마다 목표 요약 정보를 업데이트하여 달성률 즉시 반영
        goalInput.addEventListener('change', updateGoalSummary); 
        goalInput.addEventListener('keyup', updateGoalSummary); 
    }

	// 페이지 로드 시 '전체' 탭 기준으로 루틴 목록 초기 필터링 적용
	filterRoutinesBy("전체");
});