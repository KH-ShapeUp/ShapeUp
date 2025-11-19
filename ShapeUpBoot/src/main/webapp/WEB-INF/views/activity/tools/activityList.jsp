<div id="activity-list-backdrop" class="modal-backdrop" style="display:none;">
  <div class="modal-container diet-list-modal">
    <div class="modal-header">
      <div class="header-top">
        <h3>활동 목록</h3>
        <div class="header-actions">
        <button type="button" class="ghost-btn direct-input-btn" onclick="openCustomModalFromList()">직접 입력하기</button>
        <button type="button" class="close-btn" onclick="closeActivityListModal()">✕</button>
      </div>
      </div>
      <form class="activity-search" id="activity-search-form">
        <input type="text" id="activity-search-input" placeholder="활동명을 입력하세요" />
        <button type="submit" class="primary-btn">검색</button>
      </form>
    </div>
    <div class="modal-body">
      <ul class="activity-list" id="activity-list-container">
        <li class="activity-item empty-message">활동을 검색해주세요</li>
      </ul>
    </div>
    <div class="modal-footer">
      <div class="selected-wrap">
        <div class="selected-name" id="selected-food-name">선택된 메뉴:</div>
        <div class="selected-list" id="selected-food-list"></div>
      </div>
      <div class="footer-actions">
        <button type="button" class="ghost-btn" onclick="closeActivityListModal()">닫기</button>
        <button type="button" class="primary-btn footer-add-btn" id="activity-list-submit">추가하기</button>
      </div>
    </div>
  </div>
</div>