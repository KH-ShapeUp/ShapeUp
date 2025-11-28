package com.ShapeUp.boot.app.admin.controller;

import com.ShapeUp.boot.domain.notice.model.service.NoticeService;
import com.ShapeUp.boot.domain.notice.model.vo.Notice;
import com.ShapeUp.boot.domain.notice.model.vo.NoticeImage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/notices")
@RequiredArgsConstructor
@Slf4j
public class NoticeApiController {

    private final NoticeService noticeService;
    private static final DateTimeFormatter ISO = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final Path UPLOAD_ROOT = Paths.get(System.getProperty("user.dir"), "uploads", "notice");

//    @GetMapping
//    public ResponseEntity<Map<String, Object>> list(
//            @RequestParam(defaultValue = "1") int page,
//            @RequestParam(defaultValue = "10") int size
//    ) {
//        int total = noticeService.getTotalCount(null, null, null);
//        List<Notice> items = noticeService.selectNoticeList(page, size);
//        Map<String, Object> body = new HashMap<>();
//        body.put("total", total);
//        body.put("items", items);
//        return ResponseEntity.ok(body);
//    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Notice notice) {
        try {
            if (notice.getUserNo() != null && notice.getUserNo() <= 0) {
                notice.setUserNo(null);
            }
            if (notice.getNoticeCategory() == null) {
                notice.setNoticeCategory("공지");
            }
            if (notice.getNoticeContent() == null) {
                notice.setNoticeContent("");
            }
            if (notice.getViewCount() == null) {
                notice.setViewCount(0);
            }
            if ("이벤트".equals(notice.getNoticeCategory())) {
                if (notice.getEventStart() == null || notice.getEventStart().isEmpty()) {
                    notice.setEventStart(LocalDate.now().format(ISO));
                }
            } else {
                notice.setEventStart(null);
                notice.setEventEnd(null);
            }
            int result = noticeService.insertNotice(notice);
            if (result > 0) {
                Map<String, Object> body = new HashMap<>();
                body.put("noticeNo", notice.getNoticeNo());
                return ResponseEntity.ok(body);
            }
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            log.error("Failed to create notice", e);
            return ResponseEntity.internalServerError().body("fail");
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable("id") int id, @RequestBody Notice notice) {
        notice.setNoticeNo(id);
        try {
            int result = noticeService.updateNotice(notice);
            return result > 0 ? ResponseEntity.ok().build() : ResponseEntity.badRequest().build();
        } catch (Exception e) {
            log.error("Failed to update notice {}", id, e);
            return ResponseEntity.internalServerError().body("fail");
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable("id") int id) {
        try {
            List<NoticeImage> images = noticeService.selectImagesByNotice(id);
            int result = noticeService.deleteNotice(id);
            if (result > 0 && images != null) {
                for (NoticeImage img : images) {
                    if (img.getImgPath() != null) {
                        try {
                            Path p = Paths.get(System.getProperty("user.dir") + img.getImgPath());
                            Files.deleteIfExists(p);
                        } catch (Exception ignore) {}
                    }
                }
            }
            return result > 0 ? ResponseEntity.ok().build() : ResponseEntity.badRequest().build();
        } catch (Exception e) {
            log.error("Failed to delete notice {}", id, e);
            return ResponseEntity.internalServerError().body("fail");
        }
    }

    @GetMapping("/trend")
    public ResponseEntity<?> trend() {
        return ResponseEntity.ok(noticeService.selectNoticeTrend());
    }

    @PostMapping("/{id}/images")
    public ResponseEntity<?> uploadImages(@PathVariable("id") int id,
                                          @RequestParam("files") List<MultipartFile> files) {
        if (files == null || files.isEmpty()) {
            return ResponseEntity.badRequest().body("no files");
        }
        try {
            Path noticeDir = UPLOAD_ROOT.resolve(String.valueOf(id));
            Files.createDirectories(noticeDir);
            int index = 0;
            for (MultipartFile file : files) {
                if (file.isEmpty()) continue;
                String original = file.getOriginalFilename();
                String ext = "";
                if (original != null && original.contains(".")) {
                    ext = original.substring(original.lastIndexOf("."));
                }
                String rename = UUID.randomUUID() + ext;
                Path target = noticeDir.resolve(rename);
                file.transferTo(target.toFile());

                NoticeImage img = new NoticeImage();
                img.setNoticeNo(id);
                img.setImgOriginalName(original);
                img.setImgRename(rename);
                img.setImgPath("/uploads/notice/" + id + "/" + rename);
                img.setImgMainYn(index == 0 ? "Y" : "N");
                noticeService.insertNoticeImage(img);
                index++;
            }
            return ResponseEntity.ok().build();
        } catch (IOException e) {
            log.error("upload fail", e);
            return ResponseEntity.internalServerError().body("fail");
        }
    }

    @DeleteMapping("/{noticeId}/images/{imgNo}")
    public ResponseEntity<?> deleteImage(@PathVariable int noticeId, @PathVariable int imgNo) {
        int result = noticeService.deleteNoticeImage(imgNo);
        return result > 0 ? ResponseEntity.ok().build() : ResponseEntity.badRequest().build();
    }
}
