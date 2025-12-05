package com.ShapeUp.boot.domain.activity.model.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.domain.activity.model.vo.ActivityLogVO;
//import com.ShapeUp.boot.app.activity.controller.dto.ActivityinsertDto;
//import com.ShapeUp.boot.domain.activity.model.vo.ActivityLogVO;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;

@Mapper
public interface ActivityMapper {

	List<ActivityVO> getActivityListByKeyword(String keyword);

	int insertActivityVO(ActivityLogVO log);

	List<Map<String, Object>> selectLogsByDate(@Param("userNo") int userNo, @Param("actionDate") String actionDate);

	Map<String, Object> sumLogsByDate(@Param("userNo") int userNo, @Param("actionDate") String actionDate);

	List<Map<String, Object>> sumKcalByType(@Param("userNo") int userNo, @Param("actionDate") String actionDate);

	int deleteLogs(@Param("userNo") int userNo, @Param("logIds") List<Integer> logIds);
	
}
