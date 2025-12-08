package com.ShapeUp.boot.domain.routine.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ShapeUp.boot.app.routine.util.DayOfWeekConverter;
import com.ShapeUp.boot.domain.routine.mapper.RoutineMapper;
import com.ShapeUp.boot.domain.routine.service.RoutineService;
import com.ShapeUp.boot.domain.routine.vo.Routine;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RoutineServiceImpl implements RoutineService {

	private final RoutineMapper rMapper;

	public List<Routine> selectRoutineListByUserNo(int userNo) {
		List<Routine> routineList = rMapper.selectRoutineListByUserNo(userNo);
		return routineList;
	}

	public List<String> selectActivityNames() {
		return rMapper.selectActivityNames();
	}

	@Override
	public Double selectCaloriePerMinByName(String activityName) {
		if (activityName == null || activityName.trim().isEmpty()) {
			return 0.0;
		}
		return rMapper.selectCaloriePerMinByName(activityName);
	}

	public void insertFullRoutine(Map<String, Object> routineData) {
		// 1, 2, 3 단계: ROUTINE_TBL, ACTIVITY_TBL, ROUTINE_ITEM_TBL 삽입 로직 (생략 없이 유지)
		rMapper.insertRoutine(routineData);

		int routineId = ((Number) routineData.get("routineId")).intValue();
		String activityName = (String) routineData.get("activityName");

		int activityId = rMapper.selectActivityIdByName(activityName);

		routineData.put("routineId", routineId);
		routineData.put("activityId", activityId);
		rMapper.insertRoutineItem(routineData);
		int routineItemId = ((Number) routineData.get("routineItemId")).intValue();

		// 4. ROUTINE_ITEM_DAY_TBL에 반복 요일 삽입 (문자열 -> 숫자 변환 로직)
		@SuppressWarnings("unchecked")
		List<String> days = (List<String>) routineData.get("days");

		Map<String, Integer> dayMapConverter = new HashMap<>();
		dayMapConverter.put("월", 1);
		dayMapConverter.put("화", 2);
		dayMapConverter.put("수", 3);
		dayMapConverter.put("목", 4);
		dayMapConverter.put("금", 5);
		dayMapConverter.put("토", 6);
		dayMapConverter.put("일", 7);

		for (String day : days) {
			if (day == null || day.isEmpty()) {
				continue;
			}

			Integer dayCode = dayMapConverter.get(day);

			if (dayCode != null) {
				Map<String, Object> dayMap = new HashMap<>();
				dayMap.put("routineItemId", Integer.valueOf(routineItemId));
				dayMap.put("dayOfWeek", dayCode); // DB에는 숫자 코드가 저장됨

				rMapper.insertRoutineItemDay(dayMap);
			}
		}
	}
	// ------------------------------------------------------------------------

	// --- [새로 추가된 부분] DB에서 숫자를 조회하여 문자열로 변환하는 예시 메서드 ---
	/**
	 * DB에 저장된 요일 숫자 코드를 조회하여 사용자에게 보여줄 문자열 리스트로 변환합니다.
	 * 
	 * @param routineItemId 조회할 루틴 아이템 ID
	 * @return 요일 문자열 리스트 (예: ["월", "화", "수"])
	 */
	public List<String> getDisplayDaysForRoutineItem(int routineItemId) {
		// 이 메서드를 실행하려면 RoutineMapper에 List<Integer>를 반환하는
		// selectRoutineItemDays(int routineItemId) 메서드가 정의되어 있어야 합니다.

		// 1. DB에서 요일 숫자 코드 리스트를 조회 (예시용 코드, 실제 Mapper 호출 필요)
		// List<Integer> dayCodes = rMapper.selectRoutineItemDays(routineItemId);

		// **[임시] 테스트를 위해 가상의 숫자 리스트를 사용합니다.**
		List<Integer> dayCodes = List.of(1, 3, 5);

		// 2. DayOfWeekConverter를 사용하여 숫자를 문자열로 변환
		List<String> displayDays = dayCodes.stream().map(DayOfWeekConverter::getDayString) // 숫자 코드를 문자열로 변환
				.filter(day -> !day.isEmpty()) // 빈 문자열 (알 수 없음)은 제거
				.collect(Collectors.toList());

		return displayDays; // 최종 결과: ["월", "수", "금"]
	}

	@Override
	public int deleteRoutine(int routineId) {
		return rMapper.deleteRoutine(routineId);
	}
	
	// ⭐ 주간 목표 칼로리 조회
		@Override
		public Integer getWeeklyGoalCalorie(int userNo) {
			Integer goalCalorie = rMapper.selectWeeklyGoalCalorie(userNo);
			// null이면 기본값 3000 반환
			return goalCalorie != null ? goalCalorie : 3000;
		}

		// ⭐ 주간 목표 칼로리 업데이트
		@Override
		@Transactional
		public int updateWeeklyGoalCalorie(int userNo, int goalCalorie) {
			return rMapper.updateWeeklyGoalCalorie(userNo, goalCalorie);
		}
}