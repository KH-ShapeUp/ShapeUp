package com.ShapeUp.boot.domain.admin.user.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.admin.user.model.vo.AdminUserVO;

public interface AdminUserService {

    List<AdminUserVO> findAllUsers();

    AdminUserVO findUserByNo(int userNo);

    void changeUserStatus(int userNo, String status, java.sql.Timestamp updatedAt, Long banDays);

    void changeUserPassword(int userNo, String rawPassword);

    void changeUserType(int userNo, String userType);

    void updateUserProfile(int userNo, String userId, String userName, String userNickname, String userEmail, String userPhone, String userSerialNo, Integer userAge);
}
