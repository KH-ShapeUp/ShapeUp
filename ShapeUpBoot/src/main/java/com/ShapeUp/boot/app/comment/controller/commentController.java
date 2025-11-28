package com.ShapeUp.boot.app.comment.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.domain.comment.model.service.commentService;
import com.ShapeUp.boot.domain.comment.model.vo.commentVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/comment")
@RequiredArgsConstructor
public class commentController {
	private final commentService cService;

    @GetMapping("/list")
    public List<commentVO> getCommentList(@RequestParam int communityNo) {
    	List<commentVO> cList = cService.selectCommentList(communityNo);
    	System.out.println("가져온 댓글" + cList);
        return cList;
    }

    @PostMapping("/add")
    public List<commentVO> addComment(@RequestBody commentVO comment) {
        // 1. 댓글 DB에 저장
        int result = cService.insertComment(comment);
        
        // 2. 저장 후, 갱신된 목록을 다시 조회해서 반환 (화면 갱신용)
        if(result > 0) {
            return cService.selectCommentList(comment.getCommunityNo());
        } else {
            return null; // 혹은 예외 처리
        }
    }

    @DeleteMapping("/delete")
    @ResponseBody
    public int deleteComment(@RequestParam int commentNo) {
        int result = cService.deleteComment(commentNo);      
        return result;
    }
}
