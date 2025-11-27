package com.ShapeUp.boot.domain.notice.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import com.ShapeUp.boot.domain.notice.model.vo.Notice;
import com.ShapeUp.boot.domain.notice.model.vo.NoticeImage;

@Mapper
public interface NoticeMapper {

	int getTotalCount();
	
	List<Notice> selectNoticeList(RowBounds rowBounds);

	int insertNotice(Notice notice);

	int updateNotice(Notice notice);

	List<NoticeImage> selectImagesByNotice(int noticeNo);

	int insertNoticeImage(NoticeImage image);

	int deleteNoticeImage(int imgNo);

	int deleteNotice(int noticeNo);

	List<java.util.Map<String, Object>> selectNoticeTrend();

}
