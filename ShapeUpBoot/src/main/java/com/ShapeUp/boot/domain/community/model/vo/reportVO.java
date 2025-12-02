package com.ShapeUp.boot.domain.community.model.vo;

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
public class reportVO {
	private int reportNo;			// 신고 구분 번호
	private String reportType;		// 게시판인지 댓글 신고인지 구분
	private Integer communityNo;		// 커뮤니티 번호 
	private Integer commentNo;			// 댓글 번호
	private int reporterNo;			// 신고자 번호
	private String reportReason;    // 신고 타입 (욕설, 성회롱, 비하 등등)
	private Timestamp createdAt;	// 신고 날짜
	private String reportStatus;	// 신고 처리 상태 기본(처리 대기) 'N', 처리 완료 'Y' 
}
