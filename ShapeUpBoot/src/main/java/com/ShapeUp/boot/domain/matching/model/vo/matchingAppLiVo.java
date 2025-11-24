package com.ShapeUp.boot.domain.matching.model.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class matchingAppLiVo {
	private int matchingAppliNo; 	// 매칭 신청자 (세션)
	private int userNo;				// 매칭 게시글 작성자
	private int matchingNo;			// 매칭 게시글 번호
	private Timestamp createdAt;	// 신청 날짜
	private String acceptYn;		// 매칭 신청자 승인여부 기본값 : N 
}
