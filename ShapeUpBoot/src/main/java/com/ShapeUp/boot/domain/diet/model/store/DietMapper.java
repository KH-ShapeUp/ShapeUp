package com.ShapeUp.boot.domain.diet.model.store;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.domain.diet.model.vo.FoodApi;

@Mapper
public interface DietMapper {

	List<FoodApi> getFoodsByKeyword(String keyword);

}
