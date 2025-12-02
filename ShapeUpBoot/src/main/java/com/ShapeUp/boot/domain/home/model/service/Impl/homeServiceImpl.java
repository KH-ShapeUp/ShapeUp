package com.ShapeUp.boot.domain.home.model.service.Impl;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.app.success.dto.successListDTO;
import com.ShapeUp.boot.common.util.TimeUtil;
import com.ShapeUp.boot.domain.home.model.mapper.homeMapper;
import com.ShapeUp.boot.domain.home.model.service.homeService;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class homeServiceImpl implements homeService{
	private final homeMapper hMapper;

	/* 매칭 리스트 */
	@Override
	public List<matchingListDTO> getMatchingList() {
		return hMapper.getMatchingList();
	}

	/* 커뮤니티 리스트 */
	@Override
	public List<communityListDTO> getCommunityList() {
		List<communityListDTO> cList = hMapper.getCoummityList();
		
		for (communityListDTO dto : cList) {
	        Timestamp ts = dto.getCreatedAt(); 
	        dto.setTimeAgo(TimeUtil.getTimeAgo(ts)); 
	    }
		
		return cList;
	}

	/* 성공후기 리스트 */
	@Override
	public List<successListDTO> getSuccessList() {
		List<successListDTO> sList = hMapper.getSuccessList();
		
		for (successListDTO dto : sList) {
	        Timestamp ts = dto.getCreatedAt(); 
	        dto.setTimeAgo(TimeUtil.getTimeAgo(ts)); 
	    }
		return sList;
	}

	/* 공지 리스트 */
	@Override
	public List<Notice> getNoticeList() {				
		return hMapper.getNoticeList();
	}

}
