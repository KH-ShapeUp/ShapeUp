package com.ShapeUp.boot.app.diet.dto;

import java.util.List;

import lombok.Data;
@Data
public class DietSaveRequest {
   private String dietType;
   private String dietDate;
   private List<Item> items;
}

