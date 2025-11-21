package com.ShapeUp.boot.domain.matching.model.vo;

import java.sql.Timestamp;

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
public class matchingVO {
	private int matchingNo;				// 매칭 구분 번호
	private String matchingTitle;		// 매칭 제목
	private String matchingContent;		// 매칭 내용
	private Timestamp createdAt;		// 생성일
	private Timestamp updateAt;			// 수정일
	private String deleteYn;			// 삭제 기본값 N
	private String matchingLocation;	// 매칭 지역
	private String matchingDate;		// 매칭 날짜
	private int matchingLevel;			// 매칭 난이도
	private String matchingTime;		// 매칭 시간
	private String matchingPrice;		// 매칭 가격
	private String partnerType;			// 파트너 타입
	private String matchingType; 		// 매칭 타입
	private int userNo;					// 작성자
	private int matchingUserCount;		// 모집인원
	private int activityId;				// 활동 카테고리 id
}
