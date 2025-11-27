package com.ShapeUp.boot.app.notice.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class NoticeInsertImageDto {
	
	private int imgNo;
	private int noticeNo;
	private String imgPath;
	private String imgRename;
	private String imgOriginalName;
	private String imgMainYn;
}
