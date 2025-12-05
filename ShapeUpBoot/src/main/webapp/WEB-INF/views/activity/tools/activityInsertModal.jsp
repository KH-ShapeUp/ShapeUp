<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
  /* 기존 스타일 유지 */
  .activity-insert-modal {
    max-width: 560px;
    width: 92%;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 18px 48px rgba(15, 23, 42, 0.16);
    padding: 18px 18px 20px;
    display: flex;
    flex-direction: column;
    gap: 14px;
  }
  .activity-modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 8px;
  }
  .activity-name { font-size: 20px; font-weight: 800; }
  .activity-badge { padding: 6px 10px; border-radius: 999px; background: #eef2ff; color: #1d4ed8; font-weight: 700; font-size: 12px; }
  .activity-kcal { font-size: 26px; font-weight: 800; margin: 4px 0; }
  .activity-meta { color: #6b7280; font-weight: 700; }
  /* 목표 설정 모달과 구분하기 위해 activity-grid 스타일 변경 (3열 -> 2열) */
  .activity-insert-modal:not(#goal-setting-backdrop .activity-insert-modal) .activity-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
  .activity-box { border: 1px solid #e5e7eb; border-radius: 12px; padding: 10px; text-align: center; background: #fafbff; }
  .activity-box .label { color: #6b7280; font-weight: 700; font-size: 13px; }
  .activity-box .value { font-weight: 800; margin-top: 4px; }
  .control-row { display: flex; gap: 10px; align-items: center; }
  .control-row .field { flex: 1; }
  .input-pill { width: 100%; padding: 12px; border: 1px solid #d1d5db; border-radius: 12px; font-weight: 800; text-align: center; }
  .intensity-group { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-top: 8px; }
  .intensity-btn { border: 1px solid #d1d5db; border-radius: 12px; padding: 10px; background: #fff; cursor: pointer; font-weight: 800; }
  .intensity-btn.active { border-color: #2f80ff; background: #e7f0ff; color: #1d4ed8; }
  .qty-control { display: inline-flex; align-items: center; gap: 12px; justify-content: center; }
  .qty-control button { width: 38px; height: 38px; border-radius: 12px; border: 1px solid #d1d5db; background: #fff; cursor: pointer; font-weight: 900; }
  .qty-control span { min-width: 40px; text-align: center; font-weight: 800; }
  .modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 6px; }
  .primary-add { min-width: 140px; border: none; border-radius: 12px; background: linear-gradient(135deg, #34d399, #10b981); color: #fff; padding: 12px 16px; font-weight: 800; cursor: pointer; box-shadow: 0 14px 32px rgba(16,185,129,0.35); }
</style>

<div id="activity-insert-backdrop" class="modal-backdrop" style="display:none;">
  <div class="activity-insert-modal" role="dialog" aria-modal="true">
    <div class="activity-modal-header">
      <div>
        <div class="activity-badge" id="actModalType">-</div>
        <h3 class="activity-name" id="actModalName">선택한 활동</h3>
      </div>
      <button type="button" class="close-btn" onclick="closeActivityInsertModal()">✕</button>
    </div>
    <div>
      <div class="activity-kcal" id="actModalKcal">0 kcal</div>
      <div class="activity-meta">분당 칼로리: <span id="actModalPerMin">0</span> kcal</div>
    </div>
    <div class="activity-grid">
      <div class="activity-box">
        <div class="label">시간</div>
        <div class="value"><span id="actModalMinutes">0</span> 분</div>
      </div>
      <div class="activity-box">
        <div class="label">강도</div>
        <div class="value" id="actModalIntensityLabel">보통 (1.0x)</div>
      </div>
      <div class="activity-box">
        <div class="label">계산 칼로리</div>
        <div class="value" id="actModalCalc">0 kcal</div>
      </div>
    </div>
    <div class="control-row">
      <div class="field">
        <div class="label">시간(분)</div>
        <div class="qty-control">
          <button type="button" onclick="changeActMinutes(-5)">-</button>
          <span id="actModalMinutesDisplay">30</span>
          <button type="button" onclick="changeActMinutes(5)">+</button>
        </div>
      </div>
      <div class="field">
        <div class="label">직접 입력</div>
        <input type="number" id="actModalMinuteInput" class="input-pill" min="1" value="30">
      </div>
    </div>
    <div class="field">
      <div class="label" style="margin-bottom:6px;">강도 선택</div>
      <div class="intensity-group">
        <button type="button" class="intensity-btn" data-factor="0.8">약하게</button>
        <button type="button" class="intensity-btn active" data-factor="1">보통</button>
        <button type="button" class="intensity-btn" data-factor="1.3">강하게</button>
      </div>
    </div>
    <div class="modal-actions">
      <button type="button" class="ghost-btn" onclick="closeActivityInsertModal()">닫기</button>
      <button type="button" class="primary-add" onclick="addActivityFromModal()">추가하기</button>
    </div>
  </div>
</div>

<div id="goal-setting-backdrop" class="modal-backdrop" style="display:none;">
  <div class="activity-insert-modal" role="dialog" aria-modal="true">
    <div class="activity-modal-header">
      <div>
        <h3 class="activity-name">오늘의 목표 설정</h3>
      </div>
      <button type="button" class="close-btn" onclick="closeGoalSettingModal()">✕</button>
    </div>

    <div class="activity-grid" style="grid-template-columns: repeat(2, 1fr);">
      <div class="activity-box">
        <div class="label">현재 목표 소모 칼로리</div>
        <div class="value"><span id="currentGoalCalorie">0</span> kcal</div>
      </div>
      <div class="activity-box">
        <div class="label">현재 목표 운동 시간</div>
        <div class="value"><span id="currentGoalTime">0</span> 분</div>
      </div>
    </div>

    <div class="control-row">
      <div class="field">
        <div class="label">일일 목표 소모 칼로리 (kcal)</div>
        <input type="number" id="dailyGoalCalorieInput" class="input-pill" min="0" placeholder="예: 500">
      </div>
    </div>
    <div class="control-row">
      <div class="field">
        <div class="label">목표 운동 시간 (분)</div>
        <input type="number" id="dailyGoalTimeInput" class="input-pill" min="0" placeholder="예: 60">
      </div>
    </div>

    <div class="modal-actions">
      <button type="button" class="ghost-btn" onclick="closeGoalSettingModal()">닫기</button>
      <button type="button" class="primary-add" onclick="saveGoalSettings()">저장하기</button>
    </div>
  </div>
</div>

<script>
  // =========================================================
  // 1. 기존 활동 추가 모달 스크립트 (건드리지 않고 그대로 유지)
  // =========================================================

  const activityModalState = {
    activityId: null,
    name: '선택한 활동',
    type: '-',
    calPerMin: 0,
    minutes: 30,
    intensity: 1,
    weightLevel: 1
  };

  function updateActivityModalView() {
    const { name, type, calPerMin, minutes, intensity } = activityModalState;
    const kcal = Math.round((calPerMin * minutes * intensity) * 10) / 10;
    document.getElementById('actModalName').textContent = name || '선택한 활동';
    document.getElementById('actModalType').textContent = type || '-';
    document.getElementById('actModalPerMin').textContent = (calPerMin || 0).toFixed(1);
    document.getElementById('actModalMinutes').textContent = minutes;
    document.getElementById('actModalMinutesDisplay').textContent = minutes;
    document.getElementById('actModalMinuteInput').value = minutes;
    const intLabel = intensity === 0.8 ? '약하게' : intensity === 1.3 ? '강하게' : '보통';
    document.getElementById('actModalIntensityLabel').textContent = intLabel + ` (${intensity}x)`;
    document.getElementById('actModalCalc').textContent = kcal + ' kcal';
    document.getElementById('actModalKcal').textContent = kcal + ' kcal';
    document.querySelectorAll('.intensity-btn').forEach((btn) => {
      const f = Number(btn.dataset.factor);
      btn.classList.toggle('active', f === intensity);
    });
  }

  function openActivityModal() {
	  const backdrop = document.getElementById('activity-list-backdrop');
	  // ...
	  if (backdrop) backdrop.style.display = 'flex'; // 검색 모달을 띄움
	  document.body.style.overflow = 'hidden';
	}
  
  function openActivityInsertModal() {
    const backdrop = document.getElementById('activity-insert-backdrop');
    if (backdrop) {
      backdrop.style.display = 'flex';
      document.body.style.overflow = 'hidden';
      updateActivityModalView();
    }
  }

  function closeActivityInsertModal() {
    const backdrop = document.getElementById('activity-insert-backdrop');
    if (backdrop) {
      backdrop.style.display = 'none';
      document.body.style.overflow = 'auto';
    }
  }

  function setActivityModalData(activity) {
    if (!activity) return;
    activityModalState.activityId = activity.activityId || activity.id || null;
    activityModalState.name = activity.activityName || activity.name || '선택한 활동';
    activityModalState.type = activity.activityType || activity.type || '-';
    activityModalState.calPerMin = Number(activity.calPerMin || activity.kcal || 0) || 0;
    activityModalState.minutes = Number(activity.minutes) || 30;
    activityModalState.intensity = Number(activity.intensityFactor) || 1;
    activityModalState.weightLevel = Number(activity.weightLevel) || 1;
    openActivityInsertModal();
  }

  function changeActMinutes(delta) {
    const next = Math.max(1, activityModalState.minutes + delta);
    activityModalState.minutes = next;
    updateActivityModalView();
  }

  function addActivityFromModal() {
    const payload = {
      name: activityModalState.name,
      activityId: activityModalState.activityId,
      minutes: activityModalState.minutes,
      kcal: Math.round((activityModalState.calPerMin * activityModalState.minutes * activityModalState.intensity) * 10) / 10,
      intensityFactor: activityModalState.intensity,
      weightLevel: activityModalState.weightLevel,
      type: activityModalState.type
    };
    if (typeof receiveActivityFromInsert === 'function') {
      receiveActivityFromInsert(payload);
    }
    closeActivityInsertModal();
  }

  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.intensity-btn').forEach((btn) => {
      btn.addEventListener('click', () => {
        activityModalState.intensity = Number(btn.dataset.factor) || 1;
        updateActivityModalView();
      });
    });
    document.getElementById('actModalMinuteInput')?.addEventListener('change', (e) => {
      const v = Math.max(1, Number(e.target.value) || 1);
      activityModalState.minutes = v;
      updateActivityModalView();
    });
  });

  // 전역 바인딩 (기존)
  window.setActivityModalData = setActivityModalData;
  window.openActivityModal = openActivityModal; // 메인 페이지와 연결
  window.openActivityInsertModal = openActivityInsertModal;
  window.closeActivityInsertModal = closeActivityInsertModal;


  // =========================================================
  // 2. 목표 설정 Modal 스크립트 (새로 추가)
  // =========================================================
  
  const goalState = {
    dailyCalorie: 0, // GOAL_CALORIE_ACTIVITY_DAILY
    activityTime: 0  // GOAL_ACTIVITY_TIME
  };

  function updateGoalSettingView() {
    const { dailyCalorie, activityTime } = goalState;
    
    document.getElementById('currentGoalCalorie').textContent = dailyCalorie;
    document.getElementById('currentGoalTime').textContent = activityTime;

    document.getElementById('dailyGoalCalorieInput').value = dailyCalorie > 0 ? dailyCalorie : '';
    document.getElementById('dailyGoalTimeInput').value = activityTime > 0 ? activityTime : '';
  }

  /**
   * 목표 설정 모달을 엽니다. (메인 페이지의 버튼과 연결)
   * @param {object} initialData - 현재 저장된 목표 값 (dailyCalorie: GOAL_CALORIE_ACTIVITY_DAILY, activityTime: GOAL_ACTIVITY_TIME)
   */
  function openGoalSettingModal(initialData = { dailyCalorie: 0, activityTime: 0 }) {
    goalState.dailyCalorie = initialData.dailyCalorie;
    goalState.activityTime = initialData.activityTime;

    const backdrop = document.getElementById('goal-setting-backdrop');
    if (backdrop) {
      backdrop.style.display = 'flex';
      document.body.style.overflow = 'hidden';
      updateGoalSettingView();
    }
  }

  function closeGoalSettingModal() {
    const backdrop = document.getElementById('goal-setting-backdrop');
    if (backdrop) {
      backdrop.style.display = 'none';
      document.body.style.overflow = 'auto';
    }
  }

  function saveGoalSettings() {
	    const dailyCalorieInput = document.getElementById('dailyGoalCalorieInput');
	    const dailyTimeInput = document.getElementById('dailyGoalTimeInput');
	    
	    const newDailyCalorie = Math.max(0, Number(dailyCalorieInput.value) || 0);
	    const newActivityTime = Math.max(0, Number(dailyTimeInput.value) || 0);

	    // 서버로 보낼 데이터 구조를 GoalVO에 맞춰 준비
	    const payload = {
	      goalCalorieActivityDaily: newDailyCalorie, // GoalVO 필드 이름 사용
	      goalActivityTime: newActivityTime          // GoalVO 필드 이름 사용
	    };

	    console.log('활동 목표 설정 저장 시도:', payload);

	    // ⭐⭐ 새로 정의한 API 엔드포인트 호출 ⭐⭐
	    fetch('/user/saveActivityGoals', {
	      method: 'POST',
	      headers: { 
	          'Content-Type': 'application/json' 
	      },
	      body: JSON.stringify(payload)
	    })
	    .then(response => {
	        if (!response.ok) {
	            throw new Error('서버 응답 오류: HTTP ' + response.status);
	        }
	        return response.json(); 
	    })
	    .then(data => {
	        if (data && data.success) { 
	            // 1. 메인 페이지 UI 업데이트 (로컬 변수 업데이트 및 화면 갱신)
	            if (typeof handleGoalsUpdate === 'function') {
	                handleGoalsUpdate(newDailyCalorie, newActivityTime);
	            }
	            // 2. 모달 닫기
	            closeGoalSettingModal();
	            showActivityToast(data.message); // 서버에서 받은 메시지 출력
	        } else {
	            alert('목표 저장에 실패했습니다: ' + (data.message || '알 수 없는 오류'));
	        }
	    })
	    .catch(error => {
	        console.error('목표 저장 통신 오류:', error);
	        alert('목표 저장 중 오류가 발생했습니다.');
	    });
	}

  // 목표 설정 모달 전역 바인딩
  window.openGoalSettingModal = openGoalSettingModal;
  window.closeGoalSettingModal = closeGoalSettingModal;
  window.saveGoalSettings = saveGoalSettings;
</script>