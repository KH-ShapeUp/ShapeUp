package com.ShapeUp.boot.domain.diet.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.diet.model.vo.FoodApi;

public interface DietService {

	List<FoodApi> getFoodsByKeyword(String keyword);

}
