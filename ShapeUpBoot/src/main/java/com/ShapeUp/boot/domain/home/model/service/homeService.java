package com.ShapeUp.boot.domain.home.model.service;

import java.util.List;

import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.app.success.dto.successListDTO;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

public interface homeService {
	/* 매칭 리스트 */
	List<matchingListDTO> getMatchingList();

	/* 커뮤니티 리스트 */
	List<communityListDTO> getCommunityList();

	/* 성공후기 리스트 */
	List<successListDTO> getSuccessList();

	/* 공지 리스트 */
	List<Notice> getNoticeList();

}
