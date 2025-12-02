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
    	Integer userNo = extractUserNo(session);
    	if (userNo == null) {
    		return ResponseEntity.status(401).body(Map.of("success", false, "message", "LOGIN_REQUIRED"));
    	}
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
            log.setActionAt(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
            log.setSourceType("MANUAL");
            
            inserted += aService.insertActivities(log);
            
            System.out.println(log);
        }
        System.out.println(inserted);
        return ResponseEntity.ok(Map.of("success", true));
    }

    @GetMapping("/summary")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getSummary(@RequestParam(value="date", required=false) String date, HttpSession session) {
    	Integer userNo = extractUserNo(session);
    	if (userNo == null) {
    		return ResponseEntity.status(401).body(Map.of("loggedIn", false));
    	}
    	String targetDate = sanitizeDate(date);
    	Map<String, Object> totals = aService.sumLogsByDate(userNo, targetDate);
    	List<Map<String, Object>> byType = aService.sumKcalByType(userNo, targetDate);
    	return ResponseEntity.ok(Map.of(
    		"loggedIn", true,
    		"date", targetDate,
    		"totals", totals != null ? totals : Map.of(),
    		"byType", byType != null ? byType : List.of()
    	));
    }

    @GetMapping("/logs")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getLogs(@RequestParam(value="date", required=false) String date, HttpSession session) {
    	Integer userNo = extractUserNo(session);
    	if (userNo == null) {
    		return ResponseEntity.status(401).body(Map.of("loggedIn", false, "logs", List.of()));
    	}
    	String targetDate = sanitizeDate(date);
    	List<Map<String, Object>> raw = aService.selectLogsByDate(userNo, targetDate);
    	List<Map<String, Object>> logs = raw.stream().map(row -> {
    		Map<String, Object> m = new java.util.HashMap<>();
    		m.put("logId", safeInt(row.get("logId")));
    		m.put("activityName", row.getOrDefault("activityName", ""));
    		m.put("activityType", row.getOrDefault("activityType", ""));
    		m.put("durationMin", safeDouble(row.get("durationMin")));
    		m.put("calories", safeDouble(row.get("calories")));
    		m.put("weightLevel", safeDouble(row.get("weightLevel")));
    		m.put("intensityFactor", safeDouble(row.get("intensityFactor")));
    		m.put("actionAt", stringifyDate(row.get("actionAt")));
    		return m;
    	}).toList();
    	return ResponseEntity.ok(Map.of(
    		"loggedIn", true,
    		"logs", logs != null ? logs : List.of()
    	));
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteLogs(@RequestBody Map<String, Object> body, HttpSession session) {
    	Integer userNo = extractUserNo(session);
    	if (userNo == null) {
    		return ResponseEntity.status(401).body(Map.of("success", false, "message", "LOGIN_REQUIRED"));
    	}
    	Object raw = body.get("logIds");
    	if (!(raw instanceof List<?> rawList) || rawList.isEmpty()) {
    		return ResponseEntity.badRequest().body(Map.of("success", false, "message", "NO_ITEMS"));
    	}
    	List<Integer> ids = rawList.stream().map(o -> {
    		try { return Integer.valueOf(String.valueOf(o).trim()); } catch (Exception e) { return null; }
    	}).filter(v -> v != null).toList();
    	if (ids.isEmpty()) {
    		return ResponseEntity.badRequest().body(Map.of("success", false, "message", "NO_ITEMS"));
    	}
    	int deleted = aService.deleteLogs(userNo, ids);
    	return ResponseEntity.ok(Map.of("success", true, "deleted", deleted));
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
            return LocalDate.now().toString();
        }
        actionAt = actionAt.trim();
        try {
            LocalDate.parse(actionAt);
            return actionAt;
        } catch (Exception e) {
            log.warn("Invalid date format received: {}, using current date", actionAt);
            return LocalDate.now().toString();
        }
    }

    private Integer extractUserNo(HttpSession session) {
    	if (session == null) return null;
    	Object raw = session.getAttribute("userNo");
    	if (raw instanceof Number) return ((Number) raw).intValue();
    	if (raw instanceof String s) {
    		try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return null; }
    	}
    	return null;
    }

    private Integer safeInt(Object o) {
    	if (o == null) return null;
    	try { return Integer.valueOf(o.toString()); } catch (Exception e) { return null; }
    }

    private Double safeDouble(Object o) {
    	if (o == null) return 0d;
    	try { return Double.valueOf(o.toString()); } catch (Exception e) { return 0d; }
    }

    private String stringifyDate(Object o) {
    	if (o == null) return null;
    	if (o instanceof java.sql.Timestamp ts) {
    		return ts.toLocalDateTime().toString();
    	}
    	return o.toString();
    }
}
