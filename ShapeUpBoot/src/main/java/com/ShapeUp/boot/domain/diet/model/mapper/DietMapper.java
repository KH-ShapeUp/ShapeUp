package com.ShapeUp.boot.domain.diet.model.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.domain.diet.model.vo.DietVo;
import com.ShapeUp.boot.domain.diet.model.vo.FoodApi;

@Mapper
public interface DietMapper {

	List<FoodApi> getFoodsByKeyword(String keyword);

	int insertDiet(DietVo diet);

	List<Map<String, Object>> sumKcalByDate(String dietDate);

	Map<String, Object> sumNutritionTotalsByDate(String dietDate);

}
