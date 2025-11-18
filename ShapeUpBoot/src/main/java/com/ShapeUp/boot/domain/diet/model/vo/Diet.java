package com.ShapeUp.boot.domain.diet.model.vo;

import java.sql.Timestamp;

import lombok.Data;
@Data
public class Diet {
	
	private int dietNo;
	private int userNo;
	private String dietDate;
	private String dietType;
	private String foodNames;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	private String foodCd;
	private double amount;
	
}
