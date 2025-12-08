package com.ShapeUp.boot.domain.user.model.service;

import java.util.List;

import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.app.matching.dto.matchingListDTO;
import com.ShapeUp.boot.domain.comment.model.vo.commentVO;
import com.ShapeUp.boot.domain.user.model.vo.ReviewVO;
import com.ShapeUp.boot.domain.user.model.vo.UserInterestVO;
import com.ShapeUp.boot.domain.user.model.vo.UserProfileImageVO;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;

public interface UserService {

    int insertUser(UserVO user);

    int checkUserIdDuplicate(String userId);

    int checkNicknameDuplicate(String nickname);

    UserVO selectUserById(String userId);

    UserVO selectUserByEmail(String email);

    UserVO findUserByNameAndEmail(String name, String email);

    UserVO selectUserByIdAndNameAndEmail(String userId, String name, String email);

    int updatePassword(String userId, String encodedPassword);

    int selectUserNoByUserId(String userId);

    int insertUserInterest(int userNo, String interests, String times, String addresses);

    boolean sendEmailVerification(String email);

    boolean sendPhoneVerification(String phone);

    boolean resetPassword(String userId, String name, String email);

    boolean isEmailExists(String email);

    UserVO login(String userId, String rawPassword);

    UserVO findUserByNameEmailPhone(String name, String email, String phone);

    int updateUserPassword(String userId, String encodedPw);

    // 🔥 추가: 아이디로만 사용자 조회
    UserVO findUserByUserId(String userId);
    
    UserVO selectUserByUserNo(int userNo);

    int updateUserEmail(int userNo, String email);

    int updateUserPhone(int userNo, String phone);

    int updateUserPasswordByUserNo(int userNo, String encodedPassword);

    int deleteUser(int userNo);
    
    int updateNickname(int userNo, String nickname);
    
    public int updateSocialUserInfo(UserVO user);
    
    UserInterestVO selectUserInterest(int userNo);
    
    int updateUserInterest(int userNo, String interests, String times);
    
    int updateUserType(int userNo, String userType);
    
    /**
     * 프로필 이미지 조회
     * @param userNo 사용자 번호
     * @return 프로필 이미지 정보
     */
    UserProfileImageVO getProfileImage(int userNo);
    
    /**
     * 프로필 이미지 등록
     * @param profileImage 프로필 이미지 정보
     * @return 등록 결과 (1: 성공, 0: 실패)
     */
    int insertProfileImage(UserProfileImageVO profileImage);
    
    /**
     * 프로필 이미지 삭제
     * @param userNo 사용자 번호
     * @return 삭제 결과 (1: 성공, 0: 실패)
     */
    int deleteProfileImage(int userNo);
    
    /**
     * 사용자의 모든 프로필 이미지 삭제
     * @param userNo 사용자 번호
     * @return 삭제 결과
     */
    int deleteAllProfileImages(int userNo);
    
    /**
     * ⭐ 사용자 프로필 이미지 경로 조회 (댓글/게시글용)
     * @param userNo 사용자 번호
     * @return 프로필 이미지 전체 경로 (IMG_PATH || '/' || IMG_RENAME)
     */
    String getUserProfileImg(int userNo);

    void updateUserStatus(UserVO user) ;
    


    /* 게시물 가져오기 */
	List<communityListDTO> getCommunityList(Integer userNo);
	/* 댓글 가져오기 */
	List<commentVO> getCommentList(Integer userNo);
	/* 내가쓴 매칭 */
	List<matchingListDTO> getMatchingList(Integer userNo);
	/* 예약한 매칭 */
	List<matchingListDTO> getApplyMatchingList(Integer userNo);
	/* 리뷰 쓰기 */
	int reviewInsert(ReviewVO rVo);
}