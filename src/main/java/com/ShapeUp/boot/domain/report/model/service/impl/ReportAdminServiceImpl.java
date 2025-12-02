package com.ShapeUp.boot.domain.report.model.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.report.model.mapper.ReportAdminMapper;
import com.ShapeUp.boot.domain.report.model.service.ReportService;
import com.ShapeUp.boot.domain.report.model.vo.Report;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportAdminServiceImpl implements ReportService {

	private final ReportAdminMapper reportAdminMapper;

	@Override
	public List<Report> findReports(String status) {
		return reportAdminMapper.selectReports(status);
	}

	@Override
	public int approve(int reportNo) {
		return reportAdminMapper.updateStatus(reportNo, "Y");
	}

	@Override
	public int reject(int reportNo) {
		return reportAdminMapper.updateStatus(reportNo, "X");
	}
}
