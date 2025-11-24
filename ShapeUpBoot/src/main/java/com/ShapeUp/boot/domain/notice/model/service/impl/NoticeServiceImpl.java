package com.ShapeUp.boot.domain.notice.model.service.impl;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ShapeUp.boot.app.notice.dto.NoticeInsertDto;
import com.ShapeUp.boot.app.notice.dto.NoticeInsertImageDto;
import com.ShapeUp.boot.domain.notice.model.mapper.NoticeImageMapper;
import com.ShapeUp.boot.domain.notice.model.mapper.NoticeMapper;
import com.ShapeUp.boot.domain.notice.model.service.FileService;
import com.ShapeUp.boot.domain.notice.model.service.NoticeService;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService{
	
	private final NoticeMapper noticeMapper;
	private final FileService fileService;
	private final NoticeImageMapper noticeImageMapper;

	@Override
	public int getTotalCount() {
		int totalCount = noticeMapper.getTotalCount();
		return totalCount;
	}

	@Override
	public List<Notice> selectNoticeList(int currentPage, int boardCountPerPage) {
		int offset = (currentPage - 1) * boardCountPerPage;
		RowBounds rowBounds = new RowBounds(offset, boardCountPerPage);
		List<Notice> nList = noticeMapper.selectNoticeList(rowBounds);
		return nList;
	}

	@Override
	@Transactional // DB 작업의 원자성(Atomicity)을 보장합니다.
	public int insertNotice(NoticeInsertDto noticeInsertDto) {
		int result = noticeMapper.insertNotice(noticeInsertDto);
		if(result == 0) {
			throw new RuntimeException("공지사항 본문 등록 실패");
		}
		
		MultipartFile file = noticeInsertDto.getUploadFile();
		if(file != null && !file.isEmpty()) {
			// 파일 저장 (FileService에서 UUID 기반 고유 이름으로 디스크에 저장)
			String savedFileName = fileService.saveFile(file);
			int generatedNoticeNo = noticeInsertDto.getNoticeNo();
			NoticeInsertImageDto imageDto = new NoticeInsertImageDto();
			imageDto.setNoticeNo(generatedNoticeNo); // FK 연결
			
			imageDto.setImgRename(savedFileName);
			imageDto.setImgPath("/resources/upload/notice/"); // 웹 경로 설정
			imageDto.setImgOriginalPath(file.getOriginalFilename()); // 원본 파일명 저장
			imageDto.setImgMain("Y");
			
			int imageResult = noticeImageMapper.insertNoticeImage(imageDto);
			if(imageResult == 0) {
				throw new RuntimeException("첨부파일 정보 DB등록 실패");
			}
		}
		return result;
	}

}
