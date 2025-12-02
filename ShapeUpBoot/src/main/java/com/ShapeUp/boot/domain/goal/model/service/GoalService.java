package com.ShapeUp.boot.domain.goal.model.service;

import com.ShapeUp.boot.domain.goal.model.vo.GoalVO;

/**
 * 목표 설정 서비스 인터페이스
 */
public interface GoalService {
    
    /**
     * 사용자 번호로 목표 조회
     * @param userNo 사용자 번호
     * @return 목표 정보
     */
    GoalVO getGoalByUserNo(Integer userNo);
    
    /**
     * 목표 저장 또는 업데이트
     * @param goalVO 목표 정보
     * @return 저장된 목표 정보
     */
    GoalVO saveOrUpdateGoal(GoalVO goalVO);
    
    /**
     * 목표 삭제
     * @param userNo 사용자 번호
     * @return 삭제 성공 여부
     */
    boolean deleteGoal(Integer userNo);
    
}