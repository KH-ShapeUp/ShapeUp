package com.ShapeUp.boot.app.user.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
public class UserController {
	@GetMapping("/user/signup")
	public String signupUser(){
		return "user/signup";
	}
	
	@GetMapping("/user/signupAgreement")
	public String signupUserAgreement() {
		return "user/signupAgreement";
	}
	
	@GetMapping("/user/signupInsertInfo")
	public String signupUserInsertInfo() {
		return "user/signupInsertInfo";
	}
	
	@GetMapping("/user/signupSurvey")
	public String signupUserSurvey() {
		return "user/signupSurvey";
	}
	
	@GetMapping("/user/signupSuccess")
	public String signupUserSuccess() {
		return "user/signupSuccess";
	}
}
