package com.ShapeUp.boot.domain.activity.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.app.activity.controller.dto.ActivityinsertDto;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityLogVO;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;

@Mapper
public interface ActivityMapper {

	List<ActivityVO> getActivityListByKeyword(String keyword);

	int insertActivityVO(ActivityLogVO log);

}
