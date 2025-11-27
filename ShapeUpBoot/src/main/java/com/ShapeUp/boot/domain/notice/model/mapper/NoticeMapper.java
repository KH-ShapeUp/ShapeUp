package com.ShapeUp.boot.domain.notice.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.app.notice.dto.NoticeInsertDto;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

@Mapper
public interface NoticeMapper {

	int getTotalCount(String category, String searchType, String searchKeyword);

	int insertNotice(NoticeInsertDto noticeInsertDto);

	List<Notice> selectNoticeList(int startRow, int endRow, String category, String searchType, String searchKeyword);

	int increaseViewCount(@Param("noticeNo") int noticeNo);

	Notice selectNoticeDetail(int noticeNo);
}
