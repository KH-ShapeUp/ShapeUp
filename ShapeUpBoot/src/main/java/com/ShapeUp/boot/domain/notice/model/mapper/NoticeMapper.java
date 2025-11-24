package com.ShapeUp.boot.domain.notice.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import com.ShapeUp.boot.app.notice.dto.NoticeInsertDto;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

@Mapper
public interface NoticeMapper {

	int getTotalCount();
	
	List<Notice> selectNoticeList(RowBounds rowBounds);

	int insertNotice(NoticeInsertDto noticeInsertDto);

}
