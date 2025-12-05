package com.ShapeUp.boot.domain.notification.model.service.impl;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ShapeUp.boot.domain.notification.model.mapper.NotificationMapper;
import com.ShapeUp.boot.domain.notification.model.service.NotificationService;
import com.ShapeUp.boot.domain.notification.model.vo.NotificationVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private final NotificationMapper notificationMapper;

    @Override
    @Transactional
    public void create(int userNo, String type, Long refId, String title, String message, String linkPath) {
        NotificationVO vo = new NotificationVO();
        vo.setUserNo(userNo);
        vo.setType(type);
        vo.setRefId(refId);
        vo.setTitle(title);
        vo.setMessage(message);
        vo.setLinkPath(linkPath);
        vo.setReadYn("N");
        notificationMapper.insert(vo);
    }

    @Override
    public List<NotificationVO> getRecentUnread(int userNo, int limit) {
        RowBounds rb = new RowBounds(0, limit);
        return notificationMapper.selectRecentUnread(userNo, rb);
    }

    @Override
    @Transactional
    public boolean markRead(long notiNo, int userNo) {
        return notificationMapper.markRead(notiNo, userNo) > 0;
    }
}
