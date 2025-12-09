package com.ShapeUp.boot.domain.community.model.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.RowBounds;

import com.ShapeUp.boot.app.community.dto.communityImageDTO;
import com.ShapeUp.boot.app.community.dto.communityInsertDTO;
import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.domain.community.model.vo.communityVO;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

@Mapper
public interface communityMapper {
	/* 커뮤니티 게시글 작성 */
	int communityInsert(communityInsertDTO cDTO);
	
	/* 커뮤니티 이미지 삽입 */
	void insertCommunityImages(List<communityImageDTO> imgList);
	
	/* 공지 사항 가져오기 */
	List<Notice> getNoticeList();
	
	/* 커뮤니티 리스트 (페이징) */
	List<communityListDTO> getCommunityList(RowBounds rowBounds, String category, String keyword);
	
	/* 커뮤니티 리스트 총 갯수 가져오기 */
	int getTotalCount(String category, String keyword);
	
	/* 댓글 순 */
	List<communityListDTO> getSortCommentList();
	
	/* 조회수 순*/
	List<communityListDTO> getSortViewList();

	/* 커뮤니티 디테일 게시판 */
	communityListDTO getCommunityDetail(int boardNo);

	/* 조회수 증가 */
	void viewCount(int boardNo);

	/* 좋아요 체크*/
	int checkLike(Map<String, Integer> checkParam);
	/* 좋아요 삭제 */
	void deleteLike(Map<String, Integer> checkParam);
	/* 좋아요 삽입 */
	void insertLike(Map<String, Integer> checkParam);
	/* 좋아요 총 갯수 */
	int countLike(int communityNo);

	/* 커뮤니티 삭제 */
	int communityDelete(int communityNo);

	communityListDTO communityModify(int communityNo);

	/* Admin 전용: 자유게시판 리스트 (삭제 포함) */
	List<com.ShapeUp.boot.app.community.dto.communityListDTO> selectAdminCommunityList(
			@org.apache.ibatis.annotations.Param("deleteYn") String deleteYn,
			@org.apache.ibatis.annotations.Param("category") String category,
			@org.apache.ibatis.annotations.Param("keyword") String keyword);

	/* Admin 전용: 성공후기 리스트 (COMMUNITY_TYPE='success') */
	List<com.ShapeUp.boot.app.community.dto.communityListDTO> selectAdminSuccessList(
			@org.apache.ibatis.annotations.Param("deleteYn") String deleteYn,
			@org.apache.ibatis.annotations.Param("successType") String successType,
			@org.apache.ibatis.annotations.Param("keyword") String keyword);

	/* Admin 전용: 이미지 목록 */
	List<com.ShapeUp.boot.app.community.dto.communityImageDTO> selectImagesByCommunity(int communityNo);
	com.ShapeUp.boot.app.community.dto.communityImageDTO selectImageById(int imgNo);

	/* Admin 전용: 삭제/복구 */
	int updateDeleteYn(@org.apache.ibatis.annotations.Param("communityNo") int communityNo,
					   @org.apache.ibatis.annotations.Param("deleteYn") String deleteYn);

	/* Admin 전용: 등록 추이 */
	List<java.util.Map<String, Object>> selectCommunityTrend();

	/* Admin 전용: 성공후기 등록 추이 */
	List<java.util.Map<String, Object>> selectSuccessTrend();

	int modifyCommunity(@Param("cDTO") communityInsertDTO cDTO, @Param("userNo") int userNo);

}
