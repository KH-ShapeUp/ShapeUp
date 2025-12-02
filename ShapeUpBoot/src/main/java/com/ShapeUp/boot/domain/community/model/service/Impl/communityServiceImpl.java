package com.ShapeUp.boot.domain.community.model.service.Impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ShapeUp.boot.app.community.dto.communityImageDTO;
import com.ShapeUp.boot.app.community.dto.communityInsertDTO;
import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.common.util.TimeUtil;
import com.ShapeUp.boot.domain.community.model.mapper.communityMapper;
import com.ShapeUp.boot.domain.community.model.service.communityService;
import com.ShapeUp.boot.domain.community.model.vo.communityVO;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class communityServiceImpl implements communityService{
	private final communityMapper cMapper;
	
	/* 커뮤니티 게시글 작성 */
	@Transactional // 게시글과 이미지는 한 몸처럼 저장되어야 함 (하나라도 실패하면 롤백)
    @Override
    public int communityInsert(communityInsertDTO cDTO) {
        
        // 1. 게시글 등록 (Mapper의 selectKey에 의해 cDTO.communityNo에 값이 담김)
        int result = cMapper.communityInsert(cDTO);

        // 2. 본문(HTML)에서 이미지 추출 및 DB 저장 로직 수행
        if(result > 0 && cDTO.getCommunityContent() != null) {
            insertImages(cDTO);
        }

        return result;
    }
	
	// [헬퍼 메소드] HTML 파싱 및 이미지 테이블 INSERT
    private void insertImages(communityInsertDTO cDTO) {
        List<communityImageDTO> imgList = new ArrayList<>();
        
        // Jsoup으로 HTML 파싱
        Document doc = Jsoup.parse(cDTO.getCommunityContent());
        Elements imgs = doc.select("img"); // <img> 태그 다 찾아라

        for (Element img : imgs) {
            String src = img.attr("src"); 
            // src 예시: "/upload/uuid_filename.jpg"
            
            // 우리가 업로드한 이미지가 맞는지 확인 (외부 링크일 수도 있으니까)
            if (src.contains("/upload/")) {
                String fileName = src.substring(src.lastIndexOf("/") + 1); // "uuid_filename.jpg" 추출
                
                communityImageDTO imgDTO = new communityImageDTO();
                imgDTO.setCommunityNo(cDTO.getCommunityNo()); // 1번에서 생긴 게시글 번호
                imgDTO.setImgPath(src);       // 전체 경로
                imgDTO.setImgRename(fileName); // 파일명
                imgDTO.setImgOriginalName(fileName); // (원본명을 따로 관리 안했다면 저장명과 동일하게)
                
                imgList.add(imgDTO);
            }
        }

        // 3. 추출된 이미지가 있으면 DB에 저장 (Mapper 호출)
        if (!imgList.isEmpty()) {
            cMapper.insertCommunityImages(imgList);
        }
    }

    /* 공지사항 가져오기 */
	@Override
	public List<Notice> getNoticeList() {
		return cMapper.getNoticeList();
	}

	/* 커뮤니티 리스트 가져오기 */
	@Override
	public List<communityListDTO> getCommunityList(int currentPage, int boardLimit, String category, String keyword) {
		int offset = (currentPage - 1) * boardLimit;
		RowBounds rowBounds = new RowBounds(offset, boardLimit);
		
		List<communityListDTO> cList = cMapper.getCommunityList(rowBounds, category, keyword);
		 // Timestamp → 상대 시간 변환
	    for (communityListDTO dto : cList) {
	        Timestamp ts = dto.getCreatedAt(); // DTO에 Timestamp 컬럼이 있어야 함
	        dto.setTimeAgo(TimeUtil.getTimeAgo(ts)); // DTO에 timeAgo 필드 추가 필요
	    }
		return cList;
	}

	/* 커뮤니티 총 갯수 */
	@Override
	public int getTotalCount(String category, String keyword) {
		return cMapper.getTotalCount(category, keyword);
	}
	
	/* 댓글순 */
	@Override
	public List<communityListDTO> getSortCommentList() {
		List<communityListDTO> cList = cMapper.getSortCommentList();
		
		for(communityListDTO dto : cList) {
			Timestamp ts = dto.getCreatedAt();
			dto.setTimeAgo(TimeUtil.getTimeAgo(ts));
		}
		return cList;
	}
	
	/* 조회수순 */
	@Override
	public List<communityListDTO> getSortViewList() {
		List<communityListDTO> cList = cMapper.getSortViewList();
		
		for(communityListDTO dto : cList) {
			Timestamp ts = dto.getCreatedAt();
			dto.setTimeAgo(TimeUtil.getTimeAgo(ts));
		}
		return cList;
	}

	/* 커뮤니티 디테일 */
	@Override
	public communityListDTO getCommunityDetail(int boardNo) {
		cMapper.viewCount(boardNo);
		communityListDTO cVO = cMapper.getCommunityDetail(boardNo);
		
		/* cVO는 List형식이 아니라 for문 x */
	    if (cVO != null) {
	        Timestamp ts = cVO.getCreatedAt();
	        cVO.setTimeAgo(TimeUtil.getTimeAgo(ts));
	    }
		
		return cVO;
	}

	/* 커뮤니티 좋아요 버튼 */
	@Override
	@Transactional
	public Map<String, Object> communityLike(int communityNo, int userNo) {
		Map<String, Object> map = new HashMap<>();
	    
	    // 1. 좋아요 여부 확인용 파라미터 맵
	    Map<String, Integer> checkParam = new HashMap<>();
	    checkParam.put("communityNo", communityNo);
	    checkParam.put("userNo", userNo);
	    
	    // 2. 이미 눌렀는지 확인
	    int check = cMapper.checkLike(checkParam);
	    
	    String status = "";
	    if (check > 0) {
	        // 이미 누름 -> 좋아요 취소 (DELETE)
	        cMapper.deleteLike(checkParam);
	        status = "unliked";
	    } else {
	        // 안 누름 -> 좋아요 추가 (INSERT)
	        cMapper.insertLike(checkParam);
	        status = "liked";
	    }
	    
	    // 3. 최신 좋아요 개수 다시 조회
	    int likeCount = cMapper.countLike(communityNo);
	    
	    map.put("status", status);
	    map.put("likeCount", likeCount);
	    
	    return map;
	}

	/* 커뮤니티 삭제 */
	@Override
	public int communityDelete(int communityNo) {
		int result = cMapper.communityDelete(communityNo);
		return result;
	}

	@Override
	public communityListDTO communityModify(int communityNo) {
		return cMapper.communityModify(communityNo);
	}
}