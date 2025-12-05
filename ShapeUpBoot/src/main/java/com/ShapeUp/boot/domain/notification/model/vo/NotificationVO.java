package com.ShapeUp.boot.domain.notification.model.vo;

import java.sql.Timestamp;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotificationVO {
    private long notiNo;
    private int userNo;
    private String type;       // 예: ROLE, CONTACT 등
    private Long refId;        // 관련 엔티티 PK
    private String title;
    private String message;
    private String linkPath;
    private String readYn;
    private Timestamp createdAt;
}
