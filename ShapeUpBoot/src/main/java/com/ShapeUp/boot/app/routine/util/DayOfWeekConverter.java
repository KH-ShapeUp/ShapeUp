package com.ShapeUp.boot.app.routine.util;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class DayOfWeekConverter {

	// 숫자를 한국어로 변환하기 위한 역방향 매핑
	private static final Map<Integer, String> NUMBER_TO_DAY;
	
	static {
		Map<Integer, String> ntd = new HashMap<>();
		ntd.put(1, "월");
        ntd.put(2, "화");
        ntd.put(3, "수");
        ntd.put(4, "목");
        ntd.put(5, "금");
        ntd.put(6, "토");
        ntd.put(7, "일");
        NUMBER_TO_DAY = Collections.unmodifiableMap(ntd);
	}
	
	/**
     * DB에서 조회한 숫자 코드를 한국어 요일 문자열로 변환합니다.
     * @param dayCode (1~7)
     * @return 요일 문자열 ("월", "화" 등)
     */
	public static String getDayString(int daycode) {
		return NUMBER_TO_DAY.getOrDefault(daycode, "");
	}
}
