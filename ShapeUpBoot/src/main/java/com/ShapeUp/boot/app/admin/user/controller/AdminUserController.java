package com.ShapeUp.boot.app.admin.user.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.domain.admin.user.model.service.AdminUserService;
import com.ShapeUp.boot.domain.admin.user.model.vo.AdminUserVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
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
}
