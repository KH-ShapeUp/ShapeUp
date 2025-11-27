package com.ShapeUp.boot.common.config;

import com.ShapeUp.boot.common.interceptor.AdminAccessInterceptor;
import com.ShapeUp.boot.common.interceptor.StadiumAccessInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
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
        registry.addMapping("/uploads/**")
                .allowedOrigins("http://localhost:8080", "http://localhost:5173")
                .allowedMethods("GET")
                .allowCredentials(true)
                .maxAge(3600);
    }

    @Override
    public void addResourceHandlers(org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + UPLOAD_BASE);
    }
}
