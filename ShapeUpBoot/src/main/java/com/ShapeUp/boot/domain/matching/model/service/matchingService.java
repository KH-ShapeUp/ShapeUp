package com.ShapeUp.boot.domain.matching.model.service;

import java.util.List;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;

import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;

import com.ShapeUp.boot.domain.matching.model.vo.matchingVO;

public interface matchingService {
	/* 매칭 삽입 */
	int matchingInsert(matchingInsertDTO mDTO);

	/* 매칭 카테고리 가져오기 */
	List<ActivityVO> matchingCategory();

	/* 매칭 카테고리 검색 */
	List<ActivityVO> searchCategory(String keyword);

	/* 매칭 리스트 */
	List<matchingListDTO> matchingList(int currentPage, int matchBoardLimit);
	
	/* 매칭 게시판 카운트 */
	int getTotalCount();


	

}
