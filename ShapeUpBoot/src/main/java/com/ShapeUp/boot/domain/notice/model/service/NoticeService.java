package com.ShapeUp.boot.domain.notice.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.notice.model.vo.Notice;

public interface NoticeService{

	int insertNotice(Notice notice);

	int getTotalCount();

	List<Notice> selectNoticeList(int currentPage, int boardCountPerPage);

}
