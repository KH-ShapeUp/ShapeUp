package com.ShapeUp.boot.app.user.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/session")
public class SessionController {

    @GetMapping("/user-type")
    public ResponseEntity<Map<String, Object>> getSessionUserType(HttpSession session) {
        String userType = (String) session.getAttribute("userType");
        Integer userNo = (Integer) session.getAttribute("userNo");

        if (userType == null) {
            return ResponseEntity.status(401).build();
        }

        Map<String, Object> body = new HashMap<>();
        body.put("userType", userType);
        body.put("userNo", userNo);
        return ResponseEntity.ok(body);
    }
}
