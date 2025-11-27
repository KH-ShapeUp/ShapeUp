package com.ShapeUp.boot.domain.activity.model.vo;

import java.sql.Timestamp;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ActivityLogVO {
    private Long logId;
    private Integer userNo;
    private String activityId;
    private Integer durationMin;
    private Integer calories;
    private String weightLevel;
    private String intensityLevel;
    private String sourceType;
    private Timestamp actionAt;
    private Timestamp createdAt;
}
