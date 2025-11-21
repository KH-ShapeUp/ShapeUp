package com.ShapeUp.boot.domain.activity.model.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ActivityVO {
	private int activityId;
	private String activityName;
	private String activityType;
	private double calPerMin;
	private String useYn;
	private Timestamp createdAt;
	private Timestamp updateAt;
	private int weightLevel;
}
