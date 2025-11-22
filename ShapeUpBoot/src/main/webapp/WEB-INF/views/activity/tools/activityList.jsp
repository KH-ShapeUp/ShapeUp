<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div id="activity-list-backdrop" class="modal-backdrop" style="display:none;">
  <div class="modal-container" id="activity-list-modal">
    <div class="modal-header">
      <div class="header-top">
        <h3>운동 검색</h3>
        <div class="header-actions">
          <button type="button" class="ghost-btn direct-input-btn" onclick="openCustomModalFromList()">직접 입력하기</button>
          <button type="button" class="close-btn" onclick="closeListModal()">✕</button>
        </div>
      </div>
      <form class="activity-search" id="activity-search-form">
        <input type="text" id="activity-search-input" placeholder="운동명을 입력하세요" />
        <button type="submit" class="primary-btn">검색</button>
      </form>
    </div>
    <div class="modal-body">
      <ul class="activity-list" id="activity-list-container"></ul>
    </div>
    <div class="modal-footer">
      <div class="selected-wrap">
        <div class="selected-name" id="selected-activity-name">선택한 운동:</div>
        <div class="selected-list" id="selected-activity-list"></div>
      </div>
      <div class="footer-actions">
        <button type="button" class="ghost-btn" onclick="closeListModal()">닫기</button>
        <button type="button" class="primary-btn footer-add-btn" id="activity-list-submit">추가하기</button>
      </div>
    </div>
  </div>
</div>

<style>
  /* 리스트 영역 스크롤(ditetList와 동일한 UX를 위해 높이 제한) */
  body.activity-record .activity-list {
    max-height: 360px;
    overflow-y: auto;
    padding-right: 4px;
  }
</style>

<script>
  const activityListState = {
    selectedActivities: [],
    listElement: null,
  };

  // 모달 열기
  function openActivityModal() {
    const backdrop = document.getElementById('activity-list-backdrop');
    const modal = document.getElementById('activity-list-modal');
    if (backdrop) {
      backdrop.style.display = 'flex';
    }
    if (modal) {
      modal.style.display = 'block';
    }
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
    if (!raw) return null;
    return {
      name: raw.activityName || raw.name || '이름 없음',
      kcal: Number(raw.calPerMin || raw.kcalPerMin) || 0, // 1분 칼로리
      type: raw.activityType || raw.type || '구분 없음',
      level: raw.weightLevel || raw.level || '일반',
    };
  }

  function renderSelectedActivities() {
    const listEl = document.getElementById('selected-activity-list');
    if (!listEl) return;
    listEl.innerHTML = '';
    if (!activityListState.selectedActivities.length) {
      const empty = document.createElement('span');
      empty.className = 'selected-empty';
      empty.textContent = '선택된 운동이 없습니다';
      listEl.appendChild(empty);
      return;
    }

    activityListState.selectedActivities.forEach((act, index) => {
      const chip = document.createElement('div');
      chip.className = 'selected-chip';

      const nameSpan = document.createElement('span');
      nameSpan.className = 'chip-name';
      nameSpan.textContent = act.name || '�̸� ����';

      const removeBtn = document.createElement('button');
      removeBtn.type = 'button';
      removeBtn.className = 'chip-remove';
      removeBtn.textContent = '?';
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
      console.error('운동 검색 실패', err);
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
    activityListState.selectedActivities.push(activity);
    renderSelectedActivities();
    if (typeof setActivityModalData === 'function') {
      setActivityModalData(activity);
    } else if (typeof openActivityDetailModal === 'function') {
      openActivityDetailModal(activity);
    }
  }

  async function submitSelectedActivities() {
    closeListModal();
    if (!activityListState.selectedActivities.length) return;
    try {
      await fetch('/activity/selected', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ items: activityListState.selectedActivities }),
      });
    } catch (err) {
      console.error('� ���� ����', err);
    }
  }

  function receiveActivityFromInsert(activity) {
    if (!activity) return;
    activityListState.selectedActivities.push(activity);
    renderSelectedActivities();
    openActivityModal();
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
  window.openCustomModalFromList = openCustomModalFromList;
  window.receiveActivityFromInsert = receiveActivityFromInsert;
</script>
