package com.ShapeUp.boot.app.notice.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.ShapeUp.boot.*;
import com.ShapeUp.boot.app.notice.dto.NoticeInsertDto;
import com.ShapeUp.boot.domain.notice.model.service.NoticeService;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/notice")
@RequiredArgsConstructor
public class NoticeController {

	private final NoticeService nService;

	@GetMapping("/list")
	public String showNoticeList(@RequestParam(value = "page", defaultValue = "1") int currentPage, 
			@RequestParam(value = "category", required = false) String category,
			@RequestParam(value = "searchType", required = false) String searchType,
			@RequestParam(value = "searchKeyword", required = false) String searchKeyword,
			Model model) {
		try {
			int totalCount = nService.getTotalCount(category, searchType, searchKeyword);
			int boardCountPerPage = 5;
			int maxPage = (int) Math.ceil((double) totalCount / boardCountPerPage);
			List<Notice> nList = nService.selectNoticeList(currentPage, boardCountPerPage, category, searchType, searchKeyword);
			int naviCountPerPage = 10;
			int startnavi = ((currentPage - 1) / naviCountPerPage) * naviCountPerPage + 1;
			int endNavi = (startnavi - 1) + naviCountPerPage;
			if (endNavi > maxPage) {
				endNavi = maxPage;
			}
			System.out.println("Search Type: " + searchType);
			System.out.println("Search Keyword: " + searchKeyword);
			model.addAttribute("totalCount", totalCount);
			model.addAttribute("maxPage", maxPage);
			model.addAttribute("currentPage", currentPage);
			model.addAttribute("startNavi", startnavi);
			model.addAttribute("endNavi", endNavi);
			model.addAttribute("nList", nList);
			model.addAttribute("category", category);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchKeyword", searchKeyword);
			return "notice/noticeList";
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
			return "common/error";
		}
	}
	
	@GetMapping("/ajaxList")
	@ResponseBody
	public List<Notice> getNoticeListAjax( //return형 바꿔놨어요 확인해주세요
			@RequestParam(value = "page", defaultValue = "1") int currentPage
			, @RequestParam(value = "category", required = false) String category,
			@RequestParam(value = "searchType", required = false) String searchType,
			@RequestParam(value = "searchKeyword", required = false) String searchKeyword){
		try {
			int boardCountPerPage = 5;
//			List<Notice> nList = nService.selectNoticeList(currentPage, boardCountPerPage, category, searchType, searchKeyword);
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@GetMapping("detail")
	public String showNoticeDetail(HttpSession session, @RequestParam("noticeNo") int noticeNo, Model model) {
		try {
			Notice notice = nService.selectNoticeDetail(noticeNo);
			if(notice != null) {
				model.addAttribute("notice", notice);
				return "notice/noticeDetail";
			}
			else {
				model.addAttribute("errorMsg", "해당공지사항을 찾을 수 없습니다.");
				return "common/error";
			}
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
			return "common/error";
		}
	}

	@GetMapping("insert")
	public String showNoticeInsert(Model model, HttpSession session) {
		try {
			// 임시 테스트 코드
			session.setAttribute("관리자", 3);
			return "notice/noticeInsert";
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
			return "common/error";
		}
	}

	@PostMapping("insert")
	public String insertNotice(@ModelAttribute NoticeInsertDto noticeInsertDto, HttpSession session, Model model) {
		Integer userNoObj = (Integer) session.getAttribute("관리자");
		String category = noticeInsertDto.getNoticeCategory();
		String encodedCategory;
		System.out.println("DTO 수신 확인");
		System.out.println("DTO to String(): " + noticeInsertDto.toString());
		try {
			if (userNoObj == null) {
				throw new IllegalStateException("로그인 세션에서 관리자 정보를 찾을 수 없습니다.");
			}
			int userNo = userNoObj.intValue();
			encodedCategory = URLEncoder.encode(category, StandardCharsets.UTF_8.toString());
			noticeInsertDto.setUserNo(userNo);
			int result = nService.insertNotice(noticeInsertDto);
			if (result > 0) {
			} else {
				encodedCategory = "공지";
				model.addAttribute("errorMsg", "공지사항 등록 실패");
				return "common/error";
			}
		} catch (Exception e) {
			e.printStackTrace();
			String errorMessage = e.getMessage();
			if (e instanceof IllegalStateException) {
				errorMessage = "오류";
			}
			model.addAttribute("errorMsg", e.getMessage());
			return "common/error";
		}
		return "redirect:/notice/list?category=" + encodedCategory;
	}

	@GetMapping("update")
	public String showNoticeUpdate(@ModelAttribute Notice notice, Model model) {
		try {
			return "notice/noticeUpdate";
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
			return "common/error";
		}
	}
	
}
