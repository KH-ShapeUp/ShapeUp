<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- custom diet insert modal -->
<div class="modal-backdrop" id="custom-backdrop" style="display: none;">
  <div class="food-modal custom-insert-modal" role="dialog" aria-modal="true">
    <div class="modal-title-bar">
      <h3 class="food-name" id="customFoodTitle">직접 입력</h3>
      <button type="button" class="close-btn" onclick="closeCustomModal()">✕</button>
    </div>
    <p class="food-kcal" id="customKcal">0 kcal</p>

    <form class="custom-form" onsubmit="return false;">
      <div class="form-row">
        <label for="customName">음식 이름</label>
        <input type="text" id="customName" placeholder="예: 닭가슴살" />
      </div>
      <div class="macro-grid">
        <div class="form-row">
          <div class="label-with-icon">
            <img src="https://img.icons8.com/ios-filled/50/000000/rice-bowl--v1.png" alt="탄수화물 아이콘" />
            <label for="customCarb">탄수화물(g)</label>
          </div>
        <input type="number" id="customCarb" step="any" inputmode="decimal" min="0" value="" placeholder="0" />
        </div>
        <div class="form-row">
          <div class="label-with-icon">
            <img src="https://img.icons8.com/ios-filled/50/000000/steak.png" alt="단백질 아이콘" />
            <label for="customProtein">단백질(g)</label>
          </div>
          <input type="number" id="customProtein" step="any" inputmode="decimal" min="0" value="" placeholder="0" />
        </div>
        <div class="form-row">
          <div class="label-with-icon">
            <img src="https://img.icons8.com/ios-filled/50/000000/milk-bottle--v1.png" alt="지방 아이콘" />
            <label for="customFat">지방(g)</label>
          </div>
          <input type="number" id="customFat" step="any" inputmode="decimal" min="0" value="" placeholder="0" />
        </div>
      </div>
    </form>

    <div class="modal-actions">
      <button class="ghost-btn" type="button" onclick="closeCustomModal()">닫기</button>
      <button class="add-to-diet-btn" type="button">추가하기</button>
    </div>
  </div>
</div>
<script>
  function updateCustomValues() {
    const carb = parseFloat(document.getElementById('customCarb').value) || 0;
    const protein = parseFloat(document.getElementById('customProtein').value) || 0;
    const fat = parseFloat(document.getElementById('customFat').value) || 0;
    const kcal = carb * 4 + protein * 4 + fat * 9;
    document.getElementById('customKcal').textContent = kcal.toFixed(1).replace(/\.0$/, '') + ' kcal';
  }

  function sanitizeAndUpdate(target) {
    if (target.value === '0') target.value = '';
    if (target.value.startsWith('0') && target.value.length > 1 && !target.value.startsWith('0.')) {
      target.value = target.value.replace(/^0+/, '');
    }
    updateCustomValues();
  }

  function openCustomModal() {
    const backdrop = document.getElementById('custom-backdrop');
    if (backdrop) {
      backdrop.style.display = 'flex';
      document.body.style.overflow = 'hidden';
      updateCustomValues();
    }
  }

  function closeCustomModal() {
    const backdrop = document.getElementById('custom-backdrop');
    if (backdrop) {
      backdrop.style.display = 'none';
      document.body.style.overflow = 'auto';
    }
  }

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeCustomModal();
    }
  });

  document.addEventListener('click', (e) => {
    const backdrop = document.getElementById('custom-backdrop');
    if (backdrop && backdrop.style.display === 'flex' && e.target === backdrop) {
      closeCustomModal();
    }
  });

  document.addEventListener('DOMContentLoaded', () => {
    ['customCarb', 'customProtein', 'customFat'].forEach((id) => {
      const el = document.getElementById(id);
      if (el) {
        el.addEventListener('focus', () => {
          if (el.value === '0') el.value = '';
        });
        el.addEventListener('input', (e) => sanitizeAndUpdate(e.target));
      }
    });

    const addBtn = document.querySelector('.custom-insert-modal .add-to-diet-btn');
    if (addBtn) {
      addBtn.addEventListener('click', () => {
        const name = (document.getElementById('customName')?.value || '').trim() || '직접 입력';
        const carb = parseFloat(document.getElementById('customCarb').value) || 0;
        const protein = parseFloat(document.getElementById('customProtein').value) || 0;
        const fat = parseFloat(document.getElementById('customFat').value) || 0;
        const kcal = Number((carb * 4 + protein * 4 + fat * 9).toFixed(1));
        const foodPayload = { name, carb, protein, fat, kcal, servingSize: 100 };
        if (typeof addSelectedFood === 'function') {
          addSelectedFood(foodPayload, { fromInsert: true });
        }
        closeCustomModal();
        if (typeof openDietListModal === 'function') {
          openDietListModal();
        }
      });
    }
  });
</script>
