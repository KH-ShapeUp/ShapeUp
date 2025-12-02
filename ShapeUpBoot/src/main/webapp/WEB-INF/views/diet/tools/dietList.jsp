<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="diet-list-backdrop" class="modal-backdrop" style="display:none;">
  <div class="modal-container diet-list-modal" role="dialog" aria-modal="true">
    <div class="modal-header">
      <div class="header-top">
        <h3>음식 검색</h3>
        <div class="header-actions">
          <button type="button" class="ghost-btn fasting-modal-btn" onclick="applyFastingFromList()">단식</button>
          <button type="button" class="ghost-btn" onclick="openCustomModalFromList()">직접 입력</button>
          <button type="button" class="close-btn" onclick="closeDietListModal()">✕</button>
        </div>
      </div>
      <form class="diet-search" id="diet-search-form">
        <input type="text" id="diet-search-input" placeholder="검색어를 입력하세요" />
        <button type="submit" class="primary-btn">검색</button>
      </form>
    </div>
    <div class="modal-body">
      <ul class="diet-list" id="diet-list-container"></ul>
    </div>
    <div class="modal-footer">
      <div class="selected-wrap">
        <div class="selected-name">선택한 음식</div>
        <div class="selected-list" id="selected-food-list"></div>
      </div>
      <div class="footer-actions">
        <button type="button" class="ghost-btn" onclick="closeDietListModal()">닫기</button>
        <button type="button" class="primary-btn" id="diet-list-submit">저장</button>
      </div>
      <div class="login-required-note" id="diet-login-note" style="display:none;">로그인이 필요합니다.</div>
    </div>
  </div>
</div>

<script>
  const dietListState = {
    selectedFoods: [],
    existingFoods: [],
    removedDietNos: [],
    listElement: null,
    dietType: '아침',
  };

  function applyLoginStateToDietModal() {
    const submitBtn = document.getElementById('diet-list-submit');
    const note = document.getElementById('diet-login-note');
    const loggedIn = !!window.isDietLoggedIn;
    if (submitBtn) {
      submitBtn.disabled = !loggedIn;
      submitBtn.classList.toggle('disabled-action', !loggedIn);
    }
    if (note) {
      note.style.display = loggedIn ? 'none' : 'block';
    }
  }

  function adaptFood(raw) {
    if (!raw) return null;
    return {
      foodCd: raw.foodCd || null,
      name: raw.foodName || raw.name || '이름 없음',
      kcal: Number(raw.kcal) || 0,
      carb: Number(raw.carb) || 0,
      protein: Number(raw.protein) || 0,
      fat: Number(raw.fat) || 0,
      servingSize: Number(raw.servingSize || raw.weight || raw.serving || 100) || 100,
    };
  }

  function openDietListModal() {
    const backdrop = document.getElementById('diet-list-backdrop');
    if (!backdrop) return;
    backdrop.style.display = 'flex';
    document.body.style.overflow = 'hidden';
    applyLoginStateToDietModal();
    loadExistingDietItems();
    if (!dietListState.listElement) {
      dietListState.listElement = document.getElementById('diet-list-container');
    }
    if (dietListState.listElement && !dietListState.listElement.childElementCount) {
      renderFoodList([], '검색어를 입력하세요');
      renderSelectedList();
    }
  }

  function closeDietListModal() {
    const backdrop = document.getElementById('diet-list-backdrop');
    if (!backdrop) return;
    backdrop.style.display = 'none';
    document.body.style.overflow = 'auto';
  }

  function openCustomModalFromList() {
    closeDietListModal();
    if (typeof openCustomModal === 'function') {
      openCustomModal();
    }
  }

  function applyFastingFromList() {
    if (typeof window.toggleFastingByType === 'function') {
      window.toggleFastingByType(dietListState.dietType || window.lastSelectedDietType || '기타');
    }
    closeDietListModal();
  }

  function renderFoodList(items = [], emptyMessage = '검색 결과가 없습니다') {
    const listEl = dietListState.listElement || document.getElementById('diet-list-container');
    if (!listEl) return;
    listEl.innerHTML = '';
    if (!items.length) {
      const li = document.createElement('li');
      li.className = 'diet-item empty-message';
      li.textContent = emptyMessage;
      listEl.appendChild(li);
      return;
    }

    items.forEach((item) => {
      const food = adaptFood(item);
      if (!food) return;
      const li = document.createElement('li');
      li.className = 'diet-item';

      const nameSpan = document.createElement('span');
      nameSpan.className = 'food-name';
      nameSpan.textContent = food.name;

      const kcalSpan = document.createElement('span');
      kcalSpan.className = 'food-kcal';
      kcalSpan.textContent = (food.kcal || 0) + ' kcal';

      const addBtn = document.createElement('button');
      addBtn.type = 'button';
      addBtn.className = 'add-btn';
      addBtn.textContent = '+';
      addBtn.addEventListener('click', (event) => {
        event.preventDefault();
        startInsertFood({ ...food });
      });

      li.appendChild(nameSpan);
      li.appendChild(kcalSpan);
      li.appendChild(addBtn);
      listEl.appendChild(li);
    });
  }

  function renderSelectedList() {
    const listEl = document.getElementById('selected-food-list');
    if (!listEl) return;
    listEl.innerHTML = '';
    if (!dietListState.selectedFoods.length) {
      const empty = document.createElement('span');
      empty.className = 'selected-empty';
      empty.textContent = '선택된 음식이 없습니다';
      listEl.appendChild(empty);
      return;
    }

    dietListState.selectedFoods.forEach((food, index) => {
      const displayName = (food && food.name) ? String(food.name) : '선택 없음';

      const chip = document.createElement('div');
      chip.className = 'selected-chip' + (food.existing ? ' existing-chip' : '');

      const nameSpan = document.createElement('span');
      nameSpan.className = 'chip-name';
      nameSpan.textContent = displayName;

      if (food.existing) {
        const badge = document.createElement('span');
        badge.className = 'chip-badge';
        badge.textContent = '기존';
        chip.appendChild(badge);
      }

      const removeBtn = document.createElement('button');
      removeBtn.type = 'button';
      removeBtn.className = 'chip-remove';
      removeBtn.textContent = '✕';
      removeBtn.addEventListener('click', () => {
        if (food.existing && food.dietNo) {
          if (!dietListState.removedDietNos.includes(food.dietNo)) {
            dietListState.removedDietNos.push(food.dietNo);
          }
        }
        dietListState.selectedFoods.splice(index, 1);
        renderSelectedList();
      });

      chip.appendChild(nameSpan);
      chip.appendChild(removeBtn);
      listEl.appendChild(chip);
    });
  }

  function startInsertFood(food) {
    if (!food) return;
    closeDietListModal();
    if (typeof setDietModalData === 'function') {
      setDietModalData(food);
    } else if (typeof openModal === 'function') {
      openModal();
    }
  }

  function addSelectedFood(food, options = {}) {
    if (!food || (!food.name && !food.foodName)) return;
    const fromInsert = options.fromInsert === true;
    const normalizedFood = {
      name: food.name || food.foodName,
      foodCd: food.foodCd || null,
      kcal: Number(food.kcal) || 0,
      carb: Number(food.carb) || 0,
      protein: Number(food.protein) || 0,
      fat: Number(food.fat) || 0,
      servingSize: Number(food.servingSize || food.weight || food.serving || 100) || 100,
      dietType: dietListState.dietType || '기타',
    };
    dietListState.selectedFoods.push(normalizedFood);
    renderSelectedList();
    if (!fromInsert) {
      closeDietListModal();
    }
  }

  async function fetchFoodList(query) {
    const url = '/diet/list?q=' + encodeURIComponent(query || '');
    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error('검색 실패');
      const data = await res.json();
      renderFoodList(Array.isArray(data) ? data : [], '검색 결과가 없습니다');
    } catch (err) {
      console.error('식품 검색 실패', err);
      renderFoodList([], '검색 결과가 없습니다');
    }
  }

  function searchFoodList() {
    const keyWord = document.getElementById('diet-search-input')?.value?.trim();
    if (!keyWord) {
      renderFoodList([], '검색어를 입력하세요');
      renderSelectedList();
      return;
    }
    fetchFoodList(keyWord);
  }

  function getToday() {
    const d = new Date();
    const mm = String(d.getMonth() + 1).padStart(2, '0');
    const dd = String(d.getDate()).padStart(2, '0');
    return `${d.getFullYear()}-${mm}-${dd}`;
  }


  function getSelectedDietDate() {
    if (typeof window.getCurrentDietDate === "function") {
      return window.getCurrentDietDate() || getToday();
    }
    return getToday();
  }

  async function submitSelectedFoods() {
    closeDietListModal();
    const newFoods = dietListState.selectedFoods.filter(f => !f.existing);
    const removed = dietListState.removedDietNos || [];
    const hasDeletes = removed.length > 0;
    const hasInserts = newFoods.length > 0;
    if (!hasDeletes && !hasInserts) {
      renderSelectedList();
      return;
    }

    // 삭제 먼저
    if (hasDeletes) {
      try {
        const resDel = await fetch('/diet/delete', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ dietNos: removed }),
        });
        if (resDel.status === 401) {
          alert('로그인이 필요합니다.');
          return;
        }
        if (!resDel.ok) throw new Error('삭제 실패');
        if (!hasInserts) {
          if (typeof refreshDietSummary === "function") {
            refreshDietSummary();
          }
          loadExistingDietItems();
          return;
        }
      } catch (err) {
        console.error('식단 삭제 실패', err);
        // 삭제 실패 시 저장 중단
        return;
      }
    }

    if (!hasInserts) {
      dietListState.removedDietNos = [];
      loadExistingDietItems();
      return;
    }

    const payload = {
      dietType: dietListState.dietType || '기타',
      dietDate: getSelectedDietDate(),
      items: newFoods.map((f) => ({
        foodNames: f.name,
        name: f.name,
        foodCd: f.foodCd,
        amount: f.servingSize,
        kcal: f.kcal,
      })),
    };
    try {
      const res = await fetch('/diet/insert', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
      if (res.status === 401) {
        alert('로그인이 필요합니다.');
        return;
      }
      if (!res.ok) throw new Error('저장 실패');
      dietListState.selectedFoods = [];
      dietListState.removedDietNos = [];
      renderSelectedList();
      if (typeof refreshDietSummary === "function") {
        refreshDietSummary();
      }
      loadExistingDietItems();
    } catch (err) {
      console.error('식단 저장 실패', err);
    }
  }

  async function loadExistingDietItems() {
    const date = getSelectedDietDate();
    const type = dietListState.dietType || '기타';
    const pendingNew = dietListState.selectedFoods.filter(f => !f.existing);
    try {
      const res = await fetch('/diet/items?date=' + encodeURIComponent(date) + '&type=' + encodeURIComponent(type));
      if (!res.ok) throw new Error('load failed');
      const json = await res.json();
      const items = json.items || [];
      const existingFoods = items.map((item) => ({
        dietNo: item.dietNo,
        name: item.foodNames || item.name || '이름 없음',
        foodCd: item.foodCd || null,
        kcal: Number(item.kcal) || 0,
        carb: Number(item.carb) || 0,
        protein: Number(item.protein) || 0,
        fat: Number(item.fat) || 0,
        servingSize: Number(item.amount || item.servingSize || 0) || 0,
        existing: true,
      }));
      dietListState.existingFoods = existingFoods;
      dietListState.selectedFoods = [...existingFoods, ...pendingNew];
      dietListState.removedDietNos = [];
      renderSelectedList();
    } catch (err) {
      console.error('기존 식단 불러오기 실패', err);
      dietListState.selectedFoods = [...pendingNew];
      dietListState.existingFoods = [];
      dietListState.removedDietNos = [];
      renderSelectedList();
    }
  }

  function receiveDietFromInsert(food) {
    addSelectedFood(food, { fromInsert: true });
    openDietListModal();
  }

  document.addEventListener('DOMContentLoaded', () => {
    applyLoginStateToDietModal();
    dietListState.listElement = document.getElementById('diet-list-container');
    renderFoodList([], '검색어를 입력하세요');
    renderSelectedList();

    document.getElementById('diet-search-form')?.addEventListener('submit', (event) => {
      event.preventDefault();
      searchFoodList();
    });

    document.getElementById('diet-search-input')?.addEventListener('keydown', (event) => {
      if (event.key === 'Enter') {
        event.preventDefault();
        searchFoodList();
      }
    });

    document.getElementById('diet-list-submit')?.addEventListener('click', submitSelectedFoods);
  });

  window.openDietListModal = openDietListModal;
  window.closeDietListModal = closeDietListModal;
  window.openCustomModalFromList = openCustomModalFromList;
  window.receiveDietFromInsert = receiveDietFromInsert;
  window.setDietType = (type) => { 
    const safeType = type || '기타';
    dietListState.dietType = safeType;
    window.lastSelectedDietType = safeType;
  };
</script>
