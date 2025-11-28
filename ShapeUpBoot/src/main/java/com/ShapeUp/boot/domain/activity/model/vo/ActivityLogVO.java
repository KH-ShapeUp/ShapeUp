package com.ShapeUp.boot.domain.activity.model.vo;

import jakarta.annotation.security.DenyAll;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ActivityLogVO {
   private int logNo;
   private int userNo;
   private int activityId;
   private int durationMin;
   private double calories;
   private int actionAt;
   private String sourceType;
   private int weightLevel;
   private int intensityLevel;
}
