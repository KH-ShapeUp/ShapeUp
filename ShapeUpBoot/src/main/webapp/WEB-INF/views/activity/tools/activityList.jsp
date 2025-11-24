<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div id="activity-list-backdrop" class="modal-backdrop" style="display:none;">
  <div class="modal-container activity-list-modal" id="activity-list-modal">
    <div class="modal-header">
      <div class="header-top">
        <h3>활동 검색</h3>
        <div class="header-actions">
          <button type="button" class="ghost-btn direct-input-btn" onclick="openCustomModalFromList()">직접 입력하기</button>
          <button type="button" class="close-btn" onclick="closeListModal()">✕</button>
        </div>
      </div>
      <form class="activity-search" id="activity-search-form">
        <input type="text" id="activity-search-input" placeholder="활동명을 입력하세요" />
        <button type="submit" class="primary-btn">검색</button>
      </form>
    </div>
    <div class="modal-body">
      <ul class="activity-list" id="activity-list-container"></ul>
    </div>
    <div class="modal-footer">
      <div class="selected-wrap">
        <div class="selected-name" id="selected-activity-name">선택된 활동:</div>
        <div class="selected-list" id="selected-activity-list"></div>
      </div>
      <div class="footer-actions">
        <button type="button" class="ghost-btn" onclick="closeListModal()">닫기</button>
        <button type="button" class="primary-btn footer-add-btn" id="activity-list-submit">추가하기</button>
      </div>
    </div>
  </div>
</div>

<script>
  const activityListState = {
    selectedActivities: [],
    listElement: null,
  };

  function openActivityModal() {
    const backdrop = document.getElementById('activity-list-backdrop');
    const modal = document.getElementById('activity-list-modal');
    if (backdrop) backdrop.style.display = 'flex';
    if (modal) modal.style.display = 'block';
    document.body.style.overflow = 'hidden';
  }

  function closeListModal() {
    const backdrop = document.getElementById('activity-list-backdrop');
    if (!backdrop) return;
    backdrop.style.display = 'none';
    document.body.style.overflow = 'auto';
  }

  function openCustomModalFromList() {
    closeListModal();
    if (typeof openCustomModal === 'function') {
      openCustomModal();
    }
  }

  function adaptActivity(raw) {
    return {
      name: raw.activityName || raw.name || '???',
      activityId: raw.activityId || raw.id || null,
      kcal: Number(raw.calPerMin || raw.kcalPerMin || raw.kcal) || 0,
      type: raw.activityType || raw.type || '?? ??',
      weightLevel: Number(raw.weightLevel || raw.level) || 1,
      intensityFactor: Number(raw.intensityFactor) || 1,
      minutes: Number(raw.minutes) || 0,
    };
  }

  function renderSelectedActivities() {
    const listEl = document.getElementById('selected-activity-list');
    if (!listEl) return;
    listEl.innerHTML = '';
    if (!activityListState.selectedActivities.length) {
      const empty = document.createElement('span');
      empty.className = 'selected-empty';
      empty.textContent = '선택된 활동이 없습니다';
      listEl.appendChild(empty);
      return;
    }

    activityListState.selectedActivities.forEach((act, index) => {
      const chip = document.createElement('div');
      chip.className = 'selected-chip';

      const nameSpan = document.createElement('span');
      nameSpan.className = 'chip-name';
      nameSpan.textContent = act.name || '이름 없음';

      const removeBtn = document.createElement('button');
      removeBtn.type = 'button';
      removeBtn.className = 'chip-remove';
      removeBtn.textContent = '✕';
      removeBtn.addEventListener('click', () => {
        activityListState.selectedActivities.splice(index, 1);
        renderSelectedActivities();
      });

      chip.appendChild(nameSpan);
      chip.appendChild(removeBtn);
      listEl.appendChild(chip);
    });
  }

  function renderActivityList(items = [], emptyMessage = '검색 결과가 없습니다') {
    const listEl = activityListState.listElement || document.getElementById('activity-list-container');
    if (!listEl) return;
    listEl.innerHTML = '';
    if (!items.length) {
      const li = document.createElement('li');
      li.className = 'activity-item empty-message';
      li.textContent = emptyMessage;
      listEl.appendChild(li);
      return;
    }

    items.forEach((item) => {
      const activity = adaptActivity(item);
      if (!activity) return;
      const li = document.createElement('li');
      li.className = 'activity-item';

      const nameSpan = document.createElement('span');
      nameSpan.className = 'activity-name';
      nameSpan.textContent = activity.name;

      const kcalSpan = document.createElement('span');
      kcalSpan.className = 'activity-kcal';
      kcalSpan.textContent = `${activity.kcal} kcal`;

      const addBtn = document.createElement('button');
      addBtn.type = 'button';
      addBtn.className = 'add-btn';
      addBtn.textContent = '+';
      addBtn.addEventListener('click', (event) => {
        event.preventDefault();
        startInsertActivity({ ...activity });
      });

      li.appendChild(nameSpan);
      li.appendChild(kcalSpan);
      li.appendChild(addBtn);
      listEl.appendChild(li);
    });
  }

  async function fetchActivityList(query) {
    const url = '/activity/list?q=' + encodeURIComponent(query || '');
    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error('검색 실패');
      const data = await res.json();
      renderActivityList(Array.isArray(data) ? data : [], '검색 결과가 없습니다');
    } catch (err) {
      console.error('활동 검색 실패', err);
      renderActivityList([], '검색 결과가 없습니다');
    }
  }

  function searchActivityList() {
    const keyword = document.getElementById('activity-search-input')?.value?.trim();
    if (!keyword) {
      renderActivityList([], '검색어를 입력하세요');
      renderSelectedActivities();
      return;
    }
    fetchActivityList(keyword);
  }

  function startInsertActivity(activity) {
    if (!activity) return;
    closeListModal();
    if (typeof setActivityModalData === 'function') {
      setActivityModalData(activity);
    } else if (typeof openActivityDetailModal === 'function') {
      openActivityDetailModal(activity);
    }
  }

  function receiveActivityFromInsert(activity) {
    if (!activity) return;
    activityListState.selectedActivities.push(activity);
    renderSelectedActivities();
    openActivityModal();
  }

  function buildActivityInsertPayload() {
    const nowIso = new Date().toISOString();
    return {
      userNo: window.loginUserNo || null,
      actionAt: nowIso,
      sourceType: 'MANUAL',
      items: activityListState.selectedActivities.map((item) => ({
        activityName: item.name || item.activityName || '???',
        activityId: item.activityId || null,
        weightLevel: Number(item.weightLevel) || 1,
        durationMin: Number(item.minutes) || 0,
        calories: Number(item.kcal) || 0,
        intensityFactor: Number(item.intensityFactor) || 1,
      })),
    };
  }

  async function submitSelectedActivities() {
    closeListModal();
    if (!activityListState.selectedActivities.length) return;
    const payload = buildActivityInsertPayload();
    console.log('Submitting activities payload =>', payload);
    try {
      const res = await fetch('/activity/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
      if (!res.ok) throw new Error('저장 실패');
    } catch (err) {
      console.error('활동 저장 실패', err);
    }
  }

  document.addEventListener('DOMContentLoaded', () => {
    activityListState.listElement = document.getElementById('activity-list-container');
    renderActivityList([], '검색어를 입력하세요');
    renderSelectedActivities();

    document.getElementById('activity-search-form')?.addEventListener('submit', (event) => {
      event.preventDefault();
      searchActivityList();
    });

    document.getElementById('activity-search-input')?.addEventListener('keydown', (event) => {
      if (event.key === 'Enter') {
        event.preventDefault();
        searchActivityList();
      }
    });

    document.getElementById('activity-list-submit')?.addEventListener('click', submitSelectedActivities);
  });

  window.openActivityModal = openActivityModal;
  window.closeListModal = closeListModal;
  window.receiveActivityFromInsert = receiveActivityFromInsert;
</script>