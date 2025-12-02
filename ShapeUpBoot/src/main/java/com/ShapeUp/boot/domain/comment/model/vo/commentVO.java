package com.ShapeUp.boot.domain.comment.model.vo;

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
public class commentVO {
	private int commentNo;			// 댓글 구분 번호
	private String commentContent;  // 댓글 내용
	private int userNo;				// 댓글 작성자 유저 번호
	private int communityNo;		// 댓글쓴 게시물 번호
	private Timestamp createdAt;	// 댓글 작성일자
	private int parentCommentNo;	// 댓글 깊이
	private int commentDepth;		// 댓글 0, 대댓글 1
	private String deleteYn;		// 삭제 여부
	
	private String userNickName;
	private String userType;
	
	private String timeAgo;      // 상대 시간 문자열
	
	 

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getTimeAgo() { return timeAgo; }
    public void setTimeAgo(String timeAgo) { this.timeAgo = timeAgo; }
}
