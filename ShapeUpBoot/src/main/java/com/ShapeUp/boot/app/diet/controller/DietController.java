package com.ShapeUp.boot.app.diet.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.domain.diet.model.service.impl.DietServiceImpl;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DietController {
	
	private final DietServiceImpl dService;
	
	
//	실제 사용할 식단 입력 Get 맵핑
//	@GetMapping("/diet2")
//	public String DietMainPage2(HttpSession session, Model model) {
//		
//		User loginUser = (User) session.getAttribute("loginUser");
//        if (loginUser == null) {
//            return "redirect:/auth/login"; // 미로그인 시 로그인 페이지로
//        }
//		List<Diet> diets = dService.getDietListByUser(loginUser.getUserId());
//		
//		return "diet/dietRecord";
//	}
	
//	더미데이터 테스트용
	@GetMapping("/diet")
	public String DietMainPage() {
		return "diet/dietRecord";
	}
	
	
	@PostMapping("/diet")
	@ResponseBody
	public java.util.Map<String, Object> DietInsert() {
		return java.util.Map.of(
				
				);
	}
}
