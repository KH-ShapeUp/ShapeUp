package com.ShapeUp.boot.domain.diet.model.vo;

import lombok.Data;

@Data
public class FoodApi {
	private String foodCd;
	private String foodName;
	private double servingSize;
	private double kcal;
	private double carb;
	private double protein;
	private double fat;
	private double sugar;
	private double sodium;
	private double cholesterol;
	private double satFat;
	private double transFat;
	private double fiber;
}
