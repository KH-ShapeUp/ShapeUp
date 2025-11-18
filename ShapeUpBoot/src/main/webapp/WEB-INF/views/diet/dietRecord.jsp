<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>오늘의 식단</title>
    <link rel="stylesheet" href="../../../resources/css/diet/dietRecord.css" />
    <link rel="stylesheet" href="../../../resources/css/diet/insertDietRecord.css" />
    <link rel="stylesheet" href="../../../resources/css/diet/modal.css" />
    <link
      href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap"
      rel="stylesheet"
    />
    <jsp:include page="/WEB-INF/views/include/head.jsp"/>
  </head>
  <body class="diet-record">
    <jsp:include page="/WEB-INF/views/include/header.jsp"/>
    <main>
      <h2>오늘의 식단</h2>
      <div class="content">
        <div class="left-box-wrapper">
          <div class="meal-summary">
            <img src="https://img.icons8.com/ios-filled/50/000000/thumb-up.png" alt="like" />
            <span>오늘의 식단 요약</span>
          </div>
          <div class="left-box">
            <div class="calorie-box">
              <div class="date-list">
                <div class="date-item">2025.11.10</div>
                <div class="date-item active">2025.11.11</div>
                <div class="date-item">2025.11.12</div>
              </div>
              <div class="calorie-display">
                <div class="circle-ratio">
                  <span>섭취량 비율</span>
                </div>
                <div class="calorie-value">
                  <span class="value">0 Kcal</span>
                  <span class="label">섭취한 칼로리</span>
                </div>
              </div>
              <div class="nutrition-grid">
                <div class="nutrition-item">
                  <div class="icon-text">
                    <img src="https://img.icons8.com/ios-filled/50/000000/rice-bowl--v1.png" alt="carbohydrate-icon" />
                    <span class="nutrient">탄수화물</span>
                  </div>
                  <span class="amount">0 / 220g</span>
                </div>
                <div class="nutrition-item">
                  <div class="icon-text">
                    <img src="https://img.icons8.com/ios-filled/50/000000/steak.png" alt="protein-icon" />
                    <span class="nutrient">단백질</span>
                  </div>
                  <span class="amount">0 / 80g</span>
                </div>
                <div class="nutrition-item">
                  <div class="icon-text">
                    <img src="https://img.icons8.com/ios-filled/50/000000/milk-bottle--v1.png" alt="fat-icon" />
                    <span class="nutrient">지방</span>
                  </div>
                  <span class="amount">준비중 g</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="right-box">
          <div class="meal-time">
            <div class="meal-label">아침</div>
            <div class="meal-info">
              <span class="add-button">식단 추가</span>
              <span class="kcal-value">0 Kcal</span>
            </div>
          </div>
          <div class="meal-time">
            <div class="meal-label">점심</div>
            <div class="meal-info">
              <span class="add-button">식단 추가</span>
              <span class="kcal-value">0 Kcal</span>
            </div>
          </div>
          <div class="meal-time">
            <div class="meal-label">저녁</div>
            <div class="meal-info">
              <span class="add-button">식단 추가</span>
              <span class="kcal-value">0 Kcal</span>
            </div>
          </div>
          <div class="meal-time">
            <div class="meal-label">간식</div>
            <div class="meal-info">
              <span class="add-button">식단 추가</span>
              <span class="kcal-value">0 Kcal</span>
            </div>
          </div>
        </div>
      </div>
    </main>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/dietInsertModal.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/customInsertModal.jsp"/>
    <jsp:include page="/WEB-INF/views/diet/tools/dietList.jsp"/>
  </body>
  <script>
  document.addEventListener('DOMContentLoaded', () => {
    const dietListBackdrop = document.getElementById('diet-list-backdrop');
    const dietInsertBackdrop = document.getElementById('modal-backdrop');
    const customInsertBackdrop = document.getElementById('custom-backdrop');
    if (dietListBackdrop) dietListBackdrop.style.display = 'none';
    if (dietInsertBackdrop) dietInsertBackdrop.style.display = 'none';
    if (customInsertBackdrop) customInsertBackdrop.style.display = 'none';

    document.querySelectorAll('.add-button').forEach((button) => {
      button.addEventListener('click', (event) => {
        event.preventDefault();
        if (typeof openDietListModal === 'function') {
          openDietListModal();
        }
      });
    });

    document.querySelectorAll('#diet-list-backdrop .add-btn').forEach((btn) => {
      btn.addEventListener('click', (event) => {
        event.preventDefault();
        if (typeof closeDietListModal === 'function') {
          closeDietListModal();
        }
        if (typeof openModal === 'function') {
          openModal();
        }
      });
    });
  });
  </script>
</html>
