package com.ShapeUp.boot.domain.community.model.service;

import java.util.List;

import com.ShapeUp.boot.app.success.dto.successInsertDTO;
import com.ShapeUp.boot.app.success.dto.successListDTO;

public interface successService {

	int successInsert(successInsertDTO sInDTO);

	List<successListDTO> successList(int currentPage, int boardLimit, String category, String keyword);

	List<successListDTO> popSuccessList();

	List<successListDTO> commentSuccessList();

	int getTotalCount(String category, String keyword);

}
