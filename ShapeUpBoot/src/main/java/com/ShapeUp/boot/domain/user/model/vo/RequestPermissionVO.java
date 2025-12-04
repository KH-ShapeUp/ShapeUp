package com.ShapeUp.boot.domain.user.model.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 권한 신청 VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RequestPermissionVO {
    private int requestNo;              // 신청 번호 (PK)
    private int userNo;                 // 신청자 회원번호 (FK)
    private String requestType;         // 신청 권한 타입 ('STADIUM_MANAGER', 'TRAINER')
    private String requestStatus;       // 신청 상태 ('대기', '승인', '반려')
    private String requestReason;       // 신청 사유
    
    // 시설 관리자용
    private String businessName;        // 사업자명/시설명
    private String businessNumber;      // 사업자등록번호
    
    // 트레이너용
    private String certificateType;     // 자격증 종류
    private String certificateNumber;   // 자격증 번호
    private String career;              // ⭐ 활동 기간
    private String careerDetail;
    // 첨부파일
    private String attachmentPath;      // 첨부파일 경로
    private String attachmentOrigin;    // 첨부파일 원본명
    private String attachmentRename;    // 첨부파일 저장명
    
    // 처리 정보
    private Timestamp createdAt;        // 신청일시
    private Timestamp updatedAt;        // 수정일시
    private Timestamp processedAt;      // 처리일시
    private String rejectReason;        // 반려 사유
    
    // 추가 정보 (JOIN용)
    private String userName;            // 신청자 이름
    private String userNickname;        // 신청자 닉네임
    private String userId;              // 신청자 아이디
}