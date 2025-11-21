package com.ShapeUp.boot.domain.matching.model.service.Impl;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Service;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.domain.activity.model.vo.Activity;
import com.ShapeUp.boot.domain.matching.model.mapper.matchingMapper;
import com.ShapeUp.boot.domain.matching.model.service.matchingService;
import com.ShapeUp.boot.domain.matching.model.vo.ActivityVO;
import com.ShapeUp.boot.domain.matching.model.vo.matchingVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class matchingServiceImpl implements matchingService{
	private final matchingMapper mMapper;
	
	/* 매칭 삽입 */
	@Override
	public int matchingInsert(matchingInsertDTO mDTO) {
		int result = mMapper.matchingInsert(mDTO);
		return result;
	}
	
	/* 매칭 카테고리 리스트 가져오기 */
	@Override
	public List<ActivityVO> matchingCategory() {
		List<ActivityVO> aList = mMapper.matchingCategory();
		return aList;
	}

	/* 매칭 카테고리 검색 */
	@Override
	public List<ActivityVO> searchCategory(String keyword) {
		List<ActivityVO> aList = mMapper.searchCategory(keyword);
		return aList;
	}

	/* 매칭 리스트 */
	@Override
	public List<matchingListDTO> matchingList(int currentPage, int matchBoardLimit) {
		int offset = ((currentPage) - 1 / matchBoardLimit);
		RowBounds rowBounds = new RowBounds(offset, matchBoardLimit);
		List<matchingListDTO> mList =  mMapper.matchingList(rowBounds);
		return mList;
	}
	
	/* 매칭 게시판 카운트 */
	@Override
	public int getTotalCount() {
		int getTotalCount = mMapper.getTotalCount();
		return getTotalCount;
	}
}
