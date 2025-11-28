package com.ShapeUp.boot.common.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebMvc
public class CommunityWebMvcConfig implements WebMvcConfigurer{

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		// 1. 기존 정적 리소스 (CSS, JS, 이미지 등) 매핑
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");

        // 2. [핵심] 업로드 이미지 외부 경로 매핑 (C드라이브)
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:///C:/shapeup/upload/");
	}
	
	@Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp("/WEB-INF/views/", ".jsp");
    }
}
