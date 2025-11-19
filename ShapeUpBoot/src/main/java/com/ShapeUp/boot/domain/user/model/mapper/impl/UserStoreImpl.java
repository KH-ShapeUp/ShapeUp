package com.ShapeUp.boot.domain.user.model.mapper.impl;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ShapeUp.boot.domain.user.model.mapper.UserStore;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;

@Repository
public class UserStoreImpl implements UserStore {
    
    @Autowired
    private SqlSession sqlSession;
    
    @Override
    public int insertUser(UserVO user) {
        return sqlSession.insert("UserMapper.insertUser", user);
    }
    
    @Override
    public int checkUserIdDuplicate(String userId) {
        return sqlSession.selectOne("UserMapper.checkUserIdDuplicate", userId);
    }
    
    @Override
    public int checkNicknameDuplicate(String nickname) {
        return sqlSession.selectOne("UserMapper.checkNicknameDuplicate", nickname);
    }
    
    @Override
    public UserVO selectUserById(String userId) {
        return sqlSession.selectOne("UserMapper.selectUserById", userId);
    }
    
    @Override
    public UserVO selectUserByEmail(String email) {
        return sqlSession.selectOne("UserMapper.selectUserByEmail", email);
    }
    
    @Override
    public UserVO selectUserByNameAndEmail(String name, String email) {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        params.put("name", name);
        params.put("email", email);
        return sqlSession.selectOne("UserMapper.selectUserByNameAndEmail", params);
    }
    
    @Override
    public UserVO selectUserByIdAndNameAndEmail(String userId, String name, String email) {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        params.put("userId", userId);
        params.put("name", name);
        params.put("email", email);
        return sqlSession.selectOne("UserMapper.selectUserByIdAndNameAndEmail", params);
    }
    
    @Override
    public int updatePassword(String userId, String encodedPassword) {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        params.put("userId", userId);
        params.put("userPw", encodedPassword);
        return sqlSession.update("UserMapper.updatePassword", params);
    }
}