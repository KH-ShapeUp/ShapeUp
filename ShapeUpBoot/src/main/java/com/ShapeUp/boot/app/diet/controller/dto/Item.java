package com.ShapeUp.boot.app.diet.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Item {
    private String foodNames;     // 음식 이름 (사용자 입력)
    private String name;          // 음식 이름 (API)
    private String foodCd;        // 음식 코드
    private Double amount;        // 섭취량
    private Double kcal;          // 칼로리
}