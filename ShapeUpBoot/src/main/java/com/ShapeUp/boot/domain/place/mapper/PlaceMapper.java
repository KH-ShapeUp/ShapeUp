package com.ShapeUp.boot.domain.place.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.domain.place.vo.Place;

@Mapper
public interface PlaceMapper {

	int insertPlace(Place place);

}
