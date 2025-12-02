package com.ShapeUp.boot.app.admin.report.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.domain.report.model.service.ReportService;
import com.ShapeUp.boot.domain.report.model.vo.Report;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin/reports")
@RequiredArgsConstructor
public class ReportAdminController {

	private final ReportService reportService;
	private static final SimpleDateFormat DF = new SimpleDateFormat("yy.MM.dd");

	private String formatDate(Date d) {
		if (d == null) return "";
		try {
			return DF.format(d);
		} catch (Exception e) {
			return "";
		}
	}

	@GetMapping
	public ResponseEntity<Map<String, Object>> list(@RequestParam(required = false) String status) {
		List<Report> rows = reportService.findReports(status);
		List<Map<String, Object>> items = rows.stream().map(r -> {
			Map<String, Object> m = new HashMap<>();
			m.put("id", r.getReportNo());
			m.put("category", (r.getCommentNo() != null ? "댓글" : "커뮤니티"));
			m.put("reporter", r.getReporterId());
			m.put("author", r.getAuthorId());
			m.put("reason", r.getReportReason());
			m.put("date", formatDate(r.getCreatedAt()));
			m.put("status", r.getReportStatus());
			m.put("communityNo", r.getCommunityNo());
			m.put("commentNo", r.getCommentNo());
			m.put("commentContent", r.getCommentContent());
			// 링크는 커뮤니티 번호 기준
			Integer cNo = r.getCommunityNo();
			if (cNo == null && r.getCommentNo() != null) {
				// comment join으로 communityNo가 없는 경우 방어
				// 프론트에서 처리
			}
			if (cNo != null) {
				m.put("link", "/community/detail?boardNo=" + cNo);
			}
			return m;
		}).collect(Collectors.toList());
		Map<String, Object> body = new HashMap<>();
		body.put("items", items);
		return ResponseEntity.ok(body);
	}

	@PostMapping("/{reportNo}/approve")
	public ResponseEntity<Map<String, Object>> approve(
			@PathVariable int reportNo,
			@RequestParam(defaultValue = "정지") String userStatus,
			@RequestParam(required = false) Long banDays) {
		int res = reportService.approve(reportNo, userStatus, banDays);
		return ResponseEntity.ok(Map.of("success", res > 0));
	}

	@PostMapping("/{reportNo}/reject")
	public ResponseEntity<Map<String, Object>> reject(@PathVariable int reportNo) {
		int res = reportService.reject(reportNo);
		return ResponseEntity.ok(Map.of("success", res > 0));
	}
}
