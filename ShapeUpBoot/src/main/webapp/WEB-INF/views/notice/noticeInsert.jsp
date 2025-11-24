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

            <label for="noticeCategory">분류</label>
            <select id="noticeCategory" name="category">
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
    </script>
  </body>
</html>
