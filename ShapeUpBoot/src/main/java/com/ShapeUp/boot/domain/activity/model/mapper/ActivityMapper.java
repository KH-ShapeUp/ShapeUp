package com.ShapeUp.boot.domain.activity.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.domain.activity.model.vo.ActivityVo;

@Mapper
public interface ActivityMapper {

	List<ActivityVo> getActivityListByKeyword(String keyword);

}
