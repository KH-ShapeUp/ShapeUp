package com.ShapeUp.boot.domain.community.model.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.domain.community.model.vo.reportVO;

@Mapper
public interface reportMapper {

	int reportInsert(reportVO rVO);

}
