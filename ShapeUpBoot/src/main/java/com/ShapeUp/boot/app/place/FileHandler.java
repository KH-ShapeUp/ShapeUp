package com.ShapeUp.boot.app.place;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.ShapeUp.boot.domain.place.vo.PlaceImageVo;

import lombok.RequiredArgsConstructor;

@Component
public class FileHandler {

	private final String uploadPath = "C:\\ShapeUp_Upload\\place\\";
	
	public List<PlaceImageVo> uploadFiles (int placeNo, List<MultipartFile> multipartFiles) throws IOException{
		List<PlaceImageVo> imageList = new ArrayList<>();
		
		// 저장경로 생성 (C:\\ShapeUp_Upload\place\2025\12\04\)
		String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
		String savePath = uploadPath + today + File.separator;
		File folder = new File((savePath));
		
		// 폴더 없으면 생성
		if(!folder.exists()) {
			folder.mkdirs();
		}
		// 1. Y = 대표이미지, N = 서브이미지
		String fileLevel = "Y";
		
		// 2. 파일 저장 및  VO 생성
		for(MultipartFile file : multipartFiles) {
			// 파일이 없거나 비어있으면 건너뜀
			if(file.isEmpty() || file.getSize() == 0) continue;
			// 파일명 처리
			String originalFileName = file.getOriginalFilename();
			// 확장자 추출
			String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
			// 서버에 저장될 고유 파일명(UUID{고유 식별자} 사용)
			String imgRename = UUID.randomUUID().toString().replaceAll("-", "") + extension;
			
			// 파일 저장 대상 객체
			File targetFile = new File(savePath + imgRename);
			
			try {
				file.transferTo(targetFile);
				//PlaceImageVo 생성
				PlaceImageVo placeImage = new PlaceImageVo();
				placeImage.setPlaceNo(placeNo);
				placeImage.setImgPath(today + File.separator); // 상대 경로만 저장(2025/12/04)
				placeImage.setImgOriginalName(originalFileName);
				placeImage.setImgRename(imgRename);
				placeImage.setImgMain(fileLevel);
				imageList.add(placeImage);
				// 첫번째 파일 처리 후 다음파일은 'N'으로 설정
				fileLevel = "N";
			} catch (IOException e) {
				throw new IOException("파일 저장 중 오류 발생: " + originalFileName, e);
			}
		}
		return imageList;
	}
}
