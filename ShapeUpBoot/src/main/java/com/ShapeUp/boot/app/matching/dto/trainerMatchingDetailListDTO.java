package com.ShapeUp.boot.app.matching.dto;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class trainerMatchingDetailListDTO {
	private int matchingNo;				// 매칭 구분 번호
	private String matchingTitle;		// 매칭 제목
	private String matchingContent;		// 매칭 내용
	private Timestamp createdAt;		// 생성일
	private Timestamp updateAt;			// 수정일
	private String deleteYn;			// 삭제 기본값 N
	private String matchingLocation;	// 매칭 지역
	private String matchingTime;		// 매칭 시간
	private String partnerType;			// 매칭 카테고리 (원래는 파트너용)
	private String matchingPrice;		// 매칭 가격
	private int userNo;					// 작성자
	private int matchingUserCount;		// 모집인원
	private String userName;
	private double latitude;				// 위도			
	private double longitude;				// 경도
	private String timeAgo;
	private String career;  // 커리어
	private String careerDetail;
	private List<String> careerInfo;

	private String locationUrl;
	private String matchingStatus; 		// SQL에서 날짜로 마감/모집중

	private int applicationCount;		// 신청 인원 수


	private int applyCount;		// 신청 인원 수
	private String userPhone;
	private String addrName;
	private String userProfileImg;

}
