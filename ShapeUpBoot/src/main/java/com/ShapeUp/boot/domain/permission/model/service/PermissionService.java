package com.ShapeUp.boot.domain.permission.model.service;

import java.util.List;
import java.util.Map;

import com.ShapeUp.boot.domain.permission.model.vo.RequestPermission;

public interface PermissionService {
	List<Map<String, Object>> findByStatus(String status);
	Map<String, Object> findById(int requestNo);
	int approve(int requestNo);
	int reject(int requestNo, String rejectReason);
}
