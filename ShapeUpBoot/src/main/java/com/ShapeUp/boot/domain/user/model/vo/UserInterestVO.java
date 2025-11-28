package com.ShapeUp.boot.domain.user.model.vo;

import lombok.Data;

@Data
public class UserInterestVO {
    private int interestNo;
    private int userNo;
    private String interestActivity;  // 축구,풋살,농구
    private String activityTime;      // 평일,저녁
    private String activityLocation;  // 선택사항
}