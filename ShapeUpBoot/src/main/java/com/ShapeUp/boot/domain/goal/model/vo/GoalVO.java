package com.ShapeUp.boot.domain.goal.model.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 목표 설정 VO (GOAL_TBL)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GoalVO {
    
    private Integer userNo;          // 사용자 번호 (PK)
    private Double goalWeight;       // 목표 체중
    private Double goalFat;          // 목표 체지방량
    private Double goalSmm;          // 목표 골격근량
    private Timestamp createdAt;     // 생성 시간
    private Timestamp updatedAt;     // 수정 시간
    private Integer goalCalorie;     // 주간 목표 칼로리
    
}