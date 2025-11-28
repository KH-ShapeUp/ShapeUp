package com.ShapeUp.boot.app.community.dto;

import lombok.Data;

@Data
public class communityImageDTO {
	private int imgNo;
    private String imgPath;         // 웹 접근 경로 (/upload/...)
    private String imgRename;       // 저장된 파일명 (uuid_파일명)
    private String imgOriginalName; // 원본 파일명 (선택사항, 모르면 imgRename과 같게)
    private int communityNo;        // 게시글 번호
}
