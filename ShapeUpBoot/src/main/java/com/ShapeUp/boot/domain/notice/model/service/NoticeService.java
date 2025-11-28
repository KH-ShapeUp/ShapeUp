package com.ShapeUp.boot.domain.notice.model.service;

import java.util.List;

import com.ShapeUp.boot.app.notice.dto.NoticeInsertDto;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

public interface NoticeService{

	int insertNotice(NoticeInsertDto noticeInsertDto);

	int getTotalCount(String category, String searchType, String searchKeyword);
	
	List<Notice> selectNoticeList(int currentPage, int boardCountPerPage, String category, String searchType, String searchKeyword);

	Notice selectNoticeDetail(int noticeNo);

}
