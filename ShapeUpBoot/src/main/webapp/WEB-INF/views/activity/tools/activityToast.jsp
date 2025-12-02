<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
  .activity-toast-wrap {
    position: fixed;
    bottom: 24px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 2000;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    pointer-events: none;
  }
  .activity-toast {
    min-width: 200px;
    padding: 12px 16px;
    border-radius: 12px;
    background: rgba(17, 24, 39, 0.9);
    color: #fff;
    font-weight: 800;
    box-shadow: 0 12px 32px rgba(15, 23, 42, 0.35);
    opacity: 0;
    transform: translateY(10px);
    transition: opacity 0.2s ease, transform 0.2s ease;
  }
  .activity-toast.show {
    opacity: 1;
    transform: translateY(0);
  }
</style>
<div class="activity-toast-wrap" id="activity-toast-wrap"></div>
<script>
  let activityToastTimer = null;
  function showActivityToast(message) {
    const wrap = document.getElementById('activity-toast-wrap');
    if (!wrap) return;
    wrap.innerHTML = '';
    const toast = document.createElement('div');
    toast.className = 'activity-toast';
    toast.textContent = message || '';
    wrap.appendChild(toast);
    requestAnimationFrame(() => toast.classList.add('show'));
    clearTimeout(activityToastTimer);
    activityToastTimer = setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => { wrap.innerHTML = ''; }, 200);
    }, 1000);
  }
  window.showActivityToast = showActivityToast;
</script>
