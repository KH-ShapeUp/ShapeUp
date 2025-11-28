package com.ShapeUp.boot.app.activity.dto;

import lombok.Data;

@Data
public class ActivityItem {
   private int activityId;
   private int durationMin;
   private double calories;
   private int weightLevel;
   private int intensityFactor;

}
