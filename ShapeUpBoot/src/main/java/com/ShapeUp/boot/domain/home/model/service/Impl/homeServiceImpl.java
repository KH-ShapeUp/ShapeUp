package com.ShapeUp.boot.domain.home.model.service.Impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.domain.home.model.mapper.homeMapper;
import com.ShapeUp.boot.domain.home.model.service.homeService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class homeServiceImpl implements homeService{
	private final homeMapper hMapper;

	/* 매칭 리스트 */
	@Override
	public List<matchingListDTO> getMatchingList() {
		return hMapper.getMatchingList();
	}

}
