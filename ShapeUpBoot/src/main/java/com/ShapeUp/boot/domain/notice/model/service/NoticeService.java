package com.ShapeUp.boot.domain.notice.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.notice.model.vo.Notice;

public interface NoticeService{

	int insertNotice(Notice notice);

	int getTotalCount();

	List<Notice> selectNoticeList(int currentPage, int boardCountPerPage);

	int updateNotice(Notice notice);

	int insertNoticeImage(com.ShapeUp.boot.domain.notice.model.vo.NoticeImage image);

	int deleteNoticeImage(int imgNo);

	int deleteNotice(int noticeNo);

	java.util.List<com.ShapeUp.boot.domain.notice.model.vo.NoticeImage> selectImagesByNotice(int noticeNo);

	java.util.List<java.util.Map<String, Object>> selectNoticeTrend();

}
