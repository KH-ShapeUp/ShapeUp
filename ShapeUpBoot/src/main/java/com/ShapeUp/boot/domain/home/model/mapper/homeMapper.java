package com.ShapeUp.boot.domain.home.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.app.success.dto.successListDTO;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

@Mapper
public interface homeMapper {
	/* 매칭 리스트 */
	List<matchingListDTO> getMatchingList();

	/* 커뮤니티 리스트 */
	List<communityListDTO> getCoummityList();

	/* 성공후기 리스트 */
	List<successListDTO> getSuccessList();

	/* 공지 리스트 */
	List<Notice> getNoticeList();

}
