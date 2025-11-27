package com.ShapeUp.boot.app.activity.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ActivityItem {
    private String activityId;
    private Integer durationMin;
    private Integer calories;
    private String weightLevel;
    private String intensityFactor;
}
