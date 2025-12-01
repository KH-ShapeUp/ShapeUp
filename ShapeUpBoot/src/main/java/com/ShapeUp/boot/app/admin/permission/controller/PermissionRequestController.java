package com.ShapeUp.boot.app.admin.permission.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.domain.permission.model.service.PermissionService;
import com.ShapeUp.boot.domain.permission.model.vo.RequestPermission;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin/permissions/requests")
@RequiredArgsConstructor
public class PermissionRequestController {

	private final PermissionService pService;

	@GetMapping
	public ResponseEntity<Map<String, Object>> list(@RequestParam(value = "status", required = false) String status) {
		List<Map<String, Object>> list = pService.findByStatus(status);
		return ResponseEntity.ok(Map.of("data", list));
	}

	@GetMapping("/{requestNo}")
	public ResponseEntity<Map<String, Object>> detail(@PathVariable int requestNo) {
		Map<String, Object> row = pService.findById(requestNo);
		return ResponseEntity.ok(Map.of("data", row));
	}

	@PostMapping("/{requestNo}/approve")
	public ResponseEntity<Map<String, Object>> approve(@PathVariable int requestNo) {
		int updated = pService.approve(requestNo);
		return ResponseEntity.ok(Map.of("success", updated > 0));
	}

	@PostMapping("/{requestNo}/reject")
	public ResponseEntity<Map<String, Object>> reject(@PathVariable int requestNo, @RequestBody Map<String, Object> body) {
		String reason = body != null ? (String) body.get("rejectReason") : null;
		int updated = pService.reject(requestNo, reason);
		return ResponseEntity.ok(Map.of("success", updated > 0));
	}
}
