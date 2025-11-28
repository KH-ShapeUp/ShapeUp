package com.ShapeUp.boot.common.util;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDateTime;

public class TimeUtil {
	public static String getTimeAgo(Timestamp createdAt) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime created = createdAt.toLocalDateTime();  // Timestamp → LocalDateTime

        Duration duration = Duration.between(created, now);

        long seconds = duration.getSeconds();
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;

        if (seconds < 60) {
            return "방금 전";
        } else if (minutes < 60) {
            return minutes + "분 전";
        } else if (hours < 24) {
            return hours + "시간 전";
        } else if (days < 7) {
            return days + "일 전";
        } else {
            return created.toLocalDate().toString();  // 7일 이상이면 날짜 표시
        }
    }
}
