package com.ShapeUp.boot.domain.community.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import com.ShapeUp.boot.app.community.dto.communityImageDTO;
import com.ShapeUp.boot.app.success.dto.successInsertDTO;
import com.ShapeUp.boot.app.success.dto.successListDTO;

@Mapper
public interface successMapper {

	int successInsert(successInsertDTO sInDTO);

	void insertSuccessImages(List<communityImageDTO> imgList);

	List<successListDTO> successList(RowBounds rowBounds, String category, String keyword);

	List<successListDTO> popSuccessList();

	List<successListDTO> commentSuccessList();

	int getTotalCount(String category, String keyword);

}
