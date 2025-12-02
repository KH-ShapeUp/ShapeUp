package com.ShapeUp.boot.domain.report.model.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class Report {
	private Integer reportNo;
	private String reportType;
	private Integer communityNo;
	private Integer commentNo;
	private Integer reporterNo;
	private String reportReason;
	private Timestamp createdAt;
	private String reportStatus;

	// joined
	private String reporterId;
	private String authorId;
	private String commentContent;
	private Integer authorNo;
}
