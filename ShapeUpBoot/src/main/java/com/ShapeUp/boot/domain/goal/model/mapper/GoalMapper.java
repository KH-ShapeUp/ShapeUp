package com.ShapeUp.boot.domain.goal.model.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.domain.goal.model.vo.GoalVO;

@Mapper
public interface GoalMapper {
    
    /**
     * 사용자 번호로 목표 조회
     * @param userNo 사용자 번호
     * @return 목표 정보
     */
    GoalVO selectGoalByUserNo(Integer userNo);
    
    /**
     * 목표 등록
     * @param goalVO 목표 정보
     * @return 등록된 행 수
     */
    int insertGoal(GoalVO goalVO);
    
    /**
     * 목표 수정
     * @param goalVO 목표 정보
     * @return 수정된 행 수
     */
    int updateGoal(GoalVO goalVO);
    
    /**
     * 목표 삭제
     * @param userNo 사용자 번호
     * @return 삭제된 행 수
     */
    int deleteGoal(Integer userNo);
    
}

