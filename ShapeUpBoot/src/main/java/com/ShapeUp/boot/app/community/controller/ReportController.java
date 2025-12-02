package com.ShapeUp.boot.app.community.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.domain.community.model.service.reportService;
import com.ShapeUp.boot.domain.community.model.vo.reportVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportController {
	private final reportService rService;
	
	@PostMapping("/add")
	@ResponseBody
	public int reportInsert(@RequestBody reportVO rVO) {
		System.out.println("신고 : " + rVO);
		int result = rService.reportInsert(rVO);
		return result;
	}
}
