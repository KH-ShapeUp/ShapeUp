package com.ShapeUp.boot.domain.notice.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.app.notice.dto.NoticeInsertDto;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;
import com.ShapeUp.boot.domain.notice.model.vo.NoticeImage;

@Mapper
public interface NoticeMapper {

	int getTotalCount(@Param("category") String category,
					  @Param("searchType") String searchType,
					  @Param("searchKeyword") String searchKeyword);

	int insertNotice(NoticeInsertDto noticeInsertDto); //원래코드(태현님 코드)
	
//	int insertNotice(Notice notice); // (승재님 코드)
	
	List<Notice> selectNoticeList(@Param("startRow") int startRow,
								  @Param("endRow") int endRow,
								  @Param("category") String category,
								  @Param("searchType") String searchType,
								  @Param("searchKeyword") String searchKeyword);

	int increaseViewCount(@Param("noticeNo") int noticeNo);

	Notice selectNoticeDetail(int noticeNo);
	
	int updateNotice(Notice notice);

	List<NoticeImage> selectImagesByNotice(int noticeNo);

	int insertNoticeImage(NoticeImage image);

	int deleteNoticeImage(int imgNo);

	int insertNoticeVo(Notice notice);

	int deleteNotice(int noticeNo);

	List<java.util.Map<String, Object>> selectNoticeTrend();
}
