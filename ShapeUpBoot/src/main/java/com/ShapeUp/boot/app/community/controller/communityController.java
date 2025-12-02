package com.ShapeUp.boot.app.community.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ShapeUp.boot.app.community.dto.communityInsertDTO;
import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.app.community.dto.communityModifyDTO;
import com.ShapeUp.boot.domain.activity.model.service.impl.ActivityServiceImpl;
import com.ShapeUp.boot.domain.community.model.service.communityService;
import com.ShapeUp.boot.domain.community.model.vo.communityVO;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class communityController {

	private final communityService cService;
	
	@GetMapping("/community")
	public String communityPage(HttpSession session, Model model, 
			@RequestParam(value="boardNo", defaultValue = "1") int currentPage,
			@RequestParam(value="category", required = false) String category,
			@RequestParam(value="keyword", required = false) String keyword) {
		Integer userNo = (Integer)session.getAttribute("userNo");
		String userType = (String)session.getAttribute("userType");
		
		/* 공지사항 리스트 가져오기 */
		List<Notice> nList = cService.getNoticeList();
		System.out.println(nList);
		
		/* 커뮤니티 리스트 가져오기 */
		int boardLimit = 10;
		int naviLimit = 5;
		
		int TotalCount = cService.getTotalCount(category, keyword);
		
		int maxPage = (int)Math.ceil((double)TotalCount / boardLimit);
		int startNavi = ((currentPage - 1)/ naviLimit) * naviLimit + 1;
		int endNavi = (startNavi - 1) + naviLimit;
		if(endNavi > maxPage) {endNavi = maxPage;}
		
		List<communityListDTO> cList = cService.getCommunityList(currentPage, boardLimit, category, keyword);
		System.out.println(cList);
		model.addAttribute("TotalCount", TotalCount);
		model.addAttribute("category", category);
	    model.addAttribute("keyword", keyword);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("endNavi", endNavi);
		model.addAttribute("maxPage", maxPage);
		model.addAttribute("startNavi", startNavi);
		model.addAttribute("cList", cList);
		model.addAttribute("nList", nList);
		/* 커뮤니티 리스트 가져오기 끝 */	
		
		/* 커뮤니티 최신 댓글 순 */
		List<communityListDTO> commentList = cService.getSortCommentList();
		model.addAttribute("ctList", commentList);
		/* 커뮤니티 최신 댓글 순 끝 */
		
		/* 커뮤니티 최신 조회수 순 */
		List<communityListDTO> viewList = cService.getSortViewList();
		System.out.println(viewList);
		model.addAttribute("vList", viewList);
		/* 커뮤니티 최신 조회수 순 끝 */
		
		model.addAttribute("userType", userType);
		model.addAttribute("userNo", userNo);
		return "community/communityMain";
	}
	
	@GetMapping("/community/insert")
	public String communityInsertPage() {
		return "community/communityInsert";
	}
	
	/* 게시글 업로드 */
	@PostMapping("/community/insert")
	@ResponseBody
	public int communityInsert(@RequestBody communityInsertDTO cDTO, HttpSession session) {
		int userNo = (int)session.getAttribute("userNo");
		cDTO.setUserNo(userNo);
		int result = cService.communityInsert(cDTO);
		return result;
	}
	
	/* 게시글의 이미지 업로드 */
	@PostMapping("/community/image-upload")
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestParam("image") MultipartFile uploadFile) {
	    
	    // 저장할 경로 
	    String uploadFolder = "C:\\shapeup\\upload\\";
	    
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
	
	/* 커뮤니티 디테일 */
	@GetMapping("/community/detail")
	public String communityDetailPage(@RequestParam("boardNo")int boardNo, Model model, HttpSession session) {
		communityListDTO cVO = cService.getCommunityDetail(boardNo);
		Integer userNo = (Integer)session.getAttribute("userNo");
		System.out.println("커뮤니티 불러온 데이터:"+cVO);
		model.addAttribute("userNo", userNo);
		model.addAttribute("cList", cVO);
		return "community/communityDetail";
	}
	
	/* 커뮤니티 좋아요 */
	@PostMapping("/community/like")
	@ResponseBody
	public Map<String, Object> likeBtn(@RequestBody Map<String, Integer> param, HttpSession session) {
	    Map<String, Object> resultMap = new HashMap<>();
	    
	    
	    int userNo = (int)session.getAttribute("userNo");
	    int communityNo = param.get("communityNo");

	    // 2. Service 호출 (좋아요 토글 로직)
	    // 리턴값: 갱신된 좋아요 개수와 상태(추가됨/삭제됨)를 담은 객체나 Map
	    Map<String, Object> serviceResult = cService.communityLike(communityNo, userNo);
	    
	    resultMap.put("result", "success");
	    resultMap.put("likeCount", serviceResult.get("likeCount")); // 갱신된 카운트
	    resultMap.put("status", serviceResult.get("status"));       // "liked" or "unliked"
	    
	    return resultMap;
	}
	
	/* 커뮤니티 삭제 */
	@DeleteMapping("/community/delete")
	@ResponseBody
	public int communityDelete(@RequestParam("boardNo") int communityNo) {
		System.out.println("번호" + communityNo);
		int result = cService.communityDelete(communityNo);
		return result;
	}
	
	@GetMapping("/community/modify")
	public String communityModify(@RequestParam("boardNo")int communityNo, Model model) {
		communityListDTO cmDTO = cService.communityModify(communityNo);
		System.out.println(cmDTO);
		model.addAttribute("cList", cmDTO);
		return "community/communityModify";
	}
}
