package com.ShapeUp.boot.domain.notice.model.service.impl;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.notice.model.mapper.NoticeMapper;
import com.ShapeUp.boot.domain.notice.model.service.NoticeService;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService{
	
	private final NoticeMapper noticeMapper;

	@Override
	public int getTotalCount() {
		int totalCount = noticeMapper.getTotalCount();
		return totalCount;
	}

	@Override
	public List<Notice> selectNoticeList(int currentPage, int boardCountPerPage) {
		int offset = (currentPage - 1) * boardCountPerPage;
		RowBounds rowBounds = new RowBounds(offset, boardCountPerPage);
		List<Notice> nList = noticeMapper.selectNoticeList(rowBounds);
		return nList;
	}

	@Override
	public int insertNotice(Notice notice) {
		int result = noticeMapper.insertNotice(notice);
		return result;
	}

}
