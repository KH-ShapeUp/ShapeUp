package com.ShapeUp.boot.domain.comment.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.comment.model.vo.commentVO;

public interface commentService {

	List<commentVO> selectCommentList(int communityNo);

	int insertComment(commentVO comment);

	int deleteComment(int commentNo);

}
