package com.ShapeUp.boot.app.activity.controller.dto;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ActivityInsertDto {
    private String actionAt;
    private List<ActivityItem> items;
}