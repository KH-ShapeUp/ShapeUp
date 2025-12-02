<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
  .activity-delete-modal {
    max-width: 420px;
    width: 90%;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 16px 40px rgba(15, 23, 42, 0.2);
    padding: 18px;
    display: flex;
    flex-direction: column;
    gap: 12px;
  }
  .activity-delete-modal .title { font-size: 18px; font-weight: 800; }
  .activity-delete-modal .desc { color: #6b7280; font-weight: 700; }
  .activity-delete-modal .actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 6px; }
  .activity-delete-modal .ghost { border: 1px solid #d1d5db; background: #fff; border-radius: 12px; padding: 10px 14px; cursor: pointer; }
  .activity-delete-modal .primary { border: none; background: linear-gradient(135deg, #f87171, #ef4444); color: #fff; border-radius: 12px; padding: 10px 14px; font-weight: 800; cursor: pointer; }
</style>
<div id="activity-delete-backdrop" class="modal-backdrop" style="display:none;">
  <div class="activity-delete-modal" role="dialog" aria-modal="true">
    <div class="title">운동 기록 삭제</div>
    <div class="desc">해당 운동 기록을 삭제하시겠습니까?</div>
    <div class="actions">
      <button type="button" class="ghost" onclick="closeActivityDeleteModal()">취소</button>
      <button type="button" class="primary" onclick="confirmActivityDelete()">삭제</button>
    </div>
  </div>
</div>
<script>
  let pendingDeleteLogId = null;
  function openActivityDeleteModal(logId) {
    pendingDeleteLogId = logId;
    const backdrop = document.getElementById('activity-delete-backdrop');
    if (backdrop) {
      backdrop.style.display = 'flex';
      document.body.style.overflow = 'hidden';
    }
  }
  function closeActivityDeleteModal() {
    pendingDeleteLogId = null;
    const backdrop = document.getElementById('activity-delete-backdrop');
    if (backdrop) {
      backdrop.style.display = 'none';
      document.body.style.overflow = 'auto';
    }
  }
  async function confirmActivityDelete() {
    if (!pendingDeleteLogId) {
      closeActivityDeleteModal();
      return;
    }
    await deleteLog(pendingDeleteLogId);
    closeActivityDeleteModal();
  }
</script>
