package com.ShapeUp.boot.domain.user.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.user.model.vo.RequestPermissionVO;

/**
 * 권한 신청 Service 인터페이스
 */
public interface RequestPermissionService {
    
    /**
     * 권한 신청 등록
     */
    int insertRequestPermission(RequestPermissionVO request);
    
    /**
     * 사용자의 대기 중인 신청 조회
     */
    RequestPermissionVO getPendingRequestByUserNo(int userNo);
    
    /**
     * 특정 사용자의 모든 신청 내역 조회
     */
    List<RequestPermissionVO> getRequestsByUserNo(int userNo);
    
    /**
     * 신청 번호로 조회
     */
    RequestPermissionVO getRequestByNo(int requestNo);
    
    /**
     * 모든 대기 중인 신청 조회 (관리자용)
     */
    List<RequestPermissionVO> getAllPendingRequests();
    
    /**
     * 모든 신청 조회 (관리자용)
     */
    List<RequestPermissionVO> getAllRequests();
    
    /**
     * 신청 승인 (권한 변경 포함)
     */
    boolean approveRequest(int requestNo);
    
    /**
     * 신청 반려
     */
    boolean rejectRequest(int requestNo, String rejectReason);
    
    /**
     * 신청 삭제
     */
    int deleteRequest(int requestNo);
    
    /**
     * 신청 취소 (사용자가 직접)
     */
    int cancelRequest(int requestNo);
    
    RequestPermissionVO selectPendingRequestByUserNo(int userNo);
    
    List<RequestPermissionVO> selectRequestsByUserNo(int userNo);
}