package com.ShapeUp.boot.domain.user.model.mapper;

import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;

@Mapper
public interface UserMapper {

    int insertUser(UserVO user);

    int checkUserIdDuplicate(@Param("userId") String userId);

    int checkNicknameDuplicate(@Param("nickname") String nickname);

    UserVO selectUserById(@Param("userId") String userId);

    UserVO selectUserByEmail(@Param("email") String email);

    UserVO findUserByNameAndEmail(@Param("name") String name, @Param("email") String email);

    UserVO selectUserByIdAndNameAndEmail(@Param("userId") String userId, 
                                         @Param("name") String name, 
                                         @Param("email") String email);

    int updatePassword(@Param("userId") String userId, 
                      @Param("encodedPassword") String encodedPassword);

    int selectUserNoByUserId(@Param("userId") String userId);

    int insertUserInterest(@Param("userNo") int userNo, 
                          @Param("interests") String interests, 
                          @Param("times") String times, 
                          @Param("addresses") String addresses);

    int countEmail(@Param("email") String email);

    UserVO findUserByNameEmailPhone(Map<String, String> params);

    // 🔥 추가: 아이디로만 사용자 조회
    UserVO findUserByUserId(@Param("userId") String userId);

    // 🔥 추가: 비밀번호 업데이트 (다른 이름)
    int updateUserPassword(@Param("userId") String userId, 
                          @Param("encodedPw") String encodedPw);
    
    UserVO selectUserByUserNo(@Param("userNo") int userNo);

    int updateUserEmail(@Param("userNo") int userNo, @Param("email") String email);

    int updateUserPhone(@Param("userNo") int userNo, @Param("phone") String phone);

    int updateUserPasswordByUserNo(@Param("userNo") int userNo, 
                                    @Param("encodedPassword") String encodedPassword);

    int deleteUser(@Param("userNo") int userNo);
    
    int updateNickname(@Param("userNo") int userNo, @Param("nickname") String nickname);
    
    UserVO findByUserId(String userId);
    
    int insertSocialUser(UserVO user);
    
    void updateSocialUserInfo(UserVO user);

}