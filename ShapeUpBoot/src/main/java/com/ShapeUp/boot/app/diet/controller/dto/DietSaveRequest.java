package com.ShapeUp.boot.app.diet.controller.dto;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Alias("DietSaveRequestController")
public class DietSaveRequest {
    private String dietDate;      // 식사 날짜 (yyyy-MM-dd)
    private String dietType;      // 식사 유형 (아침, 점심, 저녁, 간식)
    private List<Item> items;     // 음식 아이템 리스트
}
