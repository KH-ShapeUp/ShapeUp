package com.ShapeUp.boot.app.diet.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.app.diet.dto.DietSaveRequest;
import com.ShapeUp.boot.app.diet.dto.DietItem;
import com.ShapeUp.boot.domain.diet.model.service.DietService;
import com.ShapeUp.boot.domain.diet.model.vo.DietVo;
import com.ShapeUp.boot.domain.diet.model.vo.FoodApi;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/diet")
@RequiredArgsConstructor
public class DietController {
	
	private final DietService dService;

	@GetMapping
	public String dietPage() {
		
		//로그인 유저 정보 받아오기
		
		return "diet/dietRecord";
	}

	@GetMapping("/list")
	@ResponseBody
	public List<FoodApi> getFoodListByKeyword(@RequestParam("q") String keyword){
	    if (keyword == null || keyword.isBlank()) {
	        return List.of();
	    }
	    return dService.getFoodsByKeyword(keyword);
	}
	
	@PostMapping("/insert")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> saveDiet(@RequestBody DietSaveRequest request){
		if(request == null || request.getItems() == null || request.getItems().isEmpty()) {
			return ResponseEntity.badRequest().body(Map.of("success", false, "message", "NO_ITEMS"));
		}
		
		String dietDate = sanitizeDate(request.getDietDate());
		String dietType = (request.getDietType() == null || request.getDietType().isBlank())
				? "기타"
				: request.getDietType();
		
		int userNo = 2; // TODO: 로그인 사용자 정보 연동
		int inserted = 0;
		for(DietItem item : request.getItems()) {
			DietVo diet = new DietVo();
			diet.setUserNo(userNo);
			diet.setDietDate(dietDate);
			diet.setDietType(dietType);
			diet.setFoodNames(item.getFoodNames() != null && !item.getFoodNames().isBlank() ? item.getFoodNames() : item.getName());
			diet.setFoodCd(item.getFoodCd());
			diet.setAmount(item.getAmount());
			diet.setKcal(item.getKcal());
			inserted += dService.insertDiet(diet);
		}
		
		return ResponseEntity.ok(Map.of("success", true, "inserted", inserted));
	}
	
	@GetMapping("/summary")
	@ResponseBody
	public Map<String, Object> getSummary(@RequestParam(value="date", required=false) String date) {
		String targetDate = sanitizeDate(date);
		Map<String, Double> raw = dService.sumKcalByDate(targetDate);
		Map<String, Double> totals = dService.sumNutritionTotalsByDate(targetDate);
		Map<String, Double> data = new HashMap<>();
		if (raw != null) {
			raw.forEach((k, v) -> {
				String key = normalizeMealKey(k);
				if (key != null) {
					data.put(key, v);
				}
			});
		}
		return Map.of(
			"date", targetDate,
			"data", data,
			"totals", totals != null ? totals : Map.of()
		);
	}
	

	
	private String normalizeMealKey(String raw) {
		if (raw == null) return null;
		String v = raw.trim();
		switch (v) {
			case "아침":
			case "breakfast":
			case "BREAKFAST":
				return "아침";
			case "점심":
			case "lunch":
			case "LUNCH":
				return "점심";
			case "저녁":
			case "dinner":
			case "DINNER":
				return "저녁";
			case "간식":
			case "snack":
			case "SNACK":
				return "간식";
			default:
				return null;
		}
	}
	
	private String sanitizeDate(String dateStr) {
		if(dateStr == null || dateStr.isBlank() || "--".equals(dateStr.trim())) {
			return LocalDate.now().toString();
		}
		try {
			return LocalDate.parse(dateStr.trim(), DateTimeFormatter.ISO_LOCAL_DATE).toString();
		}catch(DateTimeParseException e) {
			return LocalDate.now().toString();
		}
	}
}
