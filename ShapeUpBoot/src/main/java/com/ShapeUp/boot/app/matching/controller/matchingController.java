package com.ShapeUp.boot.app.matching.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.app.matching.dto.matchingApplicationDTO;
import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;

import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;
import com.ShapeUp.boot.domain.matching.model.service.matchingService;
import com.ShapeUp.boot.domain.matching.model.vo.matchingAppLiVo;
import com.ShapeUp.boot.domain.matching.model.vo.matchingVO;
import com.ShapeUp.boot.domain.user.model.service.UserService;
import com.ShapeUp.boot.domain.user.model.vo.UserProfileImageVO;   // ⭐ 추가

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class matchingController {

    private final matchingService mService;
    private final UserService userService;

	// 매칭 페이지 이동
	@GetMapping("/matching/board")
	public String matchingPage(HttpSession session, Model model) {
		Integer userNo = (Integer)session.getAttribute("userNo");
		model.addAttribute("userNo", userNo);

        // ⭐ 프로필 이미지 조회 추가
        if (userNo != null) {
            String userProfileImg = userService.getUserProfileImg(userNo);
            model.addAttribute("userProfileImg", userProfileImg);
        }

		return "matching/matchingBoard";
	}

	// 매칭 글 작성 페이지 이동
	@GetMapping("/matching/insert")
	public String matchingInsertPage(Model model, HttpSession session) {
		List<ActivityVO> aList = mService.matchingCategory();
		System.out.println("가져온 카테고리" + aList);
		model.addAttribute("aList", aList);

        // ⭐ 프로필 이미지 조회 추가
        Integer userNo = (Integer) session.getAttribute("userNo");
        if (userNo != null) {
            String userProfileImg = userService.getUserProfileImg(userNo);
            model.addAttribute("userProfileImg", userProfileImg);
        }

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

	// ⭐⭐⭐ 매칭 리스트 (프로필 이미지 추가)
	@GetMapping("/matching/list")
	@ResponseBody
	public Map<String, Object> matchingList(matchingListDTO mDTO, HttpSession session,
	        @RequestParam("page") int currentPage,
	        @RequestParam(required = false, defaultValue = "") String location,
	        @RequestParam(required = false, defaultValue = "") String time,
	        @RequestParam(required = false, defaultValue = "") String level,
	        @RequestParam(required = false, defaultValue = "") String sort,
	        @RequestParam(required = false, defaultValue = "N") String deleteYn) {

	    int matchBoardLimit = 5;
	    int naviLimit = 5;

	    int getTotalCount = mService.getTotalCount(location, time, level, deleteYn);

	    int maxPage = (int)Math.ceil((double)getTotalCount/matchBoardLimit);
	    int startNavi = ((currentPage - 1)/naviLimit) * naviLimit + 1;
	    int endNavi = (startNavi-1) + naviLimit;
	    if(endNavi > maxPage) {endNavi = maxPage;}

	    List<matchingListDTO> mList = mService.matchingList(currentPage, matchBoardLimit, location, time, level, sort, deleteYn);

	    // ⭐⭐⭐ 각 매칭 게시글에 프로필 이미지 정보 추가
	    for (matchingListDTO matching : mList) {
	        int writerUserNo = matching.getUserNo();  // 작성자 번호
	        
	        // UserService를 통해 프로필 이미지 조회
	        UserProfileImageVO profileImage = userService.getProfileImage(writerUserNo);
	        
	        if (profileImage != null) {
	            // 프로필 이미지 전체 경로 설정
	            String fullPath = profileImage.getImgPath() + "/" + profileImage.getImgRename();
	            matching.setUserProfileImg(fullPath);
	            System.out.println("✅ 프로필 이미지 설정 - userNo: " + writerUserNo + ", path: " + fullPath);
	        } else {
	            // 기본 프로필 이미지 경로 설정
	            matching.setUserProfileImg("/resources/img/default-profile.png");
	            System.out.println("⚠️ 기본 프로필 이미지 설정 - userNo: " + writerUserNo);
	        }
	    }

	    Map<String, Object> result = new HashMap<String, Object>();
	    result.put("mList", mList);
	    result.put("currentPage", currentPage);
	    result.put("maxPage", maxPage);
	    result.put("startNavi", startNavi);
	    result.put("endNavi", endNavi);

	    result.put("location", location);
	    result.put("time", time);
	    result.put("level", level);
	    result.put("sort", sort);

	    return result;
	}


	// 매칭 신청
	@PostMapping("/matching/application")
	@ResponseBody
	public int matchApplication(@RequestBody matchingApplicationDTO mAppDTO, HttpSession session) {
		Integer loginUserNo = (Integer)session.getAttribute("userNo");
		System.out.println(loginUserNo);
		
		int writerUserNo = mService.getWriterUserNo(mAppDTO.getMatchingNo());
		System.out.println("매칭 작성자" + writerUserNo);

		if(loginUserNo == null) {
			return -10;
		}
		
		if (loginUserNo == writerUserNo) {
			return -1;
		}
		
		int matchingNo = mAppDTO.getMatchingNo();
		int matchDedupe = mService.matchDedupe(loginUserNo, matchingNo);
		
		if(matchDedupe > 0) {
			return -2;
		}
		
		mAppDTO.setMatchingAppliNo(loginUserNo);
		return mService.matchApplication(mAppDTO);
	}
	// 매칭 삭제
	@DeleteMapping("/matching/delete")
	@ResponseBody
	public int matchingDelete(@RequestParam("matchingNo") int matchingNo) {
		return mService.matchingDelete(matchingNo);
	}

	// 매칭 삭제/복구
	@RequestMapping(value = "/matching/delete", method = { RequestMethod.POST, RequestMethod.PATCH })
	@ResponseBody
	public int updateDeleteYn(@RequestParam int matchingNo, @RequestParam String deleteYn) {
		return mService.updateDeleteYn(matchingNo, deleteYn);
	}
	
	// 예약 취소
	@DeleteMapping("/apply/cancel")
	@ResponseBody
	public int applyDelete(@RequestParam("matchingNo") int matchingNo,
			@RequestParam("userNo") int userNo) {
		return mService.applyDelete(matchingNo, userNo);
	}
}
