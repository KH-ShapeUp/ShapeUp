package com.ShapeUp.boot.domain.diet.model.service;

import java.util.List;
import java.util.Map;

import com.ShapeUp.boot.domain.diet.model.vo.DietVo;
import com.ShapeUp.boot.domain.diet.model.vo.FoodApi;

public interface DietService {

	List<FoodApi> getFoodsByKeyword(String keyword);

	int insertDiet(DietVo diet);

	int insertDietList(List<DietVo> diets);

	Map<String, Double> sumKcalByDate(String dietDate, int userNo);

	Map<String, Double> sumNutritionTotalsByDate(String dietDate, int userNo);

	List<Map<String, Object>> findDietItems(String dietDate, String dietType, int userNo);

	int deleteDietItems(List<Integer> dietNos, int userNo);

}
