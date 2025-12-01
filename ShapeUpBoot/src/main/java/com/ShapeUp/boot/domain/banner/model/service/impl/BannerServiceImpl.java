package com.ShapeUp.boot.domain.banner.model.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.banner.model.mapper.BannerMapper;
import com.ShapeUp.boot.domain.banner.model.service.BannerService;
import com.ShapeUp.boot.domain.banner.model.vo.Banner;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BannerServiceImpl implements BannerService {

	private final BannerMapper bMapper;

	@Override
	public int saveBanner(Banner banner) {
		if (banner == null || banner.getNoticeNo() == null) return 0;
		// notice별 기존 배너 삭제 후 insert
		bMapper.deleteByNotice(banner.getNoticeNo());
		return bMapper.insertBanner(banner);
	}

	@Override
	public List<Banner> getActiveBanners() {
		return bMapper.selectActiveBanners();
	}

	@Override
	public Banner getByNoticeNo(int noticeNo) {
		return bMapper.selectByNoticeNo(noticeNo);
	}
}
