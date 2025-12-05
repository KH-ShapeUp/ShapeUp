package com.ShapeUp.boot.app.notification.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.domain.notification.model.service.NotificationService;
import com.ShapeUp.boot.domain.notification.model.vo.NotificationVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping("/recent")
    public ResponseEntity<?> recent(@RequestParam(defaultValue = "5") int limit, HttpSession session) {
        Integer userNo = (Integer) session.getAttribute("userNo");
        if (userNo == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        List<NotificationVO> list = notificationService.getRecentUnread(userNo, limit);
        Map<String, Object> res = new HashMap<>();
        res.put("items", list);
        res.put("count", list.size());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/read")
    public ResponseEntity<?> markRead(@RequestBody Map<String, Object> payload, HttpSession session) {
        Integer userNo = (Integer) session.getAttribute("userNo");
        if (userNo == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }
        Object idObj = payload.get("notiNo");
        long notiNo = 0L;
        if (idObj != null) {
            notiNo = Long.parseLong(String.valueOf(idObj));
        }
        if (notiNo <= 0) {
            return ResponseEntity.badRequest().body("notiNo가 필요합니다.");
        }
        boolean ok = notificationService.markRead(notiNo, userNo);
        return ResponseEntity.ok(Map.of("success", ok));
    }
}
