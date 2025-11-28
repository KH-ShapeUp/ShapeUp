package com.ShapeUp.boot.app;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.app.matching.dto.matchingApplicationDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.domain.home.model.service.homeService;
import com.ShapeUp.boot.domain.matching.model.service.matchingService;
import com.ShapeUp.boot.domain.matching.model.vo.matchingVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class HomeController {
	
	private final homeService hService;
	private final matchingService mService;
	
	@GetMapping("/")
	public String homePage(Model model) {
		List<matchingListDTO> mList = hService.getMatchingList();
		System.out.println(mList);
		model.addAttribute("mList", mList);
		return "index";
	}
	
	@PostMapping("/home")
	@ResponseBody
	public int matchApply(@RequestBody matchingApplicationDTO mAppDTO, HttpSession session) {
		Integer loginUserNo = (Integer)session.getAttribute("userNo");
		
	
		// 매칭 작성자 가져오기 mapper
		int writerUserNo = mService.getWriterUserNo(mAppDTO.getMatchingNo());
		System.out.println("매칭 작성자" + writerUserNo);

		if(loginUserNo == null) {
			return -10;
		}
		
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
	
	@GetMapping("/map")
	public String mapPaeg() {
		return "map/map";
	}
}
