package com.ShapeUp.boot.app.oauth.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.ShapeUp.boot.app.oauth.service.OAuthService;

@Slf4j
@Controller
@RequiredArgsConstructor
public class OAuthController {

    private final OAuthService oAuthService;

    /** 카카오 로그인 페이지로 이동 */
    @GetMapping("/oauth/kakao/login")
    public String kakaoLogin() {
        String url = oAuthService.getKakaoLoginUrl();
        log.info("✅ 카카오 로그인 URL 생성: {}", url);
        return "redirect:" + url;
    }

    /** 카카오 로그인 callback */
    @GetMapping("/oauth/kakao/callback")
    public String kakaoCallback(String code, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            log.info("===== 카카오 로그인 콜백 시작 =====");
            log.info("✅ 인증 코드: {}", code);
            
            // ✅ 소셜 로그인 처리 후 신규 회원 여부 반환
            boolean isNewUser = oAuthService.kakaoLogin(code, session);
            
            log.info("✅ 신규 회원 여부: {}", isNewUser);
            
            // 세션 확인
            Object loginUser = session.getAttribute("loginUser");
            Object isSocialLogin = session.getAttribute("isSocialLogin");
            log.info("✅ 세션 loginUser: {}", loginUser != null ? "있음" : "없음");
            log.info("✅ 세션 isSocialLogin: {}", isSocialLogin);
            
            if (isNewUser) {
                // 신규 회원이면 추가 정보 입력 페이지로 이동
                log.info("✅ 신규 회원 -> /user/signupInsertInfo 리다이렉트");
                return "redirect:/user/signupInsertInfo";
            } else {
                // 기존 회원이면 메인 페이지로 이동
                log.info("✅ 기존 회원 -> 메인 페이지 리다이렉트");
                return "redirect:/";
            }
        } catch (Exception e) {
            log.error("❌ 카카오 로그인 처리 중 오류 발생", e);
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMsg", "로그인 처리 중 오류가 발생했습니다.");
            return "redirect:/user/login";
        }
    }

    /** 네이버 로그인 페이지로 이동 */
    @GetMapping("/oauth/naver/login")
    public String naverLogin() {
        String url = oAuthService.getNaverLoginUrl();
        log.info("✅ 네이버 로그인 URL 생성: {}", url);
        return "redirect:" + url;
    }

    /** 네이버 callback */
    @GetMapping("/oauth/naver/callback")
    public String naverCallback(String code, String state, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            log.info("===== 네이버 로그인 콜백 시작 =====");
            log.info("✅ 인증 코드: {}, state: {}", code, state);
            
            // ✅ 소셜 로그인 처리 후 신규 회원 여부 반환
            boolean isNewUser = oAuthService.naverLogin(code, state, session);
            
            log.info("✅ 신규 회원 여부: {}", isNewUser);
            
            // 세션 확인
            Object loginUser = session.getAttribute("loginUser");
            Object isSocialLogin = session.getAttribute("isSocialLogin");
            log.info("✅ 세션 loginUser: {}", loginUser != null ? "있음" : "없음");
            log.info("✅ 세션 isSocialLogin: {}", isSocialLogin);
            
            if (isNewUser) {
                // 신규 회원이면 추가 정보 입력 페이지로 이동
                log.info("✅ 신규 회원 -> /user/signupInsertInfo 리다이렉트");
                return "redirect:/user/signupInsertInfo";
            } else {
                // 기존 회원이면 메인 페이지로 이동
                log.info("✅ 기존 회원 -> 메인 페이지 리다이렉트");
                return "redirect:/";
            }
        } catch (Exception e) {
            log.error("❌ 네이버 로그인 처리 중 오류 발생", e);
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMsg", "로그인 처리 중 오류가 발생했습니다.");
            return "redirect:/user/login";
        }
    }
}