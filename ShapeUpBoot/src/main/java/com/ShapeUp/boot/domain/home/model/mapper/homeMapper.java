package com.ShapeUp.boot.domain.home.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.app.matching.dto.matchingListDTO;

@Mapper
public interface homeMapper {
	/* 매칭 리스트 */
	List<matchingListDTO> getMatchingList();

}
