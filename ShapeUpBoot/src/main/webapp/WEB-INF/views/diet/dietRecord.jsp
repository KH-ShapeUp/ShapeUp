<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>오늘의 식단 | ShapeUp</title>
    <link rel="stylesheet" href="../../../resources/css/diet/dietRecord.css" />
    <link rel="stylesheet" href="../../../resources/css/diet/insertDietRecord.css" />
    <link rel="stylesheet" href="../../../resources/css/diet/modal.css" />
    <link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
    <script>
      window.isDietLoggedIn = <%= session.getAttribute("userNickname") != null ? "true" : "false" %>;
    </script>
    <jsp:include page="/WEB-INF/views/include/head.jsp"/>
    
    <!-- ⭐ 목표 칼로리 설정 모달 스타일 추가 -->
    <style>
      /* ========================================
         목표 칼로리 설정 모달 스타일
         ======================================== */
      .goal-setting-modal {
        display: none;
        position: fixed;
        z-index: 2000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.5);
        align-items: center;
        justify-content: center;
      }

      .goal-modal-content {
        background-color: #fff;
        border-radius: 20px;
        width: 90%;
        max-width: 520px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        animation: slideUp 0.3s ease;
        overflow: hidden;
      }

      @keyframes slideUp {
        from {
          transform: translateY(50px);
          opacity: 0;
        }
        to {
          transform: translateY(0);
          opacity: 1;
        }
      }

      .goal-modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 24px 28px;
        border-bottom: 1px solid #e5e7eb;
        background: linear-gradient(135deg, #f8f9fb, #ffffff);
      }

      .goal-modal-header h3 {
        margin: 0;
        font-size: 1.35rem;
        font-weight: 800;
        color: #0f172a;
      }

      .goal-close {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        border: none;
        background: #f1f3f5;
        font-size: 20px;
        color: #64748b;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
      }

      .goal-close:hover {
        background: #e2e8f0;
        color: #1e293b;
        transform: rotate(90deg);
      }

      .goal-modal-body {
        padding: 28px;
        max-height: 65vh;
        overflow-y: auto;
      }

      .goal-input-group {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
        gap: 12px;
        padding: 16px;
        background: #f8f9fb;
        border-radius: 14px;
        transition: all 0.2s;
      }

      .goal-input-group:hover {
        background: #f1f3f5;
        transform: translateX(2px);
      }

      .goal-input-group label {
        display: flex;
        align-items: center;
        gap: 10px;
        flex: 0 0 100px;
        font-weight: 700;
        font-size: 0.95rem;
        color: #334155;
      }

      .goal-icon-small {
        width: 36px;
        height: 36px;
        object-fit: contain;
      }

      .goal-input-group input[type="number"] {
        flex: 1;
        padding: 10px 14px;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-size: 1.05rem;
        font-weight: 600;
        text-align: right;
        transition: all 0.2s;
        background: white;
      }

      .goal-input-group input[type="number"]:focus {
        outline: none;
        border-color: #2f80ff;
        box-shadow: 0 0 0 3px rgba(47, 128, 255, 0.1);
      }

      .goal-input-group .unit {
        flex: 0 0 40px;
        font-size: 0.9rem;
        color: #64748b;
        font-weight: 600;
      }

      .goal-total {
        margin-top: 24px;
        padding: 20px;
        background: linear-gradient(135deg, #eef6ff, #f0f9ff);
        border-radius: 14px;
        text-align: center;
        border: 2px solid #bfdbfe;
      }

      .goal-total strong {
        display: block;
        font-size: 1rem;
        color: #1e40af;
        margin-bottom: 8px;
        font-weight: 700;
      }

      .goal-total-value {
        font-size: 2rem;
        font-weight: 800;
        color: #1e3a8a;
        margin: 0 4px;
      }

      .goal-modal-footer {
        display: flex;
        gap: 12px;
        padding: 20px 28px;
        border-top: 1px solid #e5e7eb;
        background: #f8f9fb;
      }

      .goal-btn {
        flex: 1;
        padding: 14px 24px;
        border: none;
        border-radius: 12px;
        font-size: 1rem;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.2s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
      }

      .goal-btn-cancel {
        background: #f1f3f5;
        color: #64748b;
      }

      .goal-btn-cancel:hover {
        background: #e2e8f0;
        color: #475569;
        transform: translateY(-2px);
      }

      .goal-btn-save {
        background: linear-gradient(135deg, #2f80ff, #1e40af);
        color: white;
        box-shadow: 0 4px 12px rgba(47, 128, 255, 0.3);
      }

      .goal-btn-save:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(47, 128, 255, 0.4);
      }

      /* ========================================
         날짜 컨트롤과 목표 설정 버튼 영역
         ======================================== */
      .diet-header-controls {
        display: flex;
        align-items: center;
        gap: 16px;
        margin: 0.8rem auto 1.2rem;
        flex-wrap: wrap;
      }

      .date-controls.wide {
        flex: 1;
        min-width: 300px;
      }

      .btn-goal-setting {
        padding: 12px 24px;
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
        border: none;
        border-radius: 12px;
        cursor: pointer;
        font-size: 0.95rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        transition: all 0.2s;
        white-space: nowrap;
      }

      .btn-goal-setting:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(16, 185, 129, 0.4);
        background: linear-gradient(135deg, #059669, #047857);
      }

      .btn-goal-setting i {
        font-size: 1.1rem;
      }

      /* ========================================
         식사 카드 목표 표시
         ======================================== */
      .meal-goal {
        color: #64748b;
        font-size: 0.85rem;
        font-weight: 600;
        margin-top: 0.4rem;
        padding: 0.3rem 0.5rem;
        background: #f8fafc;
        border-radius: 6px;
        text-align: center;
      }

      /* ========================================
         반응형 디자인
         ======================================== */
      @media (max-width: 768px) {
        .diet-header-controls {
          flex-direction: column;
          align-items: stretch;
        }

        .date-controls.wide {
          min-width: 100%;
        }

        .btn-goal-setting {
          width: 100%;
          justify-content: center;
        }

        .goal-modal-content {
          width: 95%;
          max-width: 95%;
        }

        .goal-input-group {
          flex-direction: column;
          align-items: stretch;
        }

        .goal-input-group label {
          flex: 1;
          justify-content: flex-start;
        }

        .goal-input-group input[type="number"] {
          text-align: center;
        }
      }
    </style>
  </head>
  <body class="diet-record">
    <jsp:include page="/WEB-INF/views/include/header.jsp"/>
    <main class="diet-record-main">
      <section class="page-header">
        <div>
          <h2>오늘의 식단</h2>
          <p class="page-subtitle">탄단지 밸런스를 한 눈에 확인하고, 식단을 빠르게 추가하세요.</p>
        </div>
      </section>
      
      <!-- ========================================
           날짜 선택 + 목표 칼로리 설정 버튼
           ======================================== -->
      <div class="diet-header-controls">
        <div class="date-controls wide">
          <button type="button" class="nav-btn" id="diet-date-prev-btn" aria-label="이전 날짜">←</button>
          <div class="date-pill" id="diet-date-prev">--</div>
          <div class="date-pill active" id="diet-date-today">--</div>
          <div class="date-pill" id="diet-date-next">--</div>
          <button type="button" class="nav-btn" id="diet-date-next-btn" aria-label="다음 날짜">→</button>
          <button type="button" class="calendar-fab" id="diet-calendar-btn" aria-label="달력 열기">
            <span class="calendar-icon">📅</span>
          </button>
          <input type="date" id="diet-date-picker" class="date-input-anchor" aria-label="날짜 선택" />
        </div>
        
        <button type="button" class="btn-goal-setting" id="btnGoalSetting">
          <i class="fa-solid fa-bullseye"></i> 목표 칼로리 설정
        </button>
      </div>

      <section class="diet-grid">
        <div class="summary-panel">
          <div class="summary-header">
            <div class="chip"><span class="thumb">👍</span> 오늘의 식단 한줄평</div>
            <p class="summary-caption">영양소 비율과 총 칼로리를 도넛 차트로 바로 확인하세요.</p>
          </div>
          <div class="summary-body">
            <div class="donut-card">
              <canvas id="macro-chart" width="240" height="240" aria-label="영양소 도넛 차트"></canvas>
              <div class="donut-overlay">섭취량</div>
              <div class="donut-center">
                <p class="center-title">탄단지 비율</p>
                <p class="center-kcal">
                  <span id="total-kcal">0</span> / <span id="goal-kcal">0</span> Kcal
                </p>
                <p class="center-caption">오늘 총 섭취 칼로리 / 목표 칼로리</p>
              </div>
            </div>
            <div class="macro-cards">
              <div class="macro-card carb">
                <div class="icon-box">
                  <img src="https://img.icons8.com/ios-filled/50/000000/rice-bowl--v1.png" alt="carbohydrate-icon" />
                </div>
                <div class="macro-text">
                  <p class="macro-label">탄수화물</p>
                  <p class="macro-amount" id="total-carb">0 g</p>
                  <p class="macro-sub">오늘 섭취량</p>
                </div>
              </div>
              <div class="macro-card protein">
                <div class="icon-box">
                  <img src="https://img.icons8.com/ios-filled/50/000000/steak.png" alt="protein-icon" />
                </div>
                <div class="macro-text">
                  <p class="macro-label">단백질</p>
                  <p class="macro-amount" id="total-protein">0 g</p>
                  <p class="macro-sub">오늘 섭취량</p>
                </div>
              </div>
              <div class="macro-card fat">
                <div class="icon-box">
                  <img src="https://img.icons8.com/ios-filled/50/000000/milk-bottle--v1.png" alt="fat-icon" />
                </div>
                <div class="macro-text">
                  <p class="macro-label">지방</p>
                  <p class="macro-amount" id="total-fat">0 g</p>
                  <p class="macro-sub">오늘 섭취량</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="meal-panel">
          <div class="panel-title">식사 타임라인</div>
          <div class="meal-grid">
            <!-- 아침 카드 -->
            <div class="meal-card sunrise" data-diet-type="아침">
              <div class="meal-card-top">
                <div class="icon-circle">
                  <img class="meal-icon" src="<%=request.getContextPath()%>/resources/img/diet-img/brackfast.gif" data-still="<%=request.getContextPath()%>/resources/img/diet-img/brackfast.gif" data-animated="<%=request.getContextPath()%>/resources/img/diet-img/brackfast.gif" alt="아침 아이콘" />
                </div>
                <div class="meal-text">
                  <p class="meal-name">아침</p>
                  <p class="meal-time">07:30</p>
                </div>
              </div>
              <div class="meal-card-bottom">
                <div class="kcal-label">섭취 칼로리</div>
                <div class="kcal-value" id="kcal-breakfast">0 Kcal</div>
                <div class="progress-track"><span class="progress-fill"></span></div>
                <!-- ⭐ 목표 표시 추가 -->
                <div class="meal-goal" id="goal-breakfast">목표: 500 Kcal</div>
              </div>
              <div class="fasting-overlay" style="display:none;">단식 상태입니다.</div>
            </div>
            
            <!-- 점심 카드 -->
            <div class="meal-card noon" data-diet-type="점심">
              <div class="meal-card-top">
                <div class="icon-circle">
                  <img class="meal-icon" src="<%=request.getContextPath()%>/resources/img/diet-img/lunch.gif" data-still="<%=request.getContextPath()%>/resources/img/diet-img/lunch.gif" data-animated="<%=request.getContextPath()%>/resources/img/diet-img/lunch.gif" alt="점심 아이콘" />
                </div>
                <div class="meal-text">
                  <p class="meal-name">점심</p>
                  <p class="meal-time">12:30</p>
                </div>
              </div>
              <div class="meal-card-bottom">
                <div class="kcal-label">섭취 칼로리</div>
                <div class="kcal-value" id="kcal-lunch">0 Kcal</div>
                <div class="progress-track"><span class="progress-fill"></span></div>
                <!-- ⭐ 목표 표시 추가 -->
                <div class="meal-goal" id="goal-lunch">목표: 680 Kcal</div>
              </div>
              <div class="fasting-overlay" style="display:none;">단식 상태입니다.</div>
            </div>
            
            <!-- 저녁 카드 -->
            <div class="meal-card evening" data-diet-type="저녁">
              <div class="meal-card-top">
                <div class="icon-circle">
                  <img class="meal-icon" src="<%=request.getContextPath()%>/resources/img/diet-img/dinner.gif" data-still="<%=request.getContextPath()%>/resources/img/diet-img/dinner.gif" data-animated="<%=request.getContextPath()%>/resources/img/diet-img/dinner.gif" alt="저녁 아이콘" />
                </div>
                <div class="meal-text">
                  <p class="meal-name">저녁</p>
                  <p class="meal-time">18:30</p>
                </div>
              </div>
              <div class="meal-card-bottom">
                <div class="kcal-label">섭취 칼로리</div>
                <div class="kcal-value" id="kcal-dinner">0 Kcal</div>
                <div class="progress-track"><span class="progress-fill"></span></div>
                <!-- ⭐ 목표 표시 추가 -->
                <div class="meal-goal" id="goal-dinner">목표: 550 Kcal</div>
              </div>
              <div class="fasting-overlay" style="display:none;">단식 상태입니다.</div>
            </div>
            
            <!-- 기타 카드 -->
            <div class="meal-card night" data-diet-type="기타">
              <div class="meal-card-top">
                <div class="icon-circle">
                  <img class="meal-icon" src="<%=request.getContextPath()%>/resources/img/diet-img/others.gif" data-still="<%=request.getContextPath()%>/resources/img/diet-img/others.gif" data-animated="<%=request.getContextPath()%>/resources/img/diet-img/others.gif" alt="기타 아이콘" />
                </div>
                <div class="meal-text">
                  <p class="meal-name">기타</p>
                  <p class="meal-time">22:00</p>
                </div>
              </div>
              <div class="meal-card-bottom">
                <div class="kcal-label">섭취 칼로리</div>
                <div class="kcal-value" id="kcal-etc">0 Kcal</div>
                <div class="progress-track"><span class="progress-fill"></span></div>
                <!-- ⭐ 목표 표시 추가 -->
                <div class="meal-goal" id="goal-etc">목표: 500 Kcal</div>
              </div>
              <div class="fasting-overlay" style="display:none;">단식 상태입니다.</div>
            </div>
          </div>
        </div>
      </section>
    </main>
    
    <!-- ========================================
         목표 칼로리 설정 모달
         ======================================== -->
    <div id="goalSettingModal" class="goal-setting-modal">
      <div class="goal-modal-content">
        <div class="goal-modal-header">
          <h3>식사별 목표 칼로리 설정</h3>
          <button type="button" class="goal-close" id="goalCloseBtn">&times;</button>
        </div>
        <div class="goal-modal-body">
          <!-- 아침 -->
          <div class="goal-input-group">
            <label for="breakfastGoal">
              <img src="<%=request.getContextPath()%>/resources/img/diet-img/brackfast.gif" alt="아침" class="goal-icon-small">
              아침
            </label>
            <input type="number" id="breakfastGoal" value="500" min="0" max="9999" step="10">
            <span class="unit">Kcal</span>
          </div>
          
          <!-- 점심 -->
          <div class="goal-input-group">
            <label for="lunchGoal">
              <img src="<%=request.getContextPath()%>/resources/img/diet-img/lunch.gif" alt="점심" class="goal-icon-small">
              점심
            </label>
            <input type="number" id="lunchGoal" value="680" min="0" max="9999" step="10">
            <span class="unit">Kcal</span>
          </div>
          
          <!-- 저녁 -->
          <div class="goal-input-group">
            <label for="dinnerGoal">
              <img src="<%=request.getContextPath()%>/resources/img/diet-img/dinner.gif" alt="저녁" class="goal-icon-small">
              저녁
            </label>
            <input type="number" id="dinnerGoal" value="550" min="0" max="9999" step="10">
            <span class="unit">Kcal</span>
          </div>
          
          <!-- 기타 -->
          <div class="goal-input-group">
            <label for="etcGoal">
              <img src="<%=request.getContextPath()%>/resources/img/diet-img/others.gif" alt="기타" class="goal-icon-small">
              기타
            </label>
            <input type="number" id="etcGoal" value="500" min="0" max="9999" step="10">
            <span class="unit">Kcal</span>
          </div>
          
          <!-- 총 목표 칼로리 -->
          <div class="goal-total">
            <strong>총 목표 칼로리</strong>
            <span class="goal-total-value" id="totalGoalDisplay">2230</span>
            <span style="font-size: 1.2rem; font-weight: 600; color: #64748b;"> Kcal</span>
          </div>
        </div>
        <div class="goal-modal-footer">
          <button type="button" class="goal-btn goal-btn-cancel" id="btnCancelGoal">
            <i class="fa-solid fa-xmark"></i> 취소
          </button>
          <button type="button" class="goal-btn goal-btn-save" id="btnSaveGoal">
            <i class="fa-solid fa-check"></i> 저장
          </button>
        </div>
      </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/dietInsertModal.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/customInsertModal.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/dietList.jsp"/>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <script>
  let macroChart = null;
  let currentDietDate = null;
  let currentTotalKcal = 0;
  let currentGoalKcal = 0;
  
  // ⭐ 식사별 목표 칼로리 (전역 변수)
  let MEAL_GOALS = { '아침': 500, '점심': 680, '저녁': 550, '기타': 500 };

  function pad2(n) { return (n < 10 ? '0' : '') + n; }

  function getTodayIso() {
    const d = new Date();
    return d.getFullYear() + '-' + pad2(d.getMonth() + 1) + '-' + pad2(d.getDate());
  }

  function formatDisplay(d) {
    return d.getFullYear() + '.' + pad2(d.getMonth() + 1) + '.' + pad2(d.getDate());
  }

  function sanitizeDateInput(dateStr) {
    if (!dateStr) return null;
    const v = dateStr.trim();
    if (!v || v === '--') return null;
    if (/^\d{4}-\d{2}-\d{2}$/.test(v)) return v;
    return null;
  }

  function setDietDates(baseDate) {
    const target = baseDate ? new Date(baseDate) : new Date();
    const prev = new Date(target); prev.setDate(target.getDate() - 1);
    const next = new Date(target); next.setDate(target.getDate() + 1);

    const prevEl = document.getElementById('diet-date-prev');
    const todayEl = document.getElementById('diet-date-today');
    const nextEl = document.getElementById('diet-date-next');
    if (prevEl) prevEl.textContent = formatDisplay(prev);
    if (todayEl) todayEl.textContent = formatDisplay(target);
    if (nextEl) nextEl.textContent = formatDisplay(next);
    return target.getFullYear() + '-' + pad2(target.getMonth() + 1) + '-' + pad2(target.getDate());
  }

  function renderMacroChart(carb, protein, fat) {
    const ctx = document.getElementById('macro-chart');
    if (!ctx || !window.Chart) return;
    const values = [Number(carb) || 0, Number(protein) || 0, Number(fat) || 0];
    const sum = values.reduce((acc, cur) => acc + cur, 0);
    const safeData = sum === 0 ? [1, 1, 1] : values;
    const config = {
      type: 'doughnut',
      data: {
        labels: ['탄수화물', '단백질', '지방'],
        datasets: [{
          data: safeData,
          backgroundColor: ['#ffce73', '#8b9bff', '#ff9fb2'],
          borderColor: '#f7f8fb',
          borderWidth: 3,
          hoverOffset: 10,
        }]
      },
      options: {
        cutout: '70%',
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: (context) => {
                const gram = Math.round(context.parsed * 10) / 10;
                return context.label + ': ' + gram + ' g';
              }
            }
          }
        }
      }
    };

    if (macroChart) {
      macroChart.data.datasets[0].data = safeData;
      macroChart.update();
    } else {
      macroChart = new Chart(ctx, config);
    }
  }

  // ========================================
  // ⭐ 목표 칼로리 불러오기 (식사별 포함)
  // ========================================
  async function fetchGoalCalorie() {
    try {
      const res = await fetch('/diet/goal');
      if (res.status === 401) {
        console.log('Not logged in, showing goal as 0');
        const goalEl = document.getElementById('goal-kcal');
        if (goalEl) goalEl.textContent = '0';
        currentGoalKcal = 0;
        return 0;
      }
      if (!res.ok) throw new Error('goal failed');
      const json = await res.json();
      const goalCalorie = Number(json.goalCalorie || json.GOAL_CALORIE || 0);
      currentGoalKcal = goalCalorie;
      const goalEl = document.getElementById('goal-kcal');
      if (goalEl) goalEl.textContent = goalCalorie;

      // ⭐ 식사별 목표도 업데이트
      if (json.goalCalorieMorning !== undefined) 
        MEAL_GOALS['아침'] = Number(json.goalCalorieMorning) || 500;
      if (json.goalCalorieLunch !== undefined) 
        MEAL_GOALS['점심'] = Number(json.goalCalorieLunch) || 680;
      if (json.goalCalorieDinner !== undefined) 
        MEAL_GOALS['저녁'] = Number(json.goalCalorieDinner) || 550;
      if (json.goalCalorieEtc !== undefined) 
        MEAL_GOALS['기타'] = Number(json.goalCalorieEtc) || 500;

      // ⭐ 화면에 목표 표시 업데이트
      updateMealGoalDisplay();

      return goalCalorie;
    } catch (err) {
      console.error('failed to load goal calorie', err);
      const goalEl = document.getElementById('goal-kcal');
      if (goalEl) goalEl.textContent = '0';
      currentGoalKcal = 0;
      return 0;
    }
  }

  // ========================================
  // ⭐ 화면에 식사별 목표 표시 업데이트
  // ========================================
  function updateMealGoalDisplay() {
    const goalBreakfast = document.getElementById('goal-breakfast');
    const goalLunch = document.getElementById('goal-lunch');
    const goalDinner = document.getElementById('goal-dinner');
    const goalEtc = document.getElementById('goal-etc');

    if (goalBreakfast) goalBreakfast.textContent = '목표: ' + MEAL_GOALS['아침'] + ' Kcal';
    if (goalLunch) goalLunch.textContent = '목표: ' + MEAL_GOALS['점심'] + ' Kcal';
    if (goalDinner) goalDinner.textContent = '목표: ' + MEAL_GOALS['저녁'] + ' Kcal';
    if (goalEtc) goalEtc.textContent = '목표: ' + MEAL_GOALS['기타'] + ' Kcal';
  }

  async function fetchDietSummary(dateStr) {
    const targets = {
      '아침': document.getElementById('kcal-breakfast'),
      '점심': document.getElementById('kcal-lunch'),
      '저녁': document.getElementById('kcal-dinner'),
      '기타': document.getElementById('kcal-etc'),
    };
    const macroTargets = {
      carb: document.getElementById('total-carb'),
      protein: document.getElementById('total-protein'),
      fat: document.getElementById('total-fat'),
    };
    const alias = {
      '아침': '아침', '점심': '점심', '저녁': '저녁', '간식': '기타', '기타': '기타',
      'breakfast': '아침', 'lunch': '점심', 'dinner': '저녁', 'snack': '기타', 'etc': '기타',
      'BREAKFAST': '아침', 'LUNCH': '점심', 'DINNER': '저녁', 'SNACK': '기타', 'ETC': '기타',
    };
    const progressBars = {
      '아침': document.querySelector('.meal-card[data-diet-type="아침"] .progress-fill'),
      '점심': document.querySelector('.meal-card[data-diet-type="점심"] .progress-fill'),
      '저녁': document.querySelector('.meal-card[data-diet-type="저녁"] .progress-fill'),
      '기타': document.querySelector('.meal-card[data-diet-type="기타"] .progress-fill'),
    };
    
    const applyDietState = (mealValues = {}, totals = {}) => {
      const totalFromMeals = Object.values(mealValues || {}).reduce((acc, cur) => acc + (Number(cur) || 0), 0);
      const totalKcalValue = Number(totals.kcal || totals.totalKcal || totalFromMeals) || 0;
      currentTotalKcal = totalKcalValue;
      const totalEl = document.getElementById('total-kcal');
      if (totalEl) totalEl.textContent = totalKcalValue;

      Object.entries(targets).forEach(([key, el]) => {
        const val = Number(mealValues[key]) || 0;
        const kcalText = val + ' Kcal';
        if (el) {
          el.textContent = kcalText;
          el.dataset.prevKcal = kcalText;
        }
        const progressEl = progressBars[key];
        const card = progressEl ? progressEl.closest('.meal-card') : null;
        if (card) {
          card.dataset.fasting = 'false';
          card.classList.remove('fasting-active');
          const overlay = card.querySelector('.fasting-overlay');
          if (overlay) overlay.style.display = 'none';
        }
        
        // ⭐ 진행률 바 계산 - 식사별 목표 기준
        if (progressEl) {
          const goal = MEAL_GOALS[key];
          let pct = 0;
          if (goal && goal > 0) {
            pct = Math.min(100, Math.round((val / goal) * 100));
          } else if (totalKcalValue > 0) {
            pct = Math.min(100, Math.round((val / totalKcalValue) * 100));
          } else if (val > 0) {
            pct = 100;
          }
          progressEl.style.width = pct + '%';
        }
      });

      const formatMacro = (n) => {
        if (isNaN(n)) return '0';
        return (Math.round(n * 10) / 10).toString();
      };
      const carbVal = totals.carb || totals.totalCarb || 0;
      const proteinVal = totals.protein || totals.totalProtein || 0;
      const fatVal = totals.fat || totals.totalFat || 0;
      if (macroTargets.carb) macroTargets.carb.textContent = formatMacro(Number(carbVal)) + ' g';
      if (macroTargets.protein) macroTargets.protein.textContent = formatMacro(Number(proteinVal)) + ' g';
      if (macroTargets.fat) macroTargets.fat.textContent = formatMacro(Number(fatVal)) + ' g';
      renderMacroChart(Number(carbVal) || 0, Number(proteinVal) || 0, Number(fatVal) || 0);
    };

    const safeDate = sanitizeDateInput(dateStr) || getTodayIso();
    applyDietState({}, { kcal: 0, carb: 0, protein: 0, fat: 0 });

    try {
      const res = await fetch('/diet/summary?date=' + encodeURIComponent(safeDate));
      if (res.status === 401) {
        throw new Error('unauthorized');
      }
      if (!res.ok) throw new Error('summary failed');
      const json = await res.json();
      const data = json.data || {};
      const totals = json.totals || {};

      const mealValues = {};
      Object.entries(data).forEach(([k, v]) => {
        const key = alias[k] || alias[String(k).trim()] || null;
        if (!key) return;
        mealValues[key] = Number(v) || 0;
      });

      applyDietState(mealValues, totals);
    } catch (err) {
      console.error('failed to load diet summary', err);
      applyDietState({}, { kcal: 0, carb: 0, protein: 0, fat: 0 });
    }
  }

  // ========================================
  // ⭐ 목표 설정 모달 관련 함수
  // ========================================
  function openGoalModal() {
    const modal = document.getElementById('goalSettingModal');
    if (modal) {
      modal.style.display = 'flex';
      loadGoalValues();
    }
  }

  function closeGoalModal() {
    const modal = document.getElementById('goalSettingModal');
    if (modal) {
      modal.style.display = 'none';
    }
  }

  function loadGoalValues() {
    document.getElementById('breakfastGoal').value = MEAL_GOALS['아침'];
    document.getElementById('lunchGoal').value = MEAL_GOALS['점심'];
    document.getElementById('dinnerGoal').value = MEAL_GOALS['저녁'];
    document.getElementById('etcGoal').value = MEAL_GOALS['기타'];
    updateTotalGoal();
  }

  function updateTotalGoal() {
    const breakfast = parseInt(document.getElementById('breakfastGoal').value) || 0;
    const lunch = parseInt(document.getElementById('lunchGoal').value) || 0;
    const dinner = parseInt(document.getElementById('dinnerGoal').value) || 0;
    const etc = parseInt(document.getElementById('etcGoal').value) || 0;
    const total = breakfast + lunch + dinner + etc;
    document.getElementById('totalGoalDisplay').textContent = total;
  }

  async function saveGoalValues() {
    const breakfast = parseInt(document.getElementById('breakfastGoal').value) || 0;
    const lunch = parseInt(document.getElementById('lunchGoal').value) || 0;
    const dinner = parseInt(document.getElementById('dinnerGoal').value) || 0;
    const etc = parseInt(document.getElementById('etcGoal').value) || 0;
    const total = breakfast + lunch + dinner + etc;

    const goalData = {
      goalCalorie: total,
      goalCalorieMorning: breakfast,
      goalCalorieLunch: lunch,
      goalCalorieDinner: dinner,
      goalCalorieEtc: etc
    };

    try {
      const response = await fetch('/diet/saveGoals', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(goalData)
      });

      if (!response.ok) {
        throw new Error('Failed to save goals');
      }

      const result = await response.json();

      // MEAL_GOALS 업데이트
      MEAL_GOALS['아침'] = breakfast;
      MEAL_GOALS['점심'] = lunch;
      MEAL_GOALS['저녁'] = dinner;
      MEAL_GOALS['기타'] = etc;

      // 화면 업데이트
      currentGoalKcal = total;
      const goalEl = document.getElementById('goal-kcal');
      if (goalEl) {
        goalEl.textContent = total;
      }
      updateMealGoalDisplay();

      // 프로그레스 바 업데이트
      await fetchDietSummary(currentDietDate);

      Swal.fire({
        icon: 'success',
        title: '저장 완료!',
        text: '목표 칼로리가 저장되었습니다.',
        confirmButtonText: '확인',
        confirmButtonColor: '#2f80ff'
      });

      closeGoalModal();
    } catch (error) {
      console.error('Error saving goals:', error);
      Swal.fire({
        icon: 'error',
        title: '저장 실패',
        text: '목표 칼로리 저장에 실패했습니다.',
        confirmButtonText: '확인',
        confirmButtonColor: '#f25c5c'
      });
    }
  }

  function findCardByType(type) {
    const key = type || window.lastSelectedDietType || '기타';
    return document.querySelector(`.meal-card[data-diet-type="${key}"]`);
  }

  function toggleFasting(card, desiredState) {
    if (!card) return;
    const kcalEl = card.querySelector('.kcal-value');
    const progressEl = card.querySelector('.progress-fill');
    if (!kcalEl) return;

    const isFasting = card.dataset.fasting === 'true';
    const nextState = typeof desiredState === 'boolean' ? desiredState : !isFasting;
    if (nextState === isFasting) return;

    if (nextState) {
      kcalEl.dataset.prevKcal = kcalEl.textContent;
      kcalEl.textContent = '단식';
      card.dataset.fasting = 'true';
      card.classList.add('fasting-active');
      if (progressEl) progressEl.style.width = '0%';
    } else {
      const restoreText = kcalEl.dataset.prevKcal || '0 Kcal';
      kcalEl.textContent = restoreText;
      card.dataset.fasting = 'false';
      card.classList.remove('fasting-active');
      if (progressEl) {
        const valNum = parseFloat(restoreText) || 0;
        const pct = currentTotalKcal > 0 ? Math.min(100, Math.round((valNum / currentTotalKcal) * 100)) : (valNum > 0 ? 100 : 0);
        progressEl.style.width = pct + '%';
      }
    }
  }

  window.toggleFastingByType = (type) => {
    const card = findCardByType(type);
    toggleFasting(card);
  };

  document.addEventListener('DOMContentLoaded', () => {
    // ========================================
    // 로그인 체크
    // ========================================
    if (!window.isDietLoggedIn) {
      alert('로그인이 필요한 서비스입니다.');
      window.location.href = '/user/login'; 
      return;
    }

    ['diet-list-backdrop','modal-backdrop','custom-backdrop'].forEach(id => {
      const el = document.getElementById(id);
      if (el) el.style.display = 'none';
    });

    document.querySelectorAll('.meal-card').forEach((card) => {
      const type = card.dataset.dietType || '기타';
      const icon = card.querySelector('.meal-icon');
      const still = icon ? (icon.dataset.still || icon.getAttribute('src')) : null;
      const animated = icon ? (icon.dataset.animated || still) : still;

      card.addEventListener('mouseenter', () => {
        if (icon && animated) icon.src = animated;
        card.classList.add('active-hover');
      });
      card.addEventListener('mouseleave', () => {
        if (icon && still) icon.src = still;
        card.classList.remove('active-hover');
      });
      card.addEventListener('click', () => {
        window.lastSelectedDietType = type;
        if (card.dataset.fasting === 'true') {
          const confirmOff = window.confirm('단식을 취소하겠습니까?');
          if (confirmOff) {
            toggleFasting(card, false);
          }
          return;
        }
        if (typeof setDietType === 'function') setDietType(type);
        if (typeof openDietListModal === 'function') openDietListModal();
      });
    });

    const todayIso = setDietDates();
    currentDietDate = todayIso;
    const picker = document.getElementById('diet-date-picker');
    if (picker) picker.value = todayIso;
    
    // 목표 칼로리 먼저 로드
    fetchGoalCalorie().then(() => {
      // 그 다음 식단 요약 로드
      fetchDietSummary(todayIso);
    });

    const calendarBtn = document.getElementById('diet-calendar-btn');
    if (calendarBtn && picker) {
      calendarBtn.addEventListener('click', () => picker.showPicker && picker.showPicker());
      picker.addEventListener('change', (e) => {
        const val = sanitizeDateInput(e.target.value) || getTodayIso();
        setDietDates(val);
        currentDietDate = val;
        fetchDietSummary(val);
      });
      picker.addEventListener('blur', (e) => {
        if (!sanitizeDateInput(e.target.value)) {
          const today = getTodayIso();
          picker.value = today;
          setDietDates(today);
          currentDietDate = today;
          fetchDietSummary(today);
        }
      });
    }

    const moveDate = (offset) => {
      const base = currentDietDate ? new Date(currentDietDate) : new Date();
      base.setDate(base.getDate() + offset);
      const iso = base.getFullYear() + '-' + pad2(base.getMonth() + 1) + '-' + pad2(base.getDate());
      if (picker) picker.value = iso;
      currentDietDate = setDietDates(iso);
      fetchDietSummary(currentDietDate);
    };

    const prevBtn = document.getElementById('diet-date-prev-btn');
    const nextBtn = document.getElementById('diet-date-next-btn');
    if (prevBtn) prevBtn.addEventListener('click', () => moveDate(-1));
    if (nextBtn) nextBtn.addEventListener('click', () => moveDate(1));

    // ========================================
    // ⭐ 목표 칼로리 설정 모달 이벤트 리스너
    // ========================================
    const btnGoalSetting = document.getElementById('btnGoalSetting');
    const goalCloseBtn = document.getElementById('goalCloseBtn');
    const btnCancelGoal = document.getElementById('btnCancelGoal');
    const btnSaveGoal = document.getElementById('btnSaveGoal');
    const goalModal = document.getElementById('goalSettingModal');

    if (btnGoalSetting) {
      btnGoalSetting.addEventListener('click', openGoalModal);
    }

    if (goalCloseBtn) {
      goalCloseBtn.addEventListener('click', closeGoalModal);
    }

    if (btnCancelGoal) {
      btnCancelGoal.addEventListener('click', closeGoalModal);
    }

    if (btnSaveGoal) {
      btnSaveGoal.addEventListener('click', saveGoalValues);
    }

    // 모달 외부 클릭시 닫기
    if (goalModal) {
      goalModal.addEventListener('click', (e) => {
        if (e.target === goalModal) {
          closeGoalModal();
        }
      });
    }

    // 입력값 변경시 총합 업데이트
    ['breakfastGoal', 'lunchGoal', 'dinnerGoal', 'etcGoal'].forEach(id => {
      const input = document.getElementById(id);
      if (input) {
        input.addEventListener('input', updateTotalGoal);
      }
    });
  });

  window.getCurrentDietDate = () => currentDietDate || getTodayIso();
  window.refreshDietSummary = () => fetchDietSummary(window.getCurrentDietDate());
  </script>
</html>
