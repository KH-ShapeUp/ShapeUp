package com.ShapeUp.boot.domain.notification.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.RowBounds;

import com.ShapeUp.boot.domain.notification.model.vo.NotificationVO;

@Mapper
public interface NotificationMapper {
    int insert(NotificationVO vo);
    List<NotificationVO> selectRecentUnread(@Param("userNo") int userNo, RowBounds rowBounds);
    int markRead(@Param("notiNo") long notiNo, @Param("userNo") int userNo);
}
