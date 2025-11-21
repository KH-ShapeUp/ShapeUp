package com.ShapeUp.boot.domain.activity.model.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.activity.model.mapper.ActivityMapper;
import com.ShapeUp.boot.domain.activity.model.service.ActivityService;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityVo;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ActivityServiceImpl implements ActivityService {
	
	private final ActivityMapper aMapper;
	@Override
	public List<ActivityVo> getActivityListByKeyword(String keyword) {
		List<ActivityVo> aList = aMapper.getActivityListByKeyword(keyword);
		return aList;
	}

}
