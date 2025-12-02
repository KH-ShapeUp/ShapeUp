package com.ShapeUp.boot.domain.diet.model.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.diet.model.mapper.DietMapper;
import com.ShapeUp.boot.domain.diet.model.service.DietService;
import com.ShapeUp.boot.domain.diet.model.vo.DietVo;
import com.ShapeUp.boot.domain.diet.model.vo.FoodApi;

import lombok.RequiredArgsConstructor;
@Service
@RequiredArgsConstructor
public class DietServiceImpl implements DietService{
	private final DietMapper dMapper;
	
	@Override
	public List<FoodApi> getFoodsByKeyword(String keyword) {
		List<FoodApi> foodList = dMapper.getFoodsByKeyword(keyword);
		return foodList ;
	}

	@Override
	public int insertDiet(DietVo diet) {
		return dMapper.insertDiet(diet);
	}

	@Override
	public int insertDietList(List<DietVo> diets) {
		if (diets == null || diets.isEmpty()) return 0;
		int cnt = 0;
		for (DietVo diet : diets) {
			cnt += dMapper.insertDiet(diet);
		}
		return cnt;
	}

	@Override
	public Map<String, Double> sumKcalByDate(String dietDate, int userNo) {
		List<Map<String, Object>> rows = dMapper.sumKcalByDate(dietDate, userNo);
		Map<String, Double> result = new HashMap<>();
		if (rows != null) {
			for (Map<String, Object> row : rows) {
				Object type = row.get("dietType");
				if (type == null) type = row.get("DIETTYPE");
				if (type == null) type = row.get("diettype");

				Object total = row.get("totalKcal");
				if (total == null) total = row.get("TOTALKCAL");
				if (total == null) total = row.get("totalkcal");

				if (type != null && total != null) {
					result.put(String.valueOf(type), Double.valueOf(total.toString()));
				}
			}
		}
		return result;
	}

	@Override
	public Map<String, Double> sumNutritionTotalsByDate(String dietDate, int userNo) {
		Map<String, Object> row = dMapper.sumNutritionTotalsByDate(dietDate, userNo);
		Map<String, Double> result = new HashMap<>();
		if (row != null) {
			result.put("kcal", toDouble(row.get("totalKcal"), row.get("TOTALKCAL")));
			result.put("carb", toDouble(row.get("totalCarb"), row.get("TOTALCARB")));
			result.put("protein", toDouble(row.get("totalProtein"), row.get("TOTALPROTEIN")));
			result.put("fat", toDouble(row.get("totalFat"), row.get("TOTALFAT")));
		}
		return result;
	}

	@Override
	public List<Map<String, Object>> findDietItems(String dietDate, String dietType, int userNo) {
		return dMapper.selectDietItems(dietDate, dietType, userNo);
	}

	@Override
	public int deleteDietItems(List<Integer> dietNos, int userNo) {
		if (dietNos == null || dietNos.isEmpty()) return 0;
		return dMapper.deleteDietItems(dietNos, userNo);
	}

	private Double toDouble(Object primary, Object secondary) {
		Object val = primary != null ? primary : secondary;
		if (val == null) return 0d;
		try {
			return Double.valueOf(val.toString());
		} catch (NumberFormatException e) {
			return 0d;
		}
	}

}
