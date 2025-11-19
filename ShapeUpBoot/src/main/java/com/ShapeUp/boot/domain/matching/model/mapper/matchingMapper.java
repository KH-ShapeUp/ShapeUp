package com.ShapeUp.boot.domain.matching.model.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;

@Mapper
public interface matchingMapper{
	/* 매칭 삽입 */
	int matchingInsert(matchingInsertDTO mDTO);

}
