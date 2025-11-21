package com.ShapeUp.boot.domain.activity.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.activity.model.vo.ActivityVo;

public interface ActivityService {

	List<ActivityVo> getActivityListByKeyword(String keyword);

}
