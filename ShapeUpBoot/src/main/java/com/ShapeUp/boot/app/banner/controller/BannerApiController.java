package com.ShapeUp.boot.app.banner.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ShapeUp.boot.domain.banner.model.service.BannerService;
import com.ShapeUp.boot.domain.banner.model.vo.Banner;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Slf4j
public class BannerApiController {

	private final BannerService bService;

	@GetMapping("/banners/active")
	public ResponseEntity<List<Banner>> active() {
		List<Banner> list = bService.getActiveBanners();
		log.info("Active banners fetched: {}", (list == null ? 0 : list.size()));
		if (list != null) {
			for (Banner b : list) {
				String path = b.getImgPath();
				log.info("Banner {} raw path: {}", b.getBannerNo(), path);
				if (path == null || path.isBlank() || "false".equalsIgnoreCase(path)) {
					b.setImgPath("/resources/img/ad-img1.gif");
				} else {
					b.setImgPath(path.startsWith("http") ? path : (path.startsWith("/") ? path : "/" + path));
				}
				log.info("Banner {} normalized path: {}", b.getBannerNo(), b.getImgPath());
			}
		}
		return ResponseEntity.ok(list);
	}

	@PostMapping("/admin/notices/{noticeNo}/banner")
	public ResponseEntity<Map<String, Object>> uploadBanner(@PathVariable int noticeNo,
			@RequestParam("bannerTitle") String bannerTitle,
			@RequestParam("bannerYn") String bannerYn,
			@RequestParam("file") MultipartFile file,
			HttpSession session) {
		if (file == null || file.isEmpty()) {
			return ResponseEntity.badRequest().body(Map.of("success", false, "message", "NO_FILE"));
		}
		try {
			Path bannerDir = Paths.get(System.getProperty("user.dir"), "uploads", "notice", String.valueOf(noticeNo), "banner");
			Files.createDirectories(bannerDir);
			String original = file.getOriginalFilename();
			String ext = "";
			if (original != null && original.contains(".")) {
				ext = original.substring(original.lastIndexOf("."));
			}
			String rename = UUID.randomUUID() + ext;
			Path target = bannerDir.resolve(rename);
			file.transferTo(target.toFile());

			Banner banner = new Banner();
			banner.setNoticeNo(noticeNo);
			banner.setBannerTitle(bannerTitle);
			banner.setImgPath("/uploads/notice/" + noticeNo + "/banner/" + rename);
			banner.setBannerYn((bannerYn == null || bannerYn.isBlank()) ? "Y" : bannerYn);
			int saved = bService.saveBanner(banner);
			return ResponseEntity.ok(Map.of(
				"success", saved > 0,
				"imgPath", banner.getImgPath()
			));
		} catch (IOException e) {
			log.error("banner upload fail", e);
			return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "UPLOAD_FAIL"));
		}
	}
}
