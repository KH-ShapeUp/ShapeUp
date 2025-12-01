package com.ShapeUp.boot.domain.user.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.ShapeUp.boot.domain.user.model.vo.RequestPermissionVO;

/**
 * 권한 신청 Mapper 인터페이스
 */
@Mapper
public interface RequestPermissionMapper {
    
    /**
     * 권한 신청 등록
     */
    int insertRequestPermission(RequestPermissionVO request);
    
    /**
     * 사용자의 대기 중인 신청 조회
     */
    RequestPermissionVO selectPendingRequestByUserNo(@Param("userNo") int userNo);
    
    /**
     * 특정 사용자의 모든 신청 내역 조회
     */
    List<RequestPermissionVO> selectRequestsByUserNo(@Param("userNo") int userNo);
    
    /**
     * 신청 번호로 조회
     */
    RequestPermissionVO selectRequestByNo(@Param("requestNo") int requestNo);
    
    /**
     * 모든 대기 중인 신청 조회 (관리자용)
     */
    List<RequestPermissionVO> selectAllPendingRequests();
    
    /**
     * 모든 신청 조회 (관리자용)
     */
    List<RequestPermissionVO> selectAllRequests();
    
    /**
     * 신청 상태 업데이트 (승인/반려)
     */
    int updateRequestStatus(@Param("requestNo") int requestNo, 
                           @Param("status") String status,
                           @Param("rejectReason") String rejectReason);
    
    /**
     * 신청 삭제
     */
    int deleteRequest(@Param("requestNo") int requestNo);
    
    /**
     * 신청 취소 (사용자가 직접)
     */
    int cancelRequest(@Param("requestNo") int requestNo);
    
    
    
    
}