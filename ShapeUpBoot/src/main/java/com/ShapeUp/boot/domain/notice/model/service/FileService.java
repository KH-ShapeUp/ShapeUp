package com.ShapeUp.boot.domain.notice.model.service;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FileService {

	private final String rootPath = "C:\\uploadFiles\\notice\\";
	
	public String saveFile(MultipartFile file) {
		if(file == null || file.isEmpty()) {
			return null;
		}
		
		String originalFileName = file.getOriginalFilename();
		String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
		String savedFileName = UUID.randomUUID().toString() + extension;
		
		try {
			File path = new File(rootPath);
			if(!path.exists()) path.mkdirs();
			File target = new File(rootPath + savedFileName);
			file.transferTo(target);
		} catch (IOException e) {
			throw new RuntimeException("파일 저장 중 I/O 오류 발생", e);
		}
		return savedFileName;
	}
}
