package com.ShapeUp.boot.app.community.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class communityModifyDTO {
	private int communityNo;
	private String communityTitle;
	private String communityContent;
	private int userNo;
	private Timestamp updatedAt;
	private String communityType;
	private String communityStatus;
}
