package com.ShapeUp.boot.domain.matching.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import com.ShapeUp.boot.app.matching.dto.matchingApplicationDTO;
import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingDetailListDTO;
import com.ShapeUp.boot.app.matching.dto.trainerMatchingListDTO;

@Mapper
public interface trainerMatchingMapper {
	/* 삽입 */
	int trainerMatchingInsert(matchingInsertDTO mDTO);
	
	/* 리스트 */
	List<trainerMatchingListDTO> trainerMatchingList(RowBounds rowBounds, String category, String keyword);
	int getTotalCount(String category, String keyword);
	
	/* 디테일 */
	trainerMatchingDetailListDTO trainerMatchingDetailList(int matchingNo);


	int updateDeleteYn(int matchingNo, String deleteYn);

	int getWriterUserNo(int matchingNo);

	int matchingDedpue(Integer loginUserNo, int matchingNo);

	int matchingApply(matchingApplicationDTO maDTO);

	int deleteMatching(int matchingNo);

	List<trainerMatchingListDTO> trainerMatchingList();



}
