package com.ShapeUp.boot.domain.matching.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.RowBounds;

import com.ShapeUp.boot.app.matching.dto.matchingApplicationDTO;
import com.ShapeUp.boot.app.matching.dto.matchingInsertDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;

import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;
import com.ShapeUp.boot.domain.matching.model.vo.matchingAppLiVo;
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
	List<matchingListDTO> matchingList(RowBounds rowBounds,
			@Param("location") String location,
			@Param("time") String time,
			@Param("level") String level,
			@Param("sort") String sort,
			@Param("deleteYn") String deleteYn);

	/* 매칭 게시판 카운트 */
	int getTotalCount(@Param("location") String location,
			@Param("time") String time,
			@Param("level") String level,
			@Param("deleteYn") String deleteYn);

	/* 매칭 신청 */
	int matchinApplication(matchingApplicationDTO mAppDSTO);

	/* 매칭 작성자 가져오기 */
	int getWriterUserNo(int matchingNo);

	/* 매칭 중복 방지 */
	int getMatchDedupe(int loginUserNo, int matchingNo);
	
	int updateDeleteYn(@Param("matchingNo") int matchingNo, @Param("deleteYn") String deleteYn);
	

	/* 매칭 삭제 */
	int matchingDelete(int matchingNo);
	
	/* 예약 취소 */
	int applyDelete(int matchingNo, int userNo);

}
