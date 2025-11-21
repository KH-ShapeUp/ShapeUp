package com.ShapeUp.boot.domain.matching.model.vo;

import java.sql.Timestamp;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Alias("MatchingActivityVO")
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
