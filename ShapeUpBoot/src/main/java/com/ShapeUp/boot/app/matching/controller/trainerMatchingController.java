package com.ShapeUp.boot.app.matching.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.app.matching.dto.matchingApplicationDTO;
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
	public String trainerMatchingPage(HttpSession session, Model model,
		    @RequestParam(value="pageNo", defaultValue="1") int currentPage,
	        @RequestParam(value="keyword", required = false) String keyword,
	        @RequestParam(value="category", required = false) String category) {
		
		Integer userNo = (Integer)session.getAttribute("userNo");
		String userType = (String)session.getAttribute("userType");
		System.out.println("판별"+userType);
		
		int boardLimit = 6;
		int naviLimit = 5;
		
		int totalCount = tmService.getTotalCount(category, keyword);
		
		int maxPage = (int)Math.ceil((double)totalCount / boardLimit);
		int startNavi = ((currentPage - 1)/ naviLimit) * naviLimit + 1;
		int endNavi = (startNavi - 1) + naviLimit;
		if(endNavi > maxPage) {endNavi = maxPage;}
		
		List<trainerMatchingListDTO> mList = tmService.trainerMatchingList(currentPage, boardLimit, category, keyword);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("category", category);
	    model.addAttribute("keyword", keyword);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("endNavi", endNavi);
		model.addAttribute("maxPage", maxPage);
		model.addAttribute("startNavi", startNavi);
		model.addAttribute("userType", userType);
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
		model.addAttribute("tmdList", tmdList);
		
		System.out.println("디테일" + tmdList);
		return "matching/trainerMatchingDetail";
	}
	
	/* 신청 */
	@PostMapping("/apply")
	@ResponseBody
	public int trainerApply(@RequestBody matchingApplicationDTO maDTO, HttpSession session) {
		Integer LoginUserNo = (Integer)session.getAttribute("userNo");
		
		/* 로그인 안하고 신청 */
		if(LoginUserNo == null) {
			return -99;
		}
		
		/* 자기쓴 매칭 신청 방지 */
		int writerUserNo = tmService.getWriterUserNo(maDTO.getMatchingNo());
		if (writerUserNo == LoginUserNo) {
			return -33;
		}
		
		/* 중복 방지 */
		int matchingNo = maDTO.getMatchingNo();
		int matchinDedupe = tmService.matchinDedpue(LoginUserNo, matchingNo);
		
		if(matchinDedupe > 0) {
			return -55;
		}
		
		maDTO.setMatchingAppliNo(LoginUserNo);
		int apply = tmService.matchingApply(maDTO);
		return apply;
	}
	
	/* 삭제 */
	@DeleteMapping("/detail")
	@ResponseBody
	public int deleteMatching(@RequestParam("matchingNo") int matchingNo) {
		return tmService.deleteMatching(matchingNo);
	}
}
