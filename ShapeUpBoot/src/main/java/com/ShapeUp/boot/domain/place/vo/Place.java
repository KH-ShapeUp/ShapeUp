package com.ShapeUp.boot.domain.place.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

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
public class Place {

	private int placeNo;
	private String placeName;
	private String placeInfo;
	private int userNo;
	private int placePrice;
	private double latitude;
	private double logitude;
	private String phone;
	private String deleteYn;
	private String placeLocalName;
	private String placeRoadName;
	private String placeType;
	private List<MultipartFile> placeImages;
	private List<PlaceImageVo> imageList;
}
