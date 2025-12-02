package com.ShapeUp.boot.domain.banner.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.domain.banner.model.vo.Banner;

@Mapper
public interface BannerMapper {
	int insertBanner(Banner banner);
	int deleteByNotice(@Param("noticeNo") int noticeNo);
	List<Banner> selectActiveBanners();
	Banner selectByNoticeNo(@Param("noticeNo") int noticeNo);
}
