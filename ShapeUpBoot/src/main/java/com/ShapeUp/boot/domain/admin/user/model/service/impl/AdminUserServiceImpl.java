package com.ShapeUp.boot.domain.admin.user.model.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.ShapeUp.boot.domain.admin.user.model.mapper.AdminUserMapper;
import com.ShapeUp.boot.domain.admin.user.model.service.AdminUserService;
import com.ShapeUp.boot.domain.admin.user.model.vo.AdminUserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminUserServiceImpl implements AdminUserService {

    private final AdminUserMapper adminUserMapper;
    private final BCryptPasswordEncoder passwordEncoder;

    @Override
    @Transactional(readOnly = true)
    public List<AdminUserVO> findAllUsers() {
        return adminUserMapper.selectAllUsers();
    }

    @Override
    @Transactional(readOnly = true)
    public AdminUserVO findUserByNo(int userNo) {
        return adminUserMapper.selectUserByNo(userNo);
    }

    @Override
    @Transactional
    public void changeUserStatus(int userNo, String status, java.sql.Timestamp updatedAt, Long banDays) {
        adminUserMapper.updateUserStatus(userNo, status, updatedAt, banDays);
    }

    @Override
    @Transactional
    public void changeUserPassword(int userNo, String rawPassword) {
        String encoded = passwordEncoder.encode(rawPassword);
        adminUserMapper.updateUserPassword(userNo, encoded);
    }

    @Override
    @Transactional
    public void changeUserType(int userNo, String userType) {
        adminUserMapper.updateUserType(userNo, userType);
    }

    @Override
    @Transactional
    public void updateUserProfile(int userNo, String userId, String userName, String userNickname, String userEmail, String userPhone, String userSerialNo, Integer userAge) {
        adminUserMapper.updateUserProfile(userNo, userId, userName, userNickname, userEmail, userPhone, userSerialNo, userAge);
    }
}
