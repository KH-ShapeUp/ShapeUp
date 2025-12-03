package com.ShapeUp.boot.domain.place.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.ShapeUp.boot.domain.place.vo.Place;

public interface PlaceService {

	int insertPlace(Place place, List<MultipartFile> placeImages);
}
