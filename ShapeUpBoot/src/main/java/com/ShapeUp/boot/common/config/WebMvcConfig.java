package com.ShapeUp.boot.common.config;

import com.ShapeUp.boot.common.interceptor.AdminAccessInterceptor;
import com.ShapeUp.boot.common.interceptor.StadiumAccessInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 어드민 리소스 보호
        registry.addInterceptor(new AdminAccessInterceptor())
                .addPathPatterns("/admin/**", "/api/admin/**");

        // 시설 관리자 리소스 보호
        registry.addInterceptor(new StadiumAccessInterceptor())
                .addPathPatterns("/stadium/**", "/api/stadium/**");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("http://localhost:8080", "http://localhost:5173")
                .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
