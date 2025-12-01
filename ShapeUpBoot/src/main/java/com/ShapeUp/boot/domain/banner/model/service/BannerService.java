package com.ShapeUp.boot.domain.banner.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.banner.model.vo.Banner;

public interface BannerService {
	int saveBanner(Banner banner);
	List<Banner> getActiveBanners();
	Banner getByNoticeNo(int noticeNo);
}
