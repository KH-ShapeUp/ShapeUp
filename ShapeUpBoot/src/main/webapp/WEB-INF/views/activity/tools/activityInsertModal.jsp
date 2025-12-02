<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
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
  .activity-insert-modal .activity-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
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
<script>
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

  // 전역 바인딩
  window.setActivityModalData = setActivityModalData;
  window.openActivityInsertModal = openActivityInsertModal;
  window.closeActivityInsertModal = closeActivityInsertModal;
</script>
