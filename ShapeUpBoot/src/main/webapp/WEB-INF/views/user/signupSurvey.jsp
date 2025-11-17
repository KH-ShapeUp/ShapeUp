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

    <!-- 오른쪽 영역 -->
    <section class="right-panel">
      <h1 class="logo">Shape<span>Up</span></h1>

      <!-- 상단 탭 -->
      <div class="tab-menu">
        <button class="tab">회원가입</button>
      </div>

      <!-- 3단계 진행 바 -->
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

      <!-- 설문 박스 -->
      <div class="signup-box">
        <form action="/user/signup/survey" method="post">

          <!-- 질문 1: 어떤 운동에 관심있으신가요? -->
          <div class="question-group">
            <h3>어떤 운동에 관심있으신가요?</h3>
            <p class="question-sub">아래 보기 중 선택해주세요(다중선택 가능)</p>
            
            <!-- 구기종목 드롭다운 -->
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

            <!-- 기타 드롭다운 -->
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

          <!-- 질문 2: 어떤 시간대에 활동하세요? -->
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

          <!-- 질문 3: 어느 지역에서 활동하세요? -->
          <div class="question-group">
            <h3>어느 지역에서 활동하세요?</h3>
            <p class="question-sub">활동 지역을 검색하여 선택해주세요</p>
            
            <!-- 선택된 주소 태그 표시 영역 -->
            <div class="selected-addresses" id="selectedAddresses"></div>
            
            <div class="address-input-area">
              <input type="text" id="memberAddress" placeholder="주소를 입력하세요" onkeypress="handleAddressEnter(event)">
              <button type="button" class="addr-button" onclick="searchMyAddress()">주소찾기</button>
            </div>
            
            <input type="hidden" name="addresses" id="addressesValue" />
          </div>

          <!-- 버튼 영역 -->
          <div class="button-area">
            <button type="button" class="btn cancel">취소</button>
            <button type="button" class="btn next" onclick="submitForm()">다음</button>
          </div>

        </form>
      </div>
    </section>
  </main>

</body>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
// 선택된 주소 배열
let selectedAddresses = [];

// 엔터키로 주소 추가
function handleAddressEnter(event) {
    if (event.key === 'Enter') {
        event.preventDefault();
        addAddressManually();
    }
}

// 수동으로 주소 추가
function addAddressManually() {
    const input = document.getElementById('memberAddress');
    const address = input.value.trim();
    
    if (address === '') {
        alert('주소를 입력해주세요.');
        return;
    }
    
    // 중복 체크
    if (selectedAddresses.includes(address)) {
        alert('이미 선택된 주소입니다.');
        input.value = '';
        return;
    }
    
    // 주소 추가
    selectedAddresses.push(address);
    renderAddressTags();
    
    // 입력창 비우기
    input.value = '';
}

// 드롭다운 토글 기능
function toggleDropdown(id) {
  const dropdown = document.getElementById(id);
  const toggleBtn = event.currentTarget;
  
  // 현재 드롭다운 토글
  dropdown.classList.toggle('active');
  toggleBtn.classList.toggle('active');
}

// 태그 버튼 클릭 이벤트
document.addEventListener('click', function(e) {
  if (e.target.classList.contains('tag-btn')) {
    e.target.classList.toggle('active');
  }
});

// 주소 검색
function searchMyAddress(){
    new daum.Postcode({
        oncomplete: function(data) {
            // 전체 주소 생성
            let fullAddress = data.address;
            let extraAddress = '';
            
            // 도로명 주소인 경우
            if (data.addressType === 'R') {
                if (data.bname !== '') {
                    extraAddress += data.bname;
                }
                if (data.buildingName !== '') {
                    extraAddress += (extraAddress !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if (extraAddress !== '') {
                    fullAddress += ' (' + extraAddress + ')';
                }
            }
            
            // 중복 체크
            if (selectedAddresses.includes(fullAddress)) {
                alert('이미 선택된 주소입니다.');
                return;
            }
            
            // 주소 추가
            selectedAddresses.push(fullAddress);
            renderAddressTags();
        }
    }).open();
}

// 주소 태그 렌더링
function renderAddressTags() {
    const container = document.getElementById('selectedAddresses');
    
    if (!container) {
        console.error('selectedAddresses 컨테이너를 찾을 수 없습니다.');
        return;
    }
    
    container.innerHTML = '';
    
    selectedAddresses.forEach((address, index) => {
        const tag = document.createElement('div');
        tag.className = 'address-tag';
        
        const span = document.createElement('span');
        span.textContent = address;
        
        const button = document.createElement('button');
        button.type = 'button';
        button.className = 'remove-tag';
        button.textContent = '×';
        button.onclick = function() { removeAddress(index); };
        
        tag.appendChild(span);
        tag.appendChild(button);
        container.appendChild(tag);
    });
}

// 주소 삭제
function removeAddress(index) {
    selectedAddresses.splice(index, 1);
    renderAddressTags();
}

// 폼 제출
function submitForm() {
  // 선택된 운동 종류 수집
  const selectedExercises = Array.from(document.querySelectorAll('.tag-btn[data-group="exercise"].active'))
    .map(btn => btn.getAttribute('data-value'));
  document.getElementById('interestsValue').value = selectedExercises.join(',');

  // 선택된 시간대 수집
  const selectedTimes = Array.from(document.querySelectorAll('.tag-btn[data-group="time"].active'))
    .map(btn => btn.getAttribute('data-value'));
  document.getElementById('timesValue').value = selectedTimes.join(',');

  // 주소 수집
  document.getElementById('addressesValue').value = selectedAddresses.join('|');

  // 유효성 검사
  if (selectedExercises.length === 0) {
    alert('관심있는 운동을 하나 이상 선택해주세요.');
    return;
  }

  if (selectedTimes.length === 0) {
    alert('활동 시간대를 하나 이상 선택해주세요.');
    return;
  }

  if (selectedAddresses.length === 0) {
    alert('활동 지역을 하나 이상 선택해주세요.');
    return;
  }

  // 👉 여기만 변경됨
  window.location.href = "/user/signupSuccess";
}


// 취소 버튼
document.querySelector('.btn.cancel').addEventListener('click', function() {
  if (confirm('회원가입을 취소하시겠습니까?')) {
    window.location.href = '/';
  }
});
</script>

</html>