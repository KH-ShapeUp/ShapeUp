package com.ShapeUp.boot.domain.notice.model.mapper;

import org.apache.ibatis.annotations.Mapper;
import com.ShapeUp.boot.app.notice.dto.NoticeInsertImageDto;

@Mapper // MyBatis 매퍼임을 명시합니다.
public interface NoticeImageMapper {


    int insertNoticeImage(NoticeInsertImageDto dto);
}