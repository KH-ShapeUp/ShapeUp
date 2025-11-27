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
	
	private Integer noticeNo;
	private String noticeTitle;
	private String noticeContent;
	private String noticeCategory;
	private int userNo;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	private String eventStart;
	private String eventEnd;
	private int viewCount;
}
