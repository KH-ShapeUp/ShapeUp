package com.ShapeUp.boot.domain.permission.model.vo;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class RequestPermission {
	private int requestNo;
	private int userNo;
	private String requestType;
	private String requestStatus;
	private String requestReason;
	private String businessName;
	private String businessNumber;
	private String certificateType;
	private String certificateNumber;
	private String attachmentPath;
	private String attachmentOrigin;
	private String attachmentRename;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	private Timestamp processedAt;
	private String rejectReason;

	// joined user info
	private String userName;
	private String userId;
}
