 package com.ShapeUp.boot.domain.notice.model.vo;


import java.sql.Timestamp;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class Notice {
	
	private Integer noticeNo;
	private String noticeTitle;
	private String noticeContent;
	private String noticeCategory;
	private Integer userNo;
	private String userName;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	private String eventStart;
	private String eventEnd;
	private Integer viewCount;
	private List<NoticeImage> images;
}
