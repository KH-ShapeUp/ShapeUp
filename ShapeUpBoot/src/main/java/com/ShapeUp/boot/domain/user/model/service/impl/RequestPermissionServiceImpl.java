package com.ShapeUp.boot.domain.user.model.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ShapeUp.boot.domain.user.model.mapper.UserMapper;
import com.ShapeUp.boot.domain.user.model.service.RequestPermissionService;
import com.ShapeUp.boot.domain.user.model.vo.RequestPermissionVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 권한 신청 Service 구현
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RequestPermissionServiceImpl implements RequestPermissionService {
    
    private final UserMapper userMapper;  // ⭐ UserMapper 사용

    @Override
    public RequestPermissionVO selectPendingRequestByUserNo(int userNo) {
        log.info("🔍 대기 중인 신청 조회 - userNo: {}", userNo);
        RequestPermissionVO result = userMapper.selectPendingRequestByUserNo(userNo);
        
        if (result != null) {
            log.info("✅ 대기 중인 신청 있음 - requestNo: {}, requestType: {}", 
                    result.getRequestNo(), result.getRequestType());
        } else {
            log.info("ℹ️ 대기 중인 신청 없음 - userNo: {}", userNo);
        }
        
        return result;
    }
    
    @Override
    public int insertRequestPermission(RequestPermissionVO request) {
        return userMapper.insertRequestPermission(request);
    }

    @Override
    public RequestPermissionVO getPendingRequestByUserNo(int userNo) {
        return userMapper.selectPendingRequestByUserNo(userNo);
    }

    @Override
    public List<RequestPermissionVO> getRequestsByUserNo(int userNo) {
        return userMapper.selectRequestsByUserNo(userNo);
    }

    @Override
    public RequestPermissionVO getRequestByNo(int requestNo) {
        return userMapper.selectRequestByNo(requestNo);
    }

    @Override
    public List<RequestPermissionVO> getAllPendingRequests() {
        return userMapper.selectAllPendingRequests();
    }

    @Override
    public List<RequestPermissionVO> getAllRequests() {
        return userMapper.selectAllRequests();
    }

    @Override
    @Transactional
    public boolean approveRequest(int requestNo) {
        try {
            RequestPermissionVO request = userMapper.selectRequestByNo(requestNo);
            
            if (request == null) {
                log.error("❌ 신청 정보를 찾을 수 없음 - requestNo: {}", requestNo);
                return false;
            }
            
            int statusResult = userMapper.updateRequestStatus(requestNo, "승인", null);
            
            if (statusResult > 0) {
                int userResult = userMapper.updateUserType(request.getUserNo(), request.getRequestType());
                
                if (userResult > 0) {
                    log.info("✅ 권한 신청 승인 완료 - requestNo: {}, userNo: {}, newType: {}", 
                            requestNo, request.getUserNo(), request.getRequestType());
                    return true;
                } else {
                    log.error("❌ 사용자 권한 변경 실패 - userNo: {}", request.getUserNo());
                    throw new RuntimeException("사용자 권한 변경 실패");
                }
            }
            
            return false;
            
        } catch (Exception e) {
            log.error("❌ 권한 신청 승인 중 오류 발생", e);
            throw e;
        }
    }

    @Override
    public boolean rejectRequest(int requestNo, String rejectReason) {
        int result = userMapper.updateRequestStatus(requestNo, "반려", rejectReason);
        
        if (result > 0) {
            log.info("✅ 권한 신청 반려 완료 - requestNo: {}, reason: {}", requestNo, rejectReason);
            return true;
        }
        
        return false;
    }

    @Override
    public int deleteRequest(int requestNo) {
        return userMapper.deleteRequest(requestNo);
    }

    @Override
    public int cancelRequest(int requestNo) {
        return userMapper.cancelRequest(requestNo);
    }
    
    @Override
    public List<RequestPermissionVO> selectRequestsByUserNo(int userNo) {
        log.info("🔍 사용자 신청 내역 조회 - userNo: {}", userNo);
        return userMapper.selectRequestsByUserNo(userNo);
    }
}