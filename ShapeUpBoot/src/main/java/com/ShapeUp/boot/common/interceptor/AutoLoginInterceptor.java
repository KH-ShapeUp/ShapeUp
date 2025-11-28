package com.ShapeUp.boot.common.interceptor;

import com.ShapeUp.boot.domain.user.model.service.UserService;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import java.util.Base64;

@Slf4j
@Component
public class AutoLoginInterceptor implements HandlerInterceptor {

    @Autowired
    private UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession();

        // ✅ 수정: userNo 또는 loginUser 둘 중 하나라도 있으면 이미 로그인된 상태
        if (session.getAttribute("userNo") != null || session.getAttribute("loginUser") != null) {
            return true;
        }

        // 쿠키 확인
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberId".equals(cookie.getName())) {
                    try {
                        // 쿠키에서 암호화된 userId 복호화
                        String encodedUserId = cookie.getValue();
                        String userId = new String(Base64.getDecoder().decode(encodedUserId));

                        // DB에서 사용자 정보 조회
                        UserVO user = userService.selectUserById(userId);

                        if (user != null && "정상".equals(user.getStatus())) {
                            // 세션에 사용자 정보 저장 (자동 로그인 성공)
                            session.setAttribute("userNo", user.getUserNo());
                            session.setAttribute("userNickname", user.getUserNickname());
                            session.setAttribute("loginUser", user);
                            session.setAttribute("userType", user.getUserType());
                            session.setAttribute("loginUserEmail", user.getUserEmail());

                            log.info("✅ 자동 로그인 성공: {}", userId);
                        } else {
                            // 유효하지 않은 쿠키면 삭제
                            cookie.setMaxAge(0);
                            cookie.setPath("/");
                            response.addCookie(cookie);
                            log.warn("⚠️ 자동 로그인 실패 (사용자 없음 or 정지 상태): {}", userId);
                        }
                    } catch (Exception e) {
                        // 복호화 실패 시 쿠키 삭제
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                        log.error("❌ 자동 로그인 쿠키 복호화 실패", e);
                    }
                    break;
                }
            }
        }

        return true;
    }
}