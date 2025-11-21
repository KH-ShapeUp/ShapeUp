package com.ShapeUp.boot.domain.activity.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;

public interface ActivityService {

	List<ActivityVO> getActivityListByKeyword(String keyword);

}
