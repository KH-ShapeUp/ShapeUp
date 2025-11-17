<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- diet list modal -->
<div class="modal-backdrop" id="diet-list-backdrop" style="display: none;">
  <div class="food-modal diet-list-modal" role="dialog" aria-modal="true">
    <div class="stat-header">
      <p class="result-count">검색 결과 X개</p>
      <div class="selected-summary">
        <p>선택한 음식 X개</p>
        <p class="total-kcal">총 0Kcal</p>
        <div class="summary-actions">
          <button class="register-btn outline" onclick="openManualDietInput()">식단 직접 입력하기</button>
          <button class="register-btn">식단 등록하기</button>
        </div>
      </div>
    </div>

    <div class="integrated-list-container">
      <div class="search-results section">
        <div class="result-item">
          <div class="info">
            <p class="title">검색결과명</p>
            <p class="details">1조각 (1/8 지름 30CM) (99g)</p>
            <p class="nutrition">약 298 kcal | 탄수화물 34g 단백질 12g 지방 13g</p>
          </div>
          <button class="add-btn">+</button>
        </div>
        <div class="result-item">
          <div class="info">
            <p class="title">검색결과명</p>
            <p class="details">1조각 (1/8 지름 30CM) (99g)</p>
            <p class="nutrition">약 298 kcal | 탄수화물 34g 단백질 12g 지방 13g</p>
          </div>
          <button class="add-btn">+</button>
        </div>
        <div class="result-item">
          <div class="info">
            <p class="title">검색결과명</p>
            <p class="details">1조각 (1/8 지름 30CM) (99g)</p>
            <p class="nutrition">약 298 kcal | 탄수화물 34g 단백질 12g 지방 13g</p>
          </div>
          <button class="add-btn">+</button>
        </div>
        <div class="result-item">
          <div class="info">
            <p class="title">검색결과명</p>
            <p class="details">1조각 (1/8 지름 30CM) (99g)</p>
            <p class="nutrition">약 298 kcal | 탄수화물 34g 단백질 12g 지방 13g</p>
          </div>
          <button class="add-btn">+</button>
        </div>
        <div class="result-item">
          <div class="info">
            <p class="title">검색결과명</p>
            <p class="details">1조각 (1/8 지름 30CM) (99g)</p>
            <p class="nutrition">약 298 kcal | 탄수화물 34g 단백질 12g 지방 13g</p>
          </div>
          <button class="add-btn">+</button>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
  function openDietListModal() {
    const backdrop = document.getElementById('diet-list-backdrop');
    if (backdrop) {
      backdrop.style.display = 'flex';
      document.body.style.overflow = 'hidden';
    }
  }
  function closeDietListModal() {
    const backdrop = document.getElementById('diet-list-backdrop');
    if (backdrop) {
      backdrop.style.display = 'none';
      document.body.style.overflow = 'auto';
    }
  }
  // ESC 닫기
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeDietListModal();
    }
  });
  // 바깥 클릭 닫기
  document.addEventListener('click', (e) => {
    const backdrop = document.getElementById('diet-list-backdrop');
    if (backdrop && backdrop.style.display === 'flex' && e.target === backdrop) {
      closeDietListModal();
    }
  });
  // 직접 입력 버튼 클릭 시 placeholder
  function openManualDietInput() {
    closeDietListModal();
    openModal && openModal();
  }
  // 리스트 내 + 버튼 -> 등록 모달
  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('#diet-list-backdrop .add-btn').forEach((btn) => {
      btn.addEventListener('click', () => {
        closeDietListModal();
        openModal();
      });
    });
  });
</script>
