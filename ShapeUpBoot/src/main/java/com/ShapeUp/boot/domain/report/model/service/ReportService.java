package com.ShapeUp.boot.domain.report.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.report.model.vo.Report;

public interface ReportService {
	List<Report> findReports(String status);
	int approve(int reportNo, String userStatus, Long banDays);
	int reject(int reportNo);
}
