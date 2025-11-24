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
	private String category;
	private int userNo;
	private Timestamp createAt;
	private MultipartFile uploadFile;
}
