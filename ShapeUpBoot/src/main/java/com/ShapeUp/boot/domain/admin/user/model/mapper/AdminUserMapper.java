package com.ShapeUp.boot.domain.admin.user.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.domain.admin.user.model.vo.AdminUserVO;

@Mapper
public interface AdminUserMapper {

    List<AdminUserVO> selectAllUsers();

    AdminUserVO selectUserByNo(@Param("userNo") int userNo);

    int updateUserStatus(@Param("userNo") int userNo, @Param("status") String status);

    int updateUserPassword(@Param("userNo") int userNo, @Param("userPw") String userPw);

    int updateUserType(@Param("userNo") int userNo, @Param("userType") String userType);

    int updateUserProfile(
            @Param("userNo") int userNo,
            @Param("userId") String userId,
            @Param("userName") String userName,
            @Param("userNickname") String userNickname,
            @Param("userEmail") String userEmail,
            @Param("userPhone") String userPhone,
            @Param("userSerialNo") String userSerialNo,
            @Param("userAge") Integer userAge
    );
}
