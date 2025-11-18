package com.ShapeUp.boot.domain.user.model.service;

import com.ShapeUp.boot.domain.user.model.vo.UserVO;

public interface UserService {
    int insertUser(UserVO user);
    boolean checkUserIdDuplicate(String userId);
    boolean checkNicknameDuplicate(String nickname);
    UserVO selectUserById(String userId);
    UserVO selectUserByEmail(String email);
    UserVO findUserByNameAndEmail(String name, String email);
    UserVO selectUserByIdAndNameAndEmail(String userId, String name, String email);
    int updatePassword(String userId, String encodedPassword);

    // 새로 추가
    boolean sendEmailVerification(String email);
    boolean sendPhoneVerification(String phone);
    boolean resetPassword(String userId, String name, String email);
}