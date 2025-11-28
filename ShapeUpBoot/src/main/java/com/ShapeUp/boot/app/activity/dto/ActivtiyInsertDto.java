package com.ShapeUp.boot.app.activity.dto;

import java.util.List;

import lombok.Data;

@Data
public class ActivtiyInsertDto {
	   private int userNo;
	   private String sourceType;
	   private List<ActivityItem> items;
}
