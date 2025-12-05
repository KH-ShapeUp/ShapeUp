package com.ShapeUp.boot.domain.contact.model.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class ContactVO {
	private int contactNo;
	private int userNo;
	private String userId;
	private String userNickname;
	private String contactTitle;
	private String contactContent;
	private String category;
	private String status;
	private String answerContent;
	private Timestamp answerAt;
	private Timestamp createdAt;
	private String deleteYn;
}
