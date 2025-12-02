package com.ShapeUp.boot.app.matching.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/trainer")
public class trainerMatchingController {
	
	@GetMapping("/matching/board")
	public String trainerMatchingPage() {
		return "matching/trainerMatchingBoard";
	}
}
