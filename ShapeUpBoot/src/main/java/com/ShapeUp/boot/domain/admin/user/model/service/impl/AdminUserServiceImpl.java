package com.ShapeUp.boot.domain.admin.user.model.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ShapeUp.boot.domain.admin.user.model.mapper.AdminUserMapper;
import com.ShapeUp.boot.domain.admin.user.model.service.AdminUserService;
import com.ShapeUp.boot.domain.admin.user.model.vo.AdminUserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminUserServiceImpl implements AdminUserService {

    private final AdminUserMapper adminUserMapper;

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
    public void changeUserStatus(int userNo, String status) {
        adminUserMapper.updateUserStatus(userNo, status);
    }
}
