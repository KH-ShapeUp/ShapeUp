package com.ShapeUp.boot.domain.matching.model.service;

import java.util.List;

import com.ShapeUp.boot.app.matching.dto.matchingApplicationDTO;
import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;


import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;


public interface matchingService {
	/* 매칭 삽입 */
	int matchingInsert(matchingInsertDTO mDTO);

	/* 매칭 카테고리 가져오기 */
	List<ActivityVO> matchingCategory();

	/* 매칭 카테고리 검색 */
	List<ActivityVO> searchCategory(String keyword);

	/* 매칭 리스트 */
	List<matchingListDTO> matchingList(int currentPage, int matchBoardLimit, String location, String time, 
			String level, String sort, String deleteYn);
	
	/* 매칭 게시판 카운트 */
	int getTotalCount(String location, String time, String level, String deleteYn);

	/* 매칭 삭제/복구 */
	int updateDeleteYn(int matchingNo, String deleteYn);

	/* 매칭 신청 */
	int matchApplication(matchingApplicationDTO mAppDTO);

	/* 매칭 작성자 유저 번호 가져오기 */
	int getWriterUserNo(int matchingNo);

	/* 매칭 중복 방지 */
	int matchDedupe(int loginUserNo, int matchingNo);
	
}
