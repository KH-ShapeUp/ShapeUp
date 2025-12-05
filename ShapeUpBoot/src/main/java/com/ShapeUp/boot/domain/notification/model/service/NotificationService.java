package com.ShapeUp.boot.domain.notification.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.notification.model.vo.NotificationVO;

public interface NotificationService {
    void create(int userNo, String type, Long refId, String title, String message, String linkPath);
    List<NotificationVO> getRecentUnread(int userNo, int limit);
    boolean markRead(long notiNo, int userNo);
}
