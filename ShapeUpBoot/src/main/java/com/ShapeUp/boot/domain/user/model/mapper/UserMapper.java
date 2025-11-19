package com.ShapeUp.boot.domain.user.model.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.domain.user.model.vo.UserVO;

@Mapper
public interface UserMapper {

    UserVO selectUserById(@Param("userId") String userId);

    UserVO selectUserByEmail(@Param("email") String email);

    UserVO findUserByNameAndEmail(@Param("name") String name, @Param("email") String email);

    UserVO selectUserByIdAndNameAndEmail(@Param("userId") String userId,
                                         @Param("name") String name,
                                         @Param("email") String email);

    int insertUser(UserVO user);

    int checkUserIdDuplicate(@Param("userId") String userId);

    int checkNicknameDuplicate(@Param("nickname") String nickname);

    int updatePassword(@Param("userId") String userId, @Param("encodedPassword") String encodedPassword);

    int selectUserNoByUserId(@Param("userId") String userId);

    int insertUserInterest(@Param("userNo") int userNo,
                           @Param("interests") String interests,
                           @Param("times") String times,
                           @Param("addresses") String addresses);
}
