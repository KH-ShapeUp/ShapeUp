package com.ShapeUp.boot.domain.user.model.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ShapeUp.boot.domain.user.model.mapper.UserMapper;
import com.ShapeUp.boot.domain.user.model.service.UserService;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    // resetPassword에서만 필요
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public int insertUser(UserVO user) {
        // Controller에서 이미 암호화된 비밀번호를 전달받음
        return userMapper.insertUser(user);
    }

    @Override
    public boolean checkUserIdDuplicate(String userId) {
        int count = userMapper.checkUserIdDuplicate(userId);
        return count == 0;
    }

    @Override
    public boolean checkNicknameDuplicate(String nickname) {
        int count = userMapper.checkNicknameDuplicate(nickname);
        return count == 0;
    }

    @Override
    public boolean sendEmailVerification(String email) {
        String verificationCode = String.format("%06d", (int)(Math.random() * 1000000));
        System.out.println("이메일 인증번호: " + verificationCode);
        return true;
    }

    @Override
    public boolean sendPhoneVerification(String phone) {
        String verificationCode = String.format("%06d", (int)(Math.random() * 1000000));
        System.out.println("전화번호 인증번호: " + verificationCode);
        return true;
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
        return userMapper.selectUserByNameAndEmail(name, email);
    }

    @Override
    @Transactional
    public boolean resetPassword(String userId, String name, String email) {

        UserVO user = userMapper.selectUserByIdAndNameAndEmail(userId, name, email);

        if (user == null) {
            return false;
        }

        // 임시 비밀번호 생성
        String tempPassword = generateTempPassword();

        // 암호화
        String encodedPassword = passwordEncoder.encode(tempPassword);

        // DB 업데이트
        int result = userMapper.updatePassword(userId, encodedPassword);

        if (result > 0) {
            System.out.println("임시 비밀번호: " + tempPassword);
            System.out.println("이메일 발송 대상: " + email);
            return true;
        }

        return false;
    }

    private String generateTempPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder tempPassword = new StringBuilder();

        for (int i = 0; i < 8; i++) {
            int index = (int) (Math.random() * chars.length());
            tempPassword.append(chars.charAt(index));
        }

        return tempPassword.toString();
    }

	@Override
	public UserVO selectUserByIdAndNameAndEmail(String userId, String name, String email) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int updatePassword(String userId, String encodedPassword) {
		// TODO Auto-generated method stub
		return 0;
	}
}
