package com.ShapeUp.boot.app.success.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ShapeUp.boot.app.success.dto.successInsertDTO;
import com.ShapeUp.boot.app.success.dto.successListDTO;
import com.ShapeUp.boot.domain.activity.model.service.impl.ActivityServiceImpl;
import com.ShapeUp.boot.domain.community.model.service.successService;
import com.ShapeUp.boot.domain.user.model.service.UserService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class successController {
	private final successService sService;
	private final UserService userService;

	@GetMapping("/success")
	public String successPage(HttpSession session, Model model,
			@RequestParam(value="boardNo", defaultValue = "1") int currentPage,
			@RequestParam(value="category", required = false) String category,
			@RequestParam(value="keyword", required = false) String keyword) {
		
		Integer userNo = (Integer)session.getAttribute("userNo");
		model.addAttribute("userNo", userNo);
		
		int boardLimit = 6;
		int naviLimit = 5;
		
		int TotalCount = sService.getTotalCount(category, keyword);
		
		int maxPage = (int)Math.ceil((double)TotalCount / boardLimit);
		int startNavi = ((currentPage - 1)/ naviLimit) * naviLimit + 1;
		int endNavi = (startNavi - 1) + naviLimit;
		if(endNavi > maxPage) {endNavi = maxPage;}
		
		List<successListDTO> sList = sService.successList(currentPage, boardLimit, category, keyword);
		
		// ⭐ 메인 리스트에만 프로필 이미지 추가
		for(successListDTO success : sList) {
			String profileImg = userService.getUserProfileImg(success.getUserNo());
			success.setUserProfileImg(profileImg);
		}
		
		model.addAttribute("TotalCount", TotalCount);
		model.addAttribute("category", category);
	    model.addAttribute("keyword", keyword);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("endNavi", endNavi);
		model.addAttribute("maxPage", maxPage);
		model.addAttribute("startNavi", startNavi);
		model.addAttribute("sList", sList);
		
		/* 인기 게시물 */
		List<successListDTO> popsList = sService.popSuccessList();
		model.addAttribute("psList", popsList);

		/* 댓글 순 */
		List<successListDTO> cmList = sService.commentSuccessList();
		model.addAttribute("cmsList", cmList);
		
		return "success/successMain";
	}
	
	@GetMapping("/success/insert")
	public String successInsertPage() {
		return "success/successInsert";
	}
	
	@PostMapping("/success/insert")
	@ResponseBody
	public int successInsert(@RequestBody successInsertDTO sInDTO, HttpSession session) {
		int userNo = (int)session.getAttribute("userNo");
		sInDTO.setUserNo(userNo);
		sInDTO.setCommunityType("success");
		System.out.println("받은 데이터 : " + sInDTO);
		int result = sService.successInsert(sInDTO);
		return result;
	}
	
	/* 게시글의 이미지 업로드 */
	@PostMapping("/success/image-upload")
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestParam("image") MultipartFile uploadFile) {
	    
		String projectPath = System.getProperty("user.dir");
	    // 저장할 경로 
		String uploadFolder = projectPath + "/uploads/community/";
	    
	    // 폴더가 없으면 자동으로 생성
        File folder = new File(uploadFolder);
        if (!folder.exists()) {
            folder.mkdirs(); 
        }
        
	    // 파일명 중복 방지
	    String originalFileName = uploadFile.getOriginalFilename();
	    String uuid = UUID.randomUUID().toString();
	    String saveFileName = uuid + "_" + originalFileName;
	    
	    // 파일 저장
	    File saveFile = new File(uploadFolder, saveFileName);
	    try {
	        uploadFile.transferTo(saveFile); // 실제 저장 실행
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    // URL 반환 (스프링 설정에서 매핑한 주소 사용)
	    Map<String, Object> map = new HashMap<>();
	    
	    // 브라우저는 C드라이브에 직접 접근 못하므로, 매핑된 주소("/upload/...")를 줘야 함
	    map.put("url", "/upload/" + saveFileName); 
	    
	    return map;
	}
}