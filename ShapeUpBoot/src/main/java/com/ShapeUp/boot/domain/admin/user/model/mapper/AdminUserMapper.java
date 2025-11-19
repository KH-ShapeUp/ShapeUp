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
}
