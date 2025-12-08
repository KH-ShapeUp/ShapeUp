package com.ShapeUp.boot.domain.routine.service;

import java.util.List;
import java.util.Map;

import com.ShapeUp.boot.domain.routine.vo.Routine;

public interface RoutineService {

	List<Routine> selectRoutineListByUserNo(int userNo);

	List<String> selectActivityNames();

	Double selectCaloriePerMinByName(String activityName);

	void insertFullRoutine(Map<String, Object> routineData);

	int deleteRoutine(int routineId);
	
	Integer getWeeklyGoalCalorie(int userNo);
	
	int updateWeeklyGoalCalorie(int userNo, int goalCalorie);

}
