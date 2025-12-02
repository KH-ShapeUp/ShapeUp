package com.ShapeUp.boot.app.goal.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 목표 설정 DTO (GOAL_TBL)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GoalDTO {
    
    private Integer userNo;          // 사용자 번호 (PK)
    private Double goalWeight;       // 목표 체중
    private Double goalFat;          // 목표 체지방량
    private Double goalSmm;          // 목표 골격근량
    private Timestamp createdAt;     // 생성 시간
    private Timestamp updatedAt;     // 수정 시간
    
}
