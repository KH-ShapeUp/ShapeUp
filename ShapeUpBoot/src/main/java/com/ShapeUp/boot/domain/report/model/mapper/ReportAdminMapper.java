package com.ShapeUp.boot.domain.report.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.domain.report.model.vo.Report;

@Mapper
public interface ReportAdminMapper {
	List<Report> selectReports(@Param("status") String status);
	int updateStatus(@Param("reportNo") int reportNo, @Param("status") String status);
	Report selectReportByNo(@Param("reportNo") int reportNo);
	int softDeleteCommunity(@Param("communityNo") int communityNo);
	int softDeleteComment(@Param("commentNo") int commentNo);
}
