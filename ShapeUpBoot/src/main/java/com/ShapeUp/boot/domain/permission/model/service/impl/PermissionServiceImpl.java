package com.ShapeUp.boot.domain.permission.model.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.permission.model.mapper.PermissionMapper;
import com.ShapeUp.boot.domain.permission.model.service.PermissionService;
import com.ShapeUp.boot.domain.notification.model.service.NotificationService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PermissionServiceImpl implements PermissionService {

	private final PermissionMapper pMapper;
	private final NotificationService notificationService;

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
			Map<String, Object> req = pMapper.findById(requestNo);
			if (req != null && req.get("userNo") != null) {
				int userNo = ((Number) req.get("userNo")).intValue();
				String requestType = (String) req.get("requestType");
				String typeText = "권한 신청";
				if ("STADIUM_MANAGER".equals(requestType)) typeText = "시설 관리자 권한 신청";
				if ("TRAINER".equals(requestType)) typeText = "트레이너 권한 신청";
				notificationService.create(
					userNo,
					"ROLE",
					(long) requestNo,
					"권한 신청 결과",
					typeText + "이(가) 승인되었습니다.",
					"/user/updateUserInfo"
				);
			}
		}
		return updated;
	}

	@Override
	public int reject(int requestNo, String rejectReason) {
		int updated = pMapper.reject(requestNo, rejectReason);
		if (updated > 0) {
			Map<String, Object> req = pMapper.findById(requestNo);
			if (req != null && req.get("userNo") != null) {
				int userNo = ((Number) req.get("userNo")).intValue();
				String requestType = (String) req.get("requestType");
				String typeText = "권한 신청";
				if ("STADIUM_MANAGER".equals(requestType)) typeText = "시설 관리자 권한 신청";
				if ("TRAINER".equals(requestType)) typeText = "트레이너 권한 신청";
				String msg = typeText + "이(가) 반려되었습니다.";
				if (rejectReason != null && !rejectReason.isBlank()) {
					msg += " 사유: " + rejectReason;
				}
				notificationService.create(
					userNo,
					"ROLE",
					(long) requestNo,
					"권한 신청 결과",
					msg,
					"/user/updateUserInfo"
				);
			}
		}
		return updated;
	}
}
