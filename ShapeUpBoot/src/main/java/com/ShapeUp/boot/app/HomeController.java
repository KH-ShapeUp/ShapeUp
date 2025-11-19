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
		return "user/login";
	}
	
	@GetMapping("/map")
	public String mapPage() {
		return "map/map";
	}

	
	@GetMapping("/t")
	public String page() {
		return "diet/dietRecord";
	}
	
	@GetMapping("/tt")
	public String paget() {
		return "diet/customDietRecord";
	}
}
