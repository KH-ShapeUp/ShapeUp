package com.ShapeUp.boot.domain.diet.model.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.domain.diet.model.vo.DietVo;
import com.ShapeUp.boot.domain.diet.model.vo.FoodApi;

@Mapper
public interface DietMapper {

	List<FoodApi> getFoodsByKeyword(String keyword);

	int insertDiet(DietVo diet);

	List<Map<String, Object>> sumKcalByDate(@Param("dietDate") String dietDate, @Param("userNo") int userNo);

	Map<String, Object> sumNutritionTotalsByDate(@Param("dietDate") String dietDate, @Param("userNo") int userNo);

	List<Map<String, Object>> selectDietItems(@Param("dietDate") String dietDate, @Param("dietType") String dietType, @Param("userNo") int userNo);

	int deleteDietItems(@Param("dietNos") List<Integer> dietNos, @Param("userNo") int userNo);

}
