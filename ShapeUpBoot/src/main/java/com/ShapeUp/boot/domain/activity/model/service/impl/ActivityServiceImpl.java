package com.ShapeUp.boot.domain.activity.model.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.app.activity.controller.dto.ActivityInsertDto;
import com.ShapeUp.boot.domain.activity.model.mapper.ActivityMapper;
import com.ShapeUp.boot.domain.activity.model.service.ActivityService;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityLogVO;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ActivityServiceImpl implements ActivityService {
	
	private final ActivityMapper aMapper;
	@Override
	public List<ActivityVO> getActivityListByKeyword(String keyword) {
		List<ActivityVO> aList = aMapper.getActivityListByKeyword(keyword);
		return aList;
	}
	@Override
	public int insertActivities(ActivityLogVO log) {
		return aMapper.insertActivityVO(log);
	}


}
