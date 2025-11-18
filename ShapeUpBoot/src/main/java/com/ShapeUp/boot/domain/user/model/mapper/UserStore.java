package com.ShapeUp.boot.domain.user.model.mapper;

import com.ShapeUp.boot.domain.user.model.vo.UserVO;

public interface UserStore {
    
    /**
     * 회원가입
     * @param user 회원 정보
     * @return 성공 시 1, 실패 시 0
     */
    int insertUser(UserVO user);
    
    /**
     * 아이디 중복 체크
     * @param userId 아이디
     * @return 중복 개수
     */
    int checkUserIdDuplicate(String userId);
    
    /**
     * 닉네임 중복 체크
     * @param nickname 닉네임
     * @return 중복 개수
     */
    int checkNicknameDuplicate(String nickname);
    
    /**
     * 아이디로 회원 조회
     * @param userId 아이디
     * @return User 객체
     */
    UserVO selectUserById(String userId);
    
    /**
     * 이메일로 회원 조회
     * @param email 이메일
     * @return User 객체
     */
    UserVO selectUserByEmail(String email);
    
    /**
     * 이름과 이메일로 회원 조회 (아이디 찾기)
     * @param name 이름
     * @param email 이메일
     * @return User 객체
     */
    UserVO selectUserByNameAndEmail(String name, String email);
    
    /**
     * 아이디, 이름, 이메일로 회원 조회 (비밀번호 찾기)
     * @param userId 아이디
     * @param name 이름
     * @param email 이메일
     * @return User 객체
     */
    UserVO selectUserByIdAndNameAndEmail(String userId, String name, String email);
    
    /**
     * 비밀번호 업데이트
     * @param userId 아이디
     * @param encodedPassword 암호화된 비밀번호
     * @return 성공 시 1
     */
    int updatePassword(String userId, String encodedPassword);
}