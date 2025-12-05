package com.ShapeUp.boot.common.config;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import com.ShapeUp.boot.common.interceptor.AutoLoginInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    @Autowired
    private AutoLoginInterceptor autoLoginInterceptor;
    
    /**
     * 인터셉터 설정
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(autoLoginInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/user/login",
                        "/user/signupAgreement",
                        "/user/searchId",
                        "/user/searchPw",
                        "/resources/**",
                        "/css/**",
                        "/js/**",
                        "/img/**",
                        "/upload/**",           // ⭐ upload로 통일
                        "/error"
                );
    }
    
    /**
     * ⭐⭐⭐ 정적 리소스 핸들러 설정
     * 프로젝트 내부의 uploads 폴더를 웹에서 접근 가능하도록 매핑
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String projectPath = System.getProperty("user.dir");
        
        // 프로필 이미지 경로 매핑 (프로젝트 내부)
        registry.addResourceHandler("/upload/profile/**")
                .addResourceLocations("file:///" + projectPath + "/uploads/profile/");
        
        // 권한 신청 파일 경로 매핑 (프로젝트 내부)
        registry.addResourceHandler("/upload/permissions/**")
                .addResourceLocations("file:///" + projectPath + "/uploads/permissions/");
        
        System.out.println("✅ 정적 리소스 핸들러 등록 완료");
        System.out.println("   - 프로젝트 경로: " + projectPath);
        System.out.println("   - /upload/profile/** -> " + projectPath + "/uploads/profile/");
        System.out.println("   - /upload/permissions/** -> " + projectPath + "/uploads/permissions/");
    }
}