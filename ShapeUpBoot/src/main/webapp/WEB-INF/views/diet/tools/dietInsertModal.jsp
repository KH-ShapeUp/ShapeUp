<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- diet insert modal -->
<div class="modal-backdrop" id="modal-backdrop" style="display: none;">
  <div class="food-modal" role="dialog" aria-modal="true">
    <div class="modal-title-bar">
      <h3 class="food-name">식품명</h3>
      <span class="modal-center-info">자세히</span>
    </div>
    <p class="food-kcal">880kcal</p>

    <div class="nutrition-summary">
      <div class="nutrition-item">
        <img src="https://img.icons8.com/ios-filled/50/000000/rice-bowl--v1.png" alt="탄수화물 아이콘" />
        <span>탄수화물</span>
        <span class="nutrition-value">220g</span>
      </div>
      <div class="nutrition-item">
        <img src="https://img.icons8.com/ios-filled/50/000000/steak.png" alt="단백질 아이콘" />
        <span>단백질</span>
        <span class="nutrition-value">0g</span>
      </div>
      <div class="nutrition-item">
        <img src="https://img.icons8.com/ios-filled/50/000000/milk-bottle--v1.png" alt="지방 아이콘" />
        <span>지방</span>
        <span class="nutrition-value">미정 g</span>
      </div>
    </div>

    <div class="portion-input-section">
      <div class="portion-display">
        <span>1.5인분</span>
      </div>
      <div class="amount-display">
        <span>약 220g</span>
      </div>
    </div>

    <div class="quantity-control">
      <button class="quantity-btn minus">-</button>
      <span class="current-quantity">1.5</span>
      <button class="quantity-btn plus">+</button>
    </div>

    <div class="modal-actions">
      <button class="add-to-diet-btn">추가하기</button>
    </div>
  </div>
</div>
<script>
  // 모달 열기
  function openModal() {
    const backdrop = document.getElementById('modal-backdrop');
    backdrop.style.display = 'flex';
    document.body.style.overflow = 'hidden';
  }
  // 모달 닫기
  function closeModal() {
    const backdrop = document.getElementById('modal-backdrop');
    backdrop.style.display = 'none';
    document.body.style.overflow = 'auto';
  }
  // ESC 키로 모달 닫기
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeModal();
    }
  });
  // 모달 바깥 클릭 시 닫기
  document.addEventListener('click', (e) => {
    const backdrop = document.getElementById('modal-backdrop');
    if (backdrop.style.display === 'flex' && e.target === backdrop) {
      closeModal();
    }
  });
</script>

