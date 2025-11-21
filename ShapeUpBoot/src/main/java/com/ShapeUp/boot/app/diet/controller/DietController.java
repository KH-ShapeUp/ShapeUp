package com.ShapeUp.boot.app.diet.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.domain.diet.model.service.DietService;
import com.ShapeUp.boot.domain.diet.model.vo.DietVo;
import com.ShapeUp.boot.domain.diet.model.vo.FoodApi;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/diet")
@RequiredArgsConstructor
public class DietController {
	
	private final DietService dService;

// 추후에 userNo를 받아오도록 해야함 -> 오늘의 diet리스트 출력에 필요 
//	@GetMapping("/{userNo}")
	@GetMapping
	public String dietPage() {
		return "diet/dietRecord";
	}
//	식단 검색하기
//	식품 종류 api 불러와야함
	@GetMapping("/list")
	@ResponseBody
//	public java.util.Map<String, Object> getFoodListByKeyword(@RequestParam("q") String keyword){
	public List<FoodApi> getFoodListByKeyword(@RequestParam("q") String keyword){
		
	    if (keyword == null || keyword.isBlank()) {
	        return List.of();
	    }
//		키워드로 검색
		List<FoodApi> foods = dService.getFoodsByKeyword(keyword);
//		Map<String, Object> map = new HashMap<>();
//		map.put("foods", foods);
		
		return foods;
		
	}
	
// 선택 식단 입력
	@PostMapping("/insert")
	@ResponseBody
	public java.util.Map<String, Object> insertDiet(){
		
		int userNo = 1;
//		User loginUser = (User) session.getAttribute("loginUser");
//        if (loginUser == null) {
//            return java.util.Map.of("success", false, "message", "LOGIN_REQUIRED");
//        }
		DietVo diet = new DietVo();
		diet.setUserNo(userNo);
		return java.util.Map.of(
				
				);
	}
}
