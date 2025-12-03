package com.ShapeUp.boot.app.place.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ShapeUp.boot.domain.place.service.PlaceService;
import com.ShapeUp.boot.domain.place.vo.Place;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/place")
@RequiredArgsConstructor
public class PlaceController {
	
	private final PlaceService pService;

	@GetMapping("insert")
	public String insertPlace(Model model) {
		model.addAttribute("place", new Place());
		return "place/insertPlace";
	}
	
	@PostMapping("insert")
	public String insertPlace(
			@ModelAttribute("place") Place place,
			@RequestParam("placeImages") List<MultipartFile> placeImages,
			RedirectAttributes ra
			) {
		try {			
			int placeNo = pService.insertPlace(place, placeImages);
			
			if(placeNo > 0) {
				ra.addFlashAttribute("message", "시설이 성공적으로 등록되었습니다. (No: " + placeNo + ")");
				return "redirect:/place/list";
			}
			else {
				ra.addFlashAttribute("message", "시설 등록에 실패했습니다.");
				return "redirect:/place/insert";
			}
		} catch (Exception e) {
			ra.addFlashAttribute("message", "시설등록 중 오류가 발생했습니다. 로그확인");
			System.err.println("시설 등록 오류: " + e.getMessage());
            return "redirect:/place/insert";
		}
	}
}
