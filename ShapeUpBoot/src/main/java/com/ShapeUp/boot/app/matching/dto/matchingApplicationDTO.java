package com.ShapeUp.boot.app.matching.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class matchingApplicationDTO {
	private int matchingAppliNo; 	// 매칭 신청자 (세션)
	private int userNo;				// 매칭 게시글 작성자
	private int matchingNo;			// 매칭 게시글 번호
	private Timestamp createdAt;	// 신청 날짜
	private String acceptYn;		// 매칭 신청자 승인여부 기본값 : N 
}
