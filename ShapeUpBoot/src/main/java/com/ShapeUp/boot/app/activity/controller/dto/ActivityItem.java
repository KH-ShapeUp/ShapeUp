package com.ShapeUp.boot.app.activity.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Alias("ActivityControllerItem")
public class ActivityItem {
    private String activityId;
    private Integer durationMin;
    private Integer calories;
    private String weightLevel;
    private String intensityFactor;
}
