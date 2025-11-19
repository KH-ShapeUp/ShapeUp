package com.ShapeUp.boot.domain.user.model.service;

import com.ShapeUp.boot.domain.user.model.vo.UserVO;

public interface UserService {

    int insertUser(UserVO user);

    int checkUserIdDuplicate(String userId);

    int checkNicknameDuplicate(String nickname);

    UserVO selectUserById(String userId);

    UserVO selectUserByEmail(String email);

    UserVO findUserByNameAndEmail(String name, String email);

    UserVO selectUserByIdAndNameAndEmail(String userId, String name, String email);

    int updatePassword(String userId, String encodedPassword);

    int selectUserNoByUserId(String userId);

    int insertUserInterest(int userNo, String interests, String times, String addresses);

    boolean sendEmailVerification(String email);

    boolean sendPhoneVerification(String phone);

    boolean resetPassword(String userId, String name, String email);

    // 🔹 로그인 메서드 추가
    UserVO login(String userId, String rawPassword);
}
