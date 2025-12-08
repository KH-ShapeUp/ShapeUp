package com.ShapeUp.boot.domain.matching.model.service.Impl;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingDetailListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingListDTO;
import com.ShapeUp.boot.common.util.TimeUtil;
import com.ShapeUp.boot.domain.matching.model.mapper.trainerMatchingMapper;
import com.ShapeUp.boot.domain.matching.model.service.trainerMatchingService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class trainerMatchingServiceImpl implements trainerMatchingService{
	private final trainerMatchingMapper tmMapper;
	
	@Override
	public int trainerMatchingInsert(matchingInsertDTO mDTO) {
		return tmMapper.trainerMatchingInsert(mDTO);
	}

	@Override
	public List<trainerMatchingListDTO> trainerMatchingList() {
		List<trainerMatchingListDTO> mList = tmMapper.trainerMatchingList();
		
		for(trainerMatchingListDTO tmDTO: mList) {
			Timestamp ts = tmDTO.getCreatedAt();
			tmDTO.setTimeAgo(TimeUtil.getTimeAgo(ts));
		}
		return mList;
	}

	@Override
	public trainerMatchingDetailListDTO trainerMatchingDetailList(int matchingNo) {
		trainerMatchingDetailListDTO tmdList = tmMapper.trainerMatchingDetailList(matchingNo);
		
		if (tmdList != null) {
	        Timestamp ts = tmdList.getCreatedAt();
	        tmdList.setTimeAgo(TimeUtil.getTimeAgo(ts));
	    }
		
		return tmdList;
	}

	@Override
	public int updateDeleteYn(int matchingNo, String deleteYn) {
		return tmMapper.updateDeleteYn(matchingNo, deleteYn);
	}

}
