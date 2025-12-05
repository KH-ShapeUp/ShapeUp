<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>오늘의 운동</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;600;700;800&display=swap">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/activity/activityRecord.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/activity/activityList.css">
  <jsp:include page="/WEB-INF/views/include/head.jsp"/>
</head>
<body class="activity-record">
  <jsp:include page="/WEB-INF/views/include/header.jsp"/>
  <main class="activity-record-main">
    <section class="page-header">
      <div>
        <h2>오늘의 운동</h2>
        <p class="page-subtitle">운동 시간을 기록하고, 목표를 향해 나아가세요.</p>
      </div>
      <button class="primary-cta" type="button" onclick="openGoalSettingModal({ dailyCalorie: actGoals.kcal, activityTime: actGoals.minutes })">목표 설정</button>
    </section>

    <div class="date-controls wide">
      <button type="button" class="nav-btn" id="act-date-prev-btn" aria-label="이전 날짜">←</button>
      <div class="date-pill" id="act-date-prev">--</div>
      <div class="date-pill active" id="act-date-today">--</div>
      <div class="date-pill" id="act-date-next">--</div>
      <button type="button" class="nav-btn" id="act-date-next-btn" aria-label="다음 날짜">→</button>
      <button type="button" class="calendar-fab" id="act-calendar-btn" aria-label="달력 열기">
        <span class="calendar-icon">📅</span>
      </button>
      <input type="date" id="act-date-picker" class="date-input-anchor" aria-label="날짜 선택" />
    </div>

    <section class="activity-grid">
      <div class="summary-panel card">
        <div class="summary-top">
          <div class="chip"><span class="thumb">💪</span> 오늘의 운동 요약</div>
          <div class="summary-date" id="act-summary-date">--</div>
        </div>
        <div class="stat-grid">
          <div class="stat-card time">
            <p class="stat-label">총 운동 시간</p>
            <p class="stat-value" id="total-minutes">0 분</p>
            <span class="stat-sub">목표 <span id="goal-minutes-display">90</span>분</span>
          </div>
          <div class="stat-card kcal">
            <p class="stat-label">총 소모 칼로리</p>
            <p class="stat-value" id="total-kcal">0 kcal</p>
            <span class="stat-sub">목표 <span id="goal-kcal-display">800</span> kcal</span>
          </div>
          <div class="stat-card count">
            <p class="stat-label">운동 횟수</p>
            <p class="stat-value" id="total-count">0 회</p>
            <span class="stat-sub">운동 추가 버튼으로 기록</span>
          </div>
        </div>
        <div class="progress-panel">
          <div class="progress-meta">
            <span>칼로리 진행도</span>
            <span id="progress-label">0 / 800 kcal</span>
          </div>
          <div class="progress-track"><span class="progress-fill" id="progress-fill"></span></div>
        </div>
      </div>

      <div class="chart-panel card">
        <div class="panel-header">
          <div>
            <p class="panel-title">운동 비율</p>
            <p class="panel-sub">종목별 소모 칼로리를 확인하세요.</p>
          </div>
          <button type="button" class="ghost-btn small" onclick="openActivityModal()">추가</button>
        </div>
        <div class="chart-placeholder">
          <canvas id="act-donut" width="240" height="240" aria-label="운동 비율 차트"></canvas>
        </div>
        <div class="legend">
          <span><span class="dot sports"></span>스포츠</span>
          <span><span class="dot cardio"></span>유산소</span>
          <span><span class="dot strength"></span>근력</span>
          <span><span class="dot stretch"></span>스트레칭</span>
        </div>
      </div>
    </section>

    <section class="log-panel card">
      <div class="panel-header">
        <div>
          <p class="panel-title">운동 기록</p>
          <p class="panel-sub">추가/삭제 후 새로고침 없이 바로 반영됩니다.</p>
        </div>
        <button class="ghost-btn small" type="button" onclick="openActivityModal()">운동 추가</button>
      </div>
      <div class="log-table-wrap">
        <table class="log-table">
          <thead>
            <tr>
              <th>운동명</th>
              <th>분류</th>
              <th>시간</th>
              <th>칼로리</th>
              <th>강도</th>
              <th>삭제</th>
            </tr>
          </thead>
          <tbody id="activity-log-body">
            <tr class="empty-row"><td colspan="6">기록된 운동이 없습니다. 운동을 추가해보세요.</td></tr>
          </tbody>
        </table>
      </div>
    </section>
  </main>
  <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
  <jsp:include page="/WEB-INF/views/activity/tools/activityList.jsp"/>
  <jsp:include page="/WEB-INF/views/activity/tools/activityInsertModal.jsp"/>
  <jsp:include page="/WEB-INF/views/activity/tools/activityDeleteModal.jsp"/>
  <jsp:include page="/WEB-INF/views/activity/tools/activityToast.jsp"/>
</body>

// ... (activityRecord.jsp 상단 HTML 및 <head> 부분은 동일)
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  let actCurrentDate = null;
  // 목표값 변수 (목표 설정 모달과 연동)
  const actGoals = { minutes: 90, kcal: 800 }; 
  let actDonutChart = null;
  let actLogs = [];
  const activityTypeLabel = { 'SPORTS': '스포츠', 'WEIGHT': '근력', 'CARDIO': '유산소', 'STRETCH': '스트레칭' };

  const safeStr = (v, fallback = '') => {
    if (v === null || v === undefined) return fallback;
    if (typeof v === 'boolean') return fallback;
    const s = String(v).trim();
    return s.length ? s : fallback;
  };
  const safeNum = (v, fallback = 0) => {
    const n = Number(v);
    return isNaN(n) ? fallback : n;
  };

  function pad2(n) { return (n < 10 ? '0' : '') + n; }
  function getTodayIso() {
    const d = new Date();
    return d.getFullYear() + '-' + pad2(d.getMonth() + 1) + '-' + pad2(d.getDate());
  }
  function formatDisplay(d) {
    return d.getFullYear() + '.' + pad2(d.getMonth() + 1) + '.' + pad2(d.getDate());
  }
  function setActDates(baseDate) {
    const target = baseDate ? new Date(baseDate) : new Date();
    const prev = new Date(target); prev.setDate(target.getDate() - 1);
    const next = new Date(target); next.setDate(target.getDate() + 1);
    document.getElementById('act-date-prev').textContent = formatDisplay(prev);
    document.getElementById('act-date-today').textContent = formatDisplay(target);
    document.getElementById('act-date-next').textContent = formatDisplay(next);
    document.getElementById('act-summary-date').textContent = formatDisplay(target);
    return target.getFullYear() + '-' + pad2(target.getMonth() + 1) + '-' + pad2(target.getDate());
  }
  
  // ⭐⭐⭐ 새로 추가된 헬퍼 함수: 단위 문자열에서 숫자만 추출 ⭐⭐⭐
  const extractNum = (elementId) => {
      const text = document.getElementById(elementId)?.textContent || '0';
      // '150 분' 또는 '500 kcal'에서 숫자만 추출
      const match = text.match(/[\d.]+/);
      return safeNum(match ? match[0] : 0);
  }
  // ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐


  function renderLogTable(logs = []) {
    // ... (기존 renderLogTable 함수와 동일)
    const tbody = document.getElementById('activity-log-body');
    if (!tbody) return;
    tbody.innerHTML = '';
    if (!logs.length) {
      const tr = document.createElement('tr');
      tr.className = 'empty-row';
      const td = document.createElement('td');
      td.colSpan = 6;
      td.textContent = '기록된 운동이 없습니다. 운동을 추가해보세요.';
      tr.appendChild(td);
      tbody.appendChild(tr);
      return;
    }
    logs.forEach((log) => {
      const display = (v) => {
        if (v === null || v === undefined || v === '' || v === false || v === true) return '-';
        const s = String(v).trim();
        return s.length ? s : '-';
      };
      const tr = document.createElement('tr');
      const name = display(log.name);
      const type = display(log.type);
      const minutesVal = display(log.minutes);
      const kcalVal = display(log.kcal);
      const intensity = display(log.intensityLabel);
      const logId = log.logId || '';
      const html =
        '<td>' + name + '</td>' +
        '<td>' + type + '</td>' +
        '<td>' + minutesVal + (minutesVal === '-' ? '' : ' 분') + '</td>' +
        '<td>' + kcalVal + (kcalVal === '-' ? '' : ' kcal') + '</td>' +
        '<td>' + intensity + '</td>' +
        '<td><button class="ghost-btn tiny" type="button" data-log-id="' + logId + '">삭제</button></td>';
      tr.innerHTML = html;
      tbody.appendChild(tr);
    });
    tbody.querySelectorAll('button[data-log-id]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const id = btn.getAttribute('data-log-id');
        if (!id) return;
        openActivityDeleteModal(id);
      });
    });
  }

  // 목표값을 반영하도록 수정
  function renderSummary(totals = {}) {
    const totalMinutes = Number(totals.totalMinutes) || 0;
    const totalKcal = Number(totals.totalKcal) || 0;
    const count = Number(totals.count) || 0;
    
    // 목표값 가져오기
    const goalMinutes = actGoals.minutes || 90;
    const goalKcal = actGoals.kcal || 800;
    
    // UI 업데이트
    document.getElementById('total-minutes').textContent = totalMinutes + ' 분';
    document.getElementById('goal-minutes-display').textContent = goalMinutes; // 목표 시간 업데이트
    
    document.getElementById('total-kcal').textContent = totalKcal + ' kcal';
    document.getElementById('goal-kcal-display').textContent = goalKcal; // 목표 칼로리 업데이트
    
    document.getElementById('total-count').textContent = count + ' 회';
    
    const pct = goalKcal > 0 ? Math.min(100, Math.round((totalKcal / goalKcal) * 100)) : 0;
    document.getElementById('progress-fill').style.width = pct + '%';
    document.getElementById('progress-label').textContent = totalKcal + ' / ' + goalKcal + ' kcal';
  }

  function renderDonut(logs = []) {
    // ... (기존 renderDonut 함수와 동일)
    const ctx = document.getElementById('act-donut');
    if (!ctx || !window.Chart) return;
    const typeOrder = ['스포츠', '유산소', '근력', '스트레칭'];
    const colors = ['#2f80ff', '#ff9fb2', '#8b9bff', '#ffce73'];
    const totals = { '스포츠': 0, '유산소': 0, '근력': 0, '스트레칭': 0 };
    logs.forEach((log) => {
      const t = (log.type || '').trim();
      if (totals[t] !== undefined) {
        totals[t] += Number(log.kcal) || 0;
      }
    });
    const dataArr = typeOrder.map((t) => totals[t] || 0);
    const hasData = dataArr.some((v) => v > 0);
    const safeData = hasData ? dataArr : [1,1,1,1];
    const cfg = {
      type: 'doughnut',
      data: {
        labels: typeOrder,
        datasets: [{
          data: safeData,
          backgroundColor: colors,
          borderColor: '#f7f8fb',
          borderWidth: 3,
          hoverOffset: 8,
        }]
      },
      options: {
        cutout: '70%',
        plugins: { legend: { display: false } }
      }
    };
    if (actDonutChart) {
      actDonutChart.data.datasets[0].data = safeData;
      actDonutChart.update();
    } else {
      actDonutChart = new Chart(ctx, cfg);
    }
  }

  function formatIntensityLabel(val) {
    const n = Number(val);
    if (n <= 0.85) return '약하게';
    if (n >= 1.2) return '강하게';
    return '보통';
  }

  async function loadActivityLogs(dateStr) {
    // ... (기존 loadActivityLogs 함수와 동일)
    const safeDate = dateStr || getTodayIso();
    try {
      const res = await fetch('/activity/logs?date=' + encodeURIComponent(safeDate));
      if (!res.ok) throw new Error('logs failed');
      const json = await res.json();
      const logs = json.logs || [];
      actLogs = logs.map((l) => {
        const typeCode = safeStr(l.activityType || l.type, '').toUpperCase();
        const typeLabel = activityTypeLabel[typeCode] || safeStr(l.activityType || l.type, '-');
        const minutes = safeNum(l.durationMin || l.minutes, 0);
        const kcal = safeNum(l.calories || l.kcal, 0);
        const intensityVal = l.intensityFactor != null ? safeNum(l.intensityFactor, 1) : safeNum(l.intensity, 1);
        return {
          logId: l.logId,
          name: safeStr(l.activityName || l.name, '이름 없음'),
          type: typeLabel || '-',
          minutes,
          kcal,
          intensity: intensityVal,
          intensityLabel: formatIntensityLabel(intensityVal)
        };
      });
      renderLogTable(actLogs);
    } catch (err) {
      console.error('load logs failed', err);
      actLogs = [];
      renderLogTable(actLogs);
    }
  }
  
  // ⭐⭐⭐ 수정된 부분: loadActivitySummary 함수 (운동 추가 시 목표값 초기화 방지) ⭐⭐⭐
  async function loadActivitySummary(dateStr) {
    const safeDate = dateStr || getTodayIso();
    try {
      const res = await fetch('/activity/summary?date=' + encodeURIComponent(safeDate));
      if (!res.ok) throw new Error('summary failed');
      const json = await res.json();
      
      const goals = json.goals || {};
      
      // 서버에서 받은 값이 0보다 클 경우에만 갱신하고, 그렇지 않으면 기존 actGoals 값을 유지합니다.
      const newMinutes = safeNum(goals.GOAL_ACTIVITY_TIME || goals.minutes, 0);
      const newKcal = safeNum(goals.GOAL_CALORIE_ACTIVITY_DAILY || goals.kcal, 0);

      actGoals.minutes = newMinutes > 0 ? newMinutes : actGoals.minutes;
      actGoals.kcal = newKcal > 0 ? newKcal : actGoals.kcal;

      const totals = json.totals || {};
      const totalMinutes = Number(totals.totalMinutes) || 0;
      const totalKcal = Number(totals.totalKcal) || 0;
      const count = Number(totals.count) || 0;
      
      renderSummary({ totalMinutes, totalKcal, count });
      
      const byType = json.byType || [];
      const merged = byType.map(t => ({
        name: t.activityType || '',
        type: t.activityType || '',
        minutes: 0,
        kcal: t.kcal || 0,
        intensity: '-'
      }));
      renderDonut(merged);
    } catch (err) {
      console.error('load summary failed', err);
      renderSummary({});
      renderDonut([]);
    }
  }
  // ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐

  async function deleteLog(logId) {
    try {
      const res = await fetch('/activity/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ logIds: [logId] })
      });
      if (!res.ok) throw new Error('delete failed');
      await loadActivityLogs(actCurrentDate || getTodayIso());
      await loadActivitySummary(actCurrentDate || getTodayIso());
      showActivityToast('삭제되었습니다.');
    } catch (err) {
      console.error('delete log failed', err);
    }
  }
  
  // ⭐⭐⭐ 수정된 부분: handleGoalsUpdate 함수 (목표 변경 시 진행도 초기화 방지) ⭐⭐⭐
  // 목표 설정 모달에서 저장 후 호출될 함수
  function handleGoalsUpdate(newDailyCalorie, newActivityTime) {
    actGoals.kcal = newDailyCalorie;
    actGoals.minutes = newActivityTime;
    
    // UI 바로 업데이트 시, 현재 화면에 표시된 총계 값을 정확히 추출하여 사용합니다.
    renderSummary({ 
        totalMinutes: extractNum('total-minutes'), // '150 분'에서 150 추출
        totalKcal: extractNum('total-kcal'),       // '500 kcal'에서 500 추출
        count: extractNum('total-count')
    });
    showActivityToast('목표가 업데이트되었습니다.');
  }
  window.handleGoalsUpdate = handleGoalsUpdate;
  // ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐


  document.addEventListener('DOMContentLoaded', () => {
    // ... (기존 DOMContentLoaded 로직은 동일)
    const picker = document.getElementById('act-date-picker');
    actCurrentDate = setActDates();
    if (picker) picker.value = actCurrentDate;
    loadActivityLogs(actCurrentDate);
    loadActivitySummary(actCurrentDate);

    document.getElementById('act-calendar-btn')?.addEventListener('click', () => picker && picker.showPicker && picker.showPicker());
    picker?.addEventListener('change', (e) => {
      const val = e.target.value || getTodayIso();
      actCurrentDate = setActDates(val);
      loadActivityLogs(actCurrentDate);
      loadActivitySummary(actCurrentDate);
    });

    const moveDate = (offset) => {
      const base = actCurrentDate ? new Date(actCurrentDate) : new Date();
      base.setDate(base.getDate() + offset);
      const iso = base.getFullYear() + '-' + pad2(base.getMonth() + 1) + '-' + pad2(base.getDate());
      if (picker) picker.value = iso;
      actCurrentDate = setActDates(iso);
      loadActivityLogs(actCurrentDate);
      loadActivitySummary(actCurrentDate);
    };
    document.getElementById('act-date-prev-btn')?.addEventListener('click', () => moveDate(-1));
    document.getElementById('act-date-next-btn')?.addEventListener('click', () => moveDate(1));
  });
</script>
</html>
</html>