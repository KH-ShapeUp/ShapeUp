<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- <div class="modal-overlay" id="activityListModalOverlay" onclick="closeActivityModal()" ></div> -->

<div id="activity-list-backdrop" class="modal-backdrop" style="display:none;" >
  <div class="modal-container" id="activity-list-modal">
    <div class="modal-header">
      <div class="header-top">
        <h3>운동 목록</h3>
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
      <ul class="activity-list" id="activity-list-container">
        <li class="activity-item empty-message">운동을 검색해주세요</li>
      </ul>
    </div>
    <div class="modal-footer">
      <div class="selected-wrap">
        <div class="selected-name" id="selected-activity-name">선택된 운동:</div>
        <div class="selected-list" id="selected-activit-list"></div>
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

	//모달 
	function openActivityModal() {
		const backdrop = document.getElementById('activity-list-backdrop');
		const modal = document.getElementById('activity-list-modal');
		if (backdrop) {
			backdrop.style.display='flex';
		}
		if (modal) {
			modal.style.display='block';
		}
		document.body.style.overflow = 'hidden';
	}

  function closeListModal() {
    const backdrop = document.getElementById('activity-list-backdrop');
    if(!backdrop) return;
    backdrop.style.display = 'none';
    document.bodyy.style.overflow = 'auto';
  }

  function openCustomModalFromList(){
    closeListModal();
    if(typeof openCustomModal == 'function' ){
      openCustomModal();
    }
  } 

  // 
  function adaptActivity(raw){
    if(!raw) return null;
    return{
      name : raw.activityName || raw.name || '이름없음',
      kcal : Number(raw.kcalPerMin) || 0,       //추후 계산되도록 변경필요
      type : raw.activityType || raw.type || '분류없음',
      level : raw.weightLevel || raw.level || '일반',
    };
  }

  function renderActivityList(items = [], emptyMessage = '검색 결과가 없습니다'){
    const listEl = activityListState.listElement || document.getElementById('activity-list-container');
    if(!listEl) return;
    listEl.innerHTML = '';
    if(!items.length) {
      const li = document.createElement('li');
      li.className = 'activity-item empty-message';
      li.textContent = emptyMessage;
      listEl.appendChild(li);
      return;
    }
    
    items.forEach((item) => {
      const activity = adaptActivity(item);
      if(!activity) return;
      const li = document.createElement('li');
      li.className = 'activity-item';

      const nameSpan = document.createElement('span');
      nameSpan.className = 'activity-name';
      nameSpan.textContent = activity.name;
      
      const kcalSpan = document.createElement('span');
      kcalSpan.className = 'activity-kcal';
      kcalSpan.textContent = `${activity.kcal} kcal`;

      const addBtn = document.createElement('button');
      addBtn.type = 'buuton';
      addBtn.className = 'add-btn';
      addBtn.textContent = '+';
      addBtn.addEventListener('click', (event) => {
        event.preventDefault();
        startInsertFood({...activity});
      })

      li.appendChild(nameSpan);
      li.appendChild(kcalSpan);
      li.appendChild(addBtn);
      listEl.appendChild(li);
    })
  }


</script>
