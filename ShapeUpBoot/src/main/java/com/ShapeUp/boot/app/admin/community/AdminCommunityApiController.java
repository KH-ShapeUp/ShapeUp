package com.ShapeUp.boot.app.admin.community;

import com.ShapeUp.boot.app.community.dto.communityImageDTO;
import com.ShapeUp.boot.app.community.dto.communityListDTO;
import com.ShapeUp.boot.domain.community.model.service.communityService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/community")
@RequiredArgsConstructor
public class AdminCommunityApiController {

    private final communityService communityService;

    @GetMapping
    public Map<String, Object> list(@RequestParam(defaultValue = "N") String deleted,
                                    @RequestParam(required = false) String category,
                                    @RequestParam(required = false) String keyword) {
        String deleteYn = "Y".equalsIgnoreCase(deleted) ? "Y" : "N";
        List<communityListDTO> items = communityService.selectAdminCommunityList(deleteYn, category, keyword);
        Map<String, Object> body = new HashMap<>();
        body.put("items", items);
        return body;
    }

    @GetMapping("/success")
    public Map<String, Object> successList(@RequestParam(defaultValue = "N") String deleted,
                                           @RequestParam(required = false) String successType,
                                           @RequestParam(required = false) String keyword) {
        String deleteYn = "Y".equalsIgnoreCase(deleted) ? "Y" : "N";
        List<communityListDTO> items = communityService.selectAdminSuccessList(deleteYn, successType, keyword);
        Map<String, Object> body = new HashMap<>();
        body.put("items", items);
        return body;
    }

    @PatchMapping("/{id}/delete")
    public ResponseEntity<?> toggleDelete(@PathVariable("id") int id,
                                          @RequestParam(defaultValue = "Y") String deleteYn) {
        String yn = "Y".equalsIgnoreCase(deleteYn) ? "Y" : "N";
        int result = communityService.updateDeleteYn(id, yn);
        return result > 0 ? ResponseEntity.ok().build() : ResponseEntity.badRequest().build();
    }

    @GetMapping("/{id}/images")
    public List<communityImageDTO> images(@PathVariable("id") int id) {
        return communityService.selectImagesByCommunity(id);
    }

    @GetMapping("/trend")
    public List<Map<String, Object>> trend() {
        return communityService.selectCommunityTrend();
    }

    @GetMapping("/success/trend")
    public List<Map<String, Object>> successTrend() {
        return communityService.selectSuccessTrend();
    }

    @GetMapping("/images/{imgNo}/download")
    public ResponseEntity<Resource> download(@PathVariable int imgNo) {
        communityImageDTO dto = communityService.selectImageById(imgNo);
        if (dto == null || dto.getImgPath() == null) {
            return ResponseEntity.notFound().build();
        }
        String path = dto.getImgPath();
        File file = Paths.get(System.getProperty("user.dir"), path.startsWith("/") ? path.substring(1) : path).toFile();
        if (!file.exists()) {
            return ResponseEntity.notFound().build();
        }
        FileSystemResource resource = new FileSystemResource(file);
        String name = dto.getImgOriginalName() != null ? dto.getImgOriginalName() : file.getName();
        String encoded = URLEncoder.encode(name, StandardCharsets.UTF_8);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encoded + "\"")
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(resource);
    }
}
