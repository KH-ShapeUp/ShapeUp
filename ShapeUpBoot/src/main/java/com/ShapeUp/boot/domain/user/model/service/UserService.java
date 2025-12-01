package com.ShapeUp.boot.domain.user.model.service;

import com.ShapeUp.boot.domain.user.model.vo.UserInterestVO;
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

    boolean isEmailExists(String email);

    UserVO login(String userId, String rawPassword);

    UserVO findUserByNameEmailPhone(String name, String email, String phone);

    int updateUserPassword(String userId, String encodedPw);

    // 🔥 추가: 아이디로만 사용자 조회
    UserVO findUserByUserId(String userId);
    
    UserVO selectUserByUserNo(int userNo);

    int updateUserEmail(int userNo, String email);

    int updateUserPhone(int userNo, String phone);

    int updateUserPasswordByUserNo(int userNo, String encodedPassword);

    int deleteUser(int userNo);
    
    int updateNickname(int userNo, String nickname);
    
    public int updateSocialUserInfo(UserVO user);
    
    UserInterestVO selectUserInterest(int userNo);
    
    int updateUserInterest(int userNo, String interests, String times);
    
    int updateUserType(int userNo, String userType);
}