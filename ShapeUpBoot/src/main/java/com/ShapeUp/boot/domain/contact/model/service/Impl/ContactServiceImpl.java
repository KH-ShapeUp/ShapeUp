package com.ShapeUp.boot.domain.contact.model.service.Impl;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Service;

import com.ShapeUp.boot.domain.contact.model.mapper.ContactMapper;
import com.ShapeUp.boot.domain.contact.model.service.ContactService;
import com.ShapeUp.boot.domain.contact.model.vo.ContactVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ContactServiceImpl implements ContactService {

	private final ContactMapper contactMapper;

	@Override
	public List<ContactVO> selectContactList(int userNo, int currentPage, int pageSize) {
		int offset = (currentPage - 1) * pageSize;
		RowBounds rowBounds = new RowBounds(offset, pageSize);
		return contactMapper.selectContactList(userNo, rowBounds);
	}

	@Override
	public int selectContactTotal(int userNo) {
		return contactMapper.selectContactTotal(userNo);
	}

	@Override
	public ContactVO selectContactDetail(int contactNo, int userNo) {
		return contactMapper.selectContactDetail(contactNo, userNo);
	}

	@Override
	public int insertContact(ContactVO contact) {
		return contactMapper.insertContact(contact);
	}

	@Override
	public ContactVO selectContactDetailAdmin(int contactNo) {
		return contactMapper.selectContactDetailAdmin(contactNo);
	}

	@Override
	public List<ContactVO> selectAll(int currentPage, int pageSize, String status, String category) {
		int offset = (currentPage - 1) * pageSize;
		RowBounds rb = new RowBounds(offset, pageSize);
		return contactMapper.selectAll(status, category, rb);
	}

	@Override
	public int selectAllTotal(String status, String category) {
		return contactMapper.selectAllTotal(status, category);
	}

	@Override
	public int updateAnswer(int contactNo, String answerContent, String status) {
		return contactMapper.updateAnswer(contactNo, answerContent, status);
	}
}
