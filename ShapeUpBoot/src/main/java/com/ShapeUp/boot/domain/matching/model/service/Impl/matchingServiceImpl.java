package com.ShapeUp.boot.domain.matching.model.service.Impl;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.domain.matching.model.mapper.matchingMapper;
import com.ShapeUp.boot.domain.matching.model.service.matchingService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class matchingServiceImpl implements matchingService{
	private final matchingMapper mMapper;
	
	@Override
	public int matchingInsert(matchingInsertDTO mDTO) {
		// TODO 매칭 삽입
		int result = mMapper.matchingInsert(mDTO);
		return result;
	}

}
