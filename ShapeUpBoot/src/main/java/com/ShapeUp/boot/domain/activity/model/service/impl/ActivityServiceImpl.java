package com.ShapeUp.boot.domain.activity.model.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;


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

	@Override
	public List<java.util.Map<String, Object>> selectLogsByDate(int userNo, String actionDate) {
		return aMapper.selectLogsByDate(userNo, actionDate);
	}

	@Override
	public java.util.Map<String, Object> sumLogsByDate(int userNo, String actionDate) {
		return aMapper.sumLogsByDate(userNo, actionDate);
	}

	@Override
	public List<java.util.Map<String, Object>> sumKcalByType(int userNo, String actionDate) {
		return aMapper.sumKcalByType(userNo, actionDate);
	}

	@Override
	public int deleteLogs(int userNo, List<Integer> logIds) {
		if (logIds == null || logIds.isEmpty()) return 0;
		return aMapper.deleteLogs(userNo, logIds);
	}


}

