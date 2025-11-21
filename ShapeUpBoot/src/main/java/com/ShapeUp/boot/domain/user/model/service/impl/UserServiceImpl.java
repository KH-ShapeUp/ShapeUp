package com.ShapeUp.boot.domain.user.model.service.impl;

import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.ShapeUp.boot.domain.user.model.mapper.UserMapper;
import com.ShapeUp.boot.domain.user.model.service.UserService;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;
    private final BCryptPasswordEncoder passwordEncoder; // Bean 주입

    @Override
    public int insertUser(UserVO user) {
        return userMapper.insertUser(user);
    }

    @Override
    public int checkUserIdDuplicate(String userId) {
        return userMapper.checkUserIdDuplicate(userId);
    }

    @Override
    public int checkNicknameDuplicate(String nickname) {
        return userMapper.checkNicknameDuplicate(nickname);
    }

    @Override
    public UserVO selectUserById(String userId) {
        return userMapper.selectUserById(userId);
    }

    @Override
    public UserVO selectUserByEmail(String email) {
        return userMapper.selectUserByEmail(email);
    }

    @Override
    public UserVO findUserByNameAndEmail(String name, String email) {
        return userMapper.findUserByNameAndEmail(name, email);
    }

    @Override
    public UserVO selectUserByIdAndNameAndEmail(String userId, String name, String email) {
        return userMapper.selectUserByIdAndNameAndEmail(userId, name, email);
    }

    @Override
    public int updatePassword(String userId, String encodedPassword) {
        return userMapper.updatePassword(userId, encodedPassword);
    }

    @Override
    public int selectUserNoByUserId(String userId) {
        return userMapper.selectUserNoByUserId(userId);
    }

    @Override
    public int insertUserInterest(int userNo, String interests, String times, String addresses) {
        return userMapper.insertUserInterest(userNo, interests, times, addresses);
    }

    @Override
    public boolean sendEmailVerification(String email) {
        return false;
    }

    @Override
    public boolean sendPhoneVerification(String phone) {
        return false;
    }

    @Override
    public boolean resetPassword(String userId, String name, String email) {
        return false;
    }

    // 🔹 로그인 구현
    @Override
    public UserVO login(String userId, String rawPassword) {
        UserVO user = userMapper.selectUserById(userId);
        if (user != null && passwordEncoder.matches(rawPassword, user.getUserPw())) {
            return user; // 로그인 성공
        }
        return null; // 로그인 실패
    }
    
    @Override
    public boolean isEmailExists(String email) {
        return userMapper.countEmail(email) > 0;
    }
    
    @Override
    public UserVO findUserByNameEmailPhone(String name, String email, String phone) {
        Map<String, String> params = new HashMap<>();
        params.put("name", name);
        params.put("email", email);
        params.put("phone", phone);
        return userMapper.findUserByNameEmailPhone(params);
    }
}
