package com.ShapeUp.boot.app.routine.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.domain.routine.service.RoutineService;
import com.ShapeUp.boot.domain.routine.vo.Routine;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/routine")
public class RoutineController {
	
	private final RoutineService rService;
	
	@GetMapping("/list")
	public String showRoutineList(
			@ModelAttribute Routine routine
			, Model model
			, HttpSession session) {
		try {
			// ⭐ 세션에서 userNo 가져오기
			Integer userNo = (Integer) session.getAttribute("userNo");
			if (userNo == null) {
				userNo = 1; // 테스트용 기본값
			}
			
			List<Routine> routineList = rService.selectRoutineListByUserNo(userNo);
			List<String> activityNames = rService.selectActivityNames();
			
			model.addAttribute("activityNames", activityNames);
			model.addAttribute("routineList", routineList);
			
			return "routine/routineManageMent";
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
			return "common/error";
		}
	}
	
	@ResponseBody
	@GetMapping("/getCalorie")
	public Double getCaloriePerMin(@RequestParam("activityName") String activityName) {
		if(activityName == null || activityName.isEmpty()) {
			return 0.0;
		}
		return rService.selectCaloriePerMinByName(activityName);
	}
	
	// ⭐ 루틴 생성 - HttpSession 추가하여 userNo 주입
	@ResponseBody
	@PostMapping("/create")
	public Map<String, Object> createRoutine(
			@RequestBody Map<String, Object> routineData,
			HttpSession session) {  // ⭐ HttpSession 추가
		try {
			// ⭐ 세션에서 userNo 가져오기
			Integer userNo = (Integer) session.getAttribute("userNo");
			if (userNo == null) {
				userNo = 1; // 테스트용 기본값
			}
			
			// ⭐ routineData에 userNo 추가
			routineData.put("userNo", userNo);
			
			rService.insertFullRoutine(routineData);
			return Map.of("success", true, "message", "루틴이 저장되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("루틴 저장 중 오류가 발생했습니다. 상세: " + e.getMessage());
		}
	}
	
	@PostMapping("/delete/{id}")
	public String deleteRoutine(@PathVariable("id") int routineId){
		try {
			rService.deleteRoutine(routineId); 
			return "redirect:/routine/list";
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/common/error?msg=루틴 삭제 실패";
		}
	}
	
	// ⭐ 주간 목표 칼로리 조회
	@ResponseBody
	@GetMapping("/goal/weekly")
	public ResponseEntity<Map<String, Object>> getWeeklyGoalCalorie(HttpSession session) {
		try {
			// 세션에서 userNo 가져오기
			Integer userNo = (Integer) session.getAttribute("userNo");
			if (userNo == null) {
				userNo = 1; // 테스트용 기본값
			}
			
			Integer weeklyGoal = rService.getWeeklyGoalCalorie(userNo);
			
			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			response.put("goalCalorieActivityWeekly", weeklyGoal != null ? weeklyGoal : 3000);
			
			return ResponseEntity.ok(response);
			
		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> errorResponse = new HashMap<>();
			errorResponse.put("success", false);
			errorResponse.put("message", "목표 칼로리 조회 실패: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
		}
	}
	
	// ⭐ 주간 목표 칼로리 저장
	@ResponseBody
	@PostMapping("/goal/weekly")
	public ResponseEntity<Map<String, Object>> updateWeeklyGoalCalorie(
			@RequestBody Map<String, Integer> request,
			HttpSession session) {
		
		try {
			// 세션에서 userNo 가져오기
			Integer userNo = (Integer) session.getAttribute("userNo");
			if (userNo == null) {
				userNo = 1; // 테스트용 기본값
			}
			
			Integer goalCalorie = request.get("goalCalorieActivityWeekly");
			
			// 유효성 검사
			if (goalCalorie == null || goalCalorie <= 0) {
				Map<String, Object> errorResponse = new HashMap<>();
				errorResponse.put("success", false);
				errorResponse.put("message", "올바른 칼로리를 입력해주세요.");
				return ResponseEntity.badRequest().body(errorResponse);
			}
			
			// 저장
			int result = rService.updateWeeklyGoalCalorie(userNo, goalCalorie);
			
			Map<String, Object> response = new HashMap<>();
			if (result > 0) {
				response.put("success", true);
				response.put("message", "저장 완료");
				return ResponseEntity.ok(response);
			} else {
				response.put("success", false);
				response.put("message", "저장 실패");
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> errorResponse = new HashMap<>();
			errorResponse.put("success", false);
			errorResponse.put("message", "서버 오류: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
		}
	}
}