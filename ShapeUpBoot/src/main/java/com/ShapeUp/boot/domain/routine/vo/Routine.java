package com.ShapeUp.boot.domain.routine.vo;

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
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Routine {

	private int userNo;
	private int routineId;
	private String routineName;
	private String routineExplain;
	private Timestamp routineStart;
	private Timestamp routineEnd;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	private List<RoutineItem> routineItems;
	private String routineCategorySummary;
	private String routineDaysSummary;
	private int totalKcal;
}
