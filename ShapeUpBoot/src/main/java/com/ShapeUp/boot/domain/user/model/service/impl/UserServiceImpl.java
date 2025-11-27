package com.ShapeUp.boot.domain.user.model.service.impl;

import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.Map;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import com.ShapeUp.boot.domain.user.model.mapper.UserMapper;
import com.ShapeUp.boot.domain.user.model.service.UserService;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    
    private final UserMapper userMapper;
    private final BCryptPasswordEncoder passwordEncoder;

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

    @Override
    public UserVO login(String userId, String rawPassword) {
        UserVO user = userMapper.selectUserById(userId);
        if (user != null && passwordEncoder.matches(rawPassword, user.getUserPw())) {
            return user;
        }
        return null;
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
    
    @Override
    public int updateUserPassword(String userId, String encodedPw) {
        log.info("🔄 Service - 비밀번호 업데이트 호출 - userId: {}", userId);
        int result = userMapper.updateUserPassword(userId, encodedPw);
        log.info("✅ Service - 업데이트 결과: {}", result);
        return result;
    }

    // 🔥 추가: 아이디로만 사용자 조회
    @Override
    public UserVO findUserByUserId(String userId) {
        log.info("🔍 Service - 아이디로 사용자 조회 - userId: {}", userId);
        UserVO user = userMapper.findUserByUserId(userId);
        if (user != null) {
            log.info("✅ Service - 사용자 찾음 - userName: {}, email: {}", 
                    user.getUserName(), user.getUserEmail());
        } else {
            log.warn("❌ Service - 사용자 없음");
        }
        return user;
    }
    
    @Override
    public UserVO selectUserByUserNo(int userNo) {
        log.info("🔍 Service - userNo로 사용자 조회 - userNo: {}", userNo);
        return userMapper.selectUserByUserNo(userNo);
    }

    @Override
    public int updateUserEmail(int userNo, String email) {
        log.info("🔄 Service - 이메일 업데이트 - userNo: {}, email: {}", userNo, email);
        return userMapper.updateUserEmail(userNo, email);
    }

    @Override
    public int updateUserPhone(int userNo, String phone) {
        log.info("🔄 Service - 전화번호 업데이트 - userNo: {}, phone: {}", userNo, phone);
        return userMapper.updateUserPhone(userNo, phone);
    }

    @Override
    public int updateUserPasswordByUserNo(int userNo, String encodedPassword) {
        log.info("🔄 Service - 비밀번호 업데이트 - userNo: {}", userNo);
        return userMapper.updateUserPasswordByUserNo(userNo, encodedPassword);
    }

    @Override
    public int deleteUser(int userNo) {
        log.info("🗑️ Service - 회원 탈퇴 - userNo: {}", userNo);
        return userMapper.deleteUser(userNo);
    }
    @Override
    public int updateNickname(int userNo, String nickname) {
        log.info("🔄 Service - 닉네임 업데이트 - userNo: {}, nickname: {}", userNo, nickname);
        return userMapper.updateNickname(userNo, nickname);
    }
}