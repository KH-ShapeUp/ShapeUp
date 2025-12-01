package com.ShapeUp.boot.domain.banner.model.vo;

import lombok.Data;

@Data
public class Banner {
	private Integer bannerNo;
	private Integer noticeNo;
	private String bannerTitle;
	private String imgPath;
	private String bannerYn;
}
