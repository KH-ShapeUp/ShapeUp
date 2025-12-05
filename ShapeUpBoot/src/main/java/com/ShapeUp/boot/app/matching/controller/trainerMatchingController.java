package com.ShapeUp.boot.app.matching.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingDetailListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingListDTO;
import com.ShapeUp.boot.domain.matching.model.service.trainerMatchingService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/trainer")
@RequiredArgsConstructor
public class trainerMatchingController {
	private final trainerMatchingService tmService;
	
	/* 트레이닝 모집 페이지 이동 */
	@GetMapping("/matching/board")
	public String trainerMatchingPage(HttpSession session, Model model) {
		Integer userNo = (Integer)session.getAttribute("userNo");
		
		List<trainerMatchingListDTO> mList = tmService.trainerMatchingList();
		System.out.println("모집 리스트 "+mList);
		model.addAttribute("mList", mList);
		model.addAttribute("userNo", userNo);
		return "matching/trainerMatchingBoard";
	}
	
	/* 트레이닝 모집 삽입 페이지 이동 */
	@GetMapping("/matching/insert")
	public String trainerMatchingInserPage() {
		return "matching/trainerMatchingInsert";
	}
	
	/* 트레이닝 모집 삽입 */
	@PostMapping("/matching")
	@ResponseBody
	public int trainerInsert(@RequestBody matchingInsertDTO mDTO) {
		mDTO.setMatchingType("TRAINER");
		System.out.println("트레이너 매칭 삽입" + mDTO);
		return tmService.trainerMatchingInsert(mDTO);
	}
	
	/* 디테일 */
	@GetMapping("/matching/detail")
	public String trainerMatchingDetail(@RequestParam("boardNo") int matchingNo, HttpSession session, Model model) {
		/* 신청 버튼 로그인한 사람 정보 */
		Integer userNo = (Integer)session.getAttribute("userNo");
		model.addAttribute("userNo", userNo);
		
		/* 디테일 가져오기 */
		trainerMatchingDetailListDTO tmdList = tmService.trainerMatchingDetailList(matchingNo);
		model.addAttribute("mList", tmdList);
		
		System.out.println("디테일" + tmdList);
		return "matching/trainerMatchingDetail";
	}
}
