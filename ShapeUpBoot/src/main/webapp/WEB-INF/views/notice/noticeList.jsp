<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>공지사항</title>
    <link rel="stylesheet" href="/resources/css/notice/noticeList.css" />
    <style>
      /* CSS 파일이 분리되지 않은 경우 여기에 스타일을 포함할 수 있습니다. */
      /* 아래에 제공된 CSS 내용을 여기에 복사하여 붙여넣으셔도 됩니다. */
    </style>
  </head>
  <body>
    <header class="header-placeholder"></header>

    <div class="container">
      <div class="top-section">
        <h1 class="page-title">공지사항</h1>

        <div class="logo-area">
          <img src="path/to/your/logo.png" alt="ShapeUp 로고" />
        </div>
      </div>

      <form class="search-section">
        <input type="text" placeholder="검색어를 입력하세요" />        
        <button class="search-btn" type="submit">검색</button>      
      </form>

      <div class="category-section">
        <div class="left-content">
          <span class="total-count">총 10건</span>
          <div class="category-list">
            <a href="#" class="active">전체</a>
            <a href="#">공지</a>
            <a href="#">이벤트</a>
            <a href="#">제휴</a>
            <a href="#">징계</a>
          </div>
        </div>

        <button class="write-btn">글쓰기</button>
      </div>

      <div class="notice-table-wrapper">
        <table class="notice-table">
          <thead>
            <tr>
              <th>번호</th>
              <th>분류</th>
              <th class="title-col">제목</th>
              <th>날짜</th>
              <th>작성자</th>
              <th>조회</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>10</td>
              <td><span class="badge notice">공지</span></td>
              <td class="title-col">
                [서버점검] 2025년 11월 04일 서버 업데이트 안내
              </td>
              <td>2025.11.04</td>
              <td>관리자</td>
              <td>10</td>
            </tr>
            <tr>
              <td>9</td>
              <td><span class="badge notice">공지</span></td>
              <td class="title-col">개인정보처리방침 변경 안내</td>
              <td>2025.11.04</td>
              <td>관리자</td>
              <td>15</td>
            </tr>
            <tr>
              <td>8</td>
              <td><span class="badge notice">공지</span></td>
              <td class="title-col">
                서비스 이용 약관 변경 안내 (2025년 11월 15일 시행)
              </td>
              <td>2025.11.04</td>
              <td>관리자</td>
              <td>4</td>
            </tr>
            <tr>
              <td>7</td>
              <td><span class="badge campaign">제휴</span></td>
              <td class="title-col">나의 코치를 찾는 법 '운동습관' 출시!</td>
              <td>2025.11.04</td>
              <td>관리자</td>
              <td>15</td>
            </tr>
            <tr>
              <td>6</td>
              <td><span class="badge notice">공지</span></td>
              <td class="title-col">홈페이지 비밀번호 변경 안내</td>
              <td>2025.11.04</td>
              <td>관리자</td>
              <td>22</td>
            </tr>
            <tr>
              <td>5</td>
              <td><span class="badge notice">공지</span></td>
              <td class="title-col">
                홈페이지 서비스 중단 안내 (11.04(화) 00시~05시
              </td>
              <td>2025.11.03</td>
              <td>관리자</td>
              <td>0</td>
            </tr>
            <tr>
              <td>4</td>
              <td><span class="badge notice">공지</span></td>
              <td class="title-col">
                추석연휴기간 이용문의 운영안내(10.03-10.09)
              </td>
              <td>2025.10.04</td>
              <td>관리자</td>
              <td>0</td>
            </tr>
            <tr>
              <td>3</td>
              <td><span class="badge notice">공지</span></td>
              <td class="title-col">[안내] 대체공휴일 이용문의 안내(03.03)</td>
              <td>2025.03.01</td>
              <td>관리자</td>
              <td>3</td>
            </tr>
            <tr>
              <td>2</td>
              <td><span class="badge event">이벤트</span></td>
              <td class="title-col">2024 바디챌린지 결과 공지</td>
              <td>2024.12.24</td>
              <td>관리자</td>
              <td>5</td>
            </tr>
            <tr>
              <td>1</td>
              <td><span class="badge notice">공지</span></td>
              <td class="title-col">
                [서버점검] 2024년 12월 04일 서버 업데이트 안내
              </td>
              <td>2024.12.04</td>
              <td>관리자</td>
              <td>1</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="pagination">
        <a href="#">&lt;</a>
        <a href="#" class="current">1</a>
        <a href="#">2</a>
        <a href="#">3</a>
        <a href="#">4</a>
        <a href="#">5</a>
        <a href="#">6</a>
        <a href="#">7</a>
        <a href="#">8</a>
        <a href="#">9</a>
        <a href="#">10</a>
        <a href="#">&gt;</a>
      </div>
    </div>

    <footer class="footer-placeholder"></footer>
  </body>
</html>
