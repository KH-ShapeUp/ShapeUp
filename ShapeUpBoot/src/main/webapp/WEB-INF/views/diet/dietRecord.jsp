<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>오늘의 식단</title>
    <link rel="stylesheet" href="../../../resources/css/diet/dietRecord.css" />
    <link rel="stylesheet" href="../../../resources/css/diet/insertDietRecord.css" />
    <link rel="stylesheet" href="../../../resources/css/diet/modal.css" />
    <script>
      window.isDietLoggedIn = <%= session.getAttribute("userNickname") != null ? "true" : "false" %>;
    </script>
    <jsp:include page="/WEB-INF/views/include/head.jsp"/>
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
                <p class="center-kcal" id="total-kcal">0 Kcal</p>
                <p class="center-caption">오늘 총 섭취 칼로리</p>
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
            <div class="meal-card sunrise" data-diet-type="아침">
              <div class="meal-card-top">
                <div class="icon-circle">
                  <img class="meal-icon" src="<%=request.getContextPath()%>/resources/img/diet-img/brackfast.gif" data-still="<%=request.getContextPath()%>/resources/img/diet-img/brackfast.gif" data-animated="<%=request.getContextPath()%>/resources/img/diet-img/brackfast.gif" alt="아침 아이콘" />
                </div>
                <div class="meal-text">
                  <p class="meal-name">아침</p>
                  <p class="meal-time">07:30</p>
                </div>
                <button class="fasting-button" type="button">단식</button>
              </div>
              <div class="meal-card-bottom">
                <div class="kcal-label">섭취 칼로리</div>
                <div class="kcal-value" id="kcal-breakfast">0 Kcal</div>
                <div class="progress-track"><span class="progress-fill"></span></div>
              </div>
            </div>
            <div class="meal-card noon" data-diet-type="점심">
              <div class="meal-card-top">
                <div class="icon-circle">
                  <img class="meal-icon" src="<%=request.getContextPath()%>/resources/img/diet-img/lunch.gif" data-still="<%=request.getContextPath()%>/resources/img/diet-img/lunch.gif" data-animated="<%=request.getContextPath()%>/resources/img/diet-img/lunch.gif" alt="점심 아이콘" />
                </div>
                <div class="meal-text">
                  <p class="meal-name">점심</p>
                  <p class="meal-time">12:30</p>
                </div>
                <button class="fasting-button" type="button">단식</button>
              </div>
              <div class="meal-card-bottom">
                <div class="kcal-label">섭취 칼로리</div>
                <div class="kcal-value" id="kcal-lunch">0 Kcal</div>
                <div class="progress-track"><span class="progress-fill"></span></div>
              </div>
            </div>
            <div class="meal-card evening" data-diet-type="저녁">
              <div class="meal-card-top">
                <div class="icon-circle">
                  <img class="meal-icon" src="<%=request.getContextPath()%>/resources/img/diet-img/dinner.gif" data-still="<%=request.getContextPath()%>/resources/img/diet-img/dinner.gif" data-animated="<%=request.getContextPath()%>/resources/img/diet-img/dinner.gif" alt="저녁 아이콘" />
                </div>
                <div class="meal-text">
                  <p class="meal-name">저녁</p>
                  <p class="meal-time">18:30</p>
                </div>
                <button class="fasting-button" type="button">단식</button>
              </div>
              <div class="meal-card-bottom">
                <div class="kcal-label">섭취 칼로리</div>
                <div class="kcal-value" id="kcal-dinner">0 Kcal</div>
                <div class="progress-track"><span class="progress-fill"></span></div>
              </div>
            </div>
            <div class="meal-card night" data-diet-type="기타">
              <div class="meal-card-top">
                <div class="icon-circle">
                  <img class="meal-icon" src="<%=request.getContextPath()%>/resources/img/diet-img/others.gif" data-still="<%=request.getContextPath()%>/resources/img/diet-img/others.gif" data-animated="<%=request.getContextPath()%>/resources/img/diet-img/others.gif" alt="기타 아이콘" />
                </div>
                <div class="meal-text">
                  <p class="meal-name">기타</p>
                  <p class="meal-time">22:00</p>
                </div>
                <button class="fasting-button" type="button">단식</button>
              </div>
              <div class="meal-card-bottom">
                <div class="kcal-label">섭취 칼로리</div>
                <div class="kcal-value" id="kcal-etc">0 Kcal</div>
                <div class="progress-track"><span class="progress-fill"></span></div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/dietInsertModal.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/customInsertModal.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/dietList.jsp"/>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script>
  let macroChart = null;
  let currentDietDate = null;
  const SAMPLE_DIET = {
    meals: { '아침': 320, '점심': 540, '저녁': 480, '기타': 150 },
    totals: { kcal: 1490, carb: 180, protein: 75, fat: 55 }
  };

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
      const totalEl = document.getElementById('total-kcal');
      if (totalEl) totalEl.textContent = totalKcalValue + ' Kcal';

      Object.entries(targets).forEach(([key, el]) => {
        const val = Number(mealValues[key]) || 0;
        if (el) el.textContent = val + ' Kcal';
        const progressEl = progressBars[key];
        if (progressEl) {
          const pct = totalKcalValue > 0 ? Math.min(100, Math.round((val / totalKcalValue) * 100)) : (val > 0 ? 100 : 0);
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
    const isToday = safeDate === getTodayIso();
    applyDietState({}, { kcal: 0, carb: 0, protein: 0, fat: 0 });

    try {
      const res = await fetch('/diet/summary?date=' + encodeURIComponent(safeDate));
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

      const hasMeals = Object.keys(mealValues).length > 0;
      const hasTotals = !!(totals && (totals.kcal || totals.totalKcal || totals.carb || totals.totalCarb || totals.protein || totals.totalProtein || totals.fat || totals.totalFat));

      if (!hasMeals && !hasTotals && isToday) {
        applyDietState(SAMPLE_DIET.meals, SAMPLE_DIET.totals);
        return;
      }

      applyDietState(mealValues, totals);
    } catch (err) {
      console.error('failed to load diet summary', err);
      if (isToday) {
        applyDietState(SAMPLE_DIET.meals, SAMPLE_DIET.totals);
      } else {
        applyDietState({}, { kcal: 0, carb: 0, protein: 0, fat: 0 });
      }
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
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
        if (typeof setDietType === 'function') setDietType(type);
        if (typeof openDietListModal === 'function') openDietListModal();
      });
    });

    const todayIso = setDietDates();
    currentDietDate = todayIso;
    const picker = document.getElementById('diet-date-picker');
    if (picker) picker.value = todayIso;
    fetchDietSummary(todayIso);

    const calendarBtn = document.getElementById('diet-calendar-btn');
    if (calendarBtn && picker) {
      calendarBtn.addEventListener('click', () => picker.showPicker && picker.showPicker());
      picker.addEventListener('change', (e) => {
        const val = sanitizeDateInput(e.target.value) || getTodayIso();
        currentDietDate = setDietDates(val);
        fetchDietSummary(currentDietDate);
      });
      picker.addEventListener('blur', (e) => {
        if (!sanitizeDateInput(e.target.value)) {
          const today = getTodayIso();
          picker.value = today;
          currentDietDate = setDietDates(today);
          fetchDietSummary(currentDietDate);
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
  });
  </script>
</html>
