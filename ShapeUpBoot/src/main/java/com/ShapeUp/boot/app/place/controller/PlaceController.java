package com.ShapeUp.boot.app.place.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ShapeUp.boot.domain.place.vo.Place;

@Controller
@RequestMapping("/place")
public class PlaceController {

	@GetMapping("insert")
	public String insertPlace(Model model) {
		model.addAttribute("place", new Place());
		return "place/insertPlace";
	}
}
