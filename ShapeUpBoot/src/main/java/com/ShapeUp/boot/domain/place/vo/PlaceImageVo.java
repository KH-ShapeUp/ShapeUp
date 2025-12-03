package com.ShapeUp.boot.domain.place.vo;

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
public class PlaceImageVo {

	private int imgNo;
	private int placeNo;
	private String imgPath;
	private String imgRename;
	private String imgOriginalName;
	private String imgMain;
}
