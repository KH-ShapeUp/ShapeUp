package com.ShapeUp.boot.domain.place.service.impl;

import java.io.IOException;
import java.util.List;

import javax.management.RuntimeErrorException;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ShapeUp.boot.app.place.FileHandler;
import com.ShapeUp.boot.domain.place.mapper.PlaceMapper;
import com.ShapeUp.boot.domain.place.service.PlaceService;
import com.ShapeUp.boot.domain.place.vo.Place;
import com.ShapeUp.boot.domain.place.vo.PlaceImageVo;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PlaceServiceImpl implements PlaceService{

	private final PlaceMapper pMapper;
	private final FileHandler fileHandler;
	
	@Transactional
	@Override
	public int insertPlace(Place place, List<MultipartFile> placeImages) {
		
		// 1. 시설 기본정보 DB에 등록
		int result = pMapper.insertPlace(place);
		if(result == 0) {
			return 0; // 등록 실패
		}
		int placeNo = place.getPlaceNo();
		List<PlaceImageVo> imageList;
		
		// 2. 파일 처리 및 이미지 VO 목록 생성
		try {
			// 파일을 서버에 저장하고, 저장 정보를 담은 VO 목록을 가져옴
			imageList = fileHandler.uploadFiles(placeNo, placeImages);
		} catch (IOException e) {
			// 파일 저장 실패 시 runtime오류를 발생시켜 트랜잭션 롤백 유도 
			throw new RuntimeException("시설 이미지 파일 처리 중 오류 발생: " + e.getMessage(), e);
		}
		
		// 3. 이미지 정보 DB 등록
		if(imageList != null && !imageList.isEmpty()) {
			for(PlaceImageVo image : imageList) {
				int imgResult = pMapper.insertPlaceImage(image);
				if(imgResult == 0) {
					throw new RuntimeException("시설 이미지 등록 실패: 트랜잭션 롤백");
				}
			}
		}
		return place.getPlaceNo();
	}

}
