package com.ShapeUp.boot.domain.contact.model.service;

import java.util.List;

import com.ShapeUp.boot.domain.contact.model.vo.ContactVO;

public interface ContactService {
	List<ContactVO> selectContactList(int userNo, int currentPage, int pageSize);
	int selectContactTotal(int userNo);
	ContactVO selectContactDetail(int contactNo, int userNo);
	int insertContact(ContactVO contact);

	// admin
	ContactVO selectContactDetailAdmin(int contactNo);
	List<ContactVO> selectAll(int currentPage, int pageSize, String status, String category);
	int selectAllTotal(String status, String category);
	int updateAnswer(int contactNo, String answerContent, String status);
}
