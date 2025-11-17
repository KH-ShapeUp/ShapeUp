package com.ShapeUp.boot.domain.diet.model.vo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Diet {
	private int dietNo;
	private int userNo;
	private String dietDate;
	private String dietType;
	private String foodName;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	private String foodCd;
	private double amount;
}
