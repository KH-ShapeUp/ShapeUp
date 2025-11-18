package com.ShapeUp.boot.app;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

	
	@GetMapping("/")
	public String homePage() {
		return "index";
	}

	@GetMapping("/index")
	public String indexPage() {
		return "index";
	}
	
	@GetMapping("/login")
	public String loginPage() {
		return "login";
	}
	
	@GetMapping("/map")
	public String mapPage() {
		return "map";
	}
	
	@GetMapping("/matching")
	public String matchingPage() {
		return "matchingBoard";
	}
	
	@GetMapping("/matching/insert")
	public String matchingInsertPage() {
		return "matchingInsert";
	}
}
