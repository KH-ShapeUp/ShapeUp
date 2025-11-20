<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="modal-backdrop" id="modal-backdrop" style="display:none;">
  <div class="food-modal diet-insert-modal" role="dialog" aria-modal="true">
    <div class="modal-title-bar">
      <h3 class="food-name" id="foodName">선택된 음식 없음</h3>
      <span class="modal-center-info">영양 정보</span>
    </div>
    <p class="food-kcal" id="foodKcal">0 kcal</p>

    <div class="nutrition-summary insert-grid">
      <div class="nutrition-item">
        <img src="https://img.icons8.com/ios-filled/50/000000/rice-bowl--v1.png" alt="탄수화물" />
        <span>탄수화물</span>
        <span class="nutrition-value" id="carbVal">0 g</span>
      </div>
      <div class="nutrition-item">
        <img src="https://img.icons8.com/ios-filled/50/000000/steak.png" alt="단백질" />
        <span>단백질</span>
        <span class="nutrition-value" id="proteinVal">0 g</span>
      </div>
      <div class="nutrition-item">
        <img src="https://img.icons8.com/ios-filled/50/000000/milk-bottle--v1.png" alt="지방" />
        <span>지방</span>
        <span class="nutrition-value" id="fatVal">0 g</span>
      </div>
    </div>

    <div class="pill-display-row">
      <div class="pill-display" id="portionDisplay">1.0회</div>
      <div class="pill-display" id="amountDisplay">100 g</div>
    </div>

    <div class="quantity-control insert-control">
      <button class="quantity-btn minus" type="button">-</button>
      <span class="current-quantity" id="currentQty">1.0</span>
      <button class="quantity-btn plus" type="button">+</button>
    </div>

    <div class="modal-actions">
      <button class="add-to-diet-btn" type="button">추가하기</button>
    </div>
  </div>
</div>
<script>
  const modalState = {
    servingSize: 100,
    carb: 0,
    protein: 0,
    fat: 0,
    kcal: 0,
    name: '선택된 음식 없음',
  };
  const step = 0.5;
  let currentQuantity = 1.0;

  function formatNumber(val, digits = 1) {
    return Number(val.toFixed(digits));
  }

  function updateModalValues() {
    const weight = modalState.servingSize * currentQuantity;
    const carbs = modalState.carb * currentQuantity;
    const protein = modalState.protein * currentQuantity;
    const fat = modalState.fat * currentQuantity;
    const kcal = modalState.kcal > 0
      ? modalState.kcal * currentQuantity
      : carbs * 4 + protein * 4 + fat * 9;

    document.getElementById('foodName').textContent = modalState.name || '선택된 음식 없음';
    document.getElementById('foodKcal').textContent = `\${formatNumber(kcal)} kcal`;
    document.getElementById('currentQty').textContent = formatNumber(currentQuantity);
    document.getElementById('portionDisplay').textContent = `\${formatNumber(currentQuantity)}회`;
    document.getElementById('amountDisplay').textContent = `\${formatNumber(weight)} g`;
    document.getElementById('carbVal').textContent = `\${formatNumber(carbs)} g`;
    document.getElementById('proteinVal').textContent = `\${formatNumber(protein)} g`;
    document.getElementById('fatVal').textContent = `\${formatNumber(fat)} g`;
  }

  function openModal() {
    const backdrop = document.getElementById('modal-backdrop');
    if (!backdrop) return;
    backdrop.style.display = 'flex';
    document.body.style.overflow = 'hidden';
    updateModalValues();
  }

  function closeModal() {
    const backdrop = document.getElementById('modal-backdrop');
    if (!backdrop) return;
    backdrop.style.display = 'none';
    document.body.style.overflow = 'auto';
  }

  function setDietModalData(food) {
    if (!food) return;
    modalState.name = food.name || '선택된 음식';
    modalState.servingSize = Number(food.servingSize || food.weight || 100);
    modalState.carb = Number(food.carb) || 0;
    modalState.protein = Number(food.protein) || 0;
    modalState.fat = Number(food.fat) || 0;
    modalState.kcal = Number(food.kcal) || 0;
    currentQuantity = 1.0;
    openModal();
  }

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeModal();
  });

  document.addEventListener('click', (e) => {
    const backdrop = document.getElementById('modal-backdrop');
    if (backdrop && backdrop.style.display === 'flex' && e.target === backdrop) {
      closeModal();
    }
  });

  document.addEventListener('DOMContentLoaded', () => {
    const minusBtn = document.querySelector('.quantity-btn.minus');
    const plusBtn = document.querySelector('.quantity-btn.plus');
    const addBtn = document.querySelector('.add-to-diet-btn');

    minusBtn?.addEventListener('click', () => {
      currentQuantity = Math.max(step, currentQuantity - step);
      updateModalValues();
    });

    plusBtn?.addEventListener('click', () => {
      currentQuantity += step;
      updateModalValues();
    });

    addBtn?.addEventListener('click', () => {
      closeModal();
    });
  });

  window.openModal = openModal;
  window.closeModal = closeModal;
  window.setDietModalData = setDietModalData;
</script>






