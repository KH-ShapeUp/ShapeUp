package com.ShapeUp.boot.domain.notice.model.service;

import java.util.List;

import com.ShapeUp.boot.app.notice.dto.NoticeInsertDto;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

public interface NoticeService{

	int insertNotice(NoticeInsertDto noticeInsertDto); //(태현님코드)

//	int insertNotice(Notice notice); //(승재님코드)

	int getTotalCount(String category, String searchType, String searchKeyword);
	
	List<Notice> selectNoticeList(int currentPage, int boardCountPerPage,
								  String category, String searchType, String searchKeyword);

	Notice selectNoticeDetail(int noticeNo);
	
	int updateNotice(Notice notice);

	int insertNoticeImage(com.ShapeUp.boot.domain.notice.model.vo.NoticeImage image);

	int deleteNoticeImage(int imgNo);

	int deleteNotice(int noticeNo);

	int insertNotice(Notice notice);

	java.util.List<com.ShapeUp.boot.domain.notice.model.vo.NoticeImage> selectImagesByNotice(int noticeNo);

	java.util.List<java.util.Map<String, Object>> selectNoticeTrend();

	Integer selectPrevNoticeNo(int noticeNo);

	Integer selectNextNoticeNo(int noticeNo);
}
