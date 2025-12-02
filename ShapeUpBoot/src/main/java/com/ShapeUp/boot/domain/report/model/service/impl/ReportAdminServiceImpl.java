package com.ShapeUp.boot.domain.report.model.service.impl;

import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ShapeUp.boot.domain.admin.user.model.service.AdminUserService;
import com.ShapeUp.boot.domain.report.model.mapper.ReportAdminMapper;
import com.ShapeUp.boot.domain.report.model.service.ReportService;
import com.ShapeUp.boot.domain.report.model.vo.Report;

import lombok.RequiredArgsConstructor;

@Service("reportAdminService")
@RequiredArgsConstructor
public class ReportAdminServiceImpl implements ReportService {

	private final ReportAdminMapper reportAdminMapper;
	private final AdminUserService adminUserService;

	@Override
	@Transactional(readOnly = true)
	public List<Report> findReports(String status) {
		return reportAdminMapper.selectReports(status);
	}

	@Override
	@Transactional
	public int approve(int reportNo, String userStatus, Long banDays) {
		Report target = reportAdminMapper.selectReportByNo(reportNo);
		if (target != null && target.getAuthorNo() != null && userStatus != null) {
			Timestamp until = null;
			if (banDays != null) {
				until = Timestamp.from(Instant.now().plus(banDays, ChronoUnit.DAYS));
			}
			adminUserService.changeUserStatus(target.getAuthorNo(), userStatus, until, banDays);
		}
		if (target != null) {
			if (target.getCommentNo() != null) {
				reportAdminMapper.softDeleteComment(target.getCommentNo());
			} else if (target.getCommunityNo() != null) {
				reportAdminMapper.softDeleteCommunity(target.getCommunityNo());
			}
		}
		return reportAdminMapper.updateStatus(reportNo, "Y");
	}

	@Override
	@Transactional
	public int reject(int reportNo) {
		return reportAdminMapper.updateStatus(reportNo, "X");
	}
}
