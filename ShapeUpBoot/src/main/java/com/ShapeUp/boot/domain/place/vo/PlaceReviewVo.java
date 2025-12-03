package com.ShapeUp.boot.domain.place.vo;

import java.sql.Date;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class PlaceReviewVo {

	private int reviewNo;
	private int placeNo;
	private int userNo;
	private String reviewContent;
	private int reviewType;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;
	private String deleteYn;
}
