package com.ShapeUp.boot.app.contact.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.domain.contact.model.service.ContactService;
import com.ShapeUp.boot.domain.contact.model.vo.ContactVO;
import com.ShapeUp.boot.domain.notification.model.service.NotificationService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/contact")
@RequiredArgsConstructor
public class ContactController {

    private final ContactService contactService;
    private final NotificationService notificationService;

    @GetMapping({"/list", ""})
    public String contactList() {
        return "Contact/contact";
    }

    @GetMapping("/write")
    public String contactWrite() {
        return "Contact/contact";
    }

	@GetMapping("/detail")
	public String contactDetail() {
		return "Contact/contactDetail";
	}

    // ----- User APIs -----
    @GetMapping("/api/list")
    @ResponseBody
    public ResponseEntity<?> apiList(@RequestParam(defaultValue = "1") int page,
                                     @RequestParam(defaultValue = "10") int size,
                                     HttpSession session) {
        Integer userNo = (Integer) session.getAttribute("userNo");
        if (userNo == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        List<ContactVO> items = contactService.selectContactList(userNo, page, size);
        int total = contactService.selectContactTotal(userNo);
        Map<String, Object> res = new HashMap<>();
        res.put("items", items);
        res.put("total", total);
        res.put("page", page);
        res.put("size", size);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/api/detail")
    @ResponseBody
    public ResponseEntity<?> apiDetail(@RequestParam(required = false) String contactNo, HttpSession session) {
        Integer userNo = (Integer) session.getAttribute("userNo");
        if (userNo == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        if (contactNo == null || contactNo.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("contactNo가 필요합니다.");
        }
        int id;
        try {
            id = Integer.parseInt(contactNo.trim());
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("contactNo 형식이 올바르지 않습니다.");
        }
        ContactVO detail = contactService.selectContactDetail(id, userNo);
        if (detail == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("문의가 없습니다.");
        }
        return ResponseEntity.ok(detail);
    }

    @PostMapping("/api/write")
    @ResponseBody
    public ResponseEntity<?> apiWrite(@RequestBody Map<String, String> payload, HttpSession session) {
        Integer userNo = (Integer) session.getAttribute("userNo");
        if (userNo == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        String title = payload.getOrDefault("title", "").trim();
        String content = payload.getOrDefault("content", "").trim();
        String category = payload.getOrDefault("category", "질문").trim();
        if (title.isEmpty() || content.isEmpty()) {
            return ResponseEntity.badRequest().body("제목과 내용을 입력해주세요.");
        }

        ContactVO vo = new ContactVO();
        vo.setUserNo(userNo);
        vo.setContactTitle(title);
        vo.setContactContent(content);
        vo.setCategory(category.isEmpty() ? "질문" : category);
        vo.setStatus("대기");
        vo.setDeleteYn("N");
        contactService.insertContact(vo);
        return ResponseEntity.ok("ok");
    }

    // ----- Admin APIs -----
    @GetMapping("/api/admin/list")
    @ResponseBody
    public ResponseEntity<?> apiAdminList(@RequestParam(defaultValue = "1") int page,
                                          @RequestParam(defaultValue = "10") int size,
                                          @RequestParam(required = false) String status,
                                          @RequestParam(required = false) String category) {
        List<ContactVO> items = contactService.selectAll(page, size, status, category);
        int total = contactService.selectAllTotal(status, category);
        Map<String, Object> res = new HashMap<>();
        res.put("items", items);
        res.put("total", total);
        res.put("page", page);
        res.put("size", size);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/api/admin/detail")
    @ResponseBody
    public ResponseEntity<?> apiAdminDetail(@RequestParam int contactNo) {
        ContactVO detail = contactService.selectContactDetailAdmin(contactNo);
        if (detail == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("문의가 없습니다.");
        }
        return ResponseEntity.ok(detail);
    }

    @PostMapping("/api/admin/answer")
    @ResponseBody
    public ResponseEntity<?> apiAdminAnswer(@RequestBody Map<String, String> payload) {
        int contactNo = Integer.parseInt(payload.getOrDefault("contactNo", "0"));
        String answerContent = payload.getOrDefault("answerContent", "").trim();
        if (contactNo <= 0 || answerContent.isEmpty()) {
            return ResponseEntity.badRequest().body("잘못된 요청입니다.");
        }
        ContactVO target = contactService.selectContactDetailAdmin(contactNo);
        contactService.updateAnswer(contactNo, answerContent, "완료");
        if (target != null) {
            String title = target.getContactTitle() != null && !target.getContactTitle().isBlank()
                    ? target.getContactTitle()
                    : "문의";
            String msg = title + " 의 답변이 등록되었습니다.";
            notificationService.create(
                target.getUserNo(),
                "CONTACT",
                (long) contactNo,
                "문의 답변 등록",
                msg,
                "/contact/detail?contactNo=" + contactNo
            );
        }
        return ResponseEntity.ok("ok");
    }
}
