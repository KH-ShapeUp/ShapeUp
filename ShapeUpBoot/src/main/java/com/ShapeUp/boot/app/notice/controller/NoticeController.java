package com.ShapeUp.boot.app.notice.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.ShapeUp.boot.app.activity.controller.ActivityController;
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
	public String showNoticeList(@RequestParam(value = "page", defaultValue = "1") int currentPage, Model model) {
		try {
			int totalCount = nService.getTotalCount();
			int boardCountPerPage = 10;
			int maxPage = totalCount % boardCountPerPage != 0 ? totalCount / boardCountPerPage + 1
					: totalCount / boardCountPerPage;
			maxPage = (int) Math.ceil((double) totalCount / boardCountPerPage);
			List<Notice> nList = nService.selectNoticeList(currentPage, boardCountPerPage);
			int naviCountPerPage = 10;
			int startnavi = ((currentPage - 1) / naviCountPerPage) * naviCountPerPage + 1;
			int endNavi = (startnavi - 1) + naviCountPerPage;
			if (endNavi > maxPage) {
				endNavi = maxPage;
			}
			model.addAttribute("totalCount", totalCount);
			model.addAttribute("maxPage", maxPage);
			model.addAttribute("currentPage", currentPage);
			model.addAttribute("startNavi", startnavi);
			model.addAttribute("endNavi", endNavi);
			model.addAttribute("nList", nList);
			return "notice/noticeList";
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
			return "common/error";
		}
	}

	@GetMapping("detail")
	public String showNoticeDetail(HttpSession session, @RequestParam("noticeNo") int noticeNo, Model model) {
		try {
			return "notice/noticeDetail";
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
		System.out.println("DTO 수신 확인");
		System.out.println("DTO to String(): " + noticeInsertDto.toString());
		try {
			if (userNoObj == null) {
				throw new IllegalStateException("로그인 세션에서 관리자 정보를 찾을 수 없습니다.");
			}
			int userNo = userNoObj.intValue();
			noticeInsertDto.setUserNo(userNo);
			int result = nService.insertNotice(noticeInsertDto);
			if (result > 0) {
				return "redirect:/notice/list";
			} else {
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
