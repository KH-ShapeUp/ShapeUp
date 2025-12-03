package com.ShapeUp.boot.domain.place.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.ShapeUp.boot.domain.place.mapper.PlaceMapper;
import com.ShapeUp.boot.domain.place.service.PlaceService;
import com.ShapeUp.boot.domain.place.vo.Place;
import com.ShapeUp.boot.domain.place.vo.PlaceImageVo;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PlaceServiceImpl implements PlaceService{

	private final PlaceMapper pMapper;
	
	@Override
	public int insertPlace(Place place, List<MultipartFile> placeImages) {
		int result = pMapper.insertPlace(place);
		if(result == 0) {
			return 0;
		}
		int placeNo = place.getPlaceNo();
		List<PlaceImageVo> imageList;
		return place.getPlaceNo();
	}

}
