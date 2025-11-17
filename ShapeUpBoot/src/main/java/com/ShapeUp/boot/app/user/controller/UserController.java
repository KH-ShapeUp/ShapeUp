package com.ShapeUp.boot.app.user.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserController {
	@GetMapping("/user/signupAgreement")
	public String signupAgreement() {
	    return "user/signupAgreement"; // /WEB-INF/views/user/signupAgreement.jsp
	}
	@GetMapping("/user/signupInsertInfo")
	public String signupInsertInfo() {
	    return "user/signupInsertInfo"; // /WEB-INF/views/user/signupAgreement.jsp
	}
	@GetMapping("/user/signupSuccess")
	public String signupSuccess() {
	    return "user/signupSuccess"; // /WEB-INF/views/user/signupAgreement.jsp
	}
	@GetMapping("/user/signupSurvey")
	public String signupSurvey() {
	    return "user/signupSurvey"; // /WEB-INF/views/user/signupAgreement.jsp
	}
	@GetMapping("/user/searchId")
	public String searchId() {
	    return "user/searchId"; // /WEB-INF/views/user/signupAgreement.jsp
	}
	@GetMapping("/user/searchPw")
	public String searchPw() {
	    return "user/searchPw"; // /WEB-INF/views/user/signupAgreement.jsp
	}
}
