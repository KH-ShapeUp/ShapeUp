package com.ShapeUp.boot.domain.matching.model.service.Impl;

import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Service;

import com.ShapeUp.boot.app.matching.dto.matchingApplicationDTO;
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
	public List<trainerMatchingListDTO> trainerMatchingList(int currentPage, int boardLimit, String category, String keyword) {
		int offset = (currentPage - 1) * boardLimit;
		RowBounds rowBounds = new RowBounds(offset, boardLimit);
		List<trainerMatchingListDTO> mList = tmMapper.trainerMatchingList(rowBounds, category, keyword);
		
		for(trainerMatchingListDTO tmDTO: mList) {
			Timestamp ts = tmDTO.getCreatedAt();
			tmDTO.setTimeAgo(TimeUtil.getTimeAgo(ts));
		}
		return mList;
	}

	@Override
	public int getTotalCount(String category, String keyword) {
		return tmMapper.getTotalCount(category, keyword);
	}
	
	@Override
	public trainerMatchingDetailListDTO trainerMatchingDetailList(int matchingNo) {
		trainerMatchingDetailListDTO tmdList = tmMapper.trainerMatchingDetailList(matchingNo);
		
		if (tmdList != null) {
	        Timestamp ts = tmdList.getCreatedAt();
	        tmdList.setTimeAgo(TimeUtil.getTimeAgo(ts));
	        
	     // 수정: careerDetail이 비어있지 않은지 확인해야 함
	        if(tmdList.getCareerDetail() != null && !tmdList.getCareerDetail().isEmpty()) {
	            
	            List<String> careerList = Arrays.stream(tmdList.getCareerDetail().split(","))
	                    .map(String::trim)
	                    .collect(Collectors.toList());
	                    
	            tmdList.setCareerInfo(careerList);
	            
	            // 확인용 로그 (이제 잘 뜰 겁니다)
	            System.out.println("변환 완료된 리스트: " + tmdList.getCareerInfo());
	        }
	    }
		
		
		return tmdList;
	}


	@Override
	public int updateDeleteYn(int matchingNo, String deleteYn) {
		return tmMapper.updateDeleteYn(matchingNo, deleteYn);
	}
	/* 매칭 작성자 찾기 */
	@Override
	public int getWriterUserNo(int matchingNo) {
		return tmMapper.getWriterUserNo(matchingNo);
	}

	
	/* 매칭 중복 방지 */
	@Override
	public int matchinDedpue(Integer loginUserNo, int matchingNo) {
		return tmMapper.matchingDedpue(loginUserNo, matchingNo);
	}

	/* 매칭 신청 */
	@Override
	public int matchingApply(matchingApplicationDTO maDTO) {
		return tmMapper.matchingApply(maDTO);
	}

	/* 삭제 */
	@Override
	public int deleteMatching(int matchingNo) {
		return tmMapper.deleteMatching(matchingNo);
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

}
