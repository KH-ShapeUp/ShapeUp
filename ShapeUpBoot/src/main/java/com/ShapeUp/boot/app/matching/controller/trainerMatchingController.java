package com.ShapeUp.boot.app.matching.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/trainer")
public class trainerMatchingController {
	
	@GetMapping("/matching/board")
	public String trainerMatchingPage(HttpSession session, Model model) {
		Integer userNo = (Integer)session.getAttribute("userNo");
		model.addAttribute("userNo", userNo);
		return "matching/trainerMatchingBoard";
	}
	
	@GetMapping("/matching/insert")
	public String trainerMatchingInserPage() {
		return "matching/trainerMatchingInsert";
	}
}
