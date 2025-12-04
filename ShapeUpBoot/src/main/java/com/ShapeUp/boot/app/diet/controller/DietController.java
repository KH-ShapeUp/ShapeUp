package com.ShapeUp.boot.app.diet.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.app.diet.dto.Item;
import com.ShapeUp.boot.app.diet.dto.DietSaveRequest;
import com.ShapeUp.boot.domain.diet.model.service.DietService;
import com.ShapeUp.boot.domain.diet.model.vo.DietVo;
import com.ShapeUp.boot.domain.diet.model.vo.FoodApi;
import com.ShapeUp.boot.domain.goal.model.service.GoalService;
import com.ShapeUp.boot.domain.goal.model.vo.GoalVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/diet")
@RequiredArgsConstructor
public class DietController {
	
	private final DietService dService;
	private final GoalService goalService;

	@GetMapping
	public String dietPage() {
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
	public ResponseEntity<Map<String, Object>> saveDiet(@RequestBody DietSaveRequest request, HttpSession session){
		if(request == null || request.getItems() == null || request.getItems().isEmpty()) {
			return ResponseEntity.badRequest().body(Map.of("success", false, "message", "NO_ITEMS"));
		}
		
		Integer userNo = extractUserNo(session);
		if (userNo == null) {
			return ResponseEntity.status(401).body(Map.of("success", false, "message", "LOGIN_REQUIRED"));
		}
		
		String dietDate = sanitizeDate(request.getDietDate());
		String dietType = (request.getDietType() == null || request.getDietType().isBlank())
				? "기타"
				: request.getDietType();
		
		int inserted = 0;
		for(Item item : request.getItems()) {
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
	public ResponseEntity<Map<String, Object>> getSummary(@RequestParam(value="date", required=false) String date, HttpSession session) {
		String targetDate = sanitizeDate(date);
		Integer userNo = extractUserNo(session);
		if (userNo == null) {
			return ResponseEntity.status(401).body(Map.of(
				"date", targetDate,
				"data", Map.of(),
				"totals", Map.of(),
				"loggedIn", false
			));
		}
		Map<String, Double> raw = dService.sumKcalByDate(targetDate, userNo);
		Map<String, Double> totals = dService.sumNutritionTotalsByDate(targetDate, userNo);
		Map<String, Double> data = new HashMap<>();
		if (raw != null) {
			raw.forEach((k, v) -> {
				String key = normalizeMealKey(k);
				if (key != null) {
					data.put(key, v);
				}
			});
		}
		return ResponseEntity.ok(Map.of(
			"date", targetDate,
			"data", data,
			"totals", totals != null ? totals : Map.of(),
			"loggedIn", true
		));
	}

	@GetMapping("/items")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getDietItems(
		@RequestParam(value="date", required=false) String date,
		@RequestParam(value="type", required=false) String dietType,
		HttpSession session
	) {
		String targetDate = sanitizeDate(date);
		String targetType = (dietType == null || dietType.isBlank()) ? "기타" : dietType.trim();
		Integer userNo = extractUserNo(session);
		if (userNo == null) {
			return ResponseEntity.status(401).body(Map.of(
				"items", List.of(),
				"loggedIn", false
			));
		}
		List<Map<String, Object>> items = dService.findDietItems(targetDate, targetType, userNo);
		return ResponseEntity.ok(Map.of(
			"items", items != null ? items : List.of(),
			"loggedIn", true
		));
	}

	@PostMapping("/delete")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteDiet(@RequestBody Map<String, Object> body, HttpSession session) {
		Integer userNo = extractUserNo(session);
		if (userNo == null) {
			return ResponseEntity.status(401).body(Map.of("success", false, "message", "LOGIN_REQUIRED"));
		}
		Object raw = body.get("dietNos");
		if (!(raw instanceof List<?> rawList) || rawList.isEmpty()) {
			return ResponseEntity.badRequest().body(Map.of("success", false, "message", "NO_ITEMS"));
		}
		List<Integer> dietNos = rawList.stream()
			.filter(o -> o != null)
			.map(Object::toString)
			.map(String::trim)
			.filter(s -> !s.isBlank())
			.map(Integer::valueOf)
			.toList();
		if (dietNos.isEmpty()) {
			return ResponseEntity.badRequest().body(Map.of("success", false, "message", "NO_ITEMS"));
		}
		int deleted = dService.deleteDietItems(dietNos, userNo);
		return ResponseEntity.ok(Map.of("success", true, "deleted", deleted));
	}

	// ========================================
	// 목표 칼로리 조회 API (식사별 목표 포함)
	// ========================================
	/**
	 * 목표 칼로리 조회 - 총 목표 + 식사별 목표
	 * GET /diet/goal
	 */
	@GetMapping("/goal")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getGoalCalorie(HttpSession session) {
		Integer userNo = extractUserNo(session);
		if (userNo == null) {
			return ResponseEntity.status(401).body(Map.of(
				"success", false,
				"message", "LOGIN_REQUIRED",
				"loggedIn", false
			));
		}
		
		try {
			GoalVO goal = goalService.getGoalByUserNo(userNo);
			
			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			response.put("loggedIn", true);
			
			if (goal == null) {
				// 목표가 설정되지 않은 경우 기본값 반환
				response.put("goalCalorie", 2230);
				response.put("GOAL_CALORIE", 2230);
				response.put("goalCalorieMorning", 500);
				response.put("goalCalorieLunch", 680);
				response.put("goalCalorieDinner", 550);
				response.put("goalCalorieEtc", 500);
			} else {
				// 총 목표 칼로리
				int goalCalorie = (goal.getGoalCalorie() != null) ? goal.getGoalCalorie() : 2230;
				response.put("goalCalorie", goalCalorie);
				response.put("GOAL_CALORIE", goalCalorie);
				
				// 식사별 목표 칼로리 (없으면 기본값)
				response.put("goalCalorieMorning", 
					(goal.getGoalCalorieMorning() != null) ? goal.getGoalCalorieMorning() : 500);
				response.put("goalCalorieLunch", 
					(goal.getGoalCalorieLunch() != null) ? goal.getGoalCalorieLunch() : 680);
				response.put("goalCalorieDinner", 
					(goal.getGoalCalorieDinner() != null) ? goal.getGoalCalorieDinner() : 550);
				response.put("goalCalorieEtc", 
					(goal.getGoalCalorieEtc() != null) ? goal.getGoalCalorieEtc() : 500);
			}
			
			return ResponseEntity.ok(response);
			
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body(Map.of(
				"success", false,
				"message", "INTERNAL_ERROR: " + e.getMessage(),
				"loggedIn", true
			));
		}
	}

	// ========================================
	// 식사별 목표 칼로리 저장 API (새로 추가)
	// ========================================
	/**
	 * 식사별 목표 칼로리 저장
	 * POST /diet/saveGoals
	 */
	@PostMapping("/saveGoals")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> saveGoalCalorie(
			@RequestBody Map<String, Integer> goalData,
			HttpSession session) {
		
		Integer userNo = extractUserNo(session);
		if (userNo == null) {
			return ResponseEntity.status(401).body(Map.of(
				"success", false,
				"message", "LOGIN_REQUIRED"
			));
		}

		try {
			// 기존 목표 조회
			GoalVO goal = goalService.getGoalByUserNo(userNo);
			
			if (goal == null) {
				// 새로 생성
				goal = new GoalVO();
				goal.setUserNo(userNo);
			}
			
			// 목표 칼로리 설정
			goal.setGoalCalorie(goalData.get("goalCalorie"));
			goal.setGoalCalorieMorning(goalData.get("goalCalorieMorning"));
			goal.setGoalCalorieLunch(goalData.get("goalCalorieLunch"));
			goal.setGoalCalorieDinner(goalData.get("goalCalorieDinner"));
			goal.setGoalCalorieEtc(goalData.get("goalCalorieEtc"));

			// 저장 또는 업데이트
			GoalVO savedGoal = goalService.saveOrUpdateGoal(goal);
			
			Map<String, Object> response = new HashMap<>();
			response.put("success", savedGoal != null);
			response.put("message", savedGoal != null ? "목표 칼로리가 저장되었습니다." : "저장에 실패했습니다.");
			
			return ResponseEntity.ok(response);
			
		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(500).body(response);
		}
	}

	// ========================================
	// Private Helper Methods
	// ========================================
	
	private Integer extractUserNo(HttpSession session) {
		if (session == null) return null;
		Object raw = session.getAttribute("userNo");
		if (raw instanceof Number) {
			return ((Number) raw).intValue();
		}
		if (raw instanceof String) {
			try {
				return Integer.parseInt(((String) raw).trim());
			} catch (NumberFormatException e) {
				return null;
			}
		}
		return null;
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
			case "기타":
			case "etc":
			case "ETC":
				return "기타";
			default:
				return "기타";
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