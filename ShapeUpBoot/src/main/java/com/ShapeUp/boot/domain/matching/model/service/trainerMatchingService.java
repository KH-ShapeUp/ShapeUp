package com.ShapeUp.boot.domain.matching.model.service;

import java.util.List;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingDetailListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingListDTO;

public interface trainerMatchingService {
	/* 매칭 삽입 */
	int trainerMatchingInsert(matchingInsertDTO mDTO);
	
	/* 매칭 불러오기 */
	List<trainerMatchingListDTO> trainerMatchingList();
	
	/* 디테일 */
	trainerMatchingDetailListDTO trainerMatchingDetailList(int matchingNo);

}
