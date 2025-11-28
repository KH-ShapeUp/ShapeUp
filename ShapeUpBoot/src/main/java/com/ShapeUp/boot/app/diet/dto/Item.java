package com.ShapeUp.boot.app.diet.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
public class Item {
   private String name;
   private String foodNames;
   private String foodCd;
   private double amount;
   private double kcal;
}
