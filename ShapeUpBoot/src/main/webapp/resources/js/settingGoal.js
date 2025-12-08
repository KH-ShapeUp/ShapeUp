// 전역 함수로 선언
function showModal(message) {
    console.log('✅ showModal 호출:', message);
    
    const modal = document.getElementById('customModal');
    const modalMessage = document.getElementById('modalMessage');
    
    if (!modal || !modalMessage) {
        console.error('❌ 모달 요소를 찾을 수 없습니다.');
        alert(message);
        return;
    }
    
    modalMessage.textContent = message;
    modal.style.display = 'flex';
}

function closeModal() {
    const modal = document.getElementById('customModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    console.log('📌 페이지 로드 완료');
    loadCurrentGoals();
    initializeForm();
});

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
    });
}

function displayCurrentGoals(goals) {
    const card = document.getElementById('currentGoalsCard');
    if (card) {
        card.style.display = 'block';
    }
    
    const currentWeight = document.getElementById('currentWeight');
    const currentFat = document.getElementById('currentFat');
    const currentSmm = document.getElementById('currentSmm');
    
    if (currentWeight) currentWeight.textContent = `${goals.goalWeight} kg`;
    if (currentFat) currentFat.textContent = `${goals.goalFat} kg`;
    if (currentSmm) currentSmm.textContent = `${goals.goalSmm} kg`;
}

function fillFormWithCurrentGoals(goals) {
    const goalWeightInput = document.getElementById('goalWeight');
    const goalFatInput = document.getElementById('goalFat');
    const goalSmmInput = document.getElementById('goalSmm');
    
    if (goalWeightInput) goalWeightInput.value = goals.goalWeight;
    if (goalFatInput) goalFatInput.value = goals.goalFat;
    if (goalSmmInput) goalSmmInput.value = goals.goalSmm;
}

function initializeForm() {
    const form = document.getElementById('goalForm');
    
    if (!form) {
        console.error('❌ goalForm을 찾을 수 없습니다.');
        return;
    }
    
    console.log('✅ 폼 이벤트 리스너 등록');
    
    // 폼 제출 이벤트
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        console.log('📝 폼 제출 이벤트 발생!');
        handleFormSubmit(e);
    });
    
    // 입력 필드 포커스 시 전체 선택
    const numberInputs = form.querySelectorAll('input[type="number"]');
    numberInputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.select();
        });
    });
}

function handleFormSubmit(e) {
    console.log('🚀 handleFormSubmit 실행');
    
    const goalWeightInput = document.getElementById('goalWeight');
    const goalFatInput = document.getElementById('goalFat');
    const goalSmmInput = document.getElementById('goalSmm');
    
    if (!goalWeightInput || !goalFatInput || !goalSmmInput) {
        console.error('❌ 입력 필드를 찾을 수 없음');
        showModal('필수 입력 항목을 찾을 수 없습니다.');
        return;
    }
    
    const goalData = {
        goalWeight: parseFloat(goalWeightInput.value),
        goalFat: parseFloat(goalFatInput.value),
        goalSmm: parseFloat(goalSmmInput.value)
    };
    
    console.log('📊 입력된 데이터:', goalData);
    
    // 유효성 검사
    if (!validateGoalData(goalData)) {
        console.log('❌ 유효성 검사 실패');
        return;
    }
    
    console.log('✅ 유효성 검사 통과, 저장 시작');
    saveGoals(goalData);
}

function validateGoalData(goalData) {
    console.log('🔍 유효성 검사 시작:', goalData);
    
    // NaN 체크
    if (isNaN(goalData.goalWeight) || isNaN(goalData.goalFat) || isNaN(goalData.goalSmm)) {
        console.log('❌ NaN 감지');
        showModal('모든 필수 항목을 입력해주세요.');
        return false;
    }
    
    // 체중 범위 체크
    if (goalData.goalWeight < 30 || goalData.goalWeight > 200) {
        console.log('❌ 체중 범위 초과:', goalData.goalWeight);
        showModal('목표 체중은 30kg에서 200kg 사이여야 합니다.');
        document.getElementById('goalWeight').focus();
        return false;
    }
    
    // 체지방량 범위 체크
    if (goalData.goalFat < 0 || goalData.goalFat > 100) {
        console.log('❌ 체지방량 범위 초과:', goalData.goalFat);
        showModal('목표 체지방량은 0kg에서 100kg 사이여야 합니다.');
        document.getElementById('goalFat').focus();
        return false;
    }
    
    // 골격근량 범위 체크
    if (goalData.goalSmm < 0 || goalData.goalSmm > 100) {
        console.log('❌ 골격근량 범위 초과:', goalData.goalSmm);
        showModal('목표 골격근량은 0kg에서 100kg 사이여야 합니다.');
        document.getElementById('goalSmm').focus();
        return false;
    }
    
    // 논리적 검증
    if (goalData.goalFat + goalData.goalSmm > goalData.goalWeight) {
        console.log('❌ 체지방+골격근 > 체중');
        showModal('체지방량과 골격근량의 합이 목표 체중보다 클 수 없습니다.');
        document.getElementById('goalWeight').focus();
        return false;
    }
    
    console.log('✅ 유효성 검사 통과');
    return true;
}

function saveGoals(goalData) {
    const contextPath = window.contextPath || '';
    const submitButton = document.querySelector('.btn-primary');
    
    if (submitButton) {
        submitButton.classList.add('loading');
        submitButton.disabled = true;
    }
    
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
        showModal('목표가 성공적으로 저장되었습니다! 🎉');
        displayCurrentGoals(goalData);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    })
    .catch(error => {
        console.error('Error saving goals:', error);
        showModal('목표 저장 중 오류가 발생했습니다. 다시 시도해주세요.');
    })
    .finally(() => {
        if (submitButton) {
            submitButton.classList.remove('loading');
            submitButton.disabled = false;
        }
    });
}

function resetGoalForm() {
    if (confirm('입력한 내용을 모두 초기화하시겠습니까?')) {
        const form = document.getElementById('goalForm');
        if (form) {
            form.reset();
            showModal('입력 내용이 초기화되었습니다.');
        }
    }
}

function formatNumber(num) {
    return parseFloat(num).toFixed(1);
}