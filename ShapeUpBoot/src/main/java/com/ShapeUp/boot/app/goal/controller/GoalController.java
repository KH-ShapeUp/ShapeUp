package com.ShapeUp.boot.app.goal.controller;



import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ShapeUp.boot.domain.goal.model.service.GoalService;
import com.ShapeUp.boot.domain.goal.model.vo.GoalVO;

import jakarta.servlet.http.HttpSession;

/**
 * 목표 설정 관련 컨트롤러
 */
@Controller
@RequestMapping("/user")
public class GoalController {
    
    @Autowired
    private GoalService goalService;
    
    /**
     * 목표 설정 페이지로 이동
     */
    @GetMapping("/settingGoal")
    public String settingGoalPage() {
        return "user/settingGoal";
    }
    
    /**
     * 사용자의 현재 목표 조회
     */
    @GetMapping("/getGoals")
    @ResponseBody
    public GoalVO getGoals(HttpSession session) {
        // 세션에서 사용자 번호 가져오기
        Integer userNo = (Integer) session.getAttribute("userNo");
        
        if (userNo == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }
        
        return goalService.getGoalByUserNo(userNo);
    }
    
    /**
     * 목표 저장 또는 업데이트
     */
    @PostMapping("/saveGoals")
    @ResponseBody
    public GoalVO saveGoals(@RequestBody GoalVO goalVO, HttpSession session) {
        // 세션에서 사용자 번호 가져오기
        Integer userNo = (Integer) session.getAttribute("userNo");
        
        if (userNo == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }
        
        // VO에 사용자 번호 설정
        goalVO.setUserNo(userNo);
        
        // 유효성 검사
        validateGoalData(goalVO);
        
        // 목표 저장 또는 업데이트
        return goalService.saveOrUpdateGoal(goalVO);
    }
    
    @PostMapping("/saveActivityGoals")
    @ResponseBody
    public Map<String, Object> saveActivityGoals(@RequestBody GoalVO activityGoalVO, HttpSession session) {
        Integer userNo = (Integer) session.getAttribute("userNo");
        Map<String, Object> response = new HashMap<>();
        
        if (userNo == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return response;
        }
        
        // 1. 기존 목표 정보 조회 (다른 필드의 null 방지)
        GoalVO existingGoal = goalService.getGoalByUserNo(userNo);
        GoalVO targetGoal = existingGoal != null ? existingGoal : new GoalVO();

        // 2. VO에 사용자 번호 설정
        targetGoal.setUserNo(userNo);
        
        // 3. 활동 목표 필드만 업데이트 (다른 필드는 기존 값 유지)
        targetGoal.setGoalCalorieActivityDaily(activityGoalVO.getGoalCalorieActivityDaily());
        targetGoal.setGoalActivityTime(activityGoalVO.getGoalActivityTime());
        
        // 4. 유효성 검사 (필요 시 활동 목표에 대한 유효성 검사 로직 추가)
        validateActivityGoalData(targetGoal); 
        
        try {
            // 5. 목표 저장 또는 업데이트
            GoalVO updatedGoal = goalService.saveOrUpdateGoal(targetGoal);
            
            response.put("success", true);
            response.put("message", "활동 목표가 성공적으로 저장되었습니다.");
            response.put("goal", updatedGoal);
            return response;
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "목표 저장 중 오류 발생: " + e.getMessage());
            return response;
        }
    }
    
    /**
     * 목표 데이터 유효성 검사
     */
    private void validateGoalData(GoalVO goalVO) {
        // 체중 범위 체크
        if (goalVO.getGoalWeight() < 30 || goalVO.getGoalWeight() > 200) {
            throw new IllegalArgumentException("목표 체중은 30kg에서 200kg 사이여야 합니다.");
        }
        
        // 체지방량 범위 체크
        if (goalVO.getGoalFat() < 0 || goalVO.getGoalFat() > 100) {
            throw new IllegalArgumentException("목표 체지방량은 0kg에서 100kg 사이여야 합니다.");
        }
        
        // 골격근량 범위 체크
        if (goalVO.getGoalSmm() < 0 || goalVO.getGoalSmm() > 100) {
            throw new IllegalArgumentException("목표 골격근량은 0kg에서 100kg 사이여야 합니다.");
        }
        
        // 주간 칼로리 범위 체크
        if (goalVO.getGoalCalorie() != null && 
            (goalVO.getGoalCalorie() < 0 || goalVO.getGoalCalorie() > 50000)) {
            throw new IllegalArgumentException("주간 목표 칼로리는 0kcal에서 50,000kcal 사이여야 합니다.");
        }
        
        // 논리적 검증
        if (goalVO.getGoalFat() + goalVO.getGoalSmm() > goalVO.getGoalWeight()) {
            throw new IllegalArgumentException("체지방량과 골격근량의 합이 목표 체중보다 클 수 없습니다.");
        }
    }
    
    private void validateActivityGoalData(GoalVO goalVO) {
        // 일일 목표 소모 칼로리 유효성 검사 (0~10000kcal 가정)
        if (goalVO.getGoalCalorieActivityDaily() != null && 
            (goalVO.getGoalCalorieActivityDaily() < 0 || goalVO.getGoalCalorieActivityDaily() > 10000)) {
            throw new IllegalArgumentException("일일 목표 소모 칼로리는 0kcal에서 10,000kcal 사이여야 합니다.");
        }
        
        // 목표 운동 시간 유효성 검사 (0~720분/12시간 가정)
        if (goalVO.getGoalActivityTime() != null && 
            (goalVO.getGoalActivityTime() < 0 || goalVO.getGoalActivityTime() > 720)) {
            throw new IllegalArgumentException("목표 운동 시간은 0분에서 720분(12시간) 사이여야 합니다.");
        }
    }
}