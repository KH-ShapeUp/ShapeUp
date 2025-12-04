package com.ShapeUp.boot.domain.place.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.domain.place.vo.Place;
import com.ShapeUp.boot.domain.place.vo.PlaceImageVo;

@Mapper
public interface PlaceMapper {

	int insertPlace(Place place);

	int insertPlaceImage(PlaceImageVo image);

}
