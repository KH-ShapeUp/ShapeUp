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

	@Override
	public int updateNotice(Notice notice) {
		return noticeMapper.updateNotice(notice);
	}

	@Override
	public int insertNoticeImage(com.ShapeUp.boot.domain.notice.model.vo.NoticeImage image) {
		return noticeMapper.insertNoticeImage(image);
	}

	@Override
	public int deleteNoticeImage(int imgNo) {
		return noticeMapper.deleteNoticeImage(imgNo);
	}

	@Override
	public int deleteNotice(int noticeNo) {
		return noticeMapper.deleteNotice(noticeNo);
	}

	@Override
	public java.util.List<com.ShapeUp.boot.domain.notice.model.vo.NoticeImage> selectImagesByNotice(int noticeNo) {
		return noticeMapper.selectImagesByNotice(noticeNo);
	}

	@Override
	public java.util.List<java.util.Map<String, Object>> selectNoticeTrend() {
		return noticeMapper.selectNoticeTrend();
	}

}
