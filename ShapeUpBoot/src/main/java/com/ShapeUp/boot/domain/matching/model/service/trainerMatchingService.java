package com.ShapeUp.boot.domain.matching.model.service;

import java.util.List;

import com.ShapeUp.boot.app.matching.dto.matchingApplicationDTO;
import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingDetailListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingListDTO;

public interface trainerMatchingService {
	/* 매칭 삽입 */
	int trainerMatchingInsert(matchingInsertDTO mDTO);
	
	/* 매칭 불러오기 */
	List<trainerMatchingListDTO> trainerMatchingList(int currentPage, int boardLimit, String category, String keyword);
	int getTotalCount(String category, String keyword);
	
	/* 디테일 */
	trainerMatchingDetailListDTO trainerMatchingDetailList(int matchingNo);

	/* 매칭 작성자 유저 번호 가져오기 */
	int getWriterUserNo(int matchingNo);

	/* 매칭 중복 방지 */
	int matchinDedpue(Integer loginUserNo, int matchingNo);

	/* 매칭 신청 */
	int matchingApply(matchingApplicationDTO maDTO);

	/* 삭제 */
	int deleteMatching(int matchingNo);



}
