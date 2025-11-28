package com.ShapeUp.boot.domain.community.model.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class communityVO {
	private int communityNo; 			// 커뮤니티 구분 번호
	private String communityTitle; 		// 커뮤니티 제목
	private String communityContent; 	// 커뮤니티 내용
	private int userNo;					// 게시글 작성자
	private Timestamp createdAt; 		// 작성일
	private Timestamp updatedAt; 		// 수정일
	private int viewCount; 				// 조회수
	private String communityType; 		// 커뮤니티 카테고리
	private String communityStatus;		// 커뮤니티 게시판 상태
}
