package com.ShapeUp.boot.domain.routine.vo;

import java.sql.Time;
import java.sql.Timestamp;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoutineItem {

	private int routineItmeId;
	private int routineId;
	private String activityName;
	private Time startTime;
	private int durationMin;
	private int targetSet;
	private int targetReps;
	private List<String> dayOfWeek;
	private Timestamp createdAt;
	private Timestamp updatedAt;
}
