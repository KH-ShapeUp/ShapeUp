package com.ShapeUp.boot.domain.routine.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.domain.routine.vo.Routine;
import com.ShapeUp.boot.domain.routine.vo.RoutineItem;

@Mapper
public interface RoutineMapper {

	// 유저번호로 루틴목록 요약정보 조회
	List<Routine> selectRoutineListByUserNo(int userNo);
	
	// 루틴 상세정보 조회
	List<RoutineItem> selectRoutineItemsByRoutineId(int routineId);
	
	void insertRoutine(Map<String, Object> routineData);
	
	List<String> selectActivityNames();
	
	double selectCaloriePerMinByName(String activityName);

	void insertRoutineItemDay(Map<String, Object> routineData);

	void insertRoutineItem(Map<String, Object> routineData);

	int selectActivityIdByName(String activityName);

	int deleteRoutine(Map<String, Object> params);

	
	// ⭐ 주간 목표 칼로리 조회
		Integer selectWeeklyGoalCalorie(int userNo);
		
	// ⭐ 주간 목표 칼로리 업데이트
	int updateWeeklyGoalCalorie(@Param("userNo") int userNo, 
	                            @Param("goalCalorie") int goalCalorie);

}
