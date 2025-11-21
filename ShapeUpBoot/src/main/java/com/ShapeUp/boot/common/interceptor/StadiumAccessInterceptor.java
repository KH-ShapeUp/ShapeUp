package com.ShapeUp.boot.common.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class StadiumAccessInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        String userType = session != null ? (String) session.getAttribute("userType") : null;

        if ("STADIUM_MANAGER".equalsIgnoreCase(userType)) {
            return true;
        }

        if ("SYSTEM_MANAGER".equalsIgnoreCase(userType)) {
            response.sendRedirect("http://localhost:5173/admin");
            response.getWriter().write("<script>alert('잘못된 접근입니다.');</script>");
        } else {
            response.sendRedirect("http://localhost:8080");
            response.getWriter().write("<script>alert('잘못된 접근입니다.');</script>");
        }
        return false;
    }
}
