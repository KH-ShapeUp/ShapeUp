<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>신고된 게시글 미리보기</title>
    <style>
      body {
        font-family: "Noto Sans KR", sans-serif;
        background: #f7f8fb;
        margin: 40px;
        color: #1f2430;
      }
      .post-wrapper {
        max-width: 760px;
        margin: 0 auto;
        background: #fff;
        padding: 32px;
        border-radius: 18px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
      }
      .post-meta {
        font-size: 0.9rem;
        color: #778;
        margin-bottom: 18px;
      }
      h1 {
        font-size: 1.8rem;
        margin-bottom: 16px;
      }
      p {
        line-height: 1.6;
        margin-bottom: 16px;
      }
      .flag {
        display: inline-flex;
        padding: 4px 10px;
        border-radius: 999px;
        background: #ffecec;
        color: #c62828;
        font-size: 0.85rem;
        margin-bottom: 18px;
      }
    </style>
  </head>
  <body>
    <div class="post-wrapper">
      <div class="flag">신고된 게시글 (더미)</div>
      <div class="post-meta">작성자: user02 · 2025-12-12</div>
      <h1>운동 루틴, 이건 좀...</h1>
      <p>
        운동 효과를 과장하거나 과격한 표현을 사용한 게시글의 예시입니다. 커뮤니티
        정책에 따라 허위 정보 및 타인을 불편하게 하는 표현은 제재 대상이 될 수 있습니다.
      </p>
      <p>
        본 페이지는 관리자 검토용 더미 JSP이며, 실제 서비스 데이터와는 무관합니다.
        신고 검토 페이지에서 링크 버튼을 눌러 열람하면, 실서비스와 유사한 흐름을 확인할 수 있습니다.
      </p>
    </div>
  </body>
</html>
