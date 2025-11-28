package com.ShapeUp.boot.domain.comment.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.ShapeUp.boot.domain.comment.model.vo.commentVO;

@Mapper
public interface commentMapper {

	List<commentVO> selectCommentList(int communityNo);

	int insertComment(commentVO comment);

	int deleteComment(int commentNo);

}
