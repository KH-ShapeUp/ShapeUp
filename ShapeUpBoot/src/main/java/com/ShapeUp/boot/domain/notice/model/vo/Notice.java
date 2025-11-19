 package com.ShapeUp.boot.domain.notice.model.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class Notice {
	
	private int noticeNo;
	private String noticeTitle;
	private String noticeContent;
	private String category;
	private int userNo;
	private Timestamp createAt;
	private Timestamp updateAt;
	private String evStartAt;
	private String evEndDate;
	private int viewCount;
}
