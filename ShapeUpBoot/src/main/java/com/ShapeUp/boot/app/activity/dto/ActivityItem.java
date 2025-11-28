package com.ShapeUp.boot.app.activity.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

@Data
@Alias("ActivityDomainItem")
public class ActivityItem {
   private int activityId;
   private int durationMin;
   private double calories;
   private int weightLevel;
   private int intensityFactor;

}
