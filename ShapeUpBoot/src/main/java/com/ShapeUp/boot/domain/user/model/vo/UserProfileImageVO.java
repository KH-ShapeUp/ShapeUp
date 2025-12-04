package com.ShapeUp.boot.domain.user.model.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 사용자 프로필 이미지 VO
 * USER_PROFILE_IMG_TBL 테이블과 매핑
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserProfileImageVO {
    private int imgNo;              // IMG_NO - 이미지 번호 (PK)
    private String imgPath;         // IMG_PATH - 이미지 저장 경로
    private String imgRename;       // IMG_RENAME - 변경된 파일명
    private String imgOriginalName; // IMG_ORIGINAL_NAME - 원본 파일명
    private String imgMain;         // IMG_MAIN - 메인 이미지 여부 (Y/N)
    private int userNo;            // USER_NO - 사용자 번호 (FK)
}