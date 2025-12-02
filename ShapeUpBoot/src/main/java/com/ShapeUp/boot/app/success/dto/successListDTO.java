package com.ShapeUp.boot.app.success.dto;

import java.sql.Timestamp;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class successListDTO {
	private int communityNo; 			// 커뮤니티 구분 번호
	private String communityTitle; 		// 커뮤니티 제목
	private String communityContent; 	// 커뮤니티 내용
	private int userNo;					// 게시글 작성자
	private Timestamp createdAt; 		// 작성일
	private Timestamp updatedAt; 		// 수정일
	private int viewCount; 				// 조회수
	private String communityType; 		// 커뮤니티 카테고리
	private String communityStatus;		// 커뮤니티 게시판 상태
	private String successType;
	private String goalDate;
	
	private String userNickName;	
	private int likeCount;
	private String timeAgo;      		// 상대 시간 문자열
	private int commentCount;
	
	private String thumbnail; 			// 썸네일
	private int  popularBoard;   		// 조회수/댓글수 중 큰 값

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getTimeAgo() { return timeAgo; }
    public void setTimeAgo(String timeAgo) { this.timeAgo = timeAgo; }
}
