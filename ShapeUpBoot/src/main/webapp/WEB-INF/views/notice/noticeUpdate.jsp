<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>공지사항 수정 | ShapeUp</title>
    <link href="../../../resources/img/fav/favicon.png" rel="shortcut icon" type="image/x-icon">
    <link rel="stylesheet" href="/resources/css/notice/noticeUpdate.css" />
  </head>
  <body>
    <header class="header-placeholder"></header>

    <div class="container">
      <div class="top-section">
        <h1 class="page-title">공지사항 수정</h1> 
        <div class="logo-area">
          <img src="path/to/your/logo.png" alt="ShapeUp 로고" />
        </div>
      </div>

      <div class="write-section">
        <div class="form-group title-group">
          <label for="noticeTitle">제목<span class="required">*</span></label>
          <input type="text" id="noticeTitle" value="[서버점검] 2025년 11월 04일 서버 업데이트 안내" />
          
          <label for="noticeCategory">분류</label>
          <select id="noticeCategory">
            <option value="notice" selected>공지사항</option>
            <option value="event">이벤트</option>
            <option value="campaign">캠페인</option>
            <option value="system">정기</option>
            <option value="affiliate">제휴</option>
          </select>
        </div>

        <div class="form-group file-group">
          <label>파일 첨부</label>
          <input type="text" class="file-path" readonly value="첨부파일_A.zip" />
          <input type="file" id="noticeFile" class="file-input" />
          <label for="noticeFile" class="file-select-btn">파일 선택</label>
        </div>
        
        <div class="form-group date-group hidden"> 
          <label>일정</label>
          <input type="date" class="start-date" value="2025-11-04" />
          <span class="date-separator">→</span>
          <input type="date" class="end-date" value="2025-11-04" />
        </div>

        <div class="form-group content-group">
          <label for="noticeContent">내용을 입력하세요</label>
          <textarea id="noticeContent">안녕하세요, ShapeUp 사용자 여러분.
더 나은 서비스 제공을 위해 2025년 11월 04일 (월) 오전 2시부터 오전 5시까지 서버 점검이 예정되어 있습니다.
이 시간 동안 ShapeUp 사이트의 일부 기능이 일시적으로 이용이 불가능할 수 있습니다.

점검 내용
• 서버 안정화 및 성능 개선
• 시스템 업데이트 및 버그 수정

점검이 완료된 후 더 빠르고 안정적인 서비스를 제공할 수 있도록 최선을 다하겠습니다.
점검 시간 동안 불편을 드려 죄송하며, 양해 부탁드립니다.
감사합니다.</textarea>
        </div>

        <div class="write-buttons">
          <button class="btn-secondary">초기화</button>
          <button class="btn-primary write-btn-submit update-btn">수정 완료</button>
        </div>
      </div>
    </div>

    <footer class="footer-placeholder"></footer>

    <script>
      document.addEventListener('DOMContentLoaded', function() {
        const noticeCategory = document.getElementById('noticeCategory');
        const dateGroup = document.querySelector('.date-group');

        // 함수 정의: 일정 필드 표시 여부 업데이트
        function updateDateGroupVisibility() {
          if (noticeCategory.value === 'event') {
            dateGroup.classList.remove('hidden');
          } else {
            dateGroup.classList.add('hidden');
          }
        }
        
        // 페이지 로드 시 및 분류 변경 시 함수 실행
        updateDateGroupVisibility();
        noticeCategory.addEventListener('change', updateDateGroupVisibility);
      });
    </script>
  </body>
</html>