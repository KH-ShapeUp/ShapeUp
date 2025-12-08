package com.ShapeUp.boot.app.matching.dto;

import java.sql.Timestamp;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class trainerMatchingListDTO {
	private int matchingNo;				// 매칭 구분 번호
	private String matchingTitle;		// 매칭 제목
	private String matchingContent;		// 매칭 내용
	private Timestamp createdAt;		// 생성일
	private String matchingLocation;	// 매칭 지역
	private String matchingTime;		// 매칭 시간
	private String partnerType;			// 매칭 카테고리 (원래는 파트너용)
	private String matchingPrice;		// 매칭 가격
	private int matchingUserCount;		// 모집인원
	private String userName;
	
	private String timeAgo;
	private String career;  // 커리어
	private String userPhone;

	private String matchingStatus; 		// SQL에서 날짜로 마감/모집중

	private int applicationCount;		// 신청 인원 수
	private int applyCount;		// 신청 인원 수
	private String addrName;

	private String userProfileImg;
}