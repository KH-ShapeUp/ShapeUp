package com.ShapeUp.boot.app.admin.user.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.domain.admin.user.model.service.AdminUserService;
import com.ShapeUp.boot.domain.admin.user.model.vo.AdminUserVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminUserController {

    private final AdminUserService adminUserService;

    @GetMapping
    public ResponseEntity<List<AdminUserVO>> fetchUsers() {
        return ResponseEntity.ok(adminUserService.findAllUsers());
    }

    @PatchMapping("/{userNo}/status")
    public ResponseEntity<Void> updateUserStatus(
            @PathVariable int userNo,
            @RequestParam String status) {
        adminUserService.changeUserStatus(userNo, status);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{userNo}/password")
    public ResponseEntity<Void> updateUserPassword(
            @PathVariable int userNo,
            @RequestParam String password) {
        adminUserService.changeUserPassword(userNo, password);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{userNo}/type")
    public ResponseEntity<Void> updateUserType(
            @PathVariable int userNo,
            @RequestParam String userType) {
        adminUserService.changeUserType(userNo, userType);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{userNo}")
    public ResponseEntity<Void> updateUserProfile(
            @PathVariable int userNo,
            @RequestBody AdminUserVO payload) {
        adminUserService.updateUserProfile(
                userNo,
                payload.getUserId(),
                payload.getUserName(),
                payload.getUserNickname(),
                payload.getUserEmail(),
                payload.getUserPhone(),
                payload.getUserSerialNo(),
                payload.getUserAge()
        );
        return ResponseEntity.ok().build();
    }
}
