package com.ShapeUp.boot.app.notice.dto;

import java.sql.Timestamp;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class NoticeInsertDto {

	private Integer noticeNo;
	private String noticeTitle;
	private String noticeContent;
	private String noticeCategory;
	private int userNo;
	private Timestamp createdAt;
	private String eventStart;
	private String eventEnd;
	private MultipartFile uploadFile;
}
