package com.ShapeUp.boot.domain.matching.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;
import com.ShapeUp.boot.domain.matching.model.vo.matchingVO;

@Mapper
public interface matchingMapper{
	/* 매칭 삽입 */
	int matchingInsert(matchingInsertDTO mDTO);

	/* 매칭 카테고리 */
	List<ActivityVO> matchingCategory();

	/* 매칭 삽입 */
	List<ActivityVO> searchCategory(String keyword);
	
	/* 매칭 리스트 */
	List<matchingListDTO> matchingList(RowBounds rowBounds);

	/* 매칭 게시판 카운트 */
	int getTotalCount();
}
