// 목표 설정 페이지 JavaScript

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    console.log('페이지 로드 완료, 초기화 시작'); // 디버깅용
    loadCurrentGoals();
    initializeForm();
});

// 현재 목표 불러오기
function loadCurrentGoals() {
    const contextPath = window.contextPath || '';
    fetch(`${contextPath}/user/getGoals`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('목표를 불러오는데 실패했습니다.');
        }
        // 응답이 비어있는지 확인
        return response.text().then(text => {
            return text ? JSON.parse(text) : null;
        });
    })
    .then(data => {
        if (data && data.goalWeight) {
            displayCurrentGoals(data);
            fillFormWithCurrentGoals(data);
        } else {
            console.log('저장된 목표가 없습니다.');
        }
    })
    .catch(error => {
        console.error('Error loading goals:', error);
        // 목표가 없는 경우는 에러가 아니므로 조용히 처리
    });
}

// 현재 목표 표시
function displayCurrentGoals(goals) {
    const card = document.getElementById('currentGoalsCard');
    card.style.display = 'block';
    
    document.getElementById('currentWeight').textContent = `${goals.goalWeight} kg`;
    document.getElementById('currentFat').textContent = `${goals.goalFat} kg`;
    document.getElementById('currentSmm').textContent = `${goals.goalSmm} kg`;
    document.getElementById('currentCalories').textContent = `${goals.goalCalorie ? goals.goalCalorie.toLocaleString() : 0} kcal`;
}

// 폼에 현재 목표 값 채우기
function fillFormWithCurrentGoals(goals) {
    document.getElementById('goalWeight').value = goals.goalWeight;
    document.getElementById('goalFat').value = goals.goalFat;
    document.getElementById('goalSmm').value = goals.goalSmm;
    if (goals.goalCalorie) {
        document.getElementById('weeklyCalories').value = goals.goalCalorie;
    }
}

// 폼 초기화 및 이벤트 리스너 설정
function initializeForm() {
    const form = document.getElementById('goalForm');
    
    // 폼 제출 이벤트
    form.addEventListener('submit', handleFormSubmit);
    
    // 입력 필드를 벗어날 때 검증 (blur 이벤트)
    const numberInputs = form.querySelectorAll('input[type="number"]');
    numberInputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateInputRange(this);
        });
    });
}

// 폼 제출 처리
function handleFormSubmit(e) {
    e.preventDefault();
    
    console.log('폼 제출 시작'); // 디버깅용
    
    const goalData = {
        goalWeight: parseFloat(document.getElementById('goalWeight').value),
        goalFat: parseFloat(document.getElementById('goalFat').value),
        goalSmm: parseFloat(document.getElementById('goalSmm').value),
        goalCalorie: parseInt(document.getElementById('weeklyCalories').value)
    };
    
    // 유효성 검사
    if (!validateGoalData(goalData)) {
        return;
    }
    
    // 저장 요청
    saveGoals(goalData);
}

// 목표 데이터 유효성 검사
function validateGoalData(goalData) {
    // 체중 범위 체크
    if (goalData.goalWeight < 30 || goalData.goalWeight > 200) {
        showMessage('목표 체중은 30kg에서 200kg 사이여야 합니다.', 'error');
        return false;
    }
    
    // 체지방량 범위 체크
    if (goalData.goalFat < 0 || goalData.goalFat > 100) {
        showMessage('목표 체지방량은 0kg에서 100kg 사이여야 합니다.', 'error');
        return false;
    }
    
    // 골격근량 범위 체크
    if (goalData.goalSmm < 0 || goalData.goalSmm > 100) {
        showMessage('목표 골격근량은 0kg에서 100kg 사이여야 합니다.', 'error');
        return false;
    }
    
    // 주간 칼로리 범위 체크
    if (goalData.goalCalorie < 0 || goalData.goalCalorie > 50000) {
        showMessage('주간 목표 칼로리는 0kcal에서 50,000kcal 사이여야 합니다.', 'error');
        return false;
    }
    
    // 논리적 검증: 체지방량 + 골격근량이 체중보다 크면 안됨
    if (goalData.goalFat + goalData.goalSmm > goalData.goalWeight) {
        showMessage('체지방량과 골격근량의 합이 목표 체중보다 클 수 없습니다.', 'error');
        return false;
    }
    
    return true;
}

// 입력 범위 검증 (포커스 아웃 시)
function validateInputRange(input) {
    const value = parseFloat(input.value);
    const min = parseFloat(input.min);
    const max = parseFloat(input.max);
    
    // 값이 없으면 무시
    if (isNaN(value) || input.value === '') {
        return;
    }
    
    // 범위를 벗어나면 경고 후 최소/최대값으로 조정
    if (value < min) {
        showMessage(`${input.previousElementSibling.textContent.trim()}은(는) 최소 ${min} 이상이어야 합니다.`, 'error');
        input.value = min;
    } else if (value > max) {
        showMessage(`${input.previousElementSibling.textContent.trim()}은(는) 최대 ${max} 이하여야 합니다.`, 'error');
        input.value = max;
    }
}

// 목표 저장
function saveGoals(goalData) {
    const contextPath = window.contextPath || '';
    const submitButton = document.querySelector('.btn-primary');
    
    // 버튼 로딩 상태
    submitButton.classList.add('loading');
    submitButton.disabled = true;
    
    fetch(`${contextPath}/user/saveGoals`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(goalData)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('목표 저장에 실패했습니다.');
        }
        return response.json();
    })
    .then(data => {
        showMessage('목표가 성공적으로 저장되었습니다! 🎉', 'success');
        
        // 현재 목표 업데이트
        displayCurrentGoals(goalData);
        
        // 스크롤을 상단으로 이동하여 메시지 보이기
        window.scrollTo({ top: 0, behavior: 'smooth' });
    })
    .catch(error => {
        console.error('Error saving goals:', error);
        showMessage('목표 저장 중 오류가 발생했습니다. 다시 시도해주세요.', 'error');
    })
    .finally(() => {
        // 버튼 로딩 상태 해제
        submitButton.classList.remove('loading');
        submitButton.disabled = false;
    });
}

// 폼 초기화
function resetGoalForm() {
    if (confirm('입력한 내용을 모두 초기화하시겠습니까?')) {
        document.getElementById('goalForm').reset();
        showMessage('입력 내용이 초기화되었습니다.', 'info');
    }
}

// 메시지 표시
function showMessage(message, type = 'info') {
    const messageBox = document.getElementById('messageBox');
    
    // 메시지 타입에 따른 아이콘
    const icons = {
        success: '✅',
        error: '❌',
        info: 'ℹ️'
    };
    
    messageBox.innerHTML = `${icons[type] || icons.info} ${message}`;
    messageBox.className = `message ${type} show`;
    
    // 3초 후 자동으로 숨김
    setTimeout(() => {
        messageBox.classList.remove('show');
    }, 3000);
}

// 숫자 포맷팅 (소수점 1자리)
function formatNumber(num) {
    return parseFloat(num).toFixed(1);
}

// 입력 필드에 포커스 시 전체 선택
document.addEventListener('DOMContentLoaded', function() {
    const numberInputs = document.querySelectorAll('input[type="number"]');
    numberInputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.select();
        });
    });
});