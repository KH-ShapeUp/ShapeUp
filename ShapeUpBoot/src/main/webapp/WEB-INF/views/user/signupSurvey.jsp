<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>추가 정보 입력 | ShapeUp</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/signupSurvey.css">
</head>
<body>

  <main class="signup-container">

    <section class="right-panel">
      <div class="logo">
        <img src="<%=request.getContextPath()%>/resources/img/main_logo.png" alt="" width="180px">
      </div>

      <div class="tab-menu">
        <h3>회원가입</h3>
      </div>

      <div class="step-bar">
        <div class="step completed">
          <div class="circle">1</div>
          <p>약관 동의</p>
        </div>
        <div class="line"></div>
        <div class="step active">
          <div class="circle">2</div>
          <p>정보 입력</p>
        </div>
        <div class="line"></div>
        <div class="step">
          <div class="circle">3</div>
          <p>가입 완료</p>
        </div>
      </div>

      <div class="signup-box">
        <!-- action 경로 수정 및 id 추가 -->
        <form id="surveyForm" action="<%=request.getContextPath()%>/user/signupSurvey" method="post">

          <!-- 질문 1: 운동 관심사 -->
          <div class="question-group">
            <h3>어떤 운동에 관심있으신가요?</h3>
            <p class="question-sub">아래 보기 중 선택해주세요(다중선택 가능)</p>

            <div class="dropdown-section">
              <button type="button" class="dropdown-toggle" onclick="toggleDropdown('ballSports')">
                <span>구기종목</span>
                <span class="arrow">▼</span>
              </button>
              <div class="dropdown-content" id="ballSports">
                <div class="tag-grid">
                  <button type="button" class="tag-btn" data-group="exercise" data-value="축구">축구</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="풋살">풋살</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="농구">농구</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="배구">배구</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="배드민턴">배드민턴</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="테니스">테니스</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="탁구">탁구</button>
                </div>
              </div>
            </div>

            <div class="dropdown-section">
              <button type="button" class="dropdown-toggle" onclick="toggleDropdown('others')">
                <span>기타</span>
                <span class="arrow">▼</span>
              </button>
              <div class="dropdown-content" id="others">
                <div class="tag-grid">
                  <button type="button" class="tag-btn" data-group="exercise" data-value="헬스">헬스</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="등산">등산</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="클라이밍">클라이밍</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="수영">수영</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="스키">스키</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="격투기/복싱">격투기/복싱</button>
                  <button type="button" class="tag-btn" data-group="exercise" data-value="러닝">러닝</button>
                </div>
              </div>
            </div>

            <input type="hidden" name="interests" id="interestsValue" />
          </div>

          <!-- 질문 2: 활동 시간대 -->
          <div class="question-group">
            <h3>어떤 시간대에 활동하세요?</h3>
            <p class="question-sub">아래 보기 중 선택해주세요(다중선택 가능)</p>
            <div class="tag-grid time-grid">
              <button type="button" class="tag-btn" data-group="time" data-value="평일">평일</button>
              <button type="button" class="tag-btn" data-group="time" data-value="주말">주말</button>
            </div>
            <div class="tag-grid time-grid">
              <button type="button" class="tag-btn" data-group="time" data-value="아침">아침</button>
              <button type="button" class="tag-btn" data-group="time" data-value="점심">점심</button>
              <button type="button" class="tag-btn" data-group="time" data-value="저녁">저녁</button>
              <button type="button" class="tag-btn" data-group="time" data-value="새벽">새벽</button>
            </div>
            <input type="hidden" name="times" id="timesValue" />
          </div>

          <!-- 질문 3: 지역 선택 -->
          <div class="question-group">
            <h3>어느 지역에서 활동하세요?</h3>
            <p class="question-sub">활동 지역을 선택해주세요</p>
            <div class="dropdown-section">
              <select id="memberAddressDropdown" class="dropdown-toggle">
                <option value="">모든 지역</option>
                <option value="서울">서울</option>
                <option value="경기">경기</option>
                <option value="인천">인천</option>
                <option value="강원">강원</option>
                <option value="대전/세종">대전/세종</option>
                <option value="충남">충남</option>
                <option value="충북">충북</option>
                <option value="대구">대구</option>
                <option value="경북">경북</option>
                <option value="부산">부산</option>
                <option value="울산">울산</option>
                <option value="경남">경남</option>
                <option value="광주">광주</option>
                <option value="전남">전남</option>
                <option value="전북">전북</option>
                <option value="제주">제주</option>
              </select>
            </div>
            <input type="hidden" name="addresses" id="addressesValue" />
          </div>

          <!-- 버튼 영역 -->
          <div class="button-area">
            <button type="button" class="btn cancel">취소</button>
            <!-- type="button"으로 유지하고 onclick으로 제출 -->
            <button type="button" class="btn next" onclick="submitForm()">다음</button>
          </div>

        </form>
      </div>
    </section>
  </main>

</body>

<script>
const contextPath = '<%=request.getContextPath()%>';

// 태그 버튼 선택 토글
document.addEventListener('click', function(e) {
  if (e.target.classList.contains('tag-btn')) {
    e.target.classList.toggle('active');
  }
});

// 드롭다운 토글
function toggleDropdown(id) {
  const dropdown = document.getElementById(id);
  const toggleBtn = event.currentTarget;
  dropdown.classList.toggle('active');
  toggleBtn.classList.toggle('active');
}

// 폼 제출 - 실제 form.submit() 호출하도록 수정
function submitForm() {
  // 선택된 운동 종목 수집
  const selectedExercises = Array.from(document.querySelectorAll('.tag-btn[data-group="exercise"].active'))
    .map(btn => btn.getAttribute('data-value'));
  document.getElementById('interestsValue').value = selectedExercises.join(',');

  // 선택된 시간대 수집
  const selectedTimes = Array.from(document.querySelectorAll('.tag-btn[data-group="time"].active'))
    .map(btn => btn.getAttribute('data-value'));
  document.getElementById('timesValue').value = selectedTimes.join(',');

  // 선택된 지역 수집
  const selectedAddress = document.getElementById('memberAddressDropdown').value;
  document.getElementById('addressesValue').value = selectedAddress;

  // 유효성 검사
  if (selectedExercises.length === 0) {
    alert('관심있는 운동을 하나 이상 선택해주세요.');
    return;
  }
  if (selectedTimes.length === 0) {
    alert('활동 시간대를 하나 이상 선택해주세요.');
    return;
  }
  if (!selectedAddress) {
    alert('활동 지역을 선택해주세요.');
    return;
  }

  // ✅ 실제 form 제출 (POST 요청)
  console.log('설문 제출:', {
    interests: selectedExercises.join(','),
    times: selectedTimes.join(','),
    addresses: selectedAddress
  });
  
  document.getElementById('surveyForm').submit();
}

// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
  if (confirm('회원가입을 취소하시겠습니까?')) {
    window.location.href = contextPath + '/';
  }
});
</script>

</html>