package com.ShapeUp.boot.app.activity.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.domain.activity.model.service.ActivityService;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;

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
	
	@GetMapping("/list")
	@ResponseBody
	public List<ActivityVO> getActivityList(@RequestParam("q") String keyword){
		
		if(keyword ==null || keyword.isBlank()) {
			return List.of();
		}
		List<ActivityVO> activitys = aService.getActivityListByKeyword(keyword);
		
		return activitys;
	}
	
	
}
