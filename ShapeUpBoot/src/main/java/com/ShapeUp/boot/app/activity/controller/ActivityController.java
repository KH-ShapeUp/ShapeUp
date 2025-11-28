package com.ShapeUp.boot.app.activity.controller;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import com.ShapeUp.boot.app.activity.dto.ActivityItem;
import com.ShapeUp.boot.app.activity.dto.ActivtiyInsertDto;
import com.ShapeUp.boot.domain.activity.model.service.ActivityService;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityLogVO;
import com.ShapeUp.boot.domain.activity.model.vo.ActivityVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/activity")
@RequiredArgsConstructor
@Slf4j
public class ActivityController {

    private final ActivityService aService;


    @GetMapping
    public String activityPage() {
        return "activity/activityRecord";
    }

    @GetMapping("/list")
    @ResponseBody
    public List<ActivityVO> getActivityList(@RequestParam("q") String keyword) {

        if (keyword == null || keyword.isBlank()) {
            return List.of();
        }
        List<ActivityVO> activitys = aService.getActivityListByKeyword(keyword);

        return activitys;
    }
    
    
    
    @PostMapping("/insert")
    @ResponseBody

    public ResponseEntity<Map<String, Object>> insertActivities(@RequestBody ActivtiyInsertDto items, HttpSession session) {
    	int userNo = (int) session.getAttribute("userNo");
        log.info("Received activity insert payload: {}", items);
        
        if (items == null || items.getItems() == null || items.getItems().isEmpty()) {
            return ResponseEntity.badRequest()
                .body(Map.of("success", false, "message", "NO_ITEMS"));
        }

    	//String actionAt = sanitizeDate(items.getActionAt());
//    	Timestamp actionAtTs = convertToTimestamp(actionAt);
    	
    	int inserted = 0;
        for(ActivityItem aItem : items.getItems()) {
        	ActivityLogVO log = new ActivityLogVO();
            log.setUserNo(userNo);
            log.setActivityId(aItem.getActivityId());
            log.setDurationMin(aItem.getDurationMin());
            log.setCalories(aItem.getCalories());
            log.setWeightLevel(aItem.getWeightLevel());
            log.setIntensityLevel(aItem.getIntensityFactor());
            log.setSourceType("MANUAL");
            
            inserted += aService.insertActivities(log);
            
            System.out.println(log);
        }
        System.out.println(inserted);
        return ResponseEntity.ok(Map.of("success", true));
    }
    


        //int inserted = 0;
//        for(ActivityItem aItem : items.getItems()) {
//            ActivityLogVO activityLog = new ActivityLogVO();
//            activityLog.setUserNo(userNo);
//            activityLog.setActivityId(aItem.getActivityId());
//            activityLog.setDurationMin(aItem.getDurationMin());
//            activityLog.setCalories(aItem.getCalories());
//            activityLog.setWeightLevel(aItem.getWeightLevel());
//            activityLog.setIntensityLevel(aItem.getIntensityFactor());
//            activityLog.setSourceType("MANUAL");
//            activityLog.setActionAt(actionAtTs);
//
//            int result = aService.insertActivities(activityLog);
//            inserted += result;
//            log.info("Inserted activity log: {}", activityLog);
//        }
        
//        log.info("Total {} activities inserted", inserted);
//        return ResponseEntity.ok(Map.of(
//            "success", true, 
//            "inserted", inserted
//        ));
//    }
//    
    private Timestamp convertToTimestamp(String dateStr) {
        try {
            LocalDate date = LocalDate.parse(dateStr);
            return Timestamp.valueOf(date.atStartOfDay());
        } catch (Exception e) {
            log.error("Failed to convert date to timestamp: {}", dateStr, e);
            return new Timestamp(System.currentTimeMillis());
        }
    }
    
    private String sanitizeDate(String actionAt) {
        if (actionAt == null || actionAt.isBlank()) {
            // 날짜가 없으면 오늘 날짜 반환
            return LocalDate.now().toString();
        }
        
        // 공백 제거
        actionAt = actionAt.trim();
        
        try {
            // 날짜 형식 검증 (yyyy-MM-dd)
            LocalDate.parse(actionAt);
            return actionAt;
        } catch (Exception e) {
            log.warn("Invalid date format received: {}, using current date", actionAt);
            // 파싱 실패시 오늘 날짜 반환
            return LocalDate.now().toString();
        }
    }
}
