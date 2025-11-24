package com.ShapeUp.boot.app.matching.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;



import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;

import com.ShapeUp.boot.domain.matching.model.service.matchingService;
import com.ShapeUp.boot.domain.matching.model.vo.matchingAppLiVo;
import com.ShapeUp.boot.domain.matching.model.vo.matchingVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class matchingController {

	private final matchingService mService;

	// 매칭 페이지 이동
	@GetMapping("/matching/board")
	public String matchingPage() {
		return "matching/matchingBoard";
	}

	// 매칭 글 작성 페이지 이동
	@GetMapping("/matching/insert")
	public String matchingInsertPage(Model model) {
		List<ActivityVO> aList = mService.matchingCategory();
		System.out.println("가져온 카테고리" + aList);
		model.addAttribute("aList", aList);
		return "matching/matchingInsert";
	}

	// 매칭 글 삽입
	@PostMapping("/matching")
	@ResponseBody
	@Transactional
	public int matchingInsert(@RequestBody matchingInsertDTO mDTO, HttpSession session) {
		int userNo = (int) session.getAttribute("userNo");
		System.out.println(mDTO);
		mDTO.setUserNo(userNo);
		int result = mService.matchingInsert(mDTO);
		return result;
	}

	// 카테고리 검색
	@GetMapping("/matching/search")
	@ResponseBody
	public List<ActivityVO> searchCategory(@RequestParam String keyword) {
		List<ActivityVO> aList = mService.searchCategory(keyword);
	
		System.out.println("검색 카테고리 : "+aList + "\n" + "넘어온 키워드 : " + keyword);
		return aList;
	}

	// 매칭 리스트
	@GetMapping("/matching/list")
	@ResponseBody
	public Map<String, Object> matchingList(matchingListDTO mDTO, @RequestParam("page") int currentPage) {
		int matchBoardLimit = 5;
		int naviLimit = 5;
		int getTotalCount = mService.getTotalCount();
		int maxPage = (int)Math.ceil((double)getTotalCount/matchBoardLimit);
		int startNavi = ((currentPage - 1)/naviLimit) * naviLimit + 1;
		int endNavi = (startNavi-1) + naviLimit;
		if(endNavi > maxPage) {endNavi = maxPage;}
		List<matchingListDTO> mList = mService.matchingList(currentPage, matchBoardLimit);
		System.out.println("가져온 매칭 리스트" + mList);
		
		// 매칭 신청 인원 카운트
		
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println();
		result.put("mList", mList);
		result.put("currentPage", currentPage);
		result.put("maxPage", maxPage);
		result.put("startNavi", startNavi);
		result.put("endNavi", endNavi);
		
		return result;
	}
	
	// 매칭 신청
	@PostMapping("/matching/application")
	@ResponseBody
	public int matchApplication(@RequestBody matchingAppLiVo mAppDTO, HttpSession session) {
		// 로그인한 사용자 유저 번호 가져오기
		int loginUserNo = (int)session.getAttribute("userNo");

		// 매칭 작성자 가져오기 mapper
		int writerUserNo = mService.getWriterUserNo(mAppDTO.getMatchingNo());
		System.out.println("매칭 작성자" + writerUserNo);

		if (loginUserNo == writerUserNo) {
			return -1;
		}
		
		// 매칭 중복 신청 불가능
		int matchingNo = mAppDTO.getMatchingNo();
		int matchDedupe = mService.matchDedupe(loginUserNo, matchingNo);
		
		if(matchDedupe > 0) {
			return -2;
		}
		
		mAppDTO.setMatchingAppliNo(loginUserNo);
		return mService.matchApplication(mAppDTO);
	}
}
