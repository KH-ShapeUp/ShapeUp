package com.ShapeUp.boot.app.activity.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ShapeUp.boot.domain.activity.model.service.ActivityService;

import lombok.RequiredArgsConstructor;



@Controller
@RequestMapping("/activity")
@RequiredArgsConstructor
public class ActivityController {
	
	private final ActivityService aService;
	
	@GetMapping
	public String activityPage() {
		return "activity/activityRecord";
	}
	
	
}
