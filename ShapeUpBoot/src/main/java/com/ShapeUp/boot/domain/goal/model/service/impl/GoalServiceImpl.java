package com.ShapeUp.boot.domain.goal.model.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ShapeUp.boot.domain.goal.model.mapper.GoalMapper;
import com.ShapeUp.boot.domain.goal.model.service.GoalService;
import com.ShapeUp.boot.domain.goal.model.vo.GoalVO;

@Service
public class GoalServiceImpl implements GoalService {
    
    @Autowired
    private GoalMapper goalMapper;
    
    @Override
    public GoalVO getGoalByUserNo(Integer userNo) {
        return goalMapper.selectGoalByUserNo(userNo);
    }
    
    @Override
    @Transactional
    public GoalVO saveOrUpdateGoal(GoalVO goalVO) {
        // 기존 목표가 있는지 확인
        GoalVO existingGoal = goalMapper.selectGoalByUserNo(goalVO.getUserNo());
        
        if (existingGoal != null) {
            // 업데이트
            int result = goalMapper.updateGoal(goalVO);
            if (result > 0) {
                return goalMapper.selectGoalByUserNo(goalVO.getUserNo());
            } else {
                throw new RuntimeException("목표 업데이트에 실패했습니다.");
            }
        } else {
            // 신규 등록
            int result = goalMapper.insertGoal(goalVO);
            if (result > 0) {
                return goalMapper.selectGoalByUserNo(goalVO.getUserNo());
            } else {
                throw new RuntimeException("목표 등록에 실패했습니다.");
            }
        }
    }
    
    @Override
    @Transactional
    public boolean deleteGoal(Integer userNo) {
        int result = goalMapper.deleteGoal(userNo);
        return result > 0;
    }
    
}

