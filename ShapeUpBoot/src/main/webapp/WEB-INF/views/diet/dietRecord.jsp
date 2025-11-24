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
    <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  </head>
  <body class="diet-record">
    <jsp:include page="/WEB-INF/views/include/header.jsp"/>
    <main>
      <h2>오늘의 식단</h2>
      <div class="content">
        <div class="left-box-wrapper">
          <div class="meal-summary">
            <img src="https://img.icons8.com/ios-filled/50/000000/thumb-up.png" alt="like" />
            <span>오늘의 식단 요약</span>
          </div>
          <div class="left-box">
            <div class="calorie-box">
              <div class="date-list">
                <button type="button" class="calendar-btn" id="diet-calendar-btn">📅</button>
                <input type="date" id="diet-date-picker" style="display:none;" />
                <div class="date-item" id="diet-date-prev">--</div>
                <div class="date-item active" id="diet-date-today">--</div>
                <div class="date-item" id="diet-date-next">--</div>
              </div>
              <div class="calorie-display">
                <div class="circle-ratio">
                  <span>영양소 비율</span>
                </div>
                <div class="calorie-value">
                  <span class="value" id="total-kcal">0 Kcal</span>
                  <span class="label">총 칼로리</span>
                </div>
              </div>
              <div class="nutrition-grid">
                <div class="nutrition-item">
                  <div class="icon-text">
                    <img src="https://img.icons8.com/ios-filled/50/000000/rice-bowl--v1.png" alt="carbohydrate-icon" />
                    <span class="nutrient">탄수화물</span>
                  </div>
                  <span class="amount" id="total-carb">0 g</span>
                </div>
                <div class="nutrition-item">
                  <div class="icon-text">
                    <img src="https://img.icons8.com/ios-filled/50/000000/steak.png" alt="protein-icon" />
                    <span class="nutrient">단백질</span>
                  </div>
                  <span class="amount" id="total-protein">0 g</span>
                </div>
                <div class="nutrition-item">
                  <div class="icon-text">
                    <img src="https://img.icons8.com/ios-filled/50/000000/milk-bottle--v1.png" alt="fat-icon" />
                    <span class="nutrient">지방</span>
                  </div>
                  <span class="amount" id="total-fat">0 g</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="right-box">
          <div class="meal-time">
            <div class="meal-label">아침</div>
            <div class="meal-info">
              <span class="add-button">식단 추가</span>
              <span class="kcal-value" id="kcal-breakfast">0 Kcal</span>
            </div>
          </div>
          <div class="meal-time">
            <div class="meal-label">점심</div>
            <div class="meal-info">
              <span class="add-button">식단 추가</span>
              <span class="kcal-value" id="kcal-lunch">0 Kcal</span>
            </div>
          </div>
          <div class="meal-time">
            <div class="meal-label">저녁</div>
            <div class="meal-info">
              <span class="add-button">식단 추가</span>
              <span class="kcal-value" id="kcal-dinner">0 Kcal</span>
            </div>
          </div>
          <div class="meal-time">
            <div class="meal-label">간식</div>
            <div class="meal-info">
              <span class="add-button">식단 추가</span>
              <span class="kcal-value" id="kcal-snack">0 Kcal</span>
            </div>
          </div>
        </div>
      </div>
    </main>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/dietInsertModal.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/customInsertModal.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/dietList.jsp"/>
  </body>
  <script>
  let currentDietDate = null;

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

  async function fetchDietSummary(dateStr) {
    const targets = {
      '아침': document.getElementById('kcal-breakfast'),
      '점심': document.getElementById('kcal-lunch'),
      '저녁': document.getElementById('kcal-dinner'),
      '간식': document.getElementById('kcal-snack'),
    };
    const macroTargets = {
      carb: document.getElementById('total-carb'),
      protein: document.getElementById('total-protein'),
      fat: document.getElementById('total-fat'),
    };
    const alias = {
      '아침': '아침', '점심': '점심', '저녁': '저녁', '간식': '간식',
      'breakfast': '아침', 'lunch': '점심', 'dinner': '저녁', 'snack': '간식',
      'BREAKFAST': '아침', 'LUNCH': '점심', 'DINNER': '저녁', 'SNACK': '간식',
    };
    const setAllZero = () => {
      Object.values(targets).forEach((el) => {
        if (el) el.textContent = '0 Kcal';
      });
      const totalEl = document.getElementById('total-kcal');
      if (totalEl) totalEl.textContent = '0 Kcal';
      Object.values(macroTargets).forEach((el) => {
        if (el) el.textContent = '0 g';
      });
    };

    const safeDate = sanitizeDateInput(dateStr) || getTodayIso();
    setAllZero();

    try {
      const res = await fetch('/diet/summary?date=' + encodeURIComponent(safeDate));
      if (!res.ok) throw new Error('summary failed');
      const json = await res.json();
      const data = json.data || {};
      const totals = json.totals || {};
      let total = 0;
      Object.entries(data).forEach(([k, v]) => {
        const key = alias[k] || alias[String(k).trim()] || null;
        const el = key ? targets[key] : null;
        if (el) {
          const val = Number(v) || 0;
          total += val;
          el.textContent = val + ' Kcal';
        }
      });
      const totalEl = document.getElementById('total-kcal');
      const totalKcalValue = totals.kcal || totals.totalKcal || total;
      if (totalEl) totalEl.textContent = (Number(totalKcalValue) || 0) + ' Kcal';

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
    } catch (err) {
      console.error('failed to load diet summary', err);
      setAllZero();
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    ['diet-list-backdrop','modal-backdrop','custom-backdrop'].forEach(id => {
      const el = document.getElementById(id);
      if (el) el.style.display = 'none';
    });

    const mealTypes = ['아침', '점심', '저녁', '간식'];
    document.querySelectorAll('.meal-time .add-button').forEach((btn, idx) => {
      btn.dataset.dietType = mealTypes[idx] || '기타';
      btn.addEventListener('click', (event) => {
        event.preventDefault();
        const type = btn.dataset.dietType || '기타';
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
  });

  window.getCurrentDietDate = () => currentDietDate || getTodayIso();
  window.refreshDietSummary = () => fetchDietSummary(window.getCurrentDietDate());
  </script>
</html>
