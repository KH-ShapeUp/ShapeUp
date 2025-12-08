package com.ShapeUp.boot.domain.user.model.mapper;

import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.ShapeUp.boot.domain.user.model.vo.UserInterestVO;
import com.ShapeUp.boot.domain.user.model.vo.UserProfileImageVO;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.ShapeUp.boot.domain.user.model.vo.RequestPermissionVO;
import java.util.List;

@Mapper
public interface UserMapper {
    
    int insertUser(UserVO user);
    
    int checkUserIdDuplicate(@Param("userId") String userId);
    
    int checkNicknameDuplicate(@Param("nickname") String nickname);
    
    UserVO selectUserById(@Param("userId") String userId);
    
    UserVO selectUserByEmail(@Param("email") String email);
    
    UserVO findUserByNameAndEmail(@Param("name") String name, @Param("email") String email);
    
    UserVO selectUserByIdAndNameAndEmail(@Param("userId") String userId, 
                                         @Param("name") String name, 
                                         @Param("email") String email);
    
    int updatePassword(@Param("userId") String userId, 
                      @Param("encodedPassword") String encodedPassword);
    
    int selectUserNoByUserId(@Param("userId") String userId);
    
    int insertUserInterest(@Param("userNo") int userNo, 
                          @Param("interests") String interests, 
                          @Param("times") String times, 
                          @Param("addresses") String addresses);
    
    int countEmail(@Param("email") String email);
    
    UserVO findUserByNameEmailPhone(Map<String, String> params);
    
    // 🔥 추가: 아이디로만 사용자 조회
    UserVO findUserByUserId(@Param("userId") String userId);
    
    // 🔥 추가: 비밀번호 업데이트 (다른 이름)
    int updateUserPassword(@Param("userId") String userId, 
                          @Param("encodedPw") String encodedPw);
    
    UserVO selectUserByUserNo(@Param("userNo") int userNo);
    
    int updateUserEmail(@Param("userNo") int userNo, @Param("email") String email);
    
    int updateUserPhone(@Param("userNo") int userNo, @Param("phone") String phone);
    
    int updateUserPasswordByUserNo(@Param("userNo") int userNo, 
                                    @Param("encodedPassword") String encodedPassword);
    
    int deleteUser(@Param("userNo") int userNo);
    
    int updateNickname(@Param("userNo") int userNo, @Param("nickname") String nickname);
    
    UserVO findByUserId(String userId);
    
    int insertSocialUser(UserVO user);
    
    void updateSocialUserInfo(UserVO user);
    
    // ================================
    // ⭐ 관심사 관련 메서드 추가
    // ================================
    
    /**
     * 사용자 관심사 조회
     */
    UserInterestVO selectUserInterest(@Param("userNo") int userNo);
    
    /**
     * 사용자 관심사 수정
     */
    int updateUserInterest(@Param("userNo") int userNo, 
                          @Param("interests") String interests, 
                          @Param("times") String times);
    
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
    
    /**
     * 사용자 권한(USER_TYPE) 변경
     */
    int updateUserType(@Param("userNo") int userNo, @Param("userType") String userType);
    
    /**
     * 프로필 이미지 조회
     * @param userNo 사용자 번호
     * @return 프로필 이미지 정보
     */
    UserProfileImageVO selectProfileImage(int userNo);
    
    /**
     * 프로필 이미지 등록
     * @param profileImage 프로필 이미지 정보
     * @return 등록 결과 (1: 성공, 0: 실패)
     */
    int insertProfileImage(UserProfileImageVO profileImage);
    
    /**
     * 프로필 이미지 삭제 (메인 이미지만)
     * @param userNo 사용자 번호
     * @return 삭제 결과 (1: 성공, 0: 실패)
     */
    int deleteProfileImage(int userNo);
    
    /**
     * 사용자의 모든 프로필 이미지 삭제
     * @param userNo 사용자 번호
     * @return 삭제된 행 수
     */
    int deleteAllProfileImages(int userNo);
    
    String selectUserProfileImgPath(int userNo);
    
    void updateUserStatus(UserVO user);

}