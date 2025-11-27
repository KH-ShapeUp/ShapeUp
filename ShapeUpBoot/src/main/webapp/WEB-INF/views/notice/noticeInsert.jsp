<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>공지사항 작성</title>

    <link rel="stylesheet" href="/resources/css/notice/noticeInsert.css" />
  </head>
  <body>
    <header class="header-placeholder"></header>

    <div class="container">
      <div class="top-section">
        <h1 class="page-title">공지사항 작성</h1>
        <div class="logo-area">
          <img src="" alt="ShapeUp 로고" />
        </div>
      </div>

      <div class="write-section">
        <form action="insert" method="POST" enctype="multipart/form-data">
          <div class="form-group title-group">
            <label for="noticeTitle">제목<span class="required">*</span></label>
            <input
              type="text"
              id="noticeTitle"
              name="noticeTitle"
              placeholder="제목을 입력하세요"
              required
            />

            <div
              class="form-group event-period-group"
              id="eventPeriodGroup"
              style="display: none"
            >
              <label for="evStartAt">시작일</label>
              <input type="date" id="eventStart" name="eventStart" />

              <label for="evEndDate">마감일</label>
              <input type="date" id="eventEnd" name="eventEnd" />
            </div>

            <div
              class="form-group notice-list-group"
              id="noticeListGroup"
              style="display: none"
            >
            </div>

            <label for="noticeCategory">분류</label>
            <select id="noticeCategory" name="noticeCategory">
              <option value="공지">공지사항</option>
              <option value="이벤트">이벤트</option>
              <option value="징계">징계</option>
              <option value="제휴">제휴</option>
            </select>
          </div>

          <div class="form-group file-group">
            <label>파일 첨부</label>
            <input type="text" class="file-path" readonly value="파일 선택" />
            <input
              type="file"
              id="noticeFile"
              name="uploadFile"
              class="file-input"
            />
            <label for="noticeFile" class="file-select-btn">파일 선택</label>
          </div>

          <div class="form-group content-group">
            <label for="noticeContent">내용을 입력하세요</label>
            <textarea
              id="noticeContent"
              name="noticeContent"
              placeholder="내용을 입력하세요"
            ></textarea>
          </div>

          <div class="write-buttons">
            <button type="reset" class="btn-secondary">초기화</button>
            <button type="submit" class="btn-primary write-btn-submit">
              글쓰기
            </button>
          </div>
        </form>
      </div>
    </div>

    <footer class="footer-placeholder"></footer>
    <script>
      document
        .getElementById("noticeFile")
        .addEventListener("change", function () {
          // 파일을 선택한 input 요소를 가져옴
          const fileInput = this;
          // 파일명을 표시할 input[type="text"] 요소를 가져옴
          const filePathInput = document.querySelector(".file-path");

          if (fileInput.files.length > 0) {
            // 선택된 파일이 있을 경우, 첫 번째 파일의 이름(name)을 표시
            filePathInput.value = fileInput.files[0].name;
          } else {
            // 선택된 파일이 없거나 취소된 경우 기본 텍스트 표시
            filePathInput.value = "파일 선택";
          }
        });

      // -----------------------------------------------------------
      // 2. 💡 [추가] 분류에 따른 이벤트 기간/목록 표시 기능
      const categorySelect = document.getElementById("noticeCategory");
      const periodGroup = document.getElementById("eventPeriodGroup");
      const startAtInput = document.getElementById("eventStart");
      const endDateInput = document.getElementById("eventEnd");
      const listGroup = document.getElementById("noticeListGroup");
      const listContainer = document.getElementById("noticeListContainer");

      // AJAX를 이용해 공지사항 목록을 불러와 표시하는 함수
      function loadNoticeList() {

        fetch("ajaxList?page=1") // Controller의 @GetMapping("/ajaxList") 호출
          .then((response) => {
            if (!response.ok) {
              throw new Error("HTTP status " + response.status);
            }
            return response.json();
          })
          .catch((error) => {
            console.error("공지사항 목록 불러오기 실패:", error);
          });
      }

      // 분류 변경 이벤트 리스너
      categorySelect.addEventListener("change", function () {
        const selectedValue = this.value;

        // 모든 그룹 초기화
        periodGroup.style.display = "none";
        listGroup.style.display = "none";
        startAtInput.removeAttribute("required");
        endDateInput.removeAttribute("required");
        startAtInput.value = "";
        endDateInput.value = "";

        if (selectedValue === "이벤트") {
          // 이벤트 선택 시: 이벤트 기간 표시
          periodGroup.style.display = "flex";
          startAtInput.setAttribute("required", "required");
          endDateInput.setAttribute("required", "required");
        } else if (selectedValue === "공지") {
          // 공지사항 선택 시: 목록 표시 및 데이터 로드
          listGroup.style.display = "block";
          loadNoticeList(); // AJAX 호출
        }
      });
    </script>
  </body>
</html>
