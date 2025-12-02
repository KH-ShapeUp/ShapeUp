package com.ShapeUp.boot.app.notice.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.domain.notice.model.service.NoticeService;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/notices")
@RequiredArgsConstructor
@Slf4j
public class NoticePublicApiController {

	private final NoticeService noticeService;

	@GetMapping("/latest")
	public ResponseEntity<Map<String, Object>> latest(@RequestParam(defaultValue = "5") int limit) {
		int safeLimit = Math.max(1, Math.min(limit, 20));
		Map<String, Object> body = new HashMap<>();
		try {
			List<Notice> items = noticeService.selectLatestNotices(safeLimit);
			body.put("items", items);
			return ResponseEntity.ok(body);
		} catch (Exception e) {
			log.error("latest notice load fail", e);
			body.put("items", List.of());
			body.put("error", "fail");
			body.put("message", e.getMessage());
			return ResponseEntity.internalServerError().body(body);
		}
	}
}
