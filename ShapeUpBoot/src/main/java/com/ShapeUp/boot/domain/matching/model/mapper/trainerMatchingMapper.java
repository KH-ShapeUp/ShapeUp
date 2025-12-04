package com.ShapeUp.boot.domain.matching.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingDetailListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingListDTO;

@Mapper
public interface trainerMatchingMapper {
	/* 삽입 */
	int trainerMatchingInsert(matchingInsertDTO mDTO);
	
	/* 리스트 */
	List<trainerMatchingListDTO> trainerMatchingList();
	
	/* 디테일 */
	trainerMatchingDetailListDTO trainerMatchingDetailList(int matchingNo);

}
