package com.ShapeUp.boot.domain.permission.model.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.domain.permission.model.vo.RequestPermission;

@Mapper
public interface PermissionMapper {

	List<Map<String, Object>> findByStatus(@Param("status") String status);

	int approve(@Param("requestNo") int requestNo);

	int applyRoleToUser(@Param("requestNo") int requestNo);

	int reject(@Param("requestNo") int requestNo, @Param("rejectReason") String rejectReason);

	int updateProcessedAt(@Param("requestNo") int requestNo);

	Map<String, Object> findById(@Param("requestNo") int requestNo);
}
