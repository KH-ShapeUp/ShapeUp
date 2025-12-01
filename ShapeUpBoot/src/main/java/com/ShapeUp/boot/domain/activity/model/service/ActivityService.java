package com.ShapeUp.boot.domain.activity.model.service;

import java.util.List;


import com.ShapeUp.boot.domain.activity.model.vo.ActivityLogVO;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;

public interface ActivityService {

	List<ActivityVO> getActivityListByKeyword(String keyword);

	int insertActivities(ActivityLogVO log);

	List<java.util.Map<String, Object>> selectLogsByDate(int userNo, String actionDate);

	java.util.Map<String, Object> sumLogsByDate(int userNo, String actionDate);

	List<java.util.Map<String, Object>> sumKcalByType(int userNo, String actionDate);

	int deleteLogs(int userNo, List<Integer> logIds);

}
