package com.ShapeUp.boot.domain.admin.user.model.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class AdminUserVO {
	private int userNo;              // USER_NO (시퀀스)
	private String userId;           // USER_ID
	private String userPw;           // USER_PW
	private String userName;         // USER_NAME
	private int userAge;             // USER_AGE
	private String userEmail;        // USER_EMAIL
	private String userPhone;        // USER_PHONE
	private String userSerialNo;     // USER_SERIAL_NO (생년월일+뒷번호 첫자리)
	private String userType;         // USER_TYPE (기본값: USER)
	private Timestamp createdAt;     // CREATED_AT
	private Timestamp updatedAt;     // UPDATED_AT
	private String userNickname;     // USER_NICKNAME
	private String status;           // STATUS (기본값: 정상)
}