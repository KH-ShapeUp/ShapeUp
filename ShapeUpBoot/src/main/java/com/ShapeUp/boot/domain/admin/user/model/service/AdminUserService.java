package com.ShapeUp.boot.domain.admin.user.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.admin.user.model.vo.AdminUserVO;

public interface AdminUserService {

    List<AdminUserVO> findAllUsers();

    AdminUserVO findUserByNo(int userNo);

    void changeUserStatus(int userNo, String status);
}
