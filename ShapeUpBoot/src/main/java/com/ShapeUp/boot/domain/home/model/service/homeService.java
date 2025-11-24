package com.ShapeUp.boot.domain.home.model.service;

import java.util.List;

import com.ShapeUp.boot.app.matching.dto.matchingListDTO;

public interface homeService {
	/* 매칭 리스트 */
	List<matchingListDTO> getMatchingList();

}
