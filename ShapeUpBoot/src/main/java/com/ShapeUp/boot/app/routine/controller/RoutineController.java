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

// 🚨 주의: 프로젝트 환경에 따라 javax.servlet.http.HttpSession 또는 jakarta.servlet.http.HttpSession을 사용해야 합니다.
// 제공된 코드에는 import가 없으므로, 필요시 추가하세요. 여기서는 jakarta를 가정하고 작성합니다.
import jakarta.servlet.http.HttpSession; 
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/routine")
public class RoutineController {
	
	private final RoutineService rService;

    // 💡 세션 키 "userNo"를 사용하여 userNo를 안전하게 가져오는 유틸리티 메서드
    private Integer getUserNoFromSession(HttpSession session) {
        return (Integer) session.getAttribute("userNo"); 
    }

	@GetMapping("/list")
	public String showRoutineList(
			@ModelAttribute Routine routine
			, Model model
			, HttpSession session) { // HttpSession 추가
		try {
			// 세션에서 userNo 가져오기
			Integer userNo = getUserNoFromSession(session);
			
			if (userNo == null) {
                // 로그인 상태가 아니면 로그인 페이지로 리다이렉트
                return "redirect:/user/login"; 
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
	
	@ResponseBody
	@PostMapping("/create")
	public Map<String, Object> createRoutine(
	        @RequestBody Map<String, Object> routineData
	        , HttpSession session) { // HttpSession 추가
		try {
		    // 세션에서 userNo 가져오기
            Integer userNo = getUserNoFromSession(session);
			
			if (userNo == null) {
                // 로그인 상태가 아니면 오류 응답
                return Map.of("success", false, "message", "로그인 상태가 아닙니다.");
            }
			
			// userNo를 DB 삽입을 위한 Map에 추가
			routineData.put("userNo", userNo); 
			
			rService.insertFullRoutine(routineData);
			return Map.of("success", true, "message", "루틴이 저장되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
	        // RuntimeException 대신 Map을 반환하여 AJAX 호출에 응답
	        return Map.of("success", false, "message", "루틴 저장 중 오류가 발생했습니다. 상세: " + e.getMessage());
		}
	}
	
	@PostMapping("/delete/{id}")
	public String deleteRoutine(@PathVariable("id") int routineId
	        , HttpSession session){ // HttpSession 추가
		try {
			// 세션에서 userNo 가져오기
			Integer userNo = getUserNoFromSession(session);
			
			if (userNo == null) {
                // 로그인 상태가 아니면 로그인 페이지로 리다이렉트
                return "redirect:/user/login";
            }
			
			// userNo를 Service로 전달
			int result = rService.deleteRoutine(routineId, userNo);
			
			if(result > 0) {
	            // 삭제 성공 시 루틴 목록 페이지로 리다이렉트
	            return "redirect:/routine/list";
	        } else {
	            // 삭제 실패 (해당 userNo의 루틴이 아니거나 이미 삭제됨)
	            return "redirect:/common/error?msg=루틴 삭제 실패 또는 권한 없음";
	        }
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/common/error?msg=루틴 삭제 실패";
		}
	}
}