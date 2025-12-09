package com.ShapeUp.boot.domain.user.model.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class ReviewVO {
	private int reviewNo;
	private int matchingNo;
	private int userNo;
	private String reviewContent;
	private int reviewType;
	private Timestamp createdAt;
	private Timestamp updateAt;
	private String deleteYn;

	private String userNickName;
	private String createdDay;
	
	private String userProfileImg;
}
