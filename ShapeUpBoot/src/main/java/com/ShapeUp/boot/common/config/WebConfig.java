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
                .addPathPatterns("/**")  // 모든 경로에 적용
                .excludePathPatterns(
                        "/user/login",           // 로그인 페이지
                        "/user/signupAgreement", // 회원가입
                        "/user/searchId",        // 아이디 찾기
                        "/user/searchPw",        // 비밀번호 찾기
                        "/resources/**",         // 정적 리소스
                        "/css/**",
                        "/js/**",
                        "/img/**",
                        "/uploads/**",           // ⭐ 업로드 파일 제외 (추가!)
                        "/error"
                );
    }
    
    /**
     * ⭐⭐⭐ 정적 리소스 핸들러 설정 (새로 추가!)
     * 외부 폴더의 파일을 웹에서 접근 가능하도록 매핑
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	String projectPath = System.getProperty("user.dir");
    	
        // 프로필 이미지 경로 매핑
    	registry.addResourceHandler("/upload/**")
        	.addResourceLocations("file:///" + projectPath + "/uploads/profile/");
        
        // 권한 신청 파일 경로 매핑
    	registry.addResourceHandler("/upload/**")
    	.addResourceLocations("file:///" + projectPath + "/uploads/permission/");
        
        System.out.println("✅ 정적 리소스 핸들러 등록 완료");
        System.out.println("   - /uploads/profile/** -> C:/ShapeUp/uploads/profile/");
        System.out.println("   - /uploads/permissions/** -> C:/ShapeUp/uploads/permissions/");
    }
}