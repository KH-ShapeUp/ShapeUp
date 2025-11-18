package com.ShapeUp.boot.app.matching.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class matchingController {
	// 매칭 페이지 이동
	@GetMapping("/matching")
	public String matchingPage() {
		return "matching/matchingBoard";
	}
	
	// 매칭 글 작성 페이지 이동
	@GetMapping("/matching/insert")
	public String matchingInsertPage() {
		return "matching/matchingInsert";
	}
}
