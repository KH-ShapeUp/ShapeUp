package com.ShapeUp.boot.app;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.app.matching.dto.matchingApplicationDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.app.success.dto.successListDTO;
import com.ShapeUp.boot.domain.community.model.vo.communityVO;
import com.ShapeUp.boot.domain.home.model.service.homeService;
import com.ShapeUp.boot.domain.matching.model.service.matchingService;
import com.ShapeUp.boot.domain.matching.model.vo.matchingVO;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class HomeController {
	
	private final homeService hService;
	private final matchingService mService;
	/* 이용약관 */
	@GetMapping("/terms")
	public String termsUsePage() {
		return "include/TermsOfUse";
	}
	
	@GetMapping("/")
	public String homePage(Model model) {
		/* 매칭 리스트 가져오기 */
		List<matchingListDTO> mList = hService.getMatchingList();
		model.addAttribute("mList", mList);
		
		/* 커뮤니티 리스트 가져오기 */
		List<communityListDTO> cList = hService.getCommunityList();
		model.addAttribute("cList", cList);
		
		/* 성공 후기 리스트 가져오기 */
		List<successListDTO> sList = hService.getSuccessList();
		model.addAttribute("sList", sList);

		/* 공지 리스트 가져오기 */
		List<Notice> nList = hService.getNoticeList();
		model.addAttribute("nList", nList);
		return "index";
	}

	@GetMapping("/intro")
	public String introPage() {
		return "introduce";
	}
	
	/* 매칭 신청 버튼 */
	@PostMapping("/home")
	@ResponseBody
	public int matchApply(@RequestBody matchingApplicationDTO mAppDTO, HttpSession session) {
		Integer loginUserNo = (Integer)session.getAttribute("userNo");
		
		// 매칭 작성자 가져오기 mapper
		int writerUserNo = mService.getWriterUserNo(mAppDTO.getMatchingNo());

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
	public String mapPage() {
		return "map/map";
	}
	
}

