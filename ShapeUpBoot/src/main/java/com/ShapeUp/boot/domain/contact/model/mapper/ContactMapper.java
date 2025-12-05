package com.ShapeUp.boot.domain.contact.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.session.RowBounds;

import com.ShapeUp.boot.domain.contact.model.vo.ContactVO;

@Mapper
public interface ContactMapper {

	List<ContactVO> selectContactList(@Param("userNo") int userNo, RowBounds rowBounds);

	int selectContactTotal(@Param("userNo") int userNo);

	ContactVO selectContactDetail(@Param("contactNo") int contactNo, @Param("userNo") int userNo);

	int insertContact(ContactVO contact);

	// admin
	ContactVO selectContactDetailAdmin(@Param("contactNo") int contactNo);
	List<ContactVO> selectAll(@Param("status") String status,
	                          @Param("category") String category,
	                          RowBounds rowBounds);
	int selectAllTotal(@Param("status") String status,
	                   @Param("category") String category);
	int updateAnswer(@Param("contactNo") int contactNo,
	                 @Param("answerContent") String answerContent,
	                 @Param("status") String status);
}
