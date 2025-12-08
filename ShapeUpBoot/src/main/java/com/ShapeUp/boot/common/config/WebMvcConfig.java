package com.ShapeUp.boot.common.config;

import com.ShapeUp.boot.common.interceptor.AdminAccessInterceptor;
import com.ShapeUp.boot.common.interceptor.StadiumAccessInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    private static final String UPLOAD_BASE = System.getProperty("user.dir") + "/uploads/";

@Override
public void addInterceptors(InterceptorRegistry registry) {
registry.addInterceptor(new AdminAccessInterceptor())
    .addPathPatterns("/admin/**", "/api/admin/**")
    .excludePathPatterns(
        "/error",
        // SPA entry & static assets
        "/admin/index.html",
        "/admin/assets/**",
        "/admin/mock/**",
        "/admin/**/*.js",
        "/admin/**/*.css",
        "/admin/**/*.map",
        "/admin/**/*.png",
        "/admin/**/*.jpg",
        "/admin/**/*.ico",
        "/admin/**/*.svg",
        // allow notice CRUD while session 세팅 전 개발용
        "/api/admin/notices/**"
    );

registry.addInterceptor(new StadiumAccessInterceptor())
    .addPathPatterns("/stadium/**", "/api/stadium/**")
    .excludePathPatterns(
        "/error",
        "/stadium/index.html",
        "/stadium/assets/**",
        "/stadium/mock/**",
        "/stadium/**/*.js",
        "/stadium/**/*.css",
        "/stadium/**/*.map",
        "/stadium/**/*.png",
        "/stadium/**/*.jpg",
        "/stadium/**/*.ico",
        "/stadium/**/*.svg"
    );

}

    @Override
    public void addCorsMappings(CorsRegistry registry) {
    	registry.addMapping("/trainer/**")
        		.allowedOrigins("http://localhost:5173")
        		.allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
        		.allowCredentials(true); // ★★★ 핵심
        registry.addMapping("/api/**")
                .allowedOrigins("http://localhost:8080", "http://localhost:5173")
                .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
                .allowCredentials(true)
                .maxAge(3600);
        registry.addMapping("/matching/**")
                .allowedOrigins("http://localhost:8080", "http://localhost:5173")
                .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
                .allowCredentials(true)
                .maxAge(3600);
        registry.addMapping("/contact/**")
                .allowedOrigins("http://localhost:8080", "http://localhost:5173")
                .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
                .allowCredentials(true)
                .maxAge(3600);
        registry.addMapping("/uploads/**")
                .allowedOrigins("http://localhost:8080", "http://localhost:5173")
                .allowedMethods("GET")
                .allowCredentials(true)
                .maxAge(3600);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // [중요 수정 부분] 이미지 업로드 경로 매핑
        
        // 1. 현재 프로젝트의 절대 경로(루트) 가져오기
        String projectPath = System.getProperty("user.dir");

        // 2. 브라우저 URL "/upload/**" 요청 시 -> 실제 폴더 "프로젝트루트/uploads/community/" 참조
        // file:/// 접두어 필수 (Windows/Mac 호환 및 외부 경로 참조용)
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///" + projectPath + "/uploads/community/");

        // 3. SPA(Admin) 정적 리소스 설정 (빌드된 리액트/뷰 파일 등)
        registry.addResourceHandler("/admin/**")
                .addResourceLocations("classpath:/static/admin/");

        // 4. SPA(Stadium) 정적 리소스 설정
        registry.addResourceHandler("/stadium/**")
                .addResourceLocations("classpath:/static/stadium/");

        // 5. JSP용 리소스 설정
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");

        // 6. 공지사항 용
        registry.addResourceHandler("/uploads/notice/**")
                .addResourceLocations("file:///" + projectPath + "/uploads/notice/");
    }
}
