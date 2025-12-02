package com.ShapeUp.boot.domain.community.model.service.Impl;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

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
import com.ShapeUp.boot.app.success.dto.successInsertDTO;
import com.ShapeUp.boot.app.success.dto.successListDTO;
import com.ShapeUp.boot.common.util.TimeUtil;
import com.ShapeUp.boot.domain.community.model.mapper.successMapper;
import com.ShapeUp.boot.domain.community.model.service.successService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class successServiceImpl implements successService{
	private final successMapper sMapper;
	
	@Transactional
	@Override
	public int successInsert(successInsertDTO sInDTO) {
		 // 1. 게시글 등록 (Mapper의 selectKey에 의해 cDTO.communityNo에 값이 담김)
        int result = sMapper.successInsert(sInDTO);

        // 2. 본문(HTML)에서 이미지 추출 및 DB 저장 로직 수행
        if(result > 0 && sInDTO.getCommunityContent() != null) {
            insertImages(sInDTO);
        }
        return result;
    }
	
	// [헬퍼 메소드] HTML 파싱 및 이미지 테이블 INSERT
    private void insertImages(successInsertDTO sInDTO) {
        List<communityImageDTO> imgList = new ArrayList<>();
        
        // Jsoup으로 HTML 파싱
        Document doc = Jsoup.parse(sInDTO.getCommunityContent());
        Elements imgs = doc.select("img"); // <img> 태그 다 찾아라

        for (Element img : imgs) {
            String src = img.attr("src"); 
            // src 예시: "/upload/uuid_filename.jpg"
            
            // 우리가 업로드한 이미지가 맞는지 확인 (외부 링크일 수도 있으니까)
            if (src.contains("/upload/")) {
                String fileName = src.substring(src.lastIndexOf("/") + 1); // "uuid_filename.jpg" 추출
                
                communityImageDTO imgDTO = new communityImageDTO();
                imgDTO.setCommunityNo(sInDTO.getCommunityNo()); // 1번에서 생긴 게시글 번호
                imgDTO.setImgPath(src);       // 전체 경로
                imgDTO.setImgRename(fileName); // 파일명
                imgDTO.setImgOriginalName(fileName); // (원본명을 따로 관리 안했다면 저장명과 동일하게)
                
                imgList.add(imgDTO);
            }
        }

        // 3. 추출된 이미지가 있으면 DB에 저장 (Mapper 호출)
        if (!imgList.isEmpty()) {
        	sMapper.insertSuccessImages(imgList);
        }
    }

	@Override
	public List<successListDTO> successList(int currentPage, int boardLimit, String category, String keyword) {
		int offset = (currentPage - 1) * boardLimit;
		RowBounds rowBounds = new RowBounds(offset, boardLimit);
		
		List<successListDTO> sList = sMapper.successList(rowBounds, category, keyword);
		
	    for (successListDTO sDto : sList) {
	           Timestamp ts = sDto.getCreatedAt(); 
	           sDto.setTimeAgo(TimeUtil.getTimeAgo(ts));
	    }
		return sList;
	}
	
	@Override
	public int getTotalCount(String category, String keyword) {
		return sMapper.getTotalCount(category, keyword);
	}

	@Override
	public List<successListDTO> popSuccessList() {
		List<successListDTO> popsList = sMapper.popSuccessList();
		
		for (successListDTO sDto : popsList) {
		        Timestamp ts = sDto.getCreatedAt(); 
		        sDto.setTimeAgo(TimeUtil.getTimeAgo(ts)); 
	    }
		return popsList;
	}

	@Override
	public List<successListDTO> commentSuccessList() {
		List<successListDTO> cmsList = sMapper.commentSuccessList();
		
		for (successListDTO sDto : cmsList) {
	        Timestamp ts = sDto.getCreatedAt(); 
	        sDto.setTimeAgo(TimeUtil.getTimeAgo(ts));
		}
		return cmsList;
	}

}
