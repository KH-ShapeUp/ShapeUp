package com.ShapeUp.boot.common.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.ShapeUp.boot.common.interceptor.AutoLoginInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private AutoLoginInterceptor autoLoginInterceptor;

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
                        "/error"
                );
    }
}