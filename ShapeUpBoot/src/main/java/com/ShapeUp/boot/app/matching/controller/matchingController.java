package com.ShapeUp.boot.app.matching.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.domain.matching.model.service.matchingService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class matchingController {
	
	private final matchingService mService;
	
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
	
	// 매칭 글 삽입
	@PostMapping("/matching")
	@ResponseBody
	public int matchingInsert(@RequestBody matchingInsertDTO mDTO) {
		System.out.println(mDTO);
		int result = mService.matchingInsert(mDTO);
		return result;
	}
}
