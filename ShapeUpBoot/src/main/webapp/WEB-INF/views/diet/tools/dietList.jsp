<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="diet-list-backdrop" class="modal-backdrop" style="display:none;">
  <div class="modal-container diet-list-modal">
    <div class="modal-header">
      <div class="header-top">
        <h3>식단 목록</h3>
        <div class="header-actions">
        <button type="button" class="ghost-btn direct-input-btn" onclick="openCustomModalFromList()">직접 입력하기</button>
        <button type="button" class="close-btn" onclick="closeDietListModal()">✕</button>
      </div>
      </div>
      <form class="diet-search" id="diet-search-form">
        <input type="text" id="diet-search-input" placeholder="음식명을 입력하세요" />
        <button type="submit" class="primary-btn">검색</button>
      </form>
    </div>
    <div class="modal-body">
      <ul class="diet-list" id="diet-list-container">
        <li class="diet-item empty-message">음식을 검색해주세요</li>
      </ul>
    </div>
    <div class="modal-footer">
      <div class="selected-wrap">
        <div class="selected-name" id="selected-food-name">선택된 메뉴:</div>
        <div class="selected-list" id="selected-food-list"></div>
      </div>
      <div class="footer-actions">
        <button type="button" class="ghost-btn" onclick="closeDietListModal()">닫기</button>
        <button type="button" class="primary-btn footer-add-btn" id="diet-list-submit">추가하기</button>
      </div>
    </div>
  </div>
</div>

<script>
  /* 모달 열고 닫기 */
  function openDietListModal() {
    document.getElementById("diet-list-backdrop").style.display = "flex";
  }
  function closeDietListModal() {
    document.getElementById("diet-list-backdrop").style.display = "none";
  }
  function openInsertFromList() {
    closeDietListModal();
    if (typeof openModal === "function") openModal();
  }
  function openCustomModalFromList() {
    closeDietListModal();
    if (typeof openCustomModal === "function") openCustomModal();
  }

  /* 검색 */
  function searchFoodList() {
    const keyWord = document.getElementById("diet-search-input")?.value?.trim() || "";
    if (!keyWord) {
      renderFoodList([], "음식을 검색해주세요");
      return;
    }
    fetchFoodList(keyWord);
  }
  function handleEnterKey(event) {
    if (event.key === "Enter") {
      event.preventDefault();
      searchFoodList();
    }
  }

  /* 검색결과 렌더링 */
  const dietListEl = document.getElementById("diet-list-container");
  function renderFoodList(items = [], emptyMessage = "일치하는 음식이 없습니다") {
    if (!dietListEl) return;
    dietListEl.innerHTML = "";
    if (!items || items.length === 0) {
      const li = document.createElement("li");
      li.className = "diet-item empty-message";
      li.textContent = emptyMessage;
      dietListEl.appendChild(li);
      return;
    }
    items.forEach((food) => {
      const li = document.createElement("li");
      li.className = "diet-item";
      const name = document.createElement("span");
      name.className = "food-name";
      name.textContent = food.foodName || "이름 없음";

      const kcal = document.createElement("span");
      kcal.className = "food-kcal";
      kcal.textContent = ((food.kcal ?? 0) + "") + " kcal";

      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "add-btn";
      btn.textContent = "+";
      btn.addEventListener("click", () => addSelectedFood(food.foodName || ""));

      li.appendChild(name);
      li.appendChild(kcal);
      li.appendChild(btn);
      dietListEl.appendChild(li);
    });
  }

  // 검색 리스트 불러오기 (백엔드 호출 필요)
  async function fetchFoodList(query) {
    if (!query) {
      renderFoodList([], "음식을 검색해주세요");
      return;
    }
    const url = "/diet/list?q=" + encodeURIComponent(query || "");
    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error("검색 실패");
      const data = await res.json();
      renderFoodList(Array.isArray(data) ? data : [], "일치하는 음식이 없습니다");
    } catch (err) {
      console.error("음식 검색 실패", err);
      renderFoodList([], "일치하는 음식이 없습니다");
    }
  }

  /* 선택 음식 리스트 출력 */
  const selectedFoods = [];
  function renderSelectedList() {
    const listEl = document.getElementById("selected-food-list");
    if (!listEl) return;
    listEl.innerHTML = "";
    if (selectedFoods.length === 0) {
      const empty = document.createElement("span");
      empty.className = "selected-empty";
      empty.textContent = "선택 없음";
      listEl.appendChild(empty);
      return;
    }
    selectedFoods.forEach((name, idx) => {
      const chip = document.createElement("div");
      chip.className = "selected-chip";
      chip.textContent = name;
      const removeBtn = document.createElement("button");
      removeBtn.type = "button";
      removeBtn.className = "chip-remove";
      removeBtn.textContent = "✕";
      removeBtn.addEventListener("click", () => {
        selectedFoods.splice(idx, 1);
        renderSelectedList();
      });
      chip.appendChild(removeBtn);
      listEl.appendChild(chip);
    });
  }

  /* 리스트에 음식 추가 */
  function addSelectedFood(name) {
    if (!name) return;
    selectedFoods.push(name);
    renderSelectedList();
  }

  /* 리스트에 담은 음식 전송 */
  async function submitSelectedFoods() {
    closeDietListModal();
    const payload = { items: selectedFoods };
    try {
      await fetch('/diet/selected', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
    } catch (err) {
      console.error('선택된 메뉴 전송 실패', err);
    }
  }

  // 초기 상태: 안내 메시지
  renderFoodList([], "음식을 검색해주세요");

  document.addEventListener("DOMContentLoaded", () => {
    const searchForm = document.getElementById("diet-search-form");
    const searchInput = document.getElementById("diet-search-input");
    searchForm?.addEventListener("submit", (e) => {
      e.preventDefault();
      searchFoodList();
    });
    searchInput?.addEventListener("keydown", handleEnterKey);

    const submitBtn = document.getElementById('diet-list-submit');
    submitBtn?.addEventListener('click', submitSelectedFoods);
  });
</script>




