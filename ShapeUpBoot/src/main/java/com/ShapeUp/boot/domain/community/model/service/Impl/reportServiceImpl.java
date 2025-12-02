package com.ShapeUp.boot.domain.community.model.service.Impl;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.community.model.mapper.reportMapper;
import com.ShapeUp.boot.domain.community.model.service.reportService;
import com.ShapeUp.boot.domain.community.model.vo.reportVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class reportServiceImpl implements reportService{
	private final reportMapper rMapper;
	
	@Override
	public int reportInsert(reportVO rVO) {
		return rMapper.reportInsert(rVO);
	}

}
