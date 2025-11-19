package com.ShapeUp.boot.domain.matching.model.service;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;

public interface matchingService {
	/* 매칭 삽입 */
	int matchingInsert(matchingInsertDTO mDTO);

}
