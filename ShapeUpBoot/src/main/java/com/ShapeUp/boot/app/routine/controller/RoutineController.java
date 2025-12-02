package com.ShapeUp.boot.app.routine.controller;

import java.util.List;
import java.util.Map;

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
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.domain.routine.service.RoutineService;
import com.ShapeUp.boot.domain.routine.vo.Routine;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/routine")
public class RoutineController {
	
	private final RoutineService rService;

	@GetMapping("")
	public String showRoutineList(
			@ModelAttribute Routine routine
			, Model model) {
		try {
			int userNo = 1;
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
	
	@ResponseBody
	@PostMapping("/create")
	public Map<String, Object> createRoutine(@RequestBody Map<String, Object> routineData) {
		try {
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
	        // 삭제 성공 시 루틴 목록 페이지로 리다이렉트
	        return "redirect:/routine/list";
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/common/error?msg=루틴 삭제 실패";
		}
	}
}
