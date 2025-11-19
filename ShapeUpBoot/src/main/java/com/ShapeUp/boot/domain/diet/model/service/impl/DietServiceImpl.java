package com.ShapeUp.boot.domain.diet.model.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.diet.model.mapper.DietMapper;
import com.ShapeUp.boot.domain.diet.model.service.DietService;
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

}
