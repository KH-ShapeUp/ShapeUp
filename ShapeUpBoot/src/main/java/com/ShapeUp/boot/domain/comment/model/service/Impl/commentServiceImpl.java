package com.ShapeUp.boot.domain.comment.model.service.Impl;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.stereotype.Service;

import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.common.util.TimeUtil;
import com.ShapeUp.boot.domain.comment.model.mapper.commentMapper;
import com.ShapeUp.boot.domain.comment.model.service.commentService;
import com.ShapeUp.boot.domain.comment.model.vo.commentVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class commentServiceImpl implements commentService{
	private final commentMapper cMapper;
	
	@Override
	public List<commentVO> selectCommentList(int communityNo) {
		List <commentVO> cList = cMapper.selectCommentList(communityNo);
		
		for (commentVO cVO : cList) {
	        Timestamp ts = cVO.getCreatedAt(); // DTO에 Timestamp 컬럼이 있어야 함
	        cVO.setTimeAgo(TimeUtil.getTimeAgo(ts)); // DTO에 timeAgo 필드 추가 필요	   
	    }
		return cList;
	}

	@Override
	public int insertComment(commentVO comment) {
		return cMapper.insertComment(comment);
	}

	@Override
	public int deleteComment(int commentNo) {
		return cMapper.deleteComment(commentNo);
	}

}
