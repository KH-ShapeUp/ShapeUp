package com.ShapeUp.boot.domain.permission.model.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.permission.model.mapper.PermissionMapper;
import com.ShapeUp.boot.domain.permission.model.service.PermissionService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PermissionServiceImpl implements PermissionService {

	private final PermissionMapper pMapper;

	@Override
	public List<Map<String, Object>> findByStatus(String status) {
		return pMapper.findByStatus(status);
	}

	@Override
	public Map<String, Object> findById(int requestNo) {
		return pMapper.findById(requestNo);
	}

	@Override
	public int approve(int requestNo) {
		int updated = pMapper.approve(requestNo);
		if (updated > 0) {
			pMapper.applyRoleToUser(requestNo);
		}
		return updated;
	}

	@Override
	public int reject(int requestNo, String rejectReason) {
		return pMapper.reject(requestNo, rejectReason);
	}
}
