package com.ShapeUp.boot.domain.community.model.service;

import java.util.List;
import java.util.Map;

import com.ShapeUp.boot.app.community.dto.communityInsertDTO;
import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.app.community.dto.communityModifyDTO;
import com.ShapeUp.boot.domain.community.model.vo.communityVO;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

public interface communityService {
	/* 커뮤니티 게시글 작성 */
	int communityInsert(communityInsertDTO cDTO);
	
	/* 공지 사항 가져오기 */
	List<Notice> getNoticeList();
	
	/* 커뮤니티 가져오기 */
	List<communityListDTO> getCommunityList(int currentPage, int boardLimit, String category, String keyword);

	/* 커뮤니티 총 개시물 가져오기 */
	int getTotalCount(String category, String keyword);

	/* 댓글순 */
	List<communityListDTO> getSortCommentList();

	/* 조회수순 */
	List<communityListDTO> getSortViewList();

	/* 커뮤니티 디테일 */
	communityListDTO getCommunityDetail(int boardNo);

	/* 커뮤니티 좋아요 버튼 */
	Map<String, Object> communityLike(int communityNo, int userNo);

	/* 커뮤니티 삭제 */
	int communityDelete(int communityNo);

	/* 커뮤니티 수정 */
	communityListDTO communityModify(int communityNo);

}
